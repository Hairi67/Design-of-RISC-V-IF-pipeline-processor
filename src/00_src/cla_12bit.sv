module cla_12bit (
    input  logic [11:0] A,    // 12-bit input A
    input  logic [11:0] B,    // 12-bit input B
    input  logic        C_in, // Carry-in
    output logic [11:0] Sum,  // 12-bit Sum
    output logic        C_out // Carry-out
);

    logic c_mid; // Intermediate carry between the two 6-bit CLA blocks

    // Lower 6 bits (0 to 5)
    cla_6bit cla_lsb_6 (
        .A(A[5:0]),
        .B(B[5:0]),
        .C_in(C_in),
        .Sum(Sum[5:0]),
        .C_out(c_mid)
    );

    // Upper 6 bits (6 to 11)
    cla_6bit cla_msb_6 (
        .A(A[11:6]),
        .B(B[11:6]),
        .C_in(c_mid),   // Carry-in is the carry-out from the LSB block
        .Sum(Sum[11:6]),
        .C_out(C_out)
    );

endmodule: cla_12bit