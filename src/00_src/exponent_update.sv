module exponent_update (

    input logic [8:0] i_inv_exponent,
    input logic [1:0] i_offset,
    output logic [7:0] o_exponent

);
logic [8:0] exponent;
assign o_exponent = exponent[7:0]; // Assign the lower 8 bits to output
always_comb begin
    case (i_offset)
        2'b00: exponent = i_inv_exponent + 9'b011111110; // No offset
        2'b01: exponent = i_inv_exponent + 9'b111111111 + 9'b011111110; // Offset of 1
        default:    // Default case, should not happen
            exponent = i_inv_exponent + 9'b011111110;
    endcase
end
endmodule