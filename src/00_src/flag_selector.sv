module flag_selector (
    input  logic greater_than,
    input  logic less_than,
    input  logic equal,
    input  logic NaN,
    input  logic [31:0] i_rs1_f,
    input  logic [31:0] i_rs2_f,
    input  logic flt,
    input  logic feq,
    input  logic fle,
    input  logic fmin,
    input  logic fmax,
    output logic [31:0] o_comp_result
);

    always_comb begin
        // Default output
        o_comp_result = 32'd0;

        // 1. Handle fmin and fmax first (not affected by NaN)
        if (fmin) begin
            // output min of i_rs1_f and i_rs2_f based on flags
            if (less_than || equal) begin
                o_comp_result = i_rs1_f; // rs1 is min if rs1 < rs2 or rs1 == rs2
            end else begin
                o_comp_result = i_rs2_f;
            end
        end else if (fmax) begin
            // output max of i_rs1_f and i_rs2_f based on flags
            if (greater_than || equal) begin
                o_comp_result = i_rs1_f; // rs1 is max if rs1 > rs2 or rs1 == rs2
            end else begin
                o_comp_result = i_rs2_f;
            end
        end else begin
            // 2. Handle flt, feq, fle with NaN consideration
            if (NaN) begin
                // If NaN present and function is flt, feq, or fle -> output 0
                o_comp_result = 32'd0;
            end else begin
                if (flt) begin
                    o_comp_result = less_than ? 32'd1 : 32'd0;
                end else if (feq) begin
                    o_comp_result = equal ? 32'd1 : 32'd0;
                end else if (fle) begin
                    o_comp_result = (less_than || equal) ? 32'd1 : 32'd0;
                end else begin
                    o_comp_result = 32'd0;
                end
            end
        end
    end

endmodule
