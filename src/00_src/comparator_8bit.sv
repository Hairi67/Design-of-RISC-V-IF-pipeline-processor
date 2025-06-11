module comparator_8bit (
    input  logic [7:0] a_8,     // First input
    input  logic [7:0] b_8,     // Second input
    output logic       greater_8, // A > B
    output logic       equal_8,   // A == B
    output logic       less_8     // A < B
);

    always_comb begin
        // Default
        greater_8 = 0;
        equal_8 = 1;
        less_8 = 0;

        // Check bit by bit from MSB to LSB
        for (int i=7; i>=0; i--) begin
            if (a_8[i] != b_8[i]) begin
                equal_8 = 0;
                if (a_8[i] == 1 && b_8[i] == 0) begin
                    greater_8 = 1;
                    less_8 = 0;
                end else begin
                    greater_8 = 0;
                    less_8 = 1;
                end
                break; // Exit loop once difference found
            end
        end
    end

endmodule
