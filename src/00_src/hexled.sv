

module hexled (
    input logic [6:0] i_data, // Changed input to 7 bits
    output logic [6:0] o_hex  // 7-segment display output
);

  always_comb begin
    unique case(i_data)
      7'd0:  o_hex = 7'b1000000; // 40 in hex (displays 0)
      7'd1:  o_hex = 7'b1111001; // 79 in hex (displays 1)
      7'd2:  o_hex = 7'b0100100; // 24 in hex (displays 2)
      7'd3:  o_hex = 7'b0110000; // 30 in hex (displays 3)
      7'd4:  o_hex = 7'b0011001; // 19 in hex (displays 4)
      7'd5:  o_hex = 7'b0010010; // 12 in hex (displays 5)
      7'd6:  o_hex = 7'b0000010; // 02 in hex (displays 6)
      7'd7:  o_hex = 7'b1111000; // 78 in hex (displays 7)
      7'd8:  o_hex = 7'b0000000; // 00 in hex (displays 8)
      7'd9:  o_hex = 7'b0010000; // 10 in hex (displays 9)
      7'hA:  o_hex = 7'b0001000; // 08 in hex (displays A)
      7'hB:  o_hex = 7'b0000011; // 03 in hex (displays B)
      7'hC:  o_hex = 7'b1000110; // 46 in hex (displays C)
      7'hD:  o_hex = 7'b0100001; // 21 in hex (displays D)
      7'hE:  o_hex = 7'b0000110; // 06 in hex (displays E)
      7'hF:  o_hex = 7'b0001110; // 0E in hex (displays F)
      default: o_hex = 7'b0111111; // 3F in hex (displays -)
    endcase
  end

endmodule


