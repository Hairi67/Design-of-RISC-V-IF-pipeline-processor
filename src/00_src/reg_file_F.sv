module reg_file_F(
	input logic         i_clk,
	input logic         i_rst_n,
	input logic [31:0]  i_rd_data, 
	input logic [4:0]   i_rd_addr,  
	input logic [4:0]   i_rs1_addr,    
	input logic [4:0]   i_rs2_addr, 
	input logic [4:0]   i_rs3_addr,	
	input logic         i_rd_wren,      
	output logic [31:0] o_rs1_data, 
	output logic [31:0] o_rs2_data,
	output logic [31:0] o_rs3_data,	

    // Output test: f1–f31
    output logic [31:0] f1,  f2,  f3,  f4,  f5,
                        f6,  f7,  f8,  f9,  f10,
                        f11, f12, f13, f14, f15,
                        f16, f17, f18, f19, f20,
                        f21, f22, f23, f24, f25,
                        f26, f27, f28, f29, f30, f31
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
    assign o_rs3_data = (i_rs3_addr == 5'b00000) ? 32'b0 : regfile[i_rs3_addr];	
	
	    // Output test: gán từng thanh ghi
    assign f1  = regfile[1];
    assign f2  = regfile[2];
    assign f3  = regfile[3];
    assign f4  = regfile[4];
    assign f5  = regfile[5];
    assign f6  = regfile[6];
    assign f7  = regfile[7];
    assign f8  = regfile[8];
    assign f9  = regfile[9];
    assign f10 = regfile[10];
    assign f11 = regfile[11];
    assign f12 = regfile[12];
    assign f13 = regfile[13];
    assign f14 = regfile[14];
    assign f15 = regfile[15];
    assign f16 = regfile[16];
    assign f17 = regfile[17];
    assign f18 = regfile[18];
    assign f19 = regfile[19];
    assign f20 = regfile[20];
    assign f21 = regfile[21];
    assign f22 = regfile[22];
    assign f23 = regfile[23];
    assign f24 = regfile[24];
    assign f25 = regfile[25];
    assign f26 = regfile[26];
    assign f27 = regfile[27];
    assign f28 = regfile[28];
    assign f29 = regfile[29];
    assign f30 = regfile[30];
    assign f31 = regfile[31];

endmodule