module lsu
  #(parameter DATA_WIDTH = 32,
	 parameter HEX_DATA_WIDTH = 7)
  (
  // inputs
  input logic              i_clk,
  input logic              i_rst_n,
  input [DATA_WIDTH-1:0]   i_lsu_addr,
  input [2:0]              i_func,
   
  input logic              i_lsu_wren,
  input [DATA_WIDTH-1: 0] 	i_st_data,
  input [DATA_WIDTH-1: 0] 	i_io_sw, // switch data
  input [3: 0] 				i_keypad, // keypad data
  
  input [DATA_WIDTH-1: 0] 	i_pc,
  // outputs
  output [DATA_WIDTH-1:0]  o_ld_data,
  output [DATA_WIDTH-1:0] 	o_io_lcd,
  output [DATA_WIDTH-1:0] 	o_io_ledg,
  output [DATA_WIDTH-1:0]  o_io_ledr,
  
  output [HEX_DATA_WIDTH-1:0]  o_io_hex0,
  output [HEX_DATA_WIDTH-1:0]  o_io_hex1,
  output [HEX_DATA_WIDTH-1:0]  o_io_hex2,
  output [HEX_DATA_WIDTH-1:0]  o_io_hex3,
  output [HEX_DATA_WIDTH-1:0]  o_io_hex4,
  output [HEX_DATA_WIDTH-1:0]  o_io_hex5,
  output [HEX_DATA_WIDTH-1:0]  o_io_hex6,
  output [HEX_DATA_WIDTH-1:0]  o_io_hex7,
  
  output [DATA_WIDTH-1:0] 	o_instr,
  
  output [HEX_DATA_WIDTH:0]	   o_keypad		
);
  wire [5:0] true_addr = i_lsu_addr[5:0];
  wire [3:0] bank_sel = i_lsu_addr[14:11];
  wire [DATA_WIDTH-1: 0] ld_data_ip;
  wire [DATA_WIDTH-1: 0] o_ld_datap;
  logic [DATA_WIDTH-1: 0] ld_data_d;
							 
