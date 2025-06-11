module full_adder( 
    input logic A,
    input logic B,
    input logic Cx,
    output logic Sum_FA,
    output logic Carry_FA
);
    wire C0, C1, S0;

    // Instantiate the first half adder
    half_adder half_adder1 (
        .A(A),
        .B(B),
        .Sum_HA(S0),
        .Carry_HA(C0)
    );

    // Instantiate the second half adder
    half_adder half_adder2 (
        .A(S0),
        .B(Cx),
        .Sum_HA(Sum_FA),
        .Carry_HA(C1)
    );

    // Compute the final carry
    assign Carry_FA = C0 | C1;

endmodule: full_adder