// Módulo para divisão de 4x4 bits em estilo ESTRUTURAL
// Utiliza o algoritmo de Divisão com Restauração (combinacional)
module Divisor4Bits(
    input [3:0] A,  // Dividendo
    input [3:0] B,  // Divisor
    output [3:0] Q, // Quociente
    output [3:0] R, // Resto
    output ERR      // Flag de erro (1 para divisão por zero)
);
    // --- Sinais Intermediários ---
    wire [4:0] R_partial1_shifted, R_partial1_sub, R_partial1;
    wire [4:0] R_partial2_shifted, R_partial2_sub, R_partial2;
    wire [4:0] R_partial3_shifted, R_partial3_sub, R_partial3;
    wire [4:0] R_partial4_shifted, R_partial4_sub, R_final;
    wire [3:0] sub1_s, sub2_s, sub3_s, sub4_s;
    wire bout1, bout2, bout3, bout4;

    // --- Lógica de Erro (B == 0) ---
    wire nor_err_in;
    or or_err(nor_err_in, B[0], B[1], B[2], B[3]);
    not not_err(ERR, nor_err_in);

    // --- Estágio 1 (para Q[3]) ---
    // R_partial1_shifted = {1'b0, A[3]} (Resto inicial é 0)
    buf buf_s1_4(R_partial1_shifted[4], 1'b0); buf buf_s1_3(R_partial1_shifted[3], 1'b0); buf buf_s1_2(R_partial1_shifted[2], 1'b0); buf buf_s1_1(R_partial1_shifted[1], 1'b0); buf buf_s1_0(R_partial1_shifted[0], A[3]);
    Subtrator4Bits SUB1(sub1_s, bout1, R_partial1_shifted[3:0], B, R_partial1_shifted[4]);
    buf buf_sub1_4(R_partial1_sub[4], bout1); buf buf_sub1_3(R_partial1_sub[3], sub1_s[3]); buf buf_sub1_2(R_partial1_sub[2], sub1_s[2]); buf buf_sub1_1(R_partial1_sub[1], sub1_s[1]); buf buf_sub1_0(R_partial1_sub[0], sub1_s[0]);
    not not_q3(Q[3], bout1);
    Mux2para1_5bit MUX1(R_partial1_sub, R_partial1_shifted, bout1, R_partial1);

    // --- Estágio 2 (para Q[2]) ---
    // R_partial2_shifted = {R_partial1[3:0], A[2]}
    buf buf_s2_4(R_partial2_shifted[4], R_partial1[3]); buf buf_s2_3(R_partial2_shifted[3], R_partial1[2]); buf buf_s2_2(R_partial2_shifted[2], R_partial1[1]); buf buf_s2_1(R_partial2_shifted[1], R_partial1[0]); buf buf_s2_0(R_partial2_shifted[0], A[2]);
    Subtrator4Bits SUB2(sub2_s, bout2, R_partial2_shifted[3:0], B, R_partial2_shifted[4]);
    buf buf_sub2_4(R_partial2_sub[4], bout2); buf buf_sub2_3(R_partial2_sub[3], sub2_s[3]); buf buf_sub2_2(R_partial2_sub[2], sub2_s[2]); buf buf_sub2_1(R_partial2_sub[1], sub2_s[1]); buf buf_sub2_0(R_partial2_sub[0], sub2_s[0]);
    not not_q2(Q[2], bout2);
    Mux2para1_5bit MUX2(R_partial2_sub, R_partial2_shifted, bout2, R_partial2);

    // --- Estágio 3 (para Q[1]) ---
    buf buf_s3_4(R_partial3_shifted[4], R_partial2[3]); buf buf_s3_3(R_partial3_shifted[3], R_partial2[2]); buf buf_s3_2(R_partial3_shifted[2], R_partial2[1]); buf buf_s3_1(R_partial3_shifted[1], R_partial2[0]); buf buf_s3_0(R_partial3_shifted[0], A[1]);
    Subtrator4Bits SUB3(sub3_s, bout3, R_partial3_shifted[3:0], B, R_partial3_shifted[4]);
    buf buf_sub3_4(R_partial3_sub[4], bout3); buf buf_sub3_3(R_partial3_sub[3], sub3_s[3]); buf buf_sub3_2(R_partial3_sub[2], sub3_s[2]); buf buf_sub3_1(R_partial3_sub[1], sub3_s[1]); buf buf_sub3_0(R_partial3_sub[0], sub3_s[0]);
    not not_q1(Q[1], bout3);
    Mux2para1_5bit MUX3(R_partial3_sub, R_partial3_shifted, bout3, R_partial3);
    
    // --- Estágio 4 (para Q[0]) ---
    buf buf_s4_4(R_partial4_shifted[4], R_partial3[3]); buf buf_s4_3(R_partial4_shifted[3], R_partial3[2]); buf buf_s4_2(R_partial4_shifted[2], R_partial3[1]); buf buf_s4_1(R_partial4_shifted[1], R_partial3[0]); buf buf_s4_0(R_partial4_shifted[0], A[0]);
    Subtrator4Bits SUB4(sub4_s, bout4, R_partial4_shifted[3:0], B, R_partial4_shifted[4]);
    buf buf_sub4_4(R_partial4_sub[4], bout4); buf buf_sub4_3(R_partial4_sub[3], sub4_s[3]); buf buf_sub4_2(R_partial4_sub[2], sub4_s[2]); buf buf_sub4_1(R_partial4_sub[1], sub4_s[1]); buf buf_sub4_0(R_partial4_sub[0], sub4_s[0]);
    not not_q0(Q[0], bout4);
    Mux2para1_5bit MUX4(R_partial4_sub, R_partial4_shifted, bout4, R_final);

    // Saída final do Resto
    buf buf_r0(R[0], R_final[0]); buf buf_r1(R[1], R_final[1]); buf buf_r2(R[2], R_final[2]); buf buf_r3(R[3], R_final[3]);
endmodule