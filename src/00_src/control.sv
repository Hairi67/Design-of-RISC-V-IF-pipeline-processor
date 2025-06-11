module control (
	input logic [31:0] i_instr,
	
	output logic o_pc_sel,
	output logic o_br_unsigned,
	output logic o_rd_wren_I,
	output logic o_op_a_sel,
	output logic o_op_b_sel,
	output logic [4:0] o_alu_op,
	output logic o_mem_wren,
	output logic [2:0] o_func,
	output logic [2:0] o_wb_sel,
	output logic o_lsu_sel,
	output logic o_rd_wren_F,
    output logic o_Reg_sel,	
	output logic insn_vld //invalid instructions
);
/*
wb_sel_0 == 000 => pc_four
wb_sel_0 == 001 => alu_data
wb_sel_0 == 010 => ld_data
wb_sel_0 == 011 => rs1_data
wb_sel_0 == 100 => rs1_f

reg_sel_o == 0 => reg_I
reg_sel_o == 1 => reg_F

lsu_sel_o == 0 => rs2_data
lsu_sel_o == 1 => rs2_f
*/
	logic [19:0]out;
	assign {o_pc_sel, o_rd_wren_I, o_br_unsigned, o_op_a_sel, o_op_b_sel, o_alu_op, o_mem_wren, o_func, o_wb_sel, o_lsu_sel, o_rd_wren_F, o_Reg_sel} = out;
	
	
