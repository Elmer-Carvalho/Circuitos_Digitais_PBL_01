// Módulo para decodificar um valor de 4 bits para um display de 7 segmentos
module Decodificador7Seg(
    input [3:0] I,           // Entrada de 4 bits
    output [6:0] segments    // Saída para os 7 segmentos (a,b,c,d,e,f,g)
);
    wire notD, notC, notB, notA;
    wire seg_a_out, seg_b_out, seg_c_out, seg_d_out, seg_e_out, seg_f_out, seg_g_out;

    // Inversores para cada bit de entrada
    not nD(notD, I[3]);
    not nC(notC, I[2]);
    not nB(notB, I[1]);
    not nA(notA, I[0]);

    // Expressões Booleanas Minimizadas para cada segmento

    // Segmento 'a' = D + B + (C&A) + (notC&notA)
    wire a_t1, a_t2;
    and and_a1(a_t1, I[2], I[0]);
    and and_a2(a_t2, notC, notA);
    or or_a(seg_a_out, I[3], I[1], a_t1, a_t2);
    not not_a(segments[6], seg_a_out); // CORREÇÃO: Inverte a saída

    // Segmento 'b' = notC + (notB&notA) + (B&A)
    wire b_t1, b_t2;
    and and_b1(b_t1, notB, notA);
    and and_b2(b_t2, I[1], I[0]);
    or or_b(seg_b_out, notC, b_t1, b_t2);
    not not_b(segments[5], seg_b_out); // CORREÇÃO: Inverte a saída

    // Segmento 'c' = C + notB + A
    or or_c(seg_c_out, I[2], notB, I[0]);
    not not_c(segments[4], seg_c_out); // CORREÇÃO: Inverte a saída

    // Segmento 'd' = (notC&notA) + (C&notB&A) + (B&notA&C) + (B&notC&A) + D
    wire d_t1, d_t2, d_t3, d_t4;
    and and_d1(d_t1, notC, notA);
    and and_d2(d_t2, I[2], notB, I[0]);
    and and_d3(d_t3, I[1], notA, I[2]);
    and and_d4(d_t4, I[1], notC, I[0]);
    or or_d(seg_d_out, d_t1, d_t2, d_t3, d_t4, I[3]);
    not not_d(segments[3], seg_d_out); // CORREÇÃO: Inverte a saída

    // Segmento 'e' = (notC&notA) + (B&notA)
    wire e_t1;
    and and_e1(e_t1, I[1], notA);
    or or_e(seg_e_out, e_t1, d_t1); // reutiliza (notC&notA)
    not not_e(segments[2], seg_e_out); // CORREÇÃO: Inverte a saída

    // Segmento 'f' = D + (C&notB) + (B&notA)
    wire f_t1;
    and and_f1(f_t1, I[2], notB);
    or or_f(seg_f_out, I[3], f_t1, e_t1); // reutiliza (B&notA)
    not not_f(segments[1], seg_f_out); // CORREÇÃO: Inverte a saída

    // Segmento 'g' = D + (C&notB) + (B&notC) + (C&notA)
    wire g_t1, g_t2;
    and and_g1(g_t1, I[1], notC);
    and and_g2(g_t2, I[2], notA);
    or or_g(seg_g_out, I[3], f_t1, g_t1, g_t2); // reutiliza (C&notB)
    not not_g(segments[0], seg_g_out); // CORREÇÃO: Inverte a saída

endmodule