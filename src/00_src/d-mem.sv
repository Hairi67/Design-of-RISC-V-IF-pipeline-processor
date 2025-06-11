module d_mem #(

  parameter int unsigned DMEM_ADDR = 13
) 
(
  input  logic                  i_clk,
  input  logic                  i_rst_n,
  input  logic [DMEM_ADDR-1:0]  pi_lsu_addr,
  input  logic                  penable_i, //select Data mem
  input  logic                  pwrite_i , //enable write to data mem
  input  logic [31:0]           pwdata_i , //data to write 
  
  input  logic [2:0]            pfunct_code_i, //kind of load/store
  output logic [31:0]           prdata_o  //data output
  
);

  logic [7:0] dmem [0:200]; //array 8Kib

  wire  [3:0] pstrb = (pfunct_code_i == 3'd0) ? 4'b0001 : //Store byte
                      (pfunct_code_i == 3'd1) ? 4'b0011 : //Store half
                      (pfunct_code_i == 3'd2) ? 4'b1111 : 4'b0000; //Store word

 
always_ff @(posedge i_clk) begin : proc_data
    if (penable_i && pwrite_i) begin
        if (pstrb[0]) begin
            dmem[pi_lsu_addr] <= pwdata_i[7:0]; // Store byte
        end
        if (pstrb[1]) begin
            dmem[pi_lsu_addr + 1] <= pwdata_i[15:8]; // Store half
        end
//        if (pstrb[2]) begin
//            dmem[pi_lsu_addr+2] <= pwdata_i[23:16]; 
//        end
        if (pstrb[3]) begin
            dmem[pi_lsu_addr + 2] <= pwdata_i[23:16];
            dmem[pi_lsu_addr + 3] <= pwdata_i[31:24]; // Store word
        end
    end
end


  
  logic [31: 0] rd_reg;
  
  always_comb begin : extends_by_imm_sel
    case (pfunct_code_i)
      3'b000:  rd_reg = {{24{dmem[pi_lsu_addr][7]}}, dmem[pi_lsu_addr]};                                          //Load byte
      3'b001:  rd_reg = {{16{dmem[pi_lsu_addr + 1][7]}}, dmem[pi_lsu_addr + 1], dmem[pi_lsu_addr]};               //Load half
      3'b010:  rd_reg = {dmem[pi_lsu_addr + 3], dmem[pi_lsu_addr + 2], dmem[pi_lsu_addr + 1], dmem[pi_lsu_addr]}; //Load word
      3'b100:  rd_reg = {24'd0, dmem[pi_lsu_addr]};                         //Load byte unsigned
      3'b101:  rd_reg = {16'd0 ,dmem[pi_lsu_addr + 1], dmem[pi_lsu_addr]}; //Load half word unsigned
      default: rd_reg = 32'd0;
    endcase
  end
	
  assign prdata_o = penable_i ? rd_reg : 'z;

endmodule : d_mem