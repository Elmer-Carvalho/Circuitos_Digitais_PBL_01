// Módulo para multiplicação de 4x4 bits em estilo ESTRUTURAL
// VERSÃO FINAL CORRIGIDA - SEM 'assign'
module Multiplicador4Bits(
    input [3:0] A,
    input [3:0] B,
    output [7:0] P // O produto (P) precisa de 8 bits
);
    // --- 1. Gerar todos os 16 Produtos Parciais (usando portas AND) ---
    wire pp_00, pp_01, pp_02, pp_03;
    wire pp_10, pp_11, pp_12, pp_13;
    wire pp_20, pp_21, pp_22, pp_23;
    wire pp_30, pp_31, pp_32, pp_33;

    and and_00(pp_00, A[0], B[0]); and and_01(pp_01, A[0], B[1]); and and_02(pp_02, A[0], B[2]); and and_03(pp_03, A[0], B[3]);
    and and_10(pp_10, A[1], B[0]); and and_11(pp_11, A[1], B[1]); and and_12(pp_12, A[1], B[2]); and and_13(pp_13, A[1], B[3]);
    and and_20(pp_20, A[2], B[0]); and and_21(pp_21, A[2], B[1]); and and_22(pp_22, A[2], B[2]); and and_23(pp_23, A[2], B[3]);
    and and_30(pp_30, A[3], B[0]); and and_31(pp_31, A[3], B[1]); and and_32(pp_32, A[3], B[2]); and and_33(pp_33, A[3], B[3]);

    // --- 2. Construir a matriz de Somadores de 1 Bit (Full Adders) ---
    wire S_10, S_11, S_12;
    wire C_10, C_11, C_12;
    wire S_20, S_21, S_22;
    wire C_20, C_21, C_22;
    wire S_30, S_31, S_32;
    wire C_30, C_31, C_32;

    // Fio de terra para entradas de carry iniciais
    wire gnd;
    wire temp_gnd;
    not gnd_not_inst(temp_gnd, A[0]);
    and gnd_and_inst(gnd, A[0], temp_gnd);

    // Primeira linha de somadores
    Somador1Bit FA_10 (S_10, C_10, pp_10, pp_01, gnd);
    Somador1Bit FA_11 (S_11, C_11, pp_11, pp_02, C_10);
    Somador1Bit FA_12 (S_12, C_12, pp_12, pp_03, C_11);
    
    // Segunda linha de somadores
    Somador1Bit FA_20 (S_20, C_20, pp_20, S_10, gnd);
    Somador1Bit FA_21 (S_21, C_21, pp_21, S_11, C_20);
    Somador1Bit FA_22 (S_22, C_22, pp_22, S_12, C_21);
    
    // Terceira linha de somadores
    Somador1Bit FA_30 (S_30, C_30, pp_30, S_20, gnd);
    Somador1Bit FA_31 (S_31, C_31, pp_31, S_21, C_30);
    Somador1Bit FA_32 (S_32, C_32, pp_32, S_22, C_31);

    // --- 3. Montar o Produto Final (P de 8 bits) ---
    buf buf_p0(P[0], pp_00);
    buf buf_p1(P[1], S_10);
    buf buf_p2(P[2], S_20);
    buf buf_p3(P[3], S_30);
    buf buf_p4(P[4], S_31);
    buf buf_p5(P[5], S_32);
    
    // O último estágio de soma para os bits mais significativos
    wire final_sum, final_carry;
    Somador1Bit FA_final1 (final_sum, final_carry, C_12, C_22, gnd);
    Somador1Bit FA_final2 (P[6], P[7], final_sum, C_32, final_carry);
endmodule