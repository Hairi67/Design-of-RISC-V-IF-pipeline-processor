module fpu_top (
	input logic i_clk,
	input logic i_rst_n,	
   input logic [31:0] i_rs1_f,
	input logic [31:0] i_rs2_f,
	input logic [31:0] i_rs3_f,

	input logic [31:0] instr_ex,
	input logic [4:0]  i_alu_op,
	
	input logic [31:0] i_operand_a,
	
	output logic o_done,
	output logic [31:0] o_fpu_data
);
logic [31:0] neg_rs1_f;

assign neg_rs1_f = {~i_rs1_f[31], i_rs1_f[30:0]};

logic [3:0]  op_sel_F; //for final select
logic		 	sub_sign; //sub sign for add sub float
logic 		start; // start logic for fdiv
logic 		min; //min flag
logic 		max; //max flag
logic 		flt; //less then flag
logic 		fle; //less equal flag
logic 		feq; // equal flag
logic 		muxa; // mux logic in choosing rs1_f in mul
logic 		muxb; // mux logic in choosing mul_result in add
logic 		muxc; // mux logic in choosing rs3_f in add

logic [31:0] fpu_add_result; //temp result before final select
logic [31:0] fpu_mul_result; //temp result before final select
logic [31:0] fpu_div_result; //temp result before final select
logic [31:0] fpu_sign_inject_result; //temp result before final select
logic [31:0] fpu_convert_result; //temp result before final select
logic [31:0] fpu_class_result; //temp result before final select
logic [31:0] fpu_reciprocal_result; //temp result before final select
logic [31:0] fpu_comp_result; //temp result before final select
logic [31:0] data_mul_rs2; //data to put in mul in case of fdiv
logic [31:0] data_mul_rs1; //data to put in mul in case of fnma
logic [31:0] data_add_rs1; //data to put in add in case of fma
logic [31:0] data_add_rs2; //data to put in add in case of fma
always_comb begin
	// Default assignments
	sub_sign = 1'b0;
	start    = 1'b0;
	min 		= 1'b0;
	max      = 1'b0;
	fle 		= 1'b0;
	flt    	= 1'b0; 
	feq    	= 1'b0;
	muxa 		= 1'b0;
	muxb 		= 1'b0;
	muxc 		= 1'b0;	
	case (instr_ex[6:2])
		5'b10010: muxa = 1'b1; //fnmsub.s
		5'b10011: muxa = 1'b1; //fnmadd.s
	endcase
	case (i_alu_op) 			
		5'b01010:	op_sel_F = 4'b0000; //fadd
		5'b01011:	op_sel_F = 4'b0001; //fsub
		5'b01100:	op_sel_F = 4'b0010; //fmul
		5'b01101:	op_sel_F = 4'b0011; //fdiv
		5'b10001:	op_sel_F = 4'b0100; //float sign injection 
		5'b10010:	op_sel_F = 4'b0100; //float sign injection signed revert	
		5'b10011:	op_sel_F = 4'b0100; //float sign injection injection XOR	
		5'b10110:	op_sel_F = 4'b0101; //fcvt.w.s
		5'b10111:	op_sel_F = 4'b0101; //fcvt.wu.s
		5'b11001:	op_sel_F = 4'b0101; //fcvt.s.w
		5'b11010:	op_sel_F = 4'b0101; //fcvt.s.wu	
		5'b11000:	op_sel_F = 4'b0110; //fclass
		5'b10100:	op_sel_F = 4'b0111; //fmin	
		5'b10101:	op_sel_F = 4'b1000; //fmax
		5'b11011:	op_sel_F = 4'b1001; //fle	
		5'b11100:	op_sel_F = 4'b1010; //flt
		5'b11101:	op_sel_F = 4'b1011; //feq
		5'b11110:	op_sel_F = 4'b1100; //fmadd
		5'b11111:	op_sel_F = 4'b1101; //fmsub			
		default:    op_sel_F = 4'b0000;
	endcase
	case (op_sel_F)
		 4'b0000: sub_sign = 1'b0;
		 4'b0001: sub_sign = 1'b1;
		 4'b0011: start = 1'b1;		 
		 4'b0111: min    = 1'b1;
		 4'b1000: max    = 1'b1;
		 4'b1001: fle    = 1'b1;
		 4'b1010: flt    = 1'b1;
		 4'b1011: feq    = 1'b1;
		 4'b1100: begin
			 muxb   		= 1'b1;
			 muxc 		= 1'b1;			 
		 end
		 4'b1101: begin
			 muxb    	= 1'b1;
			 muxc 		= 1'b1;
			 sub_sign 	= 1'b1;
		 end		 
		 // No need for 'default' if everything is already set by default above
	endcase   
