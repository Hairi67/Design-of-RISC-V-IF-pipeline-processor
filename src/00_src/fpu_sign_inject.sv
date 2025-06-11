module fpu_sign_inject (
    input logic [31:0] i_operand_a,
    input logic [31:0] i_operand_b,
    input logic [4:0]  i_alu_op,
    output logic [31:0] o_sign_inject
);



always_comb begin 
    case (i_alu_op) 
        5'b10001: o_sign_inject = {i_operand_b[31], i_operand_a[30:0]}; //float sign injection signed
        5'b10010: o_sign_inject = {~i_operand_b[31], i_operand_a[30:0]}; //float sign injection signed revert
        5'b10011: o_sign_inject = {i_operand_a[31] ^ i_operand_b[31], i_operand_a[30:0]}; //float sign injection XOR
        default:   o_sign_inject = 32'b0;
    endcase

end




endmodule