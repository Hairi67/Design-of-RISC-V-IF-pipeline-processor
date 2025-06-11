module comp_block (
  input logic [31:0]  i_rs1_f, 
  input logic [31:0]  i_rs2_f,
  output logic        greater_than,           // Final outputs
  output logic        equal,
  output logic        less_than
);

  // Intermediate comparator outputs
  logic [0:0] Sa, Sb; // Sign bits
  logic [7:0] Ea, Eb; // Exponent bits
  logic [22:0] Ma, Mb; // Mantissa bits
  // Extract sign, exponent, and mantissa from the inputs
  assign Sa = i_rs1_f[31];
  assign Sb = i_rs2_f[31];
  assign Ea = i_rs1_f[30:23];
  assign Eb = i_rs2_f[30:23];
  assign Ma = i_rs1_f[22:0];
  assign Mb = i_rs2_f[22:0];

  logic Sa_gt, Sa_eq, Sa_lt;
  logic [1:0] Ea_comp, Ma_comp; // [1]=greater, [0]=equal
  logic Ea_gt, Ea_eq, Ea_lt;
  logic Ma_gt, Ma_eq, Ma_lt;

  // Instantiate 1-bit comparator for sign
  comparator_1bit sign_comp (
    .a_1(Sa),
    .b_1(Sb),
    .greater_1(Sa_gt),
    .equal_1(Sa_eq),
    .less_1(Sa_lt)
  );

  // Instantiate 4-bit comparator for exponent
  comparator_8bit exponent_comp (
    .a_8(Ea),
    .b_8(Eb),
    .greater_8(Ea_gt),
    .equal_8(Ea_eq),
    .less_8(Ea_lt)
  );

  // Instantiate 11-bit comparator for mantissa
  comparator_23bit mantissa_comp (
    .a_23(Ma),
    .b_23(Mb),
    .greater_23(Ma_gt),
    .equal_23(Ma_eq),
    .less_23(Ma_lt)
  );

  // Logic for final outputs
  // Greater-than logic
  assign greater_than = (Sa_lt) |
                        (Sa_eq & Ea_gt) |
                        (Sa_eq & Ea_eq & Ma_gt);

  // Equal logic
  assign equal = (Sa_eq & Ea_eq & Ma_eq);

  // Less-than logic
  assign less_than = (Sa_gt) |
                      (Sa_eq & Ea_lt) |
                      (Sa_eq & Ea_eq & Ma_lt);

endmodule
