module multiplier (

	input logic [23:0] A,B,
	output logic [23:0] result_mult


);

logic [47:0] temp_mult;
assign temp_mult = A * B;
assign result_mult = temp_mult[46:23];

endmodule