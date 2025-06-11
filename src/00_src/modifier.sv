module modifier (
    input logic [17:0] data_2m,
  
    output logic [23:0] data_modified
);


logic [8:0] M1;
logic [8:0] M2;

assign M1 = data_2m[17:9];
assign M2 = ~data_2m[8:0];
assign data_modified[23:0] = {1'b1, M1, M2, 5'b00000};

endmodule