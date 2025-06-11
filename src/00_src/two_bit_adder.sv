module two_bit_adder (
    input logic [1:0] A,      // 2-bit input operand A
    input logic [1:0] B,      // 2-bit input operand B
    input logic C_in,         // Carry-in
    output logic [1:0] Sum,   // 2-bit Sum output
    output logic C_out        // Carry-out
);
    logic Carry_0;            // Intermediate carry between adders

    // Instantiate the first full adder (LSB addition)
    full_adder FA0 (
        .A(A[0]),
        .B(B[0]),
        .Cx(C_in),
        .Sum_FA(Sum[0]),
        .Carry_FA(Carry_0)
    );

    // Instantiate the second full adder (MSB addition)
    full_adder FA1 (
        .A(A[1]),
        .B(B[1]),
        .Cx(Carry_0),
        .Sum_FA(Sum[1]),
        .Carry_FA(C_out)
    );

endmodule: two_bit_adder