module fclass (
    input  logic [31:0] i_rs1_f,   // Input float (single-precision IEEE 754)
    output logic [9:0]  o_rd     // Classification bits
);

    // Signals for fields
    logic sign;
    logic [7:0] exponent;
    logic [22:0] mantissa;

    // Signals for classification
    logic is_zero;
    logic is_subnormal;
    logic is_infinity;
    logic is_nan;
    logic is_snan;
    logic is_qnan;

    // Field extraction
    assign sign     = i_rs1_f[31];
    assign exponent = i_rs1_f[30:23];
    assign mantissa = i_rs1_f[22:0];

    // Classification logic
    assign is_zero      = (exponent == 8'b0) && (mantissa == 23'b0);
    assign is_subnormal = (exponent == 8'b0) && (mantissa != 23'b0);
    assign is_infinity  = (exponent == 8'hFF) && (mantissa == 23'b0);
    assign is_nan       = (exponent == 8'hFF) && (mantissa != 23'b0);
    assign is_snan      = is_nan && (mantissa[22] == 1'b0);
    assign is_qnan      = is_nan && (mantissa[22] == 1'b1);

    // Classification bits
    always_comb begin
        o_rd = 10'b0;
        if (is_infinity && sign)             o_rd[0] = 1'b1;  // -infinity
        else if (~sign && is_infinity)       o_rd[7] = 1'b1;  // +infinity
        else if (is_zero && sign)            o_rd[3] = 1'b1;  // -0
        else if (is_zero && ~sign)           o_rd[4] = 1'b1;  // +0
        else if (is_subnormal && sign)       o_rd[2] = 1'b1;  // negative subnormal
        else if (is_subnormal && ~sign)      o_rd[5] = 1'b1;  // positive subnormal
        else if (~sign && ~is_nan && ~is_infinity && ~is_zero && ~is_subnormal) o_rd[6] = 1'b1;  // positive normal
        else if (sign && ~is_nan && ~is_infinity && ~is_zero && ~is_subnormal)  o_rd[1] = 1'b1;  // negative normal
        else if (is_snan)                    o_rd[8] = 1'b1;  // signaling NaN
        else if (is_qnan)                    o_rd[9] = 1'b1;  // quiet NaN
    end

endmodule
