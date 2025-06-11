module adder #(
    parameter WIDTH = 24
)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic             sel,
    output logic [WIDTH-1:0] Sum
);

    // Internal signals
    // logic [WIDTH:0] temp_sum; // one bit wider to store internal carry

    always_comb begin
        if (sel == 0)
            Sum = A + B;   // Add A and B
        else
            Sum = A - B;   // Subtract B from A

    end

endmodule
