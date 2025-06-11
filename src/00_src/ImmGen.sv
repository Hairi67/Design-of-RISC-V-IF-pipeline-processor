module ImmGen (
    input  logic [31:0] instr,   
    output logic [31:0] ImmOut   
);

// Internal signal for Immediate type
    logic [31:0] ImmVal;
    logic [2:0]  ImmSel;   // Immediate format selector

//Determine the format based on Opcode [6:0] and funct3 [14:12]
    always_comb begin
         	case (instr[6:0])
            7'b0010011, 									// I-type (Immediate ALU operations like ADDI)
            7'b0000011, 									// I-type (Load instructions like LW)
            7'b1100111: ImmSel = 3'b000; 				// I-type (JALR)
            7'b0100011: ImmSel = 3'b001; 				// S-type (Store instructions like SW)
            7'b1100011: ImmSel = 3'b010; 				// B-type (Branch instructions like BEQ)
            7'b0110111, 									// U-type (LUI)
            7'b0010111: ImmSel = 3'b011; 				// U-type (AUIPC)					
            7'b1101111: ImmSel = 3'b100; 				// J-type (JAL)
				7'b0000111: ImmSel = 3'b101; 				// flw
				7'b0100111: ImmSel = 3'b110; 				// fsw
            default: begin
                // Check Funct3 if needed
			/*group9*/	case (instr[14:12])
                    3'b000: ImmSel = 3'b000; // Default I-type
                    default: ImmSel = 3'b000; // Default to I-type if not recognized
			endcase
	end
			endcase
	end

    // Immediate computation based on selected format (ImmSel)
    always_comb begin
        case (ImmSel)
            3'b000: ImmVal = {{20{instr[31]}}, instr[31:20]};               
            3'b001: ImmVal = {{20{instr[31]}}, instr[31:25], instr[11:7]};   
            3'b010: ImmVal = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};  
            3'b011: ImmVal = {instr[31:12], 12'b0};                         
            3'b100: ImmVal = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
				3'b101: ImmVal = {{20{instr[31]}}, instr[31:20]};
				3'b110: ImmVal = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            default: ImmVal = 32'b0;
        endcase
    end

    // Output the immediate value
    assign ImmOut = ImmVal;

endmodule