module branch_control (
	// Input
	input logic br_sel_i,
	input logic br_less_i,
	input logic br_equal_i,
	input logic [31:0] instr_i,
	// Output
	output logic br_sel_o
);

always_comb begin
	if (br_sel_i == 1'b1) begin
		if (instr_i[6:2] == 5'b11000) begin
			case (instr_i[14:12])
				3'b000: br_sel_o = (br_equal_i) ? 1'b1 : 1'b0;		// BEQ
				3'b001: br_sel_o = (br_equal_i) ? 1'b0 : 1'b1;		// BNE
				3'b100: br_sel_o = (br_less_i) ? 1'b1 : 1'b0;		//	BLT
				3'b101: br_sel_o = (br_less_i) ? 1'b0 : 1'b1;		// BGE
				3'b110: br_sel_o = (br_less_i) ? 1'b1 : 1'b0;		// BLTU
				3'b111: br_sel_o = (br_less_i) ? 1'b0 : 1'b1;		// BGEU
				default : br_sel_o = 1'b0;
			endcase
		end
		else br_sel_o = 1'b1;
	end
	else br_sel_o = 1'b0;
end
 
endmodule: branch_control