module shift_bit (
    input  logic [23:0] i_data,
    input  logic [1:0] i_shift_amount,
    output logic [22:0] o_data
);
    logic [23:0] data;
    assign o_data = data[22:0]; // Assign the lower 23 bits to output
    always_comb begin
        data = i_data << i_shift_amount;
    end
endmodule