always_comb begin
    // Default invalid instruction
    insn_vld = 1'b0;

    // NOP 
    if (i_instr == 32'b0) begin
        insn_vld = 1'b1;
    end
    // Validate opcode 
    else if (i_instr[6:2] == 5'b01100 ||  // R-type
             i_instr[6:2] == 5'b00100 ||  // I-type
             i_instr[6:2] == 5'b00000 ||  // Load
             i_instr[6:2] == 5'b01000 ||  // Store
             i_instr[6:2] == 5'b11000 ||  // Branch
             i_instr[6:2] == 5'b01101 ||  // LUI
             i_instr[6:2] == 5'b00101 ||  // AUIPC
             i_instr[6:2] == 5'b11001 ||  // JALR
             i_instr[6:2] == 5'b11011) begin // JAL
        
        case (i_instr[6:2])
            5'b01100: begin // R-type check funct7
                if (i_instr[31:25] == 7'b0100000 || i_instr[31:25] == 7'b0000000) begin
                    insn_vld = 1'b1;
                end
            end
            5'b00100: begin // I-type
                if ((i_instr[14:12] == 3'b001 && i_instr[31:25] == 7'b0000000) || 
                    (i_instr[14:12] == 3'b101 && i_instr[31:25] == 7'b0000000) || 
                    (i_instr[14:12] == 3'b101 && i_instr[31:25] == 7'b0100000) ) begin
                    insn_vld = 1'b1;
                end
            end
            5'b00000: begin // Load
                if (i_instr[14:12] == 3'b000 || i_instr[14:12] == 3'b001 || i_instr[14:12] == 3'b010 || i_instr[14:12] == 3'b100 || i_instr[14:12] == 3'b101) begin
                    insn_vld = 1'b1;
                end
            end
            5'b01000: begin // Store
                if (i_instr[14:12] == 3'b000 || i_instr[14:12] == 3'b001 || i_instr[14:12] == 3'b010) begin
                    insn_vld = 1'b1;
                end
            end
            5'b11000: begin // Branch
                if (i_instr[14:12] == 3'b000 || 
		    i_instr[14:12] == 3'b001 || 
 		    i_instr[14:12] == 3'b100 || 
		    i_instr[14:12] == 3'b101 || 
		    i_instr[14:12] == 3'b110 || 
		    i_instr[14:12] == 3'b111) begin
                    if (i_instr[9:8] == 2'b0) begin
                        insn_vld = 1'b1;
                    end
                end
            end
            5'b01101: begin // LUI
                insn_vld = 1'b1;  
            end
            5'b00101: begin // AUIPC
                
                if (i_instr[13:12] == 2'b0 ) begin
                    insn_vld = 1'b1;
                end
            end
            5'b11011: begin // JAL
                // Check JAL immediate is aligned 
                if (i_instr[13:12] == 2'b0) begin
                    insn_vld = 1'b1;
                end
            end
            5'b11001: begin // JALR I type
                // Check JALR immediate is aligned 
                if (i_instr[14:12] == 3'b0 && i_instr[21:20] == 2'b0 ) begin
                    insn_vld = 1'b1;
                end
            end
            default: insn_vld = 1'b1;
        endcase
    end
end


	always_comb begin
		case (i_instr[6:2]) 
				5'b01100: begin 
						case ({i_instr[30],i_instr[14:12]})//R-type						
							4'b0000: out = 20'b0_1_0_0_0_00000_0_111_001_0_0_0;//ADD
							4'b1000: out = 20'b0_1_0_0_0_00001_0_111_001_0_0_0;//SUB
							4'b0001: out = 20'b0_1_0_0_0_00111_0_111_001_0_0_0;//SLL
							4'b0010: out = 20'b0_1_0_0_0_00010_0_111_001_0_0_0;//SLT
							4'b0011: out = 20'b0_1_0_0_0_00011_0_111_001_0_0_0;//SLTU
							4'b0100: out = 20'b0_1_0_0_0_00100_0_111_001_0_0_0;//XOR
							4'b0101: out = 20'b0_1_0_0_0_01000_0_111_001_0_0_0;//SRL
							4'b1101: out = 20'b0_1_0_0_0_01001_0_111_001_0_0_0;//SRA
							4'b0110: out = 20'b0_1_0_0_0_00101_0_111_001_0_0_0;//OR
							4'b0111: out = 20'b0_1_0_0_0_00110_0_111_001_0_0_0;//AND
							default: out = 20'b0_0_0_0_0_00000_0_111_000_0_0_0;
						endcase
						end
				5'b00100: begin 
						case ({i_instr[14:12]}) //I-type
							 3'b000: out = 20'b0_1_0_0_1_00000_0_111_001_0_0_0; //ADDI
							 3'b010: out = 20'b0_1_0_0_1_00010_0_111_001_0_0_0; //SLTI
							 3'b011: out = 20'b0_1_0_0_1_00011_0_111_001_0_0_0; //SLTIU
							 3'b100: out = 20'b0_1_0_0_1_00100_0_111_001_0_0_0; //XORI
							 3'b110: out = 20'b0_1_0_0_1_00101_0_111_001_0_0_0; //ORI
							 3'b111: out = 20'b0_1_0_0_1_00110_0_111_001_0_0_0; //ANDI
							 3'b001: out = 20'b0_1_0_0_1_00111_0_111_001_0_0_0; //SLLI
							 3'b101: 
									case (i_instr[30]) 
										1'b0: out = 20'b0_1_0_0_1_01000_0_111_001_0_0_0; //SRLI
										1'b1: out = 20'b0_1_0_0_1_01001_0_111_001_0_0_0; //SRAI
									endcase
							 default: out = 20'b0_0_0_0_0_00000_0_111_000_0_0_0;
							endcase
						end
				5'b00000: begin 
						case(i_instr[14:12])  		//I-type
							3'b000: out = 20'b0_1_0_0_1_00000_0_000_010_0_0_0;//LB
							3'b001: out = 20'b0_1_0_0_1_00000_0_001_010_0_0_0;//LH
							3'b010: out = 20'b0_1_0_0_1_00000_0_010_010_0_0_0;//LW
							3'b100: out = 20'b0_1_0_0_1_00000_0_100_010_0_0_0;//LBU
							3'b101: out = 20'b0_1_0_0_1_00000_0_101_010_0_0_0;//LHU
							default: out = 20'b0_0_0_0_0_00000_0_111_000;
						endcase
						end
				5'b01000: begin 
						case(i_instr[14:12])             //S-type
							3'b000: out = 20'b0_0_0_0_1_00000_1_000_000_0_0_0;//SB
							3'b001: out = 20'b0_0_0_0_1_00000_1_001_000_0_0_0;//SH
							3'b010: out = 20'b0_0_0_0_1_00000_1_010_000_0_0_0;//SW
							default: out = 20'b0_0_0_0_0_00000_0_111_000_0_0_0;
						endcase
						end
				5'b11000: begin 
						case(i_instr[14:12])           //B-type
								3'b000: out = 20'b1_0_0_1_1_00000_0_111_000_0_0_0;//BEQ
								3'b001: out = 20'b1_0_0_1_1_00000_0_111_000_0_0_0;//BNE
								3'b100: out = 20'b1_0_0_1_1_00000_0_111_000_0_0_0;//BLT
								3'b101: out = 20'b1_0_0_1_1_00000_0_111_000_0_0_0;//BGE
								3'b110: out = 20'b1_0_1_1_1_00000_0_111_000_0_0_0;//BLTU
								3'b111: out = 20'b1_0_1_1_1_00000_0_111_000_0_0_0;//BGEU
							default: out = 20'b0_0_0_0_0_00000_0_111_000_0_0_0;
							endcase
						end
					5'b01101: begin//U-type
							out = 20'b0_1_0_0_1_01111_0_111_001_0_0_0;//LUI
						end
					5'b00101: begin//U-type
							out = 20'b0_1_0_1_1_01110_0_111_001_0_0_0;//AUIPC
						end
					5'b11001: begin 
							if(i_instr[14:12] == 3'b000) 
								out = 20'b1_1_0_0_1_00000_0_111_000_0_0_0;//JALR
							else out = 20'b0_0_0_0_0_00000_0_111_000_0_0_0;
						end
					5'b11011: begin
							out = 20'b1_1_0_1_1_00000_0_111_000_0_0_0;//JAL
						end
					5'b10100: begin 
							case ({i_instr[31:27]})						
								5'b00000: out = 20'b0_0_0_0_0_01010_0_111_001_0_1_1;//fadd.s
								5'b00001: out = 20'b0_0_0_0_0_01011_0_111_001_0_1_1;//fsub.s
								5'b00010: out = 20'b0_0_0_0_0_01100_0_111_001_0_1_1;//fmul.s
								5'b00011: out = 20'b0_0_0_0_0_01101_0_111_001_0_1_1;//fdiv.s
								5'b01011: out = 20'b0_0_0_0_0_10000_0_111_001_0_1_1;//fsqrt.s
								5'b00100: begin
										case (i_instr[14:12]) 
											3'b000: out = 20'b0_0_0_0_0_10001_0_111_001_0_1_1;//fsgnj.s
											3'b001: out = 20'b0_0_0_0_0_10010_0_111_001_0_1_1;//fsgnjn.s
											3'b010: out = 20'b0_0_0_0_0_10011_0_111_001_0_1_1;//fsgnjx.s
											default: out = 20'b0_0_0_0_0_00000_0_111_000_0_0_0;
										endcase																
									end
								5'b00101: begin
										case (i_instr[14:12]) 
											3'b000: out = 20'b0_0_0_0_0_10100_0_111_001_0_1_1;//fmin.s
											3'b001: out = 20'b0_0_0_0_0_10101_0_111_001_0_1_1;//fmax.s
											default: out = 20'b0_0_0_0_0_00000_0_111_000_0_0_0;
										endcase														
									end
								5'b11000:begin
										case (i_instr[24:20]) 
											5'b00000: out = 20'b0_1_0_0_0_10110_0_111_001_0_0_0;//fcvt.w.s
											5'b00001: out = 20'b0_1_0_0_0_10111_0_111_001_0_0_0;//fcvt.wu.s
											default: out = 20'b0_0_0_0_0_00000_0_111_000_0_0_0;
										endcase														
									end
								5'b11100: begin
										case (i_instr[14:12]) 
											3'b000: out = 20'b0_1_0_0_0_00000_0_111_100_0_0_0;//fmv.x.w
											3'b001: out = 20'b0_1_0_0_0_11000_0_111_001_0_0_0;//fclass.s
											default: out = 20'b0_0_0_0_0_00000_0_111_000_0_0_0;
										endcase	
									end
								5'b11010: begin
										case (i_instr[24:20]) 
											5'b00000: out = 20'b0_0_0_0_0_11001_0_111_001_0_1_1;//fcvt.s.w
											5'b00001: out = 20'b0_0_0_0_0_11010_0_111_001_0_1_1;//fcvt.s.wu
											default: out = 20'b0_0_0_0_0_00000_0_111_000_0_0_0;
										endcase														
									end
								5'b11110: out = 20'b0_0_0_0_0_00000_0_111_011_0_1_1; //fmv.w.x
								5'b10100:begin
										case (i_instr[14:12]) 
											3'b000: out = 20'b0_1_0_0_0_11011_0_111_001_0_0_0;//fle.s
											3'b001: out = 20'b0_1_0_0_0_11100_0_111_001_0_0_0;//flt.s
											3'b010: out = 20'b0_1_0_0_0_11101_0_111_001_0_0_0;//feq.s
											default: out = 20'b0_0_0_0_0_00000_0_111_000_0_0_0;
										endcase																
									end 						
								default: out = 20'b0_0_0_0_0_00000_0_111_000_0_0_0;
							endcase
							end
					5'b00001: //flw
							out = 20'b0_0_0_0_1_00000_0_010_010_0_1_1;
					5'b01001: //fsw
							out = 20'b0_0_0_0_1_00000_1_010_000_1_0_0;
					5'b10000: //fmadd.s
							out = 20'b0_0_0_0_0_11110_0_111_001_0_1_1;
					5'b10001: //fmsub.s
							out = 20'b0_0_0_0_0_11111_0_111_001_0_1_1;
					5'b10010: //fnmsub.s
							out = 20'b0_0_0_0_0_11110_0_111_001_0_1_1;
					5'b10011: //fnmadd.s
							out = 20'b0_0_0_0_0_11111_0_111_001_0_1_1;							
			default: out = 20'b0_0_0_0_0_00000_0_111_000_0_0_0;
			endcase
		end			
endmodule
