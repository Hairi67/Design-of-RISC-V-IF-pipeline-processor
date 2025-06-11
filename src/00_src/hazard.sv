module hazard (
	// Inputs
	input logic [4:0] ID_EX_rs1, ID_EX_rs2,		
	input logic [4:0] EX_MEM_rd,	
	input logic [2:0] wb_sel_mem,	// Check whether if it is load (2'b10)
	input logic EX_branch,
	input logic mem_rd_wren_i,
	input logic done,
	input logic	[4:0] i_alu_op,
	/* Output
	1'b1 =>	clear
	2'b00 =>	clear
	2'b01 =>	stall
	2'b11 =>	flush
	
	1: PC
	2: IF_ID
	2: ID_EX
	2: EX_MEM
	1: MEM_WB
	=> 8 bit */
	output logic [7:0] hazard_o		// {PC / IF_ID / ID_EX / EX_MEM / MEM_WB}
);


assign hazard_o = (EX_branch) ? 8'b0_11_11_00_0 :							// Jump - branch check first
((wb_sel_mem == 3'b010) && (mem_rd_wren_i == 1'b1) && ((ID_EX_rs1 == EX_MEM_rd) || (ID_EX_rs2 == EX_MEM_rd)))	? 8'b1_01_01_11_0 : // load-use hazard
((i_alu_op == 5'b01101) && (!done))	? 8'b1_01_01_11_0 :
8'b0;
						
endmodule: hazard