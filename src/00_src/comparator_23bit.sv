module comparator_23bit (
    input  logic [22:0] a_23,   // First input
    input  logic [22:0] b_23,   // Second input
    output logic        greater_23,  // A > B
    output logic        equal_23,  // A == B
    output logic        less_23   // A < B
);

    logic [22:0] diff;

    always_comb begin
        // default
        greater_23 = 0;
        equal_23 = 1;
        less_23 = 0;

        // Check bit by bit from MSB to LSB
        for (int i=22; i>=0; i--) begin
            if (a_23[i] != b_23[i]) begin
                equal_23 = 0;
                if (a_23[i] == 1 && b_23[i] == 0) begin
                    greater_23 = 1;
                    less_23 = 0;
                end else begin
                    greater_23 = 0;
                    less_23 = 1;
                end
                // Exit loop once difference found
                break;
            end
        end
    end

endmodule
