module Vedic (
    input  logic [23:0] A,  // 24-bit input A
    input  logic [23:0] B,  // 24-bit input B
    output logic [47:0] P  //  48-bit product output
);
    // Partial products from 6x6 Vedic multipliers
    logic [23:0] r0, r1, r2, r3;

    // Intermediate sums and carries
    logic [47:0] sum1, sum2;
    logic carry1, carry2, carry3;
	
    // Vedic Multipliers
    Vedic12x12 VM0 (
        .A(A[11:0]),
        .B(B[11:0]),
        .P(r0)
    );

    Vedic12x12 VM1 (
        .A(A[23:12]),
        .B(B[11:0]),
        .P(r1)
    );

    Vedic12x12 VM2 (
        .A(A[11:0]),
        .B(B[23:12]),
        .P(r2)
    );

    Vedic12x12 VM3 (
        .A(A[23:12]),
        .B(B[23:12]),
        .P(r3)
    );

    // Carry look ahead 1	
    cla_48bit CLA1 (
        .A({24'b0, r0}),
        .B({12'b0, r1, 12'b0}),
        .C_in(1'b0),
        .Sum(sum1),
        .C_out(carry1)
    );
	
    // Carry look ahead 2
    cla_48bit CLA2 (
        .A(sum1),
        .B({12'b0, r2, 12'b0}), 
        .C_in(carry1),
        .Sum(sum2),
        .C_out(carry2)
    );

    // Carry look ahead 3
    cla_48bit CLA3 (
        .A(sum2),
        .B({r3, 24'b0}), 
        .C_in(carry2),
        .Sum(P),
        .C_out(carry3)
    );

endmodule: Vedic

module Vedic12x12 (
    input  logic [11:0] A,  // 12-bit input A
    input  logic [11:0] B,  // 12-bit input B
    output logic [23:0] P  //  24-bit product output
);
    // Partial products from 6x6 Vedic multipliers
    logic [11:0] r0, r1, r2, r3;

    // Intermediate sums and carries
    logic [23:0] sum1, sum2;
    logic carry1, carry2, carry3;
	
    // Vedic Multipliers
    Vedic6x6 VM0 (
        .A(A[5:0]),
        .B(B[5:0]),
        .P(r0)
    );

    Vedic6x6 VM1 (
        .A(A[11:6]),
        .B(B[5:0]),
        .P(r1)
    );

    Vedic6x6 VM2 (
        .A(A[5:0]),
        .B(B[11:6]),
        .P(r2)
    );

    Vedic6x6 VM3 (
        .A(A[11:6]),
        .B(B[11:6]),
        .P(r3)
    );

    // Carry look ahead 1	
    cla_24bit CLA1 (
        .A({12'b0, r0}),
        .B({6'b0, r1, 6'b0}),
        .C_in(1'b0),
        .Sum(sum1),
        .C_out(carry1)
    );
	
    // Carry look ahead 2
    cla_24bit CLA2 (
        .A(sum1),
        .B({6'b0, r2, 6'b0}), 
        .C_in(carry1),
        .Sum(sum2),
        .C_out(carry2)
    );

    // Carry look ahead 3
    cla_24bit CLA3 (
        .A(sum2),
        .B({r3, 12'b0}), 
        .C_in(carry2),
        .Sum(P),
        .C_out(carry3)
    );

endmodule: Vedic12x12

module Vedic6x6 (
    input  logic [5:0] A,  // 6-bit input A
    input  logic [5:0] B,  // 6-bit input B
    output logic [11:0] P  // 12-bit product output
);
    // Partial products from 3x3 Vedic multipliers
    logic [5:0] r0, r1, r2, r3;

    // Intermediate sums and carries
    logic [11:0] sum1, sum2;
    logic carry1, carry2, carry3;
	
    // Vedic Multipliers
    Vedic3x3 VM0 (
        .A(A[2:0]),
        .B(B[2:0]),
        .P(r0)
    );

    Vedic3x3 VM1 (
        .A(A[5:3]),
        .B(B[2:0]),
        .P(r1)
    );

    Vedic3x3 VM2 (
        .A(A[2:0]),
        .B(B[5:3]),
        .P(r2)
    );

    Vedic3x3 VM3 (
        .A(A[5:3]),
        .B(B[5:3]),
        .P(r3)
    );

    // Carry look ahead 1	
    cla_12bit CLA1 (
        .A({6'b0, r0}),
        .B({3'b0, r1, 3'b0}),
        .C_in(1'b0),
        .Sum(sum1),
        .C_out(carry1)
    );
	
    // Carry look ahead 2
    cla_12bit CLA2 (
        .A(sum1),
        .B({3'b0, r2, 3'b0}), 
        .C_in(carry1),
        .Sum(sum2),
        .C_out(carry2)
    );

    // Carry look ahead 3
    cla_12bit CLA3 (
        .A(sum2),
        .B({r3, 6'b0}), 
        .C_in(carry2),
        .Sum(P),
        .C_out(carry3)
    );
    // Align and add partial products
/*     assign sum1 = {6'b0, r0} + ({3'b0, r1, 3'b0});
    assign sum2 = sum1 + ({3'b0, r2, 3'b0});
    assign P    = sum2 + ({r3, 6'b0}); */

endmodule: Vedic6x6


module Vedic3x3 (
    input logic [2:0] A,  // 3-bit input A
    input logic [2:0] B,  // 3-bit input B
    output logic [5:0] P  // 6-bit product output
);
    // Intermediate wires for partial sums and carries
    logic C0, C1, C2, C3, C4;
    logic S0, S1;

    // P[0] is the AND of the least significant bits
    assign P[0] = A[0] & B[0];

    // Stage 1: Half adder for partial product (A1B0, A0B1)
    half_adder half_adder1 (
        .A(A[1] & B[0]),
        .B(A[0] & B[1]),
        .Sum_HA(P[1]),
        .Carry_HA(C0)
    );

    // Stage 2: Full adder for partial product (A0B2, A1B1, A2B0)
    full_adder full_adder1 (
        .A(A[0] & B[2]),
        .B(A[1] & B[1]),
        .Cx(A[2] & B[0]),
        .Sum_FA(S0),
        .Carry_FA(C1)
    );

    // Stage 3: Half adder for partial product (A2B1, A1B2)
    half_adder half_adder2 (
        .A(A[2] & B[1]),
        .B(A[1] & B[2]),
        .Sum_HA(S1),
        .Carry_HA(C2)
    );

    // Stage 4: Two-bit adder for P[2] and intermediate carry
    logic [1:0] two_bit_sum1;
    two_bit_adder two_bit_adder1 (
        .A({C1, S0}),      // First input
        .B({1'b0, C0}),    // Second input (C1 shifted left)
        .C_in(1'b0),       // No carry-in
        .Sum(two_bit_sum1),
        .C_out(C3)
    );
    assign P[2] = two_bit_sum1[0];

    // Stage 5: Two-bit adder for P[3] and intermediate carry
    logic [1:0] two_bit_sum2;
    two_bit_adder two_bit_adder2 (
        .A({C3, two_bit_sum1[1]}),  // First input
        .B({1'b0, S1}),            // Second input
        .C_in(1'b0),               // No carry-in
        .Sum(two_bit_sum2),
        .C_out(C4)
    );
    assign P[3] = two_bit_sum2[0];

    // Stage 6: Two-bit adder for P[4] and P[5] (final carry)
    two_bit_adder two_bit_adder3 (
        .A({C4, two_bit_sum2[1]}), // First input
        .B({1'b0, C2}),            // Second input
        .C_in(A[2] & B[2]),        // Carry-in
        .Sum({P[5], P[4]}),        // Final output
        .C_out()                   // No further carry
    );

endmodule: Vedic3x3