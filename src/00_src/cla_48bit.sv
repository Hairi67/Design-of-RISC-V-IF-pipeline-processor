module cla_48bit (
    input  logic [47:0] A,    // 24-bit input A
    input  logic [47:0] B,    // 24-bit input B
    input  logic        C_in, // Carry-in
    output logic [47:0] Sum,  // 24-bit Sum
    output logic        C_out // Carry-out
);

    logic c_mid; // Intermediate carry between the two 12-bit CLA blocks

    // Lower 24 bits (0 to 23)
    cla_24bit cla_lsb_24 (
        .A(A[23:0]),
        .B(B[23:0]),
        .C_in(C_in),
        .Sum(Sum[23:0]),
        .C_out(c_mid)
    );

    // Upper 24 bits (24 to 47)
    cla_24bit cla_msb_24 (
        .A(A[47:24]),
        .B(B[47:24]),
        .C_in(c_mid),   // Carry-in is the carry-out from the LSB block
        .Sum(Sum[47:24]),
        .C_out(C_out)
    );

endmodule: cla_48bit