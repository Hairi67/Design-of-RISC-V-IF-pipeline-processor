module inversion (
    input logic [7:0] i_raw_exponent,

    output logic [8:0] o_inv_exponent
);

    always_comb begin
        o_inv_exponent = ~i_raw_exponent + 1;
    end

endmodule
