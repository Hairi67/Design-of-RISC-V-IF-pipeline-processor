module ROM (
    input logic [8:0] address,
    output logic [23:0] data_const
);

    // Memory array
    logic [23:0] mem [0:511];

    // Initialize memory with a file
    initial begin
        $readmemb("../02_test/511val.txt", mem);
    end

    // Read data from memory
    always_comb begin
        data_const = mem[address];
    end

endmodule