end

mux_2to1 mux1 (
		.i_data1	(i_rs2_f), 
		.i_data2	(fpu_reciprocal_result), 
		.sel		(start & o_done),
		.o_data_mux	(data_mul_rs2)
);

mux_2to1 mux2 (
		.i_data1	(i_rs1_f), 
		.i_data2	(neg_rs1_f), 
		.sel		(muxa),
		.o_data_mux	(data_mul_rs1)
);

mux_2to1 mux3 (
		.i_data1	(i_rs1_f), 
		.i_data2	(fpu_mul_result), 
		.sel		(muxb),
		.o_data_mux	(data_add_rs1)
);

mux_2to1 mux4 (
		.i_data1	(i_rs2_f), 
		.i_data2	(i_rs3_f), 
		.sel		(muxc),
		.o_data_mux	(data_add_rs2)
);

fpu_add fpu_add_block (
	.sub 	(sub_sign),
	.x		(data_add_rs1),
	.y		(data_add_rs2),
	.out	(fpu_add_result)

);

fpu_mul fpu_mul_block (
	.x		(data_mul_rs1),
	.y		(data_mul_rs2),
	.out	(fpu_mul_result)

);

top_reciprocal reciprocal_block(
	.i_clk				(i_clk),
	.i_rst_n			(i_rst_n),
	.i_rs2_f			(i_rs2_f),
	.i_start			(start),
		
	.o_rs2_f_reciprocal	(fpu_reciprocal_result),
	.o_done				(o_done)
);

fclass fclass_block(
.i_rs1_f		(i_rs1_f),   // Input float (single-precision IEEE 754)
.o_rd			(fpu_class_result)     // Classification bits
);



fpu_comp fpu_comp_block(
	.i_rs1_f			(i_rs1_f), // First floating-point number
	.i_rs2_f			(i_rs2_f), // Second floating-point number
	.flt				(flt),      // Less than flag
	.feq				(feq),      // Equal flag
	.fle				(fle),      // Less than or equal flag
	.fmin				(min),     // Minimum flag
	.fmax				(max),     // Maximum flag
	.o_comp_result	(fpu_comp_result) // Comparison result
);
fpu_sign_inject fpu_sign_inject_block (
	.i_operand_a	(i_rs1_f),
	.i_operand_b	(i_rs2_f),
	.i_alu_op		(i_alu_op),
	.o_sign_inject	(fpu_sign_inject_result)

);
fpu_convert fpu_convert_block(
	.i_operand_a	(i_operand_a),    // Integer operand
	.i_rs1_f		(i_rs1_f),        // Floating-point operand
	.i_alu_op		(i_alu_op),       // Operation select
	.o_data_convert	(fpu_convert_result)    // Conversion result

);

final_select_fpu	final_select_mux (
	.fpu_add_result			(fpu_add_result),
	.fpu_mul_result			(fpu_mul_result),
	.fpu_sign_inject_result (fpu_sign_inject_result),
	.fpu_comp_result			(fpu_comp_result),
	.fpu_convert_result		(fpu_convert_result),
	.fpu_class_result		(fpu_class_result),
	.op_sel_F				(i_alu_op),
	.result_fpu				(o_fpu_data)
);

endmodule