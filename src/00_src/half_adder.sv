module half_adder( 
    input  logic A,
    input  logic B,
    output logic Sum_HA,
    output logic Carry_HA
);
    // Dataflow modeling
    assign Sum_HA = A ^ B;
    assign Carry_HA = A & B;
endmodule: half_adder
