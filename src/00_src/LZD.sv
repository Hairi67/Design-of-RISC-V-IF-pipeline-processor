module LZD (
    input  [23:0] in,
    output reg [4:0] lz
);
    integer i;
    reg found;

    always @(*) begin
        lz = 0;
        found = 0;

        for (i = 23; i >= 0; i = i - 1) begin
            if (!found && in[i]) begin
                lz = 23 - i;
                found = 1;
            end
        end
    end
endmodule
