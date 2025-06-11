module pc
#(
	parameter WIDTH = 32
)

(
	input logic  [WIDTH -1:0]  i_nxt_pc,
	input logic                i_clk,
	input logic                i_rst_n,
	input logic 					sel_i,
	output logic [WIDTH -1:0]  o_pc
);

always_ff @(posedge i_clk or negedge i_rst_n) begin: proc_pc
	if (!i_rst_n) o_pc <= 0;						// Rst_ni activated
	else if (sel_i == 0) o_pc <= i_nxt_pc;		// Not stall
end													// Final case: Stall
endmodule