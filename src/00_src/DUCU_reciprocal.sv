module DUCU_reciprocal(
    input  logic       i_clk,
    input  logic       i_rst_n,
    input  logic       i_start,
    input  logic [23:0] i_X,

    output logic [23:0] o_1_X, D_R3,

    output logic [23:0] D_R1,
    output logic [23:0] D_R2,
    output logic [23:0] A_mult,
    output logic [23:0] B_mult,

    output logic [8:0]  address,
    output logic [23:0] C,
    output logic [17:0] data_2m,
    output logic [23:0] data_modified,
    output logic [23:0] data_mult,

    output logic [4:0]  T,


    output logic        o_done
);

logic [1:0]  sel_MUX31;
logic        sel_MUX2;
logic        sel_MUX3;
logic        sel_MUX4;
logic        ld_R1;
logic        ld_R2;
logic        ld_R3;
logic        ld_R4;
logic        sel_adder;
//logic [23:0] D_R1;
//logic [23:0] D_R2;
logic [23:0] Q_R1;
logic [23:0] Q_R2;
logic [23:0] Q_R4;


DU_reciprocal u_DU_reciprocal (
    .i_X(i_X),
    .i_sel_MUX31(sel_MUX31),
    .i_sel_MUX2(sel_MUX2),
    .i_sel_MUX3(sel_MUX3),
    .i_sel_MUX4(sel_MUX4),
    .i_ld_R1(ld_R1),
    .i_ld_R2(ld_R2),
    .i_ld_R3(ld_R3),
    .i_ld_R4(ld_R4),
    .i_sel_adder(sel_adder),
    .i_clk(i_clk),
    .D_R1(D_R1),
    .D_R2(D_R2),
    .address(address),
    .C(C),
    .A_mult(A_mult),
    .B_mult(B_mult),
    .data_2m(data_2m),
    .data_modified(data_modified),
    .data_mult(data_mult),
    .D_R3(D_R3),
    .o_1_X(o_1_X)
);

CU_reciprocal u_CU_reciprocal (
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    .i_start(i_start),

    .o_sel_MUX31(sel_MUX31),
    .o_sel_MUX2(sel_MUX2),
    .o_sel_MUX3(sel_MUX3),
    .o_sel_MUX4(sel_MUX4),
    .o_ld_R1(ld_R1),
    .o_ld_R2(ld_R2),
    .o_ld_R3(ld_R3),
    .o_ld_R4(ld_R4),
    .o_sel_adder(sel_adder),

    .T(T),
    .o_done(o_done)
);


endmodule