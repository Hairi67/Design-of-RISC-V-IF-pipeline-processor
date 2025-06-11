module add
#(
	parameter WIDTH = 32
)
(
	input logic  [WIDTH-1:0] pc_i,
	output logic [WIDTH-1:0] pc_four_o
);

always_comb begin
	pc_four_o = pc_i + 4;
end
endmodule
