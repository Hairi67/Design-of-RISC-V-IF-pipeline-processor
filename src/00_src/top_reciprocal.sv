module top_reciprocal (
    input logic i_clk,
    input logic i_rst_n,
    input logic [31:0] i_rs2_f,
    input logic i_start,
    
    output logic [31:0] o_rs2_f_reciprocal,
    output logic o_done

);


assign o_rs2_f_reciprocal[31] =  i_rs2_f[31]; // Sign bit
logic [7:0] Ex;
assign Ex = i_rs2_f[30:23]; // Exponent bits
logic [23:0] Fr;
assign Fr = {1'b1,i_rs2_f[22:0]}; // Fraction bits


logic [8:0] inv_exponent;


///////////
    logic [23:0] o_1_X, D_R3;
    logic [23:0] D_R1;
    logic [23:0] D_R2;
    logic [23:0] A_mult;
    logic [23:0] B_mult;

    logic [8:0]  address;
    logic [23:0] C;
    logic [17:0] data_2m;
    logic [23:0] data_modified;
    logic [23:0] data_mult;

    logic [4:0]  T;
/////////////////
logic [4:0] lz;


inversion invert_exp (
    .i_raw_exponent(Ex),
    .o_inv_exponent(inv_exponent)


);



DUCU_reciprocal u_DUCU_reciprocal (
    .i_clk         (i_clk),
    .i_rst_n       (i_rst_n),
    .i_start       (i_start),
    .i_X           (Fr),

    .o_1_X         (o_1_X),
    .D_R3          (D_R3),

    .D_R1          (D_R1),
    .D_R2          (D_R2),
    .A_mult        (A_mult),
    .B_mult        (B_mult),

    .address       (address),
    .C             (C),
    .data_2m       (data_2m),
    .data_modified (data_modified),
    .data_mult     (data_mult),

    .T             (T),
    .o_done        (o_done)
);

LZD u_LZD (
    .in           (o_1_X),
    .lz           (lz)
);
  
exponent_update u_exponent_update (
    .i_inv_exponent(inv_exponent),
    .i_offset(lz[1:0]),
    .o_exponent(o_rs2_f_reciprocal[30:23])
);

shift_bit u_shift_bit (
    .i_data(o_1_X),
    .i_shift_amount(lz[1:0]),
    .o_data(o_rs2_f_reciprocal[22:0])
);

endmodule