// input perripherals mem
  lsu_2d_ip_bank lsu_2d_ip(
    .i_clk    (i_clk),
    .i_rst_n  (i_rst_n),	
    .pi_lsu_addr  (true_addr),
    .penable_i(bank_sel == 4'hF), //x7800
    .pfunct_code_i	(i_func),
    .pwdata_i_1 (i_io_sw),
    .pwdata_i_2 (i_keypad),
    .prdata_o (ld_data_ip)
	);

// output perripherals mem
  lsu_2d_op_bank lsu_2d_op(
    .i_clk     (i_clk),
    .i_rst_n   (i_rst_n),
    .pi_lsu_addr   (true_addr),
    .penable_i (bank_sel == 4'hE), //x7000
    .pfunct_code_i	(i_func),
    .pwrite_i  (i_lsu_wren),
    .pwdata_i  (i_st_data),
		
    .prdata_o  (o_ld_datap),	
    .o_io_lcd  (o_io_lcd),
    .o_io_ledg (o_io_ledg),
    .o_io_ledr (o_io_ledr),	
    .o_io_hex0 (o_io_hex0),
    .o_io_hex1	(o_io_hex1),
    .o_io_hex2	(o_io_hex2),
    .o_io_hex3	(o_io_hex3),
    .o_io_hex4	(o_io_hex4),
    .o_io_hex5	(o_io_hex5),
    .o_io_hex6	(o_io_hex6),
    .o_io_hex7	(o_io_hex7),
	.o_keypad	(o_keypad)
  );
	
// D mem
d_mem lsu_2d_dmem(
   .i_clk     (i_clk),
   .i_rst_n   (i_rst_n),
   .pi_lsu_addr   (i_lsu_addr[12:0]),
   .penable_i	(bank_sel == 4'h4 || bank_sel == 4'h5 || bank_sel == 4'h6 || bank_sel == 4'h7),	//x2000 -> x3FFF
   .pwrite_i  (i_lsu_wren),
   .pwdata_i  (i_st_data),
	 .pfunct_code_i	(i_func),

   .prdata_o  (ld_data_d)
 );
    reg[11:0] bram_mem_addr, bram_pc_addr;
    assign bram_pc_addr = {i_pc[14:2]};
    assign bram_mem_addr = {i_lsu_addr[14:2]};
    reg[31:0] i_mem_data;
    wire[31:0] o_mem_data;
    wire i_mem_wren;
    assign i_mem_wren = (bank_sel == 4'h4 || bank_sel == 4'h5 || bank_sel == 4'h6 || bank_sel == 4'h7) && (i_lsu_wren);
    lsu_2d_bank  bramm(
        .i_clk		(i_clk),
        .i_rst_n	(i_rst_n),

        .i_p1_addr(bram_pc_addr),
        .i_p2_addr(bram_mem_addr),
        .o_p2_data(o_mem_data),
        .o_p1_data(o_instr),

        .i_p2_data(i_mem_data),
        .i_p2_wren(i_mem_wren)
    );	
	 
// write datamem
always @(*) begin
    i_mem_data = 32'b0;
    if (i_func == 3'd0) begin // sw (store word)
        i_mem_data = i_st_data;
    end
    else if (i_func == 3'd1) begin // sh (store half-word)
        if (!i_lsu_addr[1]) begin // Aligned to lower half-word [15:0]
            i_mem_data[15:0] = i_st_data[15:0];
            i_mem_data[31:16] = o_mem_data[31:16]; // Preserve upper half-word
        end
        else begin // Aligned to upper half-word [31:16]
            i_mem_data[15:0] = o_mem_data[15:0];   // Preserve lower half-word
            i_mem_data[31:16] = i_st_data[15:0]; // Store data in upper half-word
        end
    end
    else if (i_func == 3'd2) begin // sb (store byte)
        case (i_lsu_addr[1:0])
            2'b00: begin // Byte 0
                i_mem_data[7:0]   = i_st_data[7:0];
                i_mem_data[31:8]  = o_mem_data[31:8]; // Preserve upper 3 bytes
            end
            2'b01: begin // Byte 1
                i_mem_data[7:0]   = o_mem_data[7:0];   // Preserve byte 0
                i_mem_data[15:8]  = i_st_data[7:0];   // Store data in byte 1
                i_mem_data[31:16] = o_mem_data[31:16]; // Preserve bytes 2,3
            end
            2'b10: begin // Byte 2
                i_mem_data[15:0]  = o_mem_data[15:0];  // Preserve bytes 0,1
                i_mem_data[23:16] = i_st_data[7:0];   // Store data in byte 2
                i_mem_data[31:24] = o_mem_data[31:24]; // Preserve byte 3
            end
            2'b11: begin // Byte 3
                i_mem_data[23:0]  = o_mem_data[23:0];  // Preserve bytes 0,1,2
                i_mem_data[31:24] = i_st_data[7:0];   // Store data in byte 3
            end
            default: i_mem_data = 32'b0; 
        endcase
    end
end
	 
// read datamem
//always @(*) begin
//    ld_data_d = 32'b0;
//
//    if (bank_sel == 4'h4 || bank_sel == 4'h5 || bank_sel == 4'h6 || bank_sel == 4'h7) begin
//        if (i_func == 3'b000) begin //lw (load word)
//            ld_data_d = o_mem_data;
//        end
//        else if (i_func == 3'b001) begin //lh (load half-word, sign-extended)
//            if (!i_lsu_addr[1]) begin // Lower half-word
//                ld_data_d[15:0] = o_mem_data[15:0];
//                ld_data_d[31:16] = {16{o_mem_data[15]}}; // Sign-extend from MSB of lower half
//            end
//            else begin // Upper half-word
//                ld_data_d[15:0] = o_mem_data[31:16];
//                ld_data_d[31:16] = {16{o_mem_data[31]}}; // Sign-extend from MSB of upper half
//            end
//        end
//        else if (i_func == 3'b010) begin //lb (load byte, sign-extended)
//            case (i_lsu_addr[1:0])
//                2'b00: begin // Byte 0
//                    ld_data_d[7:0] = o_mem_data[7:0];
//                    ld_data_d[31:8] = {24{o_mem_data[7]}}; // Sign-extend from MSB of byte 0
//                end
//                2'b01: begin // Byte 1
//                    ld_data_d[7:0] = o_mem_data[15:8];
//                    ld_data_d[31:8] = {24{o_mem_data[15]}}; // Sign-extend from MSB of byte 1
//                end
//                2'b10: begin // Byte 2
//                    ld_data_d[7:0] = o_mem_data[23:16];
//                    ld_data_d[31:8] = {24{o_mem_data[23]}}; // Sign-extend from MSB of byte 2
//                end
//                2'b11: begin // Byte 3
//                    ld_data_d[7:0] = o_mem_data[31:24];
//                    ld_data_d[31:8] = {24{o_mem_data[31]}}; // Sign-extend from MSB of byte 3
//                end
//                default: ld_data_d = 32'bx; // Should not be reached, but safe.
//            endcase
//        end
//        else if (i_func == 3'b100) begin //lhu (load half-word, zero-extended)
//            if (!i_lsu_addr[1]) begin // Lower half-word
//                ld_data_d[15:0] = o_mem_data[15:0];
//                ld_data_d[31:16] = 16'b0; // Zero-extend
//            end
//            else begin // Upper half-word
//                ld_data_d[15:0] = o_mem_data[31:16];
//                ld_data_d[31:16] = 16'b0; // Zero-extend
//            end
//        end
//        else if (i_func == 3'b101) begin //lbu (load byte, zero-extended)
//            case (i_lsu_addr[1:0])
//                2'b00: begin // Byte 0
//                    ld_data_d[7:0] = o_mem_data[7:0];
//                    ld_data_d[31:8] = 24'b0; // Zero-extend
//                end
//                2'b01: begin // Byte 1
//                    ld_data_d[7:0] = o_mem_data[15:8];
//                    ld_data_d[31:8] = 24'b0; // Zero-extend
//                end
//                2'b10: begin // Byte 2
//                    ld_data_d[7:0] = o_mem_data[23:16];
//                    ld_data_d[31:8] = 24'b0; // Zero-extend
//                end
//                2'b11: begin // Byte 3
//                    ld_data_d[7:0] = o_mem_data[31:24];
//                    ld_data_d[31:8] = 24'b0; // Zero-extend
//                end
//                default: ld_data_d = 32'b0; // Should not be reached, but safe.
//            endcase
//        end
//    end
//end	 
	  
	  assign o_ld_data = (bank_sel == 4'h4 || bank_sel == 4'h5 || bank_sel == 4'h6 || bank_sel == 4'h7)  ? ld_data_d  :
                     ((bank_sel 		 == 4'hE) ? o_ld_datap :
                     ((bank_sel 		 == 4'hF) ? ld_data_ip : '0));
endmodule 
