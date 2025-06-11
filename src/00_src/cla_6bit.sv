module cla_6bit (
    input  logic [5:0] A, B,
    input  logic C_in,
    output logic [5:0] Sum,
    output logic C_out
);
    logic [5:0] P, G, C;

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = C_in;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C_out = G[5] | (P[5] & C[5]);

    assign Sum = P ^ C;
endmodule: cla_6bit