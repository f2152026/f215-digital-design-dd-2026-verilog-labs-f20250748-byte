// cla4.v
// Gate-level 4-bit carry-lookahead adder, matching the lecture circuit.
// Every gate needs an explicit delay (constant is fine here, e.g. #(2)) --
// this is the default from Task 2 onward, not a special step.
//
// TODO -- Step 1: generate/propagate signals (one xor + one and per bit)
//   p[i] = a[i] ^ b[i]
//   g[i] = a[i] & b[i]
//
// TODO -- Step 2: direct (non-recursive) carry equations. Verilog's and/or
// primitives accept more than 2 inputs directly, e.g.:
//   and #(2) (t2, p1, p0, g0);
// so you do not need to manually chain 2-input gates.
//   c1 = g0 + p0.cin
//   c2 = g1 + p1.g0 + p1.p0.cin
//   c3 = g2 + p2.g1 + p2.p1.g0 + p2.p1.p0.cin
//   c4 = g3 + p3.g2 + p3.p2.g1 + p3.p2.p1.g0 + p3.p2.p1.p0.cin
//
// TODO -- Step 3: sum bits
//   sum[i] = p[i] ^ c[i]     (c0 = cin)

module cla4(
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       cout
);

  wire [3:0] p, g;
  wire c1, c2, c3;

  // TODO: your gate-level P/G, carry, and sum logic goes here.
  xor #(2) p0 (p[0], a[0], b[0]);
  and #(2) g0 (g[0], a[0], b[0]);
  xor #(2) p1 (p[1], a[1], b[1]);
  and #(2) g1 (g[1], a[1], b[1]);
  xor #(2) p2 (p[2], a[2], b[2]);
  and #(2) g2 (g[2], a[2], b[2]);
  xor #(2) p3 (p[3], a[3], b[3]);
  and #(2) g3 (g[3], a[3], b[3]);
  // (cout should be connected to c4.) Remember the delay on every gate.
  wire c1_term1;
  and #(2) a_c1_1(c1_term1, p[0], cin);
  or  #(2) gc1  (c1, g[0], c1_term1);
  wire c2_term1, c2_term2;
  and #(2) a_c2_1(c2_term1, p[1], g[0]);
  and #(2) a_c2_2(c2_term2, p[1], p[0], cin); 
  or  #(2) gc2  (c2, g[1], c2_term1, c2_term2);
  wire c3_term1, c3_term2, c3_term3;
  and #(2) a_c3_1(c3_term1, p[2], g[1]);
  and #(2) a_c3_2(c3_term2, p[2], p[1], g[0]);
  and #(2) a_c3_3(c3_term3, p[2], p[1], p[0], cin);
  or  #(2) gc3  (c3, g[2], c3_term1, c3_term2, c3_term3);
  wire cout_term1, cout_term2, cout_term3, cout_term4;
  and #(2) a_cout_1(cout_term1, p[3], g[2]);
  and #(2) a_cout_2(cout_term2, p[3], p[2], g[1]);
  and #(2) a_cout_3(cout_term3, p[3], p[2], p[1], g[0]);
  and #(2) a_cout_4(cout_term4, p[3], p[2], p[1], p[0], cin);
  or  #(2) gcout  (cout, g[3], cout_term1, cout_term2, cout_term3, cout_term4);


  xor #(2) s0 (sum[0], p[0], cin);
  xor #(2) s1 (sum[1], p[1], c1);
  xor #(2) s2 (sum[2], p[2], c2);
  xor #(2) s3 (sum[3], p[3], c3);
  

endmodule
