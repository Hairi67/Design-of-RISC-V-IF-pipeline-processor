`timescale 1ns / 1ps

module tb_Pipelined_RISCV_IF;

  // Parameters (matching the DUT's defaults or your specific instantiation)
  localparam WIDTH = 32;
  localparam HEX_DATA_WIDTH = 7;
  localparam DATA_WIDTH = 8;

  // DUT Inputs
  logic                         i_clk;
  logic                         i_rst_n;
  logic [WIDTH-1:0]             i_io_sw;
  logic [3:0]                   i_keypad;

  // DUT Outputs
  logic [WIDTH-1:0]             o_io_lcd;
  logic [DATA_WIDTH-1:0]        o_io_ledg;
  logic [DATA_WIDTH-1:0]        o_io_ledr;
  logic [HEX_DATA_WIDTH-1:0]    o_io_hex0;
  logic [HEX_DATA_WIDTH-1:0]    o_io_hex1;
  logic [HEX_DATA_WIDTH-1:0]    o_io_hex2;
  logic [HEX_DATA_WIDTH-1:0]    o_io_hex3;
  logic [HEX_DATA_WIDTH-1:0]    o_io_hex4;
  logic [HEX_DATA_WIDTH-1:0]    o_io_hex5;
  logic [HEX_DATA_WIDTH-1:0]    o_io_hex6;
  logic [HEX_DATA_WIDTH-1:0]    o_io_hex7;
  logic [HEX_DATA_WIDTH:0]      o_keypad; // Note: DUT output is [HEX_DATA_WIDTH:0] -> [7:0]
  logic [WIDTH-1:0]             instruction;
  logic [WIDTH-1:0]             ld_data_wb;
  logic [WIDTH-1:0]             alu_data_ex;
  logic [4:0]                   alu_op_ex;
  logic [WIDTH-1:0]             operand_a_ex;
  logic [WIDTH-1:0]             operand_b_ex;
  logic [WIDTH-1:0] fwdA_f, fwdB_f, fwdC_f;
  logic [WIDTH-1:0]             wb_data;
  logic [WIDTH-1:0]             pc;
logic [31:0] x1,  x2,  x3,  x4,  x5,
             x6,  x7,  x8,  x9,  x10,
             x11, x12, x13, x14, x15,
             x16, x17, x18, x19, x20,
             x21, x22, x23, x24, x25,
             x26, x27, x28, x29, x30,
             x31;
logic [31:0] f1,  f2,  f3,  f4,  f5,
                    f6,  f7,  f8,  f9,  f10,
                    f11, f12, f13, f14, f15,
                    f16, f17, f18, f19, f20,
                    f21, f22, f23, f24, f25,
                    f26, f27, f28, f29, f30, f31;	
  // Instantiate the Device Under Test (DUT)
  Pipelined_RISCV_IF #(
      .WIDTH(WIDTH),
      .HEX_DATA_WIDTH(HEX_DATA_WIDTH),
      .DATA_WIDTH(DATA_WIDTH)
  ) DUT (
      .i_clk(i_clk),
      .i_rst_n(i_rst_n),
      .i_io_sw(i_io_sw),
      .i_keypad(i_keypad),

      .o_io_lcd(o_io_lcd),
      .o_io_ledg(o_io_ledg),
      .o_io_ledr(o_io_ledr),
      .o_io_hex0(o_io_hex0),
      .o_io_hex1(o_io_hex1),
      .o_io_hex2(o_io_hex2),
      .o_io_hex3(o_io_hex3),
      .o_io_hex4(o_io_hex4),
      .o_io_hex5(o_io_hex5),
      .o_io_hex6(o_io_hex6),
      .o_io_hex7(o_io_hex7),
      .o_keypad(o_keypad),
      .instruction(instruction),
      .ld_data_wb(ld_data_wb),
      .alu_data_ex(alu_data_ex),
      .alu_op_ex(alu_op_ex),
      .operand_a_ex(operand_a_ex),
      .operand_b_ex(operand_b_ex),
      .wb_data(wb_data),
      .pc(pc),
	  .fwdA_f(fwdA_f), .fwdB_f(fwdB_f), .fwdC_f(fwdC_f),
    .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5),
    .x6(x6), .x7(x7), .x8(x8), .x9(x9), .x10(x10),
    .x11(x11), .x12(x12), .x13(x13), .x14(x14), .x15(x15),
    .x16(x16), .x17(x17), .x18(x18), .x19(x19), .x20(x20),
    .x21(x21), .x22(x22), .x23(x23), .x24(x24), .x25(x25),
    .x26(x26), .x27(x27), .x28(x28), .x29(x29), .x30(x30),
    .x31(x31),

	 .f1(f1), .f2(f2), .f3(f3), .f4(f4), .f5(f5),
    .f6(f6), .f7(f7), .f8(f8), .f9(f9), .f10(f10),
    .f11(f11), .f12(f12), .f13(f13), .f14(f14), .f15(f15),
    .f16(f16), .f17(f17), .f18(f18), .f19(f19), .f20(f20),
    .f21(f21), .f22(f22), .f23(f23), .f24(f24), .f25(f25),
    .f26(f26), .f27(f27), .f28(f28), .f29(f29), .f30(f30),
    .f31(f31)		
  );

  // Clock generation
  localparam CLK_PERIOD = 10; // Clock period of 10 ns (100 MHz)
  always begin
    i_clk = 1'b0;
    #(CLK_PERIOD / 2);
    i_clk = 1'b1;
    #(CLK_PERIOD / 2);
  end

  // Simulation sequence
  initial begin
    $display("Starting Testbench for Pipelined_RISCV_IF");

    // 1. Initialize Inputs and Apply Reset
    i_rst_n = 1'b0; // Assert active-low reset
    i_io_sw = 32'h0000A700;
    i_keypad = 4'b0000;

    $display("Time: %0t: Reset Asserted.", $time);
    repeat (5) @(posedge i_clk); // Hold reset for a few cycles

    i_rst_n = 1'b1; // De-assert reset
    $display("Time: %0t: Reset De-asserted. Processor should start fetching.", $time);

    // 2. Let the simulation run for a specific duration
    // Adjust the number of cycles as needed for your test sequence.
    // The processor should be fetching and executing instructions from its internal source.
    repeat (3000) @(posedge i_clk); // Run for 300 clock cycles

    // 3. Finish Simulation
    $display("Time: %0t: Simulation finished after 300 cycles post-reset.", $time);
	$display("===== Register File State =====");
	$display("x1  = 0x%08x", x1);
	$display("x2  = 0x%08x", x2);
	$display("x3  = 0x%08x", x3);
	$display("x4  = 0x%08x", x4);
	$display("x5  = 0x%08x", x5);
	$display("x6  = 0x%08x", x6);
	$display("x7  = 0x%08x", x7);
	$display("x8  = 0x%08x", x8);
	$display("x9  = 0x%08x", x9);
	$display("x10 = 0x%08x", x10);
	$display("x11 = 0x%08x", x11);
	$display("x12 = 0x%08x", x12);
	$display("x13 = 0x%08x", x13);
	$display("x14 = 0x%08x", x14);
	$display("x15 = 0x%08x", x15);
	$display("x16 = 0x%08x", x16);
	$display("x17 = 0x%08x", x17);
	$display("x18 = 0x%08x", x18);
	$display("x19 = 0x%08x", x19);
	$display("x20 = 0x%08x", x20);
	$display("x21 = 0x%08x", x21);
	$display("x22 = 0x%08x", x22);
	$display("x23 = 0x%08x", x23);
	$display("x24 = 0x%08x", x24);
	$display("x25 = 0x%08x", x25);
	$display("x26 = 0x%08x", x26);
	$display("x27 = 0x%08x", x27);
	$display("x28 = 0x%08x", x28);
	$display("x29 = 0x%08x", x29);
	$display("x30 = 0x%08x", x30);
	$display("x31 = 0x%08x", x31);	
    $finish;
  end

  // Optional: Monitor key signals for debugging
  // This block will print signal values on each positive clock edge after reset is de-asserted.
  always @(posedge i_clk) begin
    if (i_rst_n) begin
      // A more concise display for general pipeline flow:
       $display("Time: %0t, PC: 0x%h, Instr: 0x%h, EX_ALU: 0x%h, ALU_A_EX: %h, ALU_B_EX: %h, WB_Data: 0x%h, WB_RegWr: %b",
                $time, pc, instruction, alu_data_ex, operand_a_ex, operand_b_ex, wb_data, (DUT.rd_wren_I_wb || DUT.rd_wren_F_wb));
				
    end
  end

endmodule