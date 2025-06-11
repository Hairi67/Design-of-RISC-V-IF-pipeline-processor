module mux_2to1 
#(parameter WIDTH = 32) (
   input logic  [WIDTH-1:0] i_data1, i_data2, 
	input logic 			    sel,
	output logic [WIDTH-1:0] o_data_mux
	
);

assign o_data_mux = sel ? i_data2 : i_data1;

endmodule 