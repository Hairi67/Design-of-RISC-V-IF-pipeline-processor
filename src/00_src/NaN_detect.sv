module NaN_detect (
    input  logic [31:0] i_rs1_f,
    input  logic [31:0] i_rs2_f,
    output logic        o_nan
);

    assign o_nan = ((i_rs1_f[30:23] == 8'hFF) && (i_rs1_f[22:0] != 0)) ||
                   ((i_rs2_f[30:23] == 8'hFF) && (i_rs2_f[22:0] != 0));

endmodule
