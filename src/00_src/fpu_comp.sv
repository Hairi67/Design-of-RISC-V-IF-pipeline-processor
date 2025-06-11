module fpu_comp (
    input  logic [31:0] i_rs1_f, // First floating-point number
    input  logic [31:0] i_rs2_f, // Second floating-point number
    input  logic        flt,      // Less than flag
    input  logic        feq,      // Equal flag
    input  logic        fle,      // Less than or equal flag
    input  logic        fmin,     // Minimum flag
    input  logic        fmax,     // Maximum flag
    output logic [31:0] o_comp_result // Comparison result
);

logic o_nan; // NaN detected flag
logic greater_than; // A > B
logic equal; // A == B
logic less_than; // A < B
comp_block comp_block_inst (
    .i_rs1_f(i_rs1_f),
    .i_rs2_f(i_rs2_f),
    .greater_than(greater_than), // A > B
    .equal(equal),         // A == B
    .less_than(less_than)      // A < B
);

NaN_detect nan_detect_inst (
    .i_rs1_f(i_rs1_f),
    .i_rs2_f(i_rs2_f),
    .o_nan(o_nan) // NaN detected flag
);

flag_selector flag_selector_inst (
    .greater_than(greater_than),
    .less_than(less_than),
    .equal(equal),
    .NaN(o_nan),
    .i_rs1_f(i_rs1_f),
    .i_rs2_f(i_rs2_f),
    .flt(flt),
    .feq(feq),
    .fle(fle),
    .fmin(fmin),
    .fmax(fmax),
    .o_comp_result(o_comp_result)
);

endmodule