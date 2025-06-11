module brc #(
    parameter data_width = 32
)(
    input  logic [data_width-1:0] i_rs1_data,
    input  logic [data_width-1:0] i_rs2_data,
    input  logic                  i_br_un,       // 1: unsigned, 0: signed
    output logic                  o_br_less,
    output logic                  o_br_equal
);

    logic rs1_neg, rs2_neg;
    logic unsigned_less;

    assign rs1_neg = i_rs1_data[31];
    assign rs2_neg = i_rs2_data[31];

    function logic unsigned_less_than(
        input logic [31:0] a,
        input logic [31:0] b
    );
        for (int i = 31; i >= 0; i--) begin
            if (a[i] != b[i]) begin
                return (a[i] == 0);  // a < b
            end
        end
        return 0;
    endfunction

    always_comb begin
        o_br_equal = (i_rs1_data == i_rs2_data);

        if (i_br_un) begin
            o_br_less = unsigned_less_than(i_rs1_data, i_rs2_data);
        end else begin
            case ({rs1_neg, rs2_neg})
                2'b00: o_br_less = unsigned_less_than(i_rs1_data, i_rs2_data); // both positive
                2'b01: o_br_less = 0;
                2'b10: o_br_less = 1;
                2'b11: o_br_less = unsigned_less_than(i_rs1_data, i_rs2_data); // both negative
            endcase
        end
    end

endmodule
function logic unsigned_less_than(
    input logic [31:0] a,
    input logic [31:0] b
);
    for (int i = 31; i >= 0; i--) begin
        if (a[i] != b[i]) begin
            return (a[i] == 0);  // a < b if a[i] == 0 and b[i] == 1
        end
    end
    return 0;  // equal
endfunction
