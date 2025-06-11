module register(
    input logic i_ld, i_clk,
    input logic  [23:0] i_data,
    output logic [23:0] o_data
);

always_ff @(posedge i_clk) begin
    if (i_ld) begin
        o_data <= i_data;
    end
end

endmodule