module lsu_2d_bank #(
    parameter MEMSIZE = 16384,
    parameter ADDRBIT = 14
    ) (
        input wire i_clk,
        input wire i_rst_n,
        input wire[ADDRBIT-3:0] i_p1_addr,
        input wire[ADDRBIT-3:0] i_p2_addr,

        output reg[31:0] o_p1_data,
        output reg[31:0] o_p2_data,

        input wire[31:0] i_p2_data,
        input wire i_p2_wren
    );
    
    reg [31:0] d_mem [MEMSIZE/4-1:0]; // 
    initial begin
        d_mem = '{default:'0};
        $readmemh("../02_test/keypad_final.hex", d_mem);
    end  
    
    initial begin
        o_p1_data = 0;
        o_p2_data = 0;
    end


    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
        end
        else begin
            if (i_p2_wren) d_mem[i_p2_addr] <= i_p2_data;
        end
    end

    // Read 
    always @(*) begin
        o_p2_data <= d_mem[i_p2_addr];
        o_p1_data <= d_mem[i_p1_addr];
    end	
endmodule