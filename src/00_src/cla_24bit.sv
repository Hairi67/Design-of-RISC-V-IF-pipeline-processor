module cla_24bit (
    input  logic [23:0] A,    // 24-bit input A
    input  logic [23:0] B,    // 24-bit input B
    input  logic        C_in, // Carry-in
    output logic [23:0] Sum,  // 24-bit Sum
    output logic        C_out // Carry-out
);

    logic c_mid; // Intermediate carry between the two 12-bit CLA blocks

    // Lower 12 bits (0 to 11)
    cla_12bit cla_lsb_12 (
        .A(A[11:0]),
        .B(B[11:0]),
        .C_in(C_in),
        .Sum(Sum[11:0]),
        .C_out(c_mid)
    );

    // Upper 12 bits (12 to 23)
    cla_12bit cla_msb_12 (
        .A(A[23:12]),
        .B(B[23:12]),
        .C_in(c_mid),   // Carry-in is the carry-out from the LSB block
        .Sum(Sum[23:12]),
        .C_out(C_out)
    );

endmodule: cla_24bit