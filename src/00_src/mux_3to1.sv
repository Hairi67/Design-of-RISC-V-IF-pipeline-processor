module mux_3to1 (
	// Input
	input logic [31:0] in1_i, in2_i, in3_i,
	input logic [1:0] sel_i,
	
	// Output 
	output logic [31:0] out_o
);

always_comb begin
	case (sel_i)
		2'b00: out_o = in1_i;
		2'b01: out_o = in2_i;
		2'b10: out_o = in3_i;
		default: out_o = 0;
	endcase
end

endmodule: mux_3to1