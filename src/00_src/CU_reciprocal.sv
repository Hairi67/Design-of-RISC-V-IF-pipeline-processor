module CU_reciprocal(
    input logic i_clk,
    input logic i_rst_n,
    input logic i_start,

    output logic [1:0]  o_sel_MUX31,
    output logic        o_sel_MUX2,
    output logic        o_sel_MUX3,
    output logic        o_sel_MUX4,
    output logic        o_ld_R1,
    output logic        o_ld_R2,
    output logic        o_ld_R3,
    output logic        o_ld_R4,
    output logic        o_sel_adder,

    output logic [4:0]  T,
    output logic        o_done
);

typedef enum logic [4:0] {
    T0, T1, T2, T3, T4, T5, T6, T7,
    T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18, T19,
    T20, T21, T22, T23, T24, T25, T26, T27

} state_t;

state_t state, next_state;

//logic [4:0] T;
assign T = state;


// State transition
always_ff @(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n)
		state <= T0;
	else begin
		case (state)
			T0: if (i_start) 
                state <= T1;
			default: state <= next_state;  
		endcase
	end
end


always_comb begin
    // Default values
    o_sel_MUX31 = 2'b00;
    o_sel_MUX2 = 1'b0;
    o_sel_MUX3 = 1'b0;
    o_sel_MUX4 = 1'b0;
    o_ld_R1 = 1'b0;
    o_ld_R2 = 1'b0;
    o_ld_R3 = 1'b0;
    o_ld_R4 = 1'b0;
    o_sel_adder = 1'b0;
    o_done = 1'b0;
    next_state = state; // Default to current state

    case (state)
        T0: begin

            next_state = T1;
        end
        T1: begin
            o_sel_MUX31 = 2'b00; // Select C
            o_sel_MUX2 = 1'b0; // Select modifier
            o_sel_MUX3 = 1'b0; // Select multiplier
            o_sel_MUX4 = 1'b1; // Select 0
            o_sel_adder = 1'b1; // add 0

            o_ld_R1 = 1'b1; // Load R1 with X0
            o_ld_R2 = 1'b1; // Load R2 with 0

            next_state = T2;
        end
        T2: begin

            o_ld_R1 = 1'b0; 
            o_ld_R2 = 1'b0; 

            o_ld_R3 = 1'b1; // Load R3 with X0
            o_ld_R4 = 1'b1; // Load R4 with X0
            next_state = T3;
        end

        T3: begin
            o_sel_MUX31 = 2'b01; // Select X
            o_sel_MUX2 = 1'b1; // Select X0
            o_sel_MUX3 = 1'b0; // Select multiplier data
            o_sel_MUX4 = 1'b1; // add 0
            o_sel_adder = 1'b1; // add 0

            o_ld_R1 = 1'b1; // Load R1 with X0 x X
            o_ld_R2 = 1'b0; // Load R2 with 0

            next_state = T4;
        end

        T4: begin

            o_ld_R3 = 1'b1; // Load R3 with X0 x X
            o_ld_R4 = 1'b0; // keep R4 as X0

            next_state = T5;
        end

        T5: begin
            o_sel_MUX3 = 1'b1; // Select X0 x X
            o_sel_MUX4 = 1'b0; // 2 - X0 x X
            o_sel_adder = 1'b1; // 2 - X0 x X

            o_ld_R1 = 1'b1; // Load R1 with X0 x X
            o_ld_R2 = 1'b1; // Load R2 with 0

            next_state = T6;
        end

        T6: begin

            o_sel_adder = 1'b1; // 2 - X0 x X

            o_ld_R3 = 1'b1; // Load R3 with X0 x X
            o_ld_R4 = 1'b0; // R4 keep as X0

            next_state = T7;
        end

        T7: begin
            o_sel_MUX31 = 2'b10; // Select 2 - X0 x X
            o_sel_MUX2 = 1'b1; // Select X0
            o_sel_MUX3 = 1'b0; // Select multiplier data
            o_sel_MUX4 = 1'b1; // add 0
            o_sel_adder = 1'b0; // add 0

            o_ld_R1 = 1'b1; // Load R1 with X0 x X
            o_ld_R2 = 1'b1; // Load R2 with 0

            next_state = T8;
        end

        T8: begin

            o_ld_R3 = 1'b1; // Load R3 with X1
            o_ld_R4 = 1'b1; // Load R4 with X1

            next_state = T9;
        end

        T9: begin
            o_sel_MUX31 = 2'b01; // Select X
            o_sel_MUX2 = 1'b1; // Select X1
            o_sel_MUX3 = 1'b0; // Select multiplier data
            o_sel_MUX4 = 1'b1; // add 0
            o_sel_adder = 1'b0; // add 0

            o_ld_R1 = 1'b1; // Load R1 with X1 x X
            o_ld_R2 = 1'b1; // Load R2 with 0

            next_state = T10;
        end

        T10: begin

            o_ld_R3 = 1'b1; // Load R3 with X1 x X
            o_ld_R4 = 1'b0; // keep X1

            next_state = T11;
        end

        T11: begin
            o_sel_MUX3 = 1'b1; // Select X1 x X
            o_sel_MUX4 = 1'b0; // 2 - X1 x X
            o_sel_adder = 1'b1; // 2 - X1 x X

            o_ld_R1 = 1'b1; // Load R1 with X0 x X
            o_ld_R2 = 1'b1; // Load R2 with 0

            next_state = T12;
        end

        T12: begin

            o_sel_adder = 1'b1; // 2 - X1 x X

            o_ld_R3 = 1'b1; // Load R3 with 2 - X1 x X
            o_ld_R4 = 1'b0; // R4 keep as X0

            next_state = T13;
        end

        T13: begin
            o_sel_MUX31 = 2'b10; // Select 2 - X1 x X
            o_sel_MUX2 = 1'b1; // Select X1
            o_sel_MUX3 = 1'b0; // Select multiplier data
            o_sel_MUX4 = 1'b1; // add 0
            o_sel_adder = 1'b0; // add 0

            o_ld_R1 = 1'b1; // Load R1 with (2 - X1 x X) x X1
            o_ld_R2 = 1'b1; // Load R2 with 0

            next_state = T14;
        end
        T14: begin

            o_ld_R3 = 1'b1; // Load R3 with X2
            o_ld_R4 = 1'b1; // Load R4 with X2

            next_state = T15;
        end

        T15: begin
            o_sel_MUX31 = 2'b01; // Select X
            o_sel_MUX2 = 1'b1; // Select X2
            o_sel_MUX3 = 1'b0; // Select multiplier data
            o_sel_MUX4 = 1'b1; // add 0
            o_sel_adder = 1'b0; // add 0

            o_ld_R1 = 1'b1; // Load R1 with X2 x X
            o_ld_R2 = 1'b1; // Load R2 with 0

            next_state = T16;

        end

        T16: begin

            o_ld_R3 = 1'b1; // Load R3 with X2 x X
            o_ld_R4 = 1'b0; // keep X2

            next_state = T17;
        end

        T17: begin
            o_sel_MUX3 = 1'b1; // Select X2 x X
            o_sel_MUX4 = 1'b0; // 2 - X2 x X
            o_sel_adder = 1'b1; // 2 - X2 x X

            o_ld_R1 = 1'b1; // Load R1 with (2 - X2 x X) 
            o_ld_R2 = 1'b1; // Load R2 with 0

            next_state = T18;
        end

        T18: begin

            o_sel_adder = 1'b1; // 2 - X2 x X

            o_ld_R3 = 1'b1; // Load R3 with 2 - X2 x X
            o_ld_R4 = 1'b0; // R4 keep as X0

            next_state = T19;
        end

        T19: begin

            o_sel_adder = 1'b1; // 2 - X2 x X

            o_ld_R3 = 1'b1; // Load R3 with 2 - X2 x X
            o_ld_R4 = 1'b0; // R4 keep as X0

            next_state = T20;
        end
        T20: begin
            o_sel_MUX31 = 2'b10; // Select 2 - X2 x X
            o_sel_MUX2 = 1'b1; // Select X2
            o_sel_MUX3 = 1'b0; // Select multiplier data
            o_sel_MUX4 = 1'b1; // add 0
            o_sel_adder = 1'b0; // add 0

            o_ld_R1 = 1'b1; // Load R1 with (2 - X2 x X) x X2
            o_ld_R2 = 1'b1; // Load R2 with 0

            next_state = T21;
        end

        T21: begin

            o_ld_R3 = 1'b1; // Load R3 with X3
            o_ld_R4 = 1'b1; // Load R4 with X3
            o_done = 1'b1;

            next_state = T0;
        end


        default: next_state = T0; // Reset to initial state on any other case

    endcase

end

endmodule