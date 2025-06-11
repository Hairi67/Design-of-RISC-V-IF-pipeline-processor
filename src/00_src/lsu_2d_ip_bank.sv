module lsu_2d_ip_bank 
(
  input  logic              i_clk ,
  input  logic              i_rst_n,
  input  logic [5:0]        pi_lsu_addr,
  input  logic              penable_i,  
  input  logic [31:0]       pwdata_i_1,
  input  logic [3:0]        pwdata_i_2,  
  input  logic [2:0]        pfunct_code_i,
  
  output logic [31:0]       prdata_o
);

logic [7:0] in_mem [0:31];
 
//No store function
  // Write for input
  always_ff @(posedge i_clk) begin : write
        in_mem[0] <= pwdata_i_1[7:0];  //x7800
        in_mem[1] <= pwdata_i_1[15:8];
        in_mem[2] <= pwdata_i_1[23:16];
        in_mem[3] <= pwdata_i_1[31:24];
		in_mem[16] <= pwdata_i_2[3:0]; //x7810 [0]-[3] col1 - col3
  end
  
  logic [31:0] rd_reg;
  
  always_comb begin : extends_by_imm_sel
    case (pfunct_code_i)
      3'b000:  rd_reg = {{24{in_mem[pi_lsu_addr][7]}}, in_mem[pi_lsu_addr]};                                          //Load byte
      3'b001:  rd_reg = {{16{in_mem[pi_lsu_addr + 1][7]}}, in_mem[pi_lsu_addr + 1], in_mem[pi_lsu_addr]};               //Load half
      3'b010:  rd_reg = {in_mem[pi_lsu_addr + 3], in_mem[pi_lsu_addr + 2], in_mem[pi_lsu_addr + 1], in_mem[pi_lsu_addr]}; //Load word
      3'b100:  rd_reg = {24'd0, in_mem[pi_lsu_addr]};                         //Load byte unsigned
      3'b101:  rd_reg = {16'd0 ,in_mem[pi_lsu_addr + 1], in_mem[pi_lsu_addr]}; //Load half word unsigned
      default: rd_reg = 32'd0;
    endcase
  end
	
  assign prdata_o = penable_i ? rd_reg : 'z;

endmodule : lsu_2d_ip_bank