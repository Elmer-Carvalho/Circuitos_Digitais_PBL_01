// Módulo para converter um número binário de 8 bits para 3 dígitos BCD
// VERSÃO PURAMENTE ESTRUTURAL - Algoritmo "Double Dabble" desenrolado
module BinarioParaBCD(
    input [7:0] bin_in,
    output [3:0] bcd_centenas,
    output [3:0] bcd_dezenas,
    output [3:0] bcd_unidades
);
    // Wires para cada estágio do shift-and-add
    wire [3:0] u0, d0, c0; // Estágio inicial
    wire [3:0] u1_adj, d1_adj, c1_adj; wire [3:0] u1, d1, c1;
    wire [3:0] u2_adj, d2_adj, c2_adj; wire [3:0] u2, d2, c2;
    wire [3:0] u3_adj, d3_adj, c3_adj; wire [3:0] u3, d3, c3;
    wire [3:0] u4_adj, d4_adj, c4_adj; wire [3:0] u4, d4, c4;
    wire [3:0] u5_adj, d5_adj, c5_adj; wire [3:0] u5, d5, c5;
    wire [3:0] u6_adj, d6_adj, c6_adj; wire [3:0] u6, d6, c6;
    wire [3:0] u7_adj, d7_adj, c7_adj; wire [3:0] u7, d7, c7;
    wire [3:0] u8_adj, d8_adj, c8_adj;

    // Estágio 0: Inicialização com zeros
    buf buf_u00(u0[0], 1'b0); buf buf_u01(u0[1], 1'b0); buf buf_u02(u0[2], 1'b0); buf buf_u03(u0[3], 1'b0);
    buf buf_d00(d0[0], 1'b0); buf buf_d01(d0[1], 1'b0); buf buf_d02(d0[2], 1'b0); buf buf_d03(d0[3], 1'b0);
    buf buf_c00(c0[0], 1'b0); buf buf_c01(c0[1], 1'b0); buf buf_c02(c0[2], 1'b0); buf buf_c03(c0[3], 1'b0);

    // --- Ciclo 1 (para bin_in[7]) ---
    Add3_if_GTE5 adj1_u(u0, u1_adj); Add3_if_GTE5 adj1_d(d0, d1_adj); Add3_if_GTE5 adj1_c(c0, c1_adj);
    buf s1_c3(c1[3], c1_adj[2]); buf s1_c2(c1[2], c1_adj[1]); buf s1_c1(c1[1], c1_adj[0]); buf s1_c0(c1[0], d1_adj[3]);
    buf s1_d3(d1[3], d1_adj[2]); buf s1_d2(d1[2], d1_adj[1]); buf s1_d1(d1[1], d1_adj[0]); buf s1_d0(d1[0], u1_adj[3]);
    buf s1_u3(u1[3], u1_adj[2]); buf s1_u2(u1[2], u1_adj[1]); buf s1_u1(u1[1], u1_adj[0]); buf s1_u0(u1[0], bin_in[7]);
    
    // --- Ciclo 2 (para bin_in[6]) ---
    Add3_if_GTE5 adj2_u(u1, u2_adj); Add3_if_GTE5 adj2_d(d1, d2_adj); Add3_if_GTE5 adj2_c(c1, c2_adj);
    buf s2_c3(c2[3], c2_adj[2]); buf s2_c2(c2[2], c2_adj[1]); buf s2_c1(c2[1], c2_adj[0]); buf s2_c0(c2[0], d2_adj[3]);
    buf s2_d3(d2[3], d2_adj[2]); buf s2_d2(d2[2], d2_adj[1]); buf s2_d1(d2[1], d2_adj[0]); buf s2_d0(d2[0], u2_adj[3]);
    buf s2_u3(u2[3], u2_adj[2]); buf s2_u2(u2[2], u2_adj[1]); buf s2_u1(u2[1], u2_adj[0]); buf s2_u0(u2[0], bin_in[6]);

    // ... (O padrão se repete para os ciclos 3 a 7) ...
    Add3_if_GTE5 adj3_u(u2, u3_adj); Add3_if_GTE5 adj3_d(d2, d3_adj); Add3_if_GTE5 adj3_c(c2, c3_adj);
    buf s3_c3(c3[3], c3_adj[2]); buf s3_c2(c3[2], c3_adj[1]); buf s3_c1(c3[1], c3_adj[0]); buf s3_c0(c3[0], d3_adj[3]);
    buf s3_d3(d3[3], d3_adj[2]); buf s3_d2(d3[2], d3_adj[1]); buf s3_d1(d3[1], d3_adj[0]); buf s3_d0(d3[0], u3_adj[3]);
    buf s3_u3(u3[3], u3_adj[2]); buf s3_u2(u3[2], u3_adj[1]); buf s3_u1(u3[1], u3_adj[0]); buf s3_u0(u3[0], bin_in[5]);
    
    Add3_if_GTE5 adj4_u(u3, u4_adj); Add3_if_GTE5 adj4_d(d3, d4_adj); Add3_if_GTE5 adj4_c(c3, c4_adj);
    buf s4_c3(c4[3], c4_adj[2]); buf s4_c2(c4[2], c4_adj[1]); buf s4_c1(c4[1], c4_adj[0]); buf s4_c0(c4[0], d4_adj[3]);
    buf s4_d3(d4[3], d4_adj[2]); buf s4_d2(d4[2], d4_adj[1]); buf s4_d1(d4[1], d4_adj[0]); buf s4_d0(d4[0], u4_adj[3]);
    buf s4_u3(u4[3], u4_adj[2]); buf s4_u2(u4[2], u4_adj[1]); buf s4_u1(u4[1], u4_adj[0]); buf s4_u0(u4[0], bin_in[4]);
    
    Add3_if_GTE5 adj5_u(u4, u5_adj); Add3_if_GTE5 adj5_d(d4, d5_adj); Add3_if_GTE5 adj5_c(c4, c5_adj);
    buf s5_c3(c5[3], c5_adj[2]); buf s5_c2(c5[2], c5_adj[1]); buf s5_c1(c5[1], c5_adj[0]); buf s5_c0(c5[0], d5_adj[3]);
    buf s5_d3(d5[3], d5_adj[2]); buf s5_d2(d5[2], d5_adj[1]); buf s5_d1(d5[1], d5_adj[0]); buf s5_d0(d5[0], u5_adj[3]);
    buf s5_u3(u5[3], u5_adj[2]); buf s5_u2(u5[2], u5_adj[1]); buf s5_u1(u5[1], u5_adj[0]); buf s5_u0(u5[0], bin_in[3]);

    Add3_if_GTE5 adj6_u(u5, u6_adj); Add3_if_GTE5 adj6_d(d5, d6_adj); Add3_if_GTE5 adj6_c(c5, c6_adj);
    buf s6_c3(c6[3], c6_adj[2]); buf s6_c2(c6[2], c6_adj[1]); buf s6_c1(c6[1], c6_adj[0]); buf s6_c0(c6[0], d6_adj[3]);
    buf s6_d3(d6[3], d6_adj[2]); buf s6_d2(d6[2], d6_adj[1]); buf s6_d1(d6[1], d6_adj[0]); buf s6_d0(d6[0], u6_adj[3]);
    buf s6_u3(u6[3], u6_adj[2]); buf s6_u2(u6[2], u6_adj[1]); buf s6_u1(u6[1], u6_adj[0]); buf s6_u0(u6[0], bin_in[2]);
    
    Add3_if_GTE5 adj7_u(u6, u7_adj); Add3_if_GTE5 adj7_d(d6, d7_adj); Add3_if_GTE5 adj7_c(c6, c7_adj);
    buf s7_c3(c7[3], c7_adj[2]); buf s7_c2(c7[2], c7_adj[1]); buf s7_c1(c7[1], c7_adj[0]); buf s7_c0(c7[0], d7_adj[3]);
    buf s7_d3(d7[3], d7_adj[2]); buf s7_d2(d7[2], d7_adj[1]); buf s7_d1(d7[1], d7_adj[0]); buf s7_d0(d7[0], u7_adj[3]);
    buf s7_u3(u7[3], u7_adj[2]); buf s7_u2(u7[2], u7_adj[1]); buf s7_u1(u7[1], u7_adj[0]); buf s7_u0(u7[0], bin_in[1]);

    // --- Ciclo 8 (para bin_in[0]) ---
    Add3_if_GTE5 adj8_u(u7, u8_adj); Add3_if_GTE5 adj8_d(d7, d8_adj); Add3_if_GTE5 adj8_c(c7, c8_adj);
    // Último shift
    buf s8_c3(bcd_centenas[3], c8_adj[2]); buf s8_c2(bcd_centenas[2], c8_adj[1]); buf s8_c1(bcd_centenas[1], c8_adj[0]); buf s8_c0(bcd_centenas[0], d8_adj[3]);
    buf s8_d3(bcd_dezenas[3], d8_adj[2]);  buf s8_d2(bcd_dezenas[2], d8_adj[1]);  buf s8_d1(bcd_dezenas[1], d8_adj[0]);  buf s8_d0(bcd_dezenas[0], u8_adj[3]);
    buf s8_u3(bcd_unidades[3], u8_adj[2]); buf s8_u2(bcd_unidades[2], u8_adj[1]); buf s8_u1(bcd_unidades[1], u8_adj[0]); buf s8_u0(bcd_unidades[0], bin_in[0]);

endmodule