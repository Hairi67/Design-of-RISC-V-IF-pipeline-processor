module forward (
	// Input
		// MEM
	input logic [4:0] mem_rd_addr_i,	// 0 -> Not forward
	input logic mem_rd_wren_I_i,			// 1 -> Forward
	input logic mem_rd_wren_F_i,	
	input logic [4:0] wb_rd_addr_i,	// 0 -> Not forward
	input logic wb_rd_wren_I_i,			// 1 -> Forward
	input logic wb_rd_wren_F_i,
	input logic [2:0] wb_sel_mem,	
		// EX
	input logic [4:0] ex_rs1_addr_i,
	input logic [4:0] ex_rs2_addr_i,
	input logic [4:0] ex_rs3_addr_i,	
	// Output
	// 0 -> Not forward
	// 1 -> Forward
	output logic [1:0] forwardA_o,
	output logic [1:0] forwardB_o,
	
	output logic [1:0] forwardA_f_o,
	output logic [1:0] forwardB_f_o,
	output logic [1:0] forwardC_f_o	
);

assign forwardA_o = (mem_rd_wren_I_i && (wb_sel_mem != 3'b010) && (mem_rd_addr_i != 0) && (mem_rd_addr_i == ex_rs1_addr_i)) ? 2'b01 :
						  ((wb_rd_wren_I_i && (wb_rd_addr_i != 0) && (wb_rd_addr_i == ex_rs1_addr_i)) ? 2'b10 : 2'b00);

assign forwardB_o = (mem_rd_wren_I_i && (wb_sel_mem != 3'b010) && (mem_rd_addr_i != 0) && (mem_rd_addr_i == ex_rs2_addr_i)) ? 2'b01 :
						  ((wb_rd_wren_I_i && (wb_rd_addr_i != 0) && (wb_rd_addr_i == ex_rs2_addr_i)) ? 2'b10 : 2'b00);
						  
assign forwardA_f_o = (mem_rd_wren_F_i && (wb_sel_mem != 3'b010) && (mem_rd_addr_i != 0) && (mem_rd_addr_i == ex_rs1_addr_i)) ? 2'b01 :
						  ((wb_rd_wren_F_i && (wb_rd_addr_i != 0) && (wb_rd_addr_i == ex_rs1_addr_i)) ? 2'b10 : 2'b00);

assign forwardB_f_o = (mem_rd_wren_F_i && (wb_sel_mem != 3'b010) && (mem_rd_addr_i != 0) && (mem_rd_addr_i == ex_rs2_addr_i)) ? 2'b01 :
						  ((wb_rd_wren_F_i && (wb_rd_addr_i != 0) && (wb_rd_addr_i == ex_rs2_addr_i)) ? 2'b10 : 2'b00);	
						  
assign forwardC_f_o = (mem_rd_wren_F_i && (wb_sel_mem != 3'b010) && (mem_rd_addr_i != 0) && (mem_rd_addr_i == ex_rs3_addr_i)) ? 2'b01 :
						  ((wb_rd_wren_F_i && (wb_rd_addr_i != 0) && (wb_rd_addr_i == ex_rs3_addr_i)) ? 2'b10 : 2'b00);							  
endmodule 