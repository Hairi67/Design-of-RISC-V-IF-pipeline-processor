module wbmux(
	input logic [31:0] i_ld_data,					
	input logic [31:0] i_alu_data,				
	input logic [31:0] i_pc_four,
	input logic [31:0] i_rs1_data,
	input logic [31:0] i_rs1_f,	
	input logic [2:0]  i_wb_sel,					
	output logic [31:0] o_wb_data
);				

always_comb begin
	case(i_wb_sel) 
		3'b010: o_wb_data = i_ld_data;
		3'b001: o_wb_data = i_alu_data;
		3'b000: o_wb_data = i_pc_four;
		3'b011: o_wb_data = i_rs1_data;
		3'b100: o_wb_data = i_rs1_f;
		default: o_wb_data = '0;
	endcase
end

endmodule