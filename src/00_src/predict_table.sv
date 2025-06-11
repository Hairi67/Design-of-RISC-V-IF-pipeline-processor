//module predict_table (
//  //inputs
//  input  logic        clk_i,
//  input  logic [31:0] inst_F_i,
//  input  logic [31:0] inst_X_i,
//  input  logic [31:0] pc_F_i,
//  input  logic [12:0] pc_present_i,
//  input  logic [12:0] pc_X_i,
//  input  logic [31:0] pc_result_i,
//  input  logic        valid_bit_i,  // Branch taken signal
//  //outputs
//  output logic [31:0] nxt_pc_F_o,
//  output logic        pc_sel_o, hit_miss_o
//);
//
//  logic [31:0] tag        [(2**11)-1:0];
//  logic [1:0]  predictor  [(2**11)-1:0];  // 2-bit predictor
//  logic [11:0] tag_addrX;
//  logic [31:0] nxt_pc_F_tmp;
//
//  assign tag_addrX = pc_X_i[12:2];
//
//  ///write_execute/////
//  always_comb begin : proc_end_br
//    hit_miss_o = 1'b0;
//    if (inst_X_i[6:0] == 7'b1100011) begin
//      hit_miss_o = ((predictor[tag_addrX] == 2'b11 || predictor[tag_addrX] == 2'b10) & ~(valid_bit_i));
//    end 
//  end
//
//  always_ff @(posedge clk_i) begin : proc_update_buffer
//    if (inst_X_i[6:0] == 7'b1100011 || inst_X_i[6:0] == 7'b1101111) begin
//      tag[tag_addrX] <= pc_result_i;
//
//      // Update 2-bit predictor
//      case (predictor[tag_addrX])
//        2'b00: predictor[tag_addrX] <= (valid_bit_i) ? 2'b01 : 2'b00;  // Strongly Not Taken
//        2'b01: predictor[tag_addrX] <= (valid_bit_i) ? 2'b10 : 2'b00;  // Weakly Not Taken
//        2'b10: predictor[tag_addrX] <= (valid_bit_i) ? 2'b11 : 2'b01;  // Weakly Taken
//        2'b11: predictor[tag_addrX] <= (valid_bit_i) ? 2'b11 : 2'b10;  // Strongly Taken
//      endcase
//    end
//  end
//
//  always_comb begin : proc_update_temp
//    nxt_pc_F_tmp = pc_F_i;
//    if (inst_F_i[6:0] == 7'b1100011 || inst_F_i[6:0] == 7'b1101111) begin
//      if (predictor[pc_present_i] == 2'b10 || predictor[pc_present_i] == 2'b11) begin
//        nxt_pc_F_tmp = tag[pc_present_i];  
//      end else nxt_pc_F_tmp = pc_F_i;
//    end
//  end
//
//  always_comb begin : proc_update_next_pc
//    pc_sel_o   = 1'b0;
//    nxt_pc_F_o = nxt_pc_F_tmp;
//    if (inst_X_i[6:0] == 7'b1100011 || inst_X_i[6:0] == 7'b1100111 || inst_X_i[6:0] == 7'b1101111) begin
//      if ((predictor[tag_addrX] == 2'b10 || predictor[tag_addrX] == 2'b11) && inst_X_i[6:0] != 7'b1100111) begin
//        pc_sel_o   = 1'b0;
//        nxt_pc_F_o = nxt_pc_F_tmp;
//      end else begin
//        pc_sel_o   = valid_bit_i;
//        nxt_pc_F_o = (valid_bit_i) ? pc_result_i : nxt_pc_F_tmp;
//      end
//    end
//  end
//
//endmodule : predict_table

module predict_table (
  // Inputs
  input  logic        clk_i,
  input  logic        rst_ni,          // Active-low reset
  input  logic [31:0] inst_F_i,
  input  logic [31:0] inst_X_i,
  input  logic [31:0] pc_F_i,
  input  logic [12:0] pc_present_i,
  input  logic [12:0] pc_X_i,
  input  logic [31:0] pc_result_i,
  input  logic        valid_bit_i,     // Branch taken signal

  // Outputs
  output logic [31:0] nxt_pc_F_o,
  output logic        pc_sel_o,
  output logic        hit_miss_o
);

  // Internal storage
  logic [31:0] tag        [(2**11)-1:0];   // BTB
  logic [1:0]  predictor  [(2**11)-1:0];   // 2-bit predictor

  // Indexes
  logic [10:0] tag_addr_X;
  logic [10:0] tag_addr_F;

  // Temporary PC
  logic [31:0] nxt_pc_F_tmp;

  assign tag_addr_X = pc_X_i[12:2];
  assign tag_addr_F = pc_present_i[12:2];

  // Predictor reset and update logic
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      for (int i = 0; i < (2**11); i++) begin
        predictor[i] <= 2'b01;       // Weakly not taken
        tag[i]       <= 32'd0;
      end
    end else if (inst_X_i[6:0] == 7'b1100011 || inst_X_i[6:0] == 7'b1101111) begin
      tag[tag_addr_X] <= pc_result_i;

      case (predictor[tag_addr_X])
        2'b00: predictor[tag_addr_X] <= (valid_bit_i) ? 2'b01 : 2'b00;  // Strongly not taken
        2'b01: predictor[tag_addr_X] <= (valid_bit_i) ? 2'b10 : 2'b00;  // Weakly not taken
        2'b10: predictor[tag_addr_X] <= (valid_bit_i) ? 2'b11 : 2'b01;  // Weakly taken
        2'b11: predictor[tag_addr_X] <= (valid_bit_i) ? 2'b11 : 2'b10;  // Strongly taken
      endcase
    end
  end

  // Hit or Miss Predictor Check
  always_comb begin
    hit_miss_o = 1'b0;
    if (inst_X_i[6:0] == 7'b1100011) begin  // Only conditional branches
      hit_miss_o = ((predictor[tag_addr_X] == 2'b10 || predictor[tag_addr_X] == 2'b11) && ~valid_bit_i);
    end
  end

  // Predict next PC in Fetch stage
  always_comb begin
    nxt_pc_F_tmp = pc_F_i;

    if (inst_F_i[6:0] == 7'b1100011 || inst_F_i[6:0] == 7'b1101111) begin  // Branch or JAL
      if (predictor[tag_addr_F] == 2'b10 || predictor[tag_addr_F] == 2'b11) begin
        nxt_pc_F_tmp = tag[tag_addr_F];  // Use predicted target
      end
    end
  end

  // Select PC (flush or not)
  always_comb begin
    nxt_pc_F_o = nxt_pc_F_tmp;
    pc_sel_o   = 1'b0;

    if (inst_X_i[6:0] == 7'b1100011 || inst_X_i[6:0] == 7'b1101111 || inst_X_i[6:0] == 7'b1100111) begin
      // If prediction was wrong, update PC and signal flush
      if ((predictor[tag_addr_X] == 2'b10 || predictor[tag_addr_X] == 2'b11) && inst_X_i[6:0] != 7'b1100111) begin
        // Prediction said taken
        if (!valid_bit_i) begin
          nxt_pc_F_o = pc_result_i;
          pc_sel_o   = 1'b1;
        end
      end else begin
        // Prediction said not taken
        if (valid_bit_i) begin
          nxt_pc_F_o = pc_result_i;
          pc_sel_o   = 1'b1;
        end
      end
    end
  end

endmodule : predict_table

