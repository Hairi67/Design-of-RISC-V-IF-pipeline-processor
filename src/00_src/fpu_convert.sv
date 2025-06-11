module fpu_convert (
    input  logic [31:0] i_operand_a,      // Integer operand (signed or unsigned - assumed based on op)
    input  logic [31:0] i_rs1_f,          // Floating-point operand (IEEE 754 single-precision)
    input  logic [4:0]  i_alu_op,         // Operation select
    output logic [31:0] o_data_convert    // Conversion result
);

    // Define operation codes
    localparam OP_FCVT_S_W  = 5'b11001; // Signed Int to Float
    localparam OP_FCVT_S_WU = 5'b11010; // Unsigned Int to Float
    localparam OP_FCVT_W_S  = 5'b10110; // Float to Signed Int
    localparam OP_FCVT_WU_S = 5'b10111; // Float to Unsigned Int

    // Intermediate signals for Integer-to-Float
    logic        int_sign;
    logic [31:0] int_abs_val;
    logic [7:0]  float_exponent_unbiased;
    logic [22:0] float_mantissa;
    // logic [4:0]  shift_amount_int_flt; // Removed as it was unused
    logic        is_zero_int;
    logic [63:0] shifted_int;
    integer      leading_zeros; // Range 0-32

    // Intermediate signals for Float-to-Integer
    logic        float_sign;
    logic [7:0]  float_exponent_biased;
    logic [22:0] float_mantissa_in;
    logic [23:0] float_significand_int;
    logic signed [8:0] float_exponent_actual;   // Range approx -127 to 128
    logic signed [8:0] shift_amount_flt_int;    // Range approx -150 to 105
    logic [63:0] shifted_significand;
    logic [31:0] int_result;
    logic        is_zero_float;
    logic        is_denormal_float;
    logic        is_normal_float;
    logic        is_nan_float;
    logic        is_inf_float;

    // Decode Float Input
    assign float_sign              = i_rs1_f[31];
    assign float_exponent_biased   = i_rs1_f[30:23];
    assign float_mantissa_in       = i_rs1_f[22:0];
    // Fixed warning: truncated value with size 32 to match size of target (9)
    assign float_exponent_actual   = signed'({1'b0, float_exponent_biased}) - 9'd127;

    // Classify float number
    assign is_zero_float       = (float_exponent_biased == 8'b0) && (float_mantissa_in == 23'b0);
    assign is_denormal_float   = (float_exponent_biased == 8'b0) && (float_mantissa_in != 23'b0);
    assign is_normal_float     = (float_exponent_biased != 8'b0) && (float_exponent_biased != 8'hFF);
    assign is_inf_float        = (float_exponent_biased == 8'hFF) && (float_mantissa_in == 23'b0);
    assign is_nan_float        = (float_exponent_biased == 8'hFF) && (float_mantissa_in != 23'b0);

    // Construct integer significand
    assign float_significand_int = is_normal_float ? {1'b1, float_mantissa_in} : {1'b0, float_mantissa_in};

    // --- Integer to Float Conversion Logic ---
    assign int_sign    = (i_alu_op == OP_FCVT_S_W) ? i_operand_a[31] : 1'b0;
    assign int_abs_val = (i_alu_op == OP_FCVT_S_W && i_operand_a[31]) ? -i_operand_a : i_operand_a;
    assign is_zero_int = (int_abs_val == 32'b0);

    always_comb begin
        leading_zeros = 32;
        if (!is_zero_int) begin
            for (int i = 31; i >= 0; i = i - 1) begin
                if (int_abs_val[i]) begin
                    leading_zeros = 31 - i;
                    break;
                end
            end
        end
    end

    // assign shift_amount_int_flt    = leading_zeros; // Removed
    // Fixed warning: truncated value with size 32 to match size of target (8)
    // (31 - leading_zeros) is in [0,31] for non-zero int. Sum (127 to 158) fits in 8 bits.
    assign float_exponent_unbiased = (is_zero_int) ? 8'b0 : 8'( (31 - leading_zeros) + 127 );
    // Fixed warning: converting signed shift amount to unsigned
    assign shifted_int             = int_abs_val << unsigned'(leading_zeros);
    assign float_mantissa          = (is_zero_int) ? 23'b0 : shifted_int[30:8];

    // --- Float to Integer Conversion Logic ---
    // Fixed warning: truncated value with size 32 to match size of target (9)
    assign shift_amount_flt_int = float_exponent_actual - 9'd23;

    always_comb begin
        logic overflow_signed;
        logic overflow_unsigned;
        logic [63:0] temp_sig_comb;

        int_result = 32'b0;
        shifted_significand = 64'b0;

        if (is_nan_float) begin
            if (i_alu_op == OP_FCVT_W_S) int_result = 32'h7FFFFFFF;
            else int_result = 32'hFFFFFFFF;
        end else if (is_inf_float) begin
            if (i_alu_op == OP_FCVT_W_S) int_result = float_sign ? 32'h80000000 : 32'h7FFFFFFF;
            else int_result = float_sign ? 32'h00000000 : 32'hFFFFFFFF;
        end else if (is_zero_float || is_denormal_float || float_exponent_actual < 0) begin
            int_result = 32'b0;
        end else if (float_exponent_actual > 31) begin
            if (i_alu_op == OP_FCVT_W_S) int_result = float_sign ? 32'h80000000 : 32'h7FFFFFFF;
            else int_result = float_sign ? 32'h00000000 : 32'hFFFFFFFF;
        end else begin
            temp_sig_comb = {40'b0, float_significand_int};

            if (shift_amount_flt_int >= 0) begin
                // Fixed warning: converting signed shift amount to unsigned
                shifted_significand = temp_sig_comb << unsigned'(shift_amount_flt_int);
            end else begin
                // Fixed warning: converting signed shift amount to unsigned
                shifted_significand = temp_sig_comb >> unsigned'(-shift_amount_flt_int);
            end

            int_result = shifted_significand[31:0];

            overflow_signed   = (float_sign == 0 && shifted_significand[63:31] != 0) ||
                                (float_sign == 1 && shifted_significand > {32'b0, 32'h80000000});
            overflow_unsigned = (shifted_significand[63:32] != 0);

            if (i_alu_op == OP_FCVT_W_S) begin // Signed
                if (overflow_signed) begin
                    int_result = float_sign ? 32'h80000000 : 32'h7FFFFFFF;
                end else if (float_sign) begin
                    int_result = -int_result;
                end
            end else begin // Unsigned
                if (float_sign) begin
                    int_result = 32'b0;
                end else if (overflow_unsigned) begin
                    int_result = 32'hFFFFFFFF;
                end
            end
        end
    end

    // Select output based on operation
    always_comb begin
        case (i_alu_op)
            OP_FCVT_S_W, OP_FCVT_S_WU: begin
                if (is_zero_int) begin
                    o_data_convert = 32'b0;
                end else begin
                    o_data_convert = {int_sign, float_exponent_unbiased, float_mantissa};
                end
            end
            OP_FCVT_W_S, OP_FCVT_WU_S: begin
                o_data_convert = int_result;
            end
            default: begin
                o_data_convert = 32'b0;
            end
        endcase
    end

endmodule