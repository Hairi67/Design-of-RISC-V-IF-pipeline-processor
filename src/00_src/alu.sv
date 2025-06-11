module alu (
	input logic [31:0] i_operand_a,
	input logic [31:0] i_operand_b,
	input logic [3:0] i_alu_op,
	output logic [31:0] o_alu_data
);
	
    logic [31:0] subtemp;
    logic less;
    assign subtemp = i_operand_a + ~i_operand_b + 1;  
   assign less = ((i_operand_a[31] == 1) && (i_operand_b[31] == 0)) ? 0 : ((i_operand_a[31] == 0) && (i_operand_b[31] == 1)) ? 1 : ((subtemp[31] == 1) ? 1 : 0);  // less 
	 
	always_comb begin
		case(i_alu_op)
			4'b0000: o_alu_data = i_operand_a + i_operand_b;// ADD
			4'b0001: o_alu_data = i_operand_a + ~i_operand_b+1;// SUB 	
			4'b0010: if(i_operand_a[31]==1 && i_operand_b[31]==0)// SLT
					o_alu_data = 1;
				else begin
					if((i_operand_a[31]==1 && i_operand_b[31]==1)||(i_operand_a[31]==0 && i_operand_b[31]==0)) 
						begin
				    		if(subtemp[31]) 
								o_alu_data = 1;
							else 
								o_alu_data = 0;
						end
					else 
						o_alu_data = 0;
				end
			4'b0011: // SLTU 
			if(less) begin
					o_alu_data = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
			end else begin
					o_alu_data = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
            end
			4'b0100: o_alu_data = i_operand_a^i_operand_b;	//XOR
			4'b0101:  o_alu_data = i_operand_a|i_operand_b;	// OR
			4'b0110: o_alu_data = i_operand_a&i_operand_b;	// AND 
			
			
			4'b0111: begin //SLL
			case (i_operand_b)
			32'b00000 : o_alu_data = {i_operand_a[31:0]};
			32'b00001 : o_alu_data = {i_operand_a[30:0],1'b0};
			32'b00010 : o_alu_data = {i_operand_a[29:0],2'b0};
			32'b00011 : o_alu_data = {i_operand_a[28:0],3'b0};
			32'b00100 : o_alu_data = {i_operand_a[27:0],4'b0};
			32'b00101 : o_alu_data = {i_operand_a[26:0],5'b0};
			32'b00110 : o_alu_data = {i_operand_a[25:0],6'b0};
			32'b00111 : o_alu_data = {i_operand_a[24:0],7'b0};
			32'b01000 : o_alu_data = {i_operand_a[23:0],8'b0};
			32'b01001 : o_alu_data = {i_operand_a[22:0],9'b0};
			32'b01010 : o_alu_data = {i_operand_a[21:0],10'b0};
			32'b01011 : o_alu_data = {i_operand_a[20:0],11'b0};
			32'b01100 : o_alu_data = {i_operand_a[19:0],12'b0};
			32'b01101 : o_alu_data = {i_operand_a[18:0],13'b0};
			32'b01110 : o_alu_data = {i_operand_a[17:0],14'b0};
			32'b01111 : o_alu_data = {i_operand_a[16:0],15'b0};
			32'b10000 : o_alu_data = {i_operand_a[15:0],16'b0};
			32'b10001 : o_alu_data = {i_operand_a[14:0],17'b0};
			32'b10010 : o_alu_data = {i_operand_a[13:0],18'b0};
			32'b10011 : o_alu_data = {i_operand_a[12:0],19'b0};
			32'b10100 : o_alu_data = {i_operand_a[11:0],20'b0};
			32'b10101 : o_alu_data = {i_operand_a[10:0],21'b0};
			32'b10110 : o_alu_data = {i_operand_a[9:0],22'b0};
			32'b10111 : o_alu_data = {i_operand_a[8:0],23'b0};
			32'b11000 : o_alu_data = {i_operand_a[7:0],24'b0};
			32'b11001 : o_alu_data = {i_operand_a[6:0],25'b0};
			32'b11010 : o_alu_data = {i_operand_a[5:0],26'b0};
			32'b11011 : o_alu_data = {i_operand_a[4:0],27'b0};
			32'b11100 : o_alu_data = {i_operand_a[3:0],28'b0};
			32'b11101 : o_alu_data = {i_operand_a[2:0],29'b0};
			32'b11110 : o_alu_data = {i_operand_a[1:0],30'b0};
			32'b11111 : o_alu_data = {i_operand_a[0:0],31'b0};
			default: o_alu_data = 32'b0;
	endcase
	end


			4'b1000: begin 			// SRL
			case (i_operand_b)
			32'b00000 : o_alu_data = {i_operand_a[31:0]};
			32'b00001 : o_alu_data = {1'b0, i_operand_a[31:1]};
			32'b00010 : o_alu_data = {2'b0, i_operand_a[31:2]};
			32'b00011 : o_alu_data = {3'b0, i_operand_a[31:3]};
			32'b00100 : o_alu_data = {4'b0, i_operand_a[31:4]};
			32'b00101 : o_alu_data = {5'b0, i_operand_a[31:5]};
			32'b00110 : o_alu_data = {6'b0, i_operand_a[31:6]};
			32'b00111 : o_alu_data = {7'b0, i_operand_a[31:7]};
			32'b01000 : o_alu_data = {8'b0, i_operand_a[31:8]};
			32'b01001 : o_alu_data = {9'b0, i_operand_a[31:9]};
			32'b01010 : o_alu_data = {10'b0, i_operand_a[31:10]};
			32'b01011 : o_alu_data = {11'b0, i_operand_a[31:11]};
			32'b01100 : o_alu_data = {12'b0, i_operand_a[31:12]};
			32'b01101 : o_alu_data = {13'b0, i_operand_a[31:13]};
			32'b01110 : o_alu_data = {14'b0, i_operand_a[31:14]};
			32'b01111 : o_alu_data = {15'b0, i_operand_a[31:15]};
			32'b10000 : o_alu_data = {16'b0, i_operand_a[31:16]};
			32'b10001 : o_alu_data = {17'b0, i_operand_a[31:17]};
			32'b10010 : o_alu_data = {18'b0, i_operand_a[31:18]};
			32'b10011 : o_alu_data = {19'b0, i_operand_a[31:19]};
			32'b10100 : o_alu_data = {20'b0, i_operand_a[31:20]};
			32'b10101 : o_alu_data = {21'b0, i_operand_a[31:21]};
			32'b10110 : o_alu_data = {22'b0, i_operand_a[31:22]};
			32'b10111 : o_alu_data = {23'b0, i_operand_a[31:23]};
			32'b11000 : o_alu_data = {24'b0, i_operand_a[31:24]};
			32'b11001 : o_alu_data = {25'b0, i_operand_a[31:25]};
			32'b11010 : o_alu_data = {26'b0, i_operand_a[31:26]};
			32'b11011 : o_alu_data = {27'b0, i_operand_a[31:27]};
			32'b11100 : o_alu_data = {28'b0, i_operand_a[31:28]};
			32'b11101 : o_alu_data = {29'b0, i_operand_a[31:29]};
			32'b11110 : o_alu_data = {30'b0, i_operand_a[31:30]};
			32'b11111 : o_alu_data = {31'b0, i_operand_a[31:31]};
			default: o_alu_data = 32'b0;

	endcase
	end
			4'b1001: if (i_operand_a[31] == 0 )	//SRA
			begin
			case (i_operand_b)
			32'b00000 : o_alu_data = {i_operand_a[31:0]};
			32'b00001 : o_alu_data = {1'b0, i_operand_a[31:1]};
			32'b00010 : o_alu_data = {2'b0, i_operand_a[31:2]};
			32'b00011 : o_alu_data = {3'b0, i_operand_a[31:3]};
			32'b00100 : o_alu_data = {4'b0, i_operand_a[31:4]};
			32'b00101 : o_alu_data = {5'b0, i_operand_a[31:5]};
			32'b00110 : o_alu_data = {6'b0, i_operand_a[31:6]};
			32'b00111 : o_alu_data = {7'b0, i_operand_a[31:7]};
			32'b01000 : o_alu_data = {8'b0, i_operand_a[31:8]};
			32'b01001 : o_alu_data = {9'b0, i_operand_a[31:9]};
			32'b01010 : o_alu_data = {10'b0, i_operand_a[31:10]};
			32'b01011 : o_alu_data = {11'b0, i_operand_a[31:11]};
			32'b01100 : o_alu_data = {12'b0, i_operand_a[31:12]};
			32'b01101 : o_alu_data = {13'b0, i_operand_a[31:13]};
			32'b01110 : o_alu_data = {14'b0, i_operand_a[31:14]};
			32'b01111 : o_alu_data = {15'b0, i_operand_a[31:15]};
			32'b10000 : o_alu_data = {16'b0, i_operand_a[31:16]};
			32'b10001 : o_alu_data = {17'b0, i_operand_a[31:17]};
			32'b10010 : o_alu_data = {18'b0, i_operand_a[31:18]};
			32'b10011 : o_alu_data = {19'b0, i_operand_a[31:19]};
			32'b10100 : o_alu_data = {20'b0, i_operand_a[31:20]};
			32'b10101 : o_alu_data = {21'b0, i_operand_a[31:21]};
			32'b10110 : o_alu_data = {22'b0, i_operand_a[31:22]};
			32'b10111 : o_alu_data = {23'b0, i_operand_a[31:23]};
			32'b11000 : o_alu_data = {24'b0, i_operand_a[31:24]};
			32'b11001 : o_alu_data = {25'b0, i_operand_a[31:25]};
			32'b11010 : o_alu_data = {26'b0, i_operand_a[31:26]};
			32'b11011 : o_alu_data = {27'b0, i_operand_a[31:27]};
			32'b11100 : o_alu_data = {28'b0, i_operand_a[31:28]};
			32'b11101 : o_alu_data = {29'b0, i_operand_a[31:29]};
			32'b11110 : o_alu_data = {30'b0, i_operand_a[31:30]};
			32'b11111 : o_alu_data = {31'b0, i_operand_a[31:31]};
			default: o_alu_data = 32'b0;

	endcase
	end else begin
			case (i_operand_b)
			32'b00000 : o_alu_data = {i_operand_a[31:0]};
			32'b00001 : o_alu_data = {1'b1, i_operand_a[31:1]};
			32'b00010 : o_alu_data = {2'b11, i_operand_a[31:2]};
			32'b00011 : o_alu_data = {3'b111, i_operand_a[31:3]};
			32'b00100 : o_alu_data = {4'b1111, i_operand_a[31:4]};
			32'b00101 : o_alu_data = {5'b11111, i_operand_a[31:5]};
			32'b00110 : o_alu_data = {6'b111111, i_operand_a[31:6]};
			32'b00111 : o_alu_data = {7'b1111111, i_operand_a[31:7]};
			32'b01000 : o_alu_data = {8'b11111111, i_operand_a[31:8]};
			32'b01001 : o_alu_data = {9'b111111111, i_operand_a[31:9]};
			32'b01010 : o_alu_data = {10'b1111111111, i_operand_a[31:10]};
			32'b01011 : o_alu_data = {11'b11111111111, i_operand_a[31:11]};
			32'b01100 : o_alu_data = {12'b111111111111, i_operand_a[31:12]};
			32'b01101 : o_alu_data = {13'b1111111111111, i_operand_a[31:13]};
			32'b01110 : o_alu_data = {14'b11111111111111, i_operand_a[31:14]};
			32'b01111 : o_alu_data = {15'b111111111111111, i_operand_a[31:15]};
			32'b10000 : o_alu_data = {16'b1111111111111111, i_operand_a[31:16]};
			32'b10001 : o_alu_data = {17'b11111111111111111, i_operand_a[31:17]};
			32'b10010 : o_alu_data = {18'b111111111111111111, i_operand_a[31:18]};
			32'b10011 : o_alu_data = {19'b1111111111111111111, i_operand_a[31:19]};
			32'b10100 : o_alu_data = {20'b11111111111111111111, i_operand_a[31:20]};
			32'b10101 : o_alu_data = {21'b111111111111111111111, i_operand_a[31:21]};
			32'b10110 : o_alu_data = {22'b1111111111111111111111, i_operand_a[31:22]};
			32'b10111 : o_alu_data = {23'b11111111111111111111111, i_operand_a[31:23]};
			32'b11000 : o_alu_data = {24'b111111111111111111111111, i_operand_a[31:24]};
			32'b11001 : o_alu_data = {25'b1111111111111111111111111, i_operand_a[31:25]};
			32'b11010 : o_alu_data = {26'b11111111111111111111111111, i_operand_a[31:26]};
			32'b11011 : o_alu_data = {27'b111111111111111111111111111, i_operand_a[31:27]};
			32'b11100 : o_alu_data = {28'b1111111111111111111111111111, i_operand_a[31:28]};
			32'b11101 : o_alu_data = {29'b11111111111111111111111111111, i_operand_a[31:29]};
			32'b11110 : o_alu_data = {30'b111111111111111111111111111111, i_operand_a[31:30]};
			32'b11111 : o_alu_data = {31'b1111111111111111111111111111111, i_operand_a[31:31]};
			default: o_alu_data = 32'b0;

	endcase
	end
         4'b1110: o_alu_data = i_operand_a + i_operand_b;//AUIPC	
			4'b1111: o_alu_data = i_operand_b;																																// LUI
			default: o_alu_data = 32'b0;
		endcase
	end
endmodule : alu
