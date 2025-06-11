module final_select_ALPU (
    input logic [31:0] i_alu_data, 
    input logic [31:0] i_fpu_data, 
    input logic [4:0]  i_alu_op,
    output logic [31:0] o_result



);


always_comb begin
    case (i_alu_op)
		5'b01010:	o_result = i_fpu_data;
		5'b01011:	o_result = i_fpu_data;
		5'b01100:	o_result = i_fpu_data;
		5'b01101:	o_result = i_fpu_data;
		5'b10001: 	o_result = i_fpu_data;
		5'b10010: 	o_result = i_fpu_data;
		5'b10011: 	o_result = i_fpu_data;
		5'b10110: 	o_result = i_fpu_data;
		5'b10111: 	o_result = i_fpu_data;
		5'b11001: 	o_result = i_fpu_data;
		5'b11010: 	o_result = i_fpu_data;
		5'b11000: 	o_result = i_fpu_data; //fclass	
		5'b10100: 	o_result = i_fpu_data;
		5'b10101: 	o_result = i_fpu_data;
		5'b11011: 	o_result = i_fpu_data;
		5'b11100: 	o_result = i_fpu_data;
		5'b11101: 	o_result = i_fpu_data;
		5'b11110: 	o_result = i_fpu_data;
		5'b11111: 	o_result = i_fpu_data;		
    default: o_result = i_alu_data;

    endcase


end

endmodule