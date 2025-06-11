module reg_select (
    input logic [31:0] i_data_selected,
    input logic i_reg_sel,
	
    output logic [31:0] o_Reg_Xwb, o_Reg_Fwb
);

always_comb begin
	o_Reg_Xwb = 32'b0;
	o_Reg_Fwb = 32'b0;
	if (i_reg_sel == 1'b0 ) begin
		o_Reg_Xwb = i_data_selected;
	end else begin
		o_Reg_Fwb = i_data_selected;
	end
end
endmodule