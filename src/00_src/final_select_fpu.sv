module final_select_fpu (
    input logic [31:0]  fpu_add_result, fpu_mul_result, 
    input logic [31:0]  fpu_sign_inject_result, fpu_class_result,
    input logic [31:0]  fpu_convert_result,fpu_comp_result,
    input logic [4:0] op_sel_F,
	
    output logic [31:0] result_fpu
);


always_comb begin
    case (op_sel_F)
			5'b01010: result_fpu = fpu_add_result; //add
			5'b01011: result_fpu = fpu_add_result; //sub
			5'b01100: result_fpu = fpu_mul_result; //mul
			5'b01101: result_fpu = fpu_mul_result; //fdiv
			5'b10001: result_fpu = fpu_sign_inject_result; //sign inject
			5'b10010: result_fpu = fpu_sign_inject_result; //sign inject
			5'b10011: result_fpu = fpu_sign_inject_result; //sign inject
			5'b10110: result_fpu = fpu_convert_result; //convert to int
			5'b10111: result_fpu = fpu_convert_result; //convert to int
			5'b11001: result_fpu = fpu_convert_result; //convert to float
			5'b11010: result_fpu = fpu_convert_result; //convert to float
			5'b11000: result_fpu = fpu_class_result; //fclass
			5'b10100: result_fpu = fpu_comp_result; //fmin
			5'b10101: result_fpu = fpu_comp_result; //fmax
			5'b11011: result_fpu = fpu_comp_result; //fle
			5'b11100: result_fpu = fpu_comp_result; //flt
			5'b11101: result_fpu = fpu_comp_result; //feq
			5'b11110: result_fpu = fpu_add_result; //fmadd
			5'b11111: result_fpu = fpu_add_result; //fmadd			
    default: result_fpu = 32'b0;

    endcase


end

endmodule