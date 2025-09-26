// Módulo estrutural para um multiplexador de 2 para 1 de 5 bits
module Mux2para1_5bit(
    input [4:0] a,
    input [4:0] b,
    input sel,
    output [4:0] out
);
    wire nsel;
    wire out_a0, out_a1, out_a2, out_a3, out_a4;
    wire out_b0, out_b1, out_b2, out_b3, out_b4;

    not not_sel(nsel, sel);

    and and_a0(out_a0, a[0], nsel); and and_a1(out_a1, a[1], nsel); and and_a2(out_a2, a[2], nsel); and and_a3(out_a3, a[3], nsel); and and_a4(out_a4, a[4], nsel);
    and and_b0(out_b0, b[0], sel);  and and_b1(out_b1, b[1], sel);  and and_b2(out_b2, b[2], sel);  and and_b3(out_b3, b[3], sel);  and and_b4(out_b4, b[4], sel);

    or or_out0(out[0], out_a0, out_b0); or or_out1(out[1], out_a1, out_b1); or or_out2(out[2], out_a2, out_b2); or or_out3(out[3], out_a3, out_b3); or or_out4(out[4], out_a4, out_b4);
endmodule