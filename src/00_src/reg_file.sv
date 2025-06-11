module reg_file(
	input logic         i_clk,
	input logic         i_rst_n,
	input logic [31:0]  i_rd_data, 
	input logic [4:0]   i_rd_addr,  
	input logic [4:0]   i_rs1_addr,    
	input logic [4:0]   i_rs2_addr,   
	input logic         i_rd_wren,      
	output logic [31:0] o_rs1_data, 
	output logic [31:0] o_rs2_data,

    // Output test: x1–x31
    output logic [31:0] x1,  x2,  x3,  x4,  x5,
                        x6,  x7,  x8,  x9,  x10,
                        x11, x12, x13, x14, x15,
                        x16, x17, x18, x19, x20,
                        x21, x22, x23, x24, x25,
                        x26, x27, x28, x29, x30, x31
);

	
	logic [31:0] regfile [31:0];  
	 
    // Write 
    always_ff @(negedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            // Reset 
            for (int i = 1; i < 32; i = i + 1) begin
                regfile[i] <= 32'b0;
            end
        end else if (i_rd_wren && (i_rd_addr != 5'b00000)) begin
            regfile[i_rd_addr] <= i_rd_data;
        end
    end
	
    // Read 
    assign o_rs1_data = (i_rs1_addr == 5'b00000) ? 32'b0 : regfile[i_rs1_addr];
    assign o_rs2_data = (i_rs2_addr == 5'b00000) ? 32'b0 : regfile[i_rs2_addr];
	
	    // Output test: gán từng thanh ghi
    assign x1  = regfile[1];
    assign x2  = regfile[2];
    assign x3  = regfile[3];
    assign x4  = regfile[4];
    assign x5  = regfile[5];
    assign x6  = regfile[6];
    assign x7  = regfile[7];
    assign x8  = regfile[8];
    assign x9  = regfile[9];
    assign x10 = regfile[10];
    assign x11 = regfile[11];
    assign x12 = regfile[12];
    assign x13 = regfile[13];
    assign x14 = regfile[14];
    assign x15 = regfile[15];
    assign x16 = regfile[16];
    assign x17 = regfile[17];
    assign x18 = regfile[18];
    assign x19 = regfile[19];
    assign x20 = regfile[20];
    assign x21 = regfile[21];
    assign x22 = regfile[22];
    assign x23 = regfile[23];
    assign x24 = regfile[24];
    assign x25 = regfile[25];
    assign x26 = regfile[26];
    assign x27 = regfile[27];
    assign x28 = regfile[28];
    assign x29 = regfile[29];
    assign x30 = regfile[30];
    assign x31 = regfile[31];

endmodule