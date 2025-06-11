module comparator_1bit (
    input  logic a_1,     // First input
    input  logic b_1,     // Second input
    output logic greater_1, // A > B
    output logic equal_1,   // A == B
    output logic less_1     // A < B
);

    always_comb begin
        // Default
        greater_1 = 0;
        equal_1 = 0;
        less_1 = 0;

        // Comparison
        if (a_1 == b_1) begin
            equal_1 = 1;
        end else if (a_1 > b_1) begin
            greater_1 = 1;
        end else begin
            less_1 = 1;
        end
    end

endmodule
