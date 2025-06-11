module MEM_WB (
	// Input 
	input logic i_clk, i_rst_n,
		// Data
	input logic [31:0] instr_i,
	input logic [31:0] pc_four_i,
	input logic [31:0] alu_data_i,
	input logic [31:0] ld_data_i,
	
	input logic [31:0] rs1_data_i,
	input logic [31:0] rs1_f_i,	
		// Hazard
	input logic sel_i,
		// Control Unit
			// WB
	input logic [4:0] rd_addr_i,
	input logic rd_wren_I_i, rd_wren_F_i,
	input logic [2:0] wb_sel_i,
	
	input logic Reg_sel_i,	
	// Output
		// Data
	output logic [31:0] instr_o,
	output logic [31:0] pc_four_o,
	output logic [31:0] alu_data_o,
	output logic [31:0] ld_data_o,
	
	output logic [31:0] rs1_data_o,
	output logic [31:0] rs1_f_o,		
		// Control Unit
			// WB
	output logic [4:0] rd_addr_o,
	output logic rd_wren_I_o, rd_wren_F_o,
	output logic [2:0] wb_sel_o,
	
	output logic Reg_sel_o	
);

// WB
logic [10:0] WB_i, WB_o;
assign WB_i = {rd_addr_i, rd_wren_I_i, rd_wren_F_i, wb_sel_i, Reg_sel_i};
assign {rd_addr_o, rd_wren_I_o, rd_wren_F_o, wb_sel_o, Reg_sel_o} = WB_o;

always_ff @(posedge i_clk) begin
	if (!i_rst_n) begin							// Negative Reset
		instr_o <= 0;
		pc_four_o <= 0;
		alu_data_o <= 0;
		ld_data_o <= 0;
		
		rs1_data_o <= 0;
		rs1_f_o <= 0;			
		
		WB_o <= 0;
	end
	else if (sel_i == 0) begin					// Normal - Not stall
		instr_o <= instr_i;
		pc_four_o <= pc_four_i;
		alu_data_o <= alu_data_i;
		ld_data_o <= ld_data_i;
		
		rs1_data_o <= rs1_data_i;
		rs1_f_o <= rs1_f_i;		
		
		WB_o <= WB_i;
	end 
	else if (sel_i == 1) begin
		instr_o <= 0;
		pc_four_o <= 0;
		alu_data_o <= 0;
		ld_data_o <= 0;

		rs1_data_o <= 0;
		rs1_f_o <= 0;		
		
		WB_o <= 0;
	end
end

endmodule: MEM_WB