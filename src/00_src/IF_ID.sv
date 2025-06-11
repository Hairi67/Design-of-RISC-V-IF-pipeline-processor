module IF_ID (
	// Inputs
	input logic i_clk, i_rst_n,
	input logic [1:0] sel_i,
	input logic [31:0] pc_if,
	input logic [31:0] instr_if,
	// Outputs
	output logic [31:0] id_pc,
	output logic [31:0] id_instr
);

always_ff @(posedge i_clk) begin
	if (!i_rst_n) begin
		id_pc <= 32'b0;
		id_instr <= 32'b0;
	end
	else if (sel_i == 2'b11) begin		// Hazard activated => Flush
		id_pc <= 32'b0;
		id_instr <= 32'b0;	
	end
	else if (sel_i == 2'b00) begin		// Normal - not stall
		id_pc <= pc_if;
		id_instr <= instr_if;	
	end
	
	// Final case: stall - keep the previous value
end

endmodule: IF_ID