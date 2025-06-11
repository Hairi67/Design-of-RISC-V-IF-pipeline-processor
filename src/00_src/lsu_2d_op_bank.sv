module lsu_2d_op_bank #(

  parameter DATA_WIDTH = 32,
  parameter HEX_DATA_WIDTH = 7,  
  parameter int unsigned out_mem_ADDR = 6
) 
(
  input  logic              i_clk,
  input  logic              i_rst_n,
  input  logic [out_mem_ADDR-1:0] pi_lsu_addr,
  input  logic              penable_i,
  input  logic              pwrite_i ,
  input  logic [31:0]       pwdata_i ,
  input  logic [2:0]        pfunct_code_i,
  
  output logic [31:0]       prdata_o,
  
  output [DATA_WIDTH-1:0] 	 o_io_lcd,
  output [DATA_WIDTH-1:0] 	 o_io_ledg,
  output [DATA_WIDTH-1:0]    o_io_ledr,
  
  output [HEX_DATA_WIDTH-1:0]   o_io_hex0,
  output [HEX_DATA_WIDTH-1:0]   o_io_hex1,
  output [HEX_DATA_WIDTH-1:0]   o_io_hex2,
  output [HEX_DATA_WIDTH-1:0]   o_io_hex3,
  output [HEX_DATA_WIDTH-1:0]   o_io_hex4,
  output [HEX_DATA_WIDTH-1:0]   o_io_hex5,
  output [HEX_DATA_WIDTH-1:0]   o_io_hex6,
  output [HEX_DATA_WIDTH-1:0]   o_io_hex7,
  
  output [HEX_DATA_WIDTH:0] 	o_keypad
);

  logic [7:0] out_mem [0:63];
  wire  [3:0] pstrb = (pfunct_code_i == 3'd0) ? 4'b0001 :
                      (pfunct_code_i == 3'd1) ? 4'b0011 :
                      (pfunct_code_i == 3'd2) ? 4'b1111 : 4'b0000;
						 

  // Read - Write
always_ff @(posedge i_clk) begin : proc_data
    if (penable_i && pwrite_i) begin
        if (pstrb[0]) begin
            out_mem[pi_lsu_addr] <= pwdata_i[7:0]; // Store byte
        end
        if (pstrb[1]) begin
            out_mem[pi_lsu_addr + 1] <= pwdata_i[15:8]; // Store half
        end
//        if (pstrb[2]) begin
//            out_mem[pi_lsu_addr+2] <= pwdata_i[23:16]; 
//        end
        if (pstrb[3]) begin
            out_mem[pi_lsu_addr + 2] <= pwdata_i[23:16];
            out_mem[pi_lsu_addr + 3] <= pwdata_i[31:24]; // Store word
        end
    end
end


  reg [31: 0] rd_reg;
  
  always_comb begin : extends_by_imm_sel
    case (pfunct_code_i)
      3'b000:  rd_reg = {{24{out_mem[pi_lsu_addr][7]}}, out_mem[pi_lsu_addr]};                                          //Load byte
      3'b001:  rd_reg = {{16{out_mem[pi_lsu_addr + 1][7]}}, out_mem[pi_lsu_addr + 1], out_mem[pi_lsu_addr]};               //Load half
      3'b010:  rd_reg = {out_mem[pi_lsu_addr + 3], out_mem[pi_lsu_addr + 2], out_mem[pi_lsu_addr + 1], out_mem[pi_lsu_addr]}; //Load word
      3'b100:  rd_reg = {24'd0, out_mem[pi_lsu_addr]};                         //Load byte unsigned
      3'b101:  rd_reg = {16'd0 ,out_mem[pi_lsu_addr + 1], out_mem[pi_lsu_addr]}; //Load half word unsigned
      default: rd_reg = 32'd0;
    endcase
  end
	
  assign prdata_o = penable_i ? rd_reg : 'z;

  assign	o_io_hex0 	= out_mem[32][6:0];  //x7020
  assign	o_io_hex1 	= out_mem[33][6:0];  //x7021
  assign o_io_hex2	= out_mem[34][6:0];  //x7022
  assign	o_io_hex3 	= out_mem[35][6:0];  //x7023
  assign	o_io_hex4	= out_mem[36][6:0];  //x7024
  assign	o_io_hex5	= out_mem[37][6:0];  //x7025
  assign	o_io_hex6 	= out_mem[38][6:0];  //x7026
  assign	o_io_hex7	= out_mem[39][6:0];  //x7027
  
  assign	o_keypad	= out_mem[4]; 	//x7004 [4]-[7]: row0 - row3
 
  assign	o_io_ledr	= out_mem[0];   //x7000
  assign	o_io_ledg	= out_mem[16];  //x7010
  assign	o_io_lcd  = {out_mem[51],out_mem[50],out_mem[49], out_mem[48]};  //x7030

endmodule : lsu_2d_op_bank