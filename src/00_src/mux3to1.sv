module mux3to1
#(parameter WIDTH = 24) (
    input  logic [WIDTH-1:0] i_data1, i_data2, i_data3,
    input  logic [1:0]       sel,
    output logic [WIDTH-1:0] o_data_mux
);

always_comb begin
    case (sel)
        2'b00: o_data_mux = i_data1;
        2'b01: o_data_mux = i_data2;
        2'b10: o_data_mux = i_data3;
        default: o_data_mux = i_data1; // fallback option
    endcase
end

endmodule
