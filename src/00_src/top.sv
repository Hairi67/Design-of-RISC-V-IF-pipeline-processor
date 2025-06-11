module top (
	input logic          CLOCK_50,
	input logic  [17:0]  SW,
	input logic  [3:0]   GPIO_1,
	/////
	output logic [7:0]  LCD_DATA,
	output LCD_ON, LCD_RW, LCD_EN, LCD_RS,
	output logic [7:0]  LEDR,
	output logic [7:0]  LEDG,
	output logic [6:0]  HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
	output logic [3:0]  GPIO_0
);

wire [31:0] lcd_wire;
//wire clk_div_out;

Pipelined_RISCV_IF Pipelined_RISCV_IF_top (
	.i_clk		(CLOCK_50),
	.i_rst_n 	(SW[17]),
	.i_io_sw 	(SW[15:0]),
	.i_keypad	(GPIO_1[3:0]),
	.o_io_lcd	(lcd_wire),
	.o_io_ledg	(LEDG),
	.o_io_ledr	(LEDR),
	.o_io_hex0  (HEX0),
	.o_io_hex1	(HEX1),
	.o_io_hex2	(HEX2),
	.o_io_hex3	(HEX3),
	.o_io_hex4	(HEX4),
	.o_io_hex5	(HEX5),
	.o_io_hex6	(HEX6),
	.o_io_hex7	(HEX7),
	.o_keypad	(GPIO_0[3:0])
);

// 	// Instantiate the clock divider module

	// clock_div2 clk_div (
		// .clk_in(CLOCK_50),	// Input clock
		// .rst(KEY[1]),		// Reset signal (active high)
		// .clk_out(clk_div_out)	// Output clock (clk_in / 2)				
	// );


    assign LCD_ON = lcd_wire[31];
    assign LCD_EN = lcd_wire[10];
    assign LCD_RS = lcd_wire[9];
    assign LCD_RW = lcd_wire[8];
    assign LCD_DATA = lcd_wire[7:0];
	 
	 
	 
endmodule