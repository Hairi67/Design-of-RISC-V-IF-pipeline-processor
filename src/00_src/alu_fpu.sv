module alu_fpu (
	input logic i_clk,
	input logic i_rst_n,
	input logic [31:0] i_operand_a,
	input logic [31:0] i_operand_b,
	input logic [31:0] i_rs1_f,
	input logic [31:0] i_rs2_f,
	input logic [31:0] i_rs3_f,
	input logic [31:0] instr_ex,	
	input logic [4:0] i_alu_op,
	
	output logic o_done,
	output logic [31:0] o_alu_fpu_data
);


logic [31:0] alu_data; //temp result before select
logic [31:0] fpu_data; //temp result before select

alu alu_block (

	.i_operand_a		(i_operand_a),
	.i_operand_b		(i_operand_b),
	.i_alu_op			(i_alu_op),
	.o_alu_data			(alu_data)


);



fpu_top fpu_block (
	.i_clk			(i_clk),
	.i_rst_n		(i_rst_n),
	.i_operand_a	(i_operand_a),
	.i_rs1_f		(i_rs1_f),
	.i_rs2_f		(i_rs2_f),	
	.i_rs3_f		(i_rs3_f),
	.instr_ex	(instr_ex),	
	.i_alu_op		(i_alu_op),
	
	.o_done			(o_done),	
	.o_fpu_data		(fpu_data)
);

final_select_ALPU	final_select_block (

	.i_alu_data		(alu_data), 
	.i_fpu_data		(fpu_data), 
	.i_alu_op		(i_alu_op),
	.o_result		(o_alu_fpu_data)


);



endmodule