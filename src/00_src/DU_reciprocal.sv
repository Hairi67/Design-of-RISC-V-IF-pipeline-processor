module DU_reciprocal(
    input logic [23:0] i_X,
    input logic [1:0]  i_sel_MUX31,
    input logic        i_sel_MUX2,
    input logic        i_sel_MUX3,
    input logic        i_sel_MUX4,
    input logic        i_ld_R1,
    input logic        i_ld_R2,
    input logic        i_ld_R3,
    input logic        i_ld_R4,
    input logic        i_sel_adder,
    input logic        i_clk,

    
    output logic [23:0] D_R3,
    output logic [23:0] D_R1,
    output logic [23:0] D_R2,
    output logic [23:0] A_mult,
    output logic [23:0] B_mult,
    output logic [8:0]  address,
    output logic [23:0] C,
    output logic [17:0] data_2m,
    output logic [23:0] data_modified,
    output logic [23:0] data_mult,
    output logic [23:0] o_1_X
);


//logic [8:0] address;
assign address = i_X[22:14];

//logic [17:0] data_2m;
assign data_2m = i_X[22:5];



//logic [23:0] C;  
//logic [23:0] data_modified;

//logic [23:0] A_mult;
//logic [23:0] B_mult;
//logic [23:0] data_mult;


//logic [23:0] D_R1;
//logic [23:0] D_R2;
//logic [23:0] D_R3; //D_R3 = D_R4;


logic [23:0] Q_R1;
logic [23:0] Q_R2;
//logic [23:0] Q_R3; this is output 1/X
logic [23:0] Q_R4; 




ROM rom_inst (
    .address(address),
    .data_const(C)
);

mux3to1 mux_inst (
    .i_data1(C),
    .i_data2(i_X),
    .i_data3(o_1_X),
    .sel(i_sel_MUX31),
    .o_data_mux(A_mult)
);

modifier modifier_inst (
    .data_2m(data_2m),
    .data_modified(data_modified)
);

mux2to1 MUX2 (
    .i_data1(data_modified),
    .i_data2(Q_R4),
    .sel(i_sel_MUX2),
    .o_data_mux(B_mult)
);

// Instantiate the multiplier module
multiplier mult_inst (
    .A(A_mult),
    .B(B_mult),
    .result_mult(data_mult)
);

mux2to1 MUX3 (
    .i_data1(data_mult),
    .i_data2(o_1_X),
    .sel(i_sel_MUX3),
    .o_data_mux(D_R1)
);

mux2to1 MUX4 (
    .i_data1(24'hFFFFFF), // 1.9999998
    .i_data2(24'b0),      // 0
    .sel(i_sel_MUX4),
    .o_data_mux(D_R2)
);


register R1 (
    .i_data(D_R1),
    .i_ld(i_ld_R1),
    .i_clk(i_clk),
    .o_data(Q_R1)
);

register R2 (
    .i_data(D_R2),
    .i_ld(i_ld_R2),
    .i_clk(i_clk),
    .o_data(Q_R2)
);

adder adder_inst (
    .A(Q_R2),
    .B(Q_R1),
    .sel(i_sel_adder),
    .Sum(D_R3)
);

register R3 (
    .i_data(D_R3),
    .i_ld(i_ld_R3),
    .i_clk(i_clk),
    .o_data(o_1_X)
);

register R4 (
    .i_data(D_R3),
    .i_ld(i_ld_R4),
    .i_clk(i_clk),
    .o_data(Q_R4)
);

endmodule