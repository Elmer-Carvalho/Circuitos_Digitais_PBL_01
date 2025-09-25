// Módulo para multiplicação de 4x4 bits em estilo ESTRUTURAL (VERSÃO FINAL E DEFINITIVA)
// Implementa um Multiplicador de Array (Array Multiplier)
module Multiplicador4Bits(
    input [3:0] A,
    input [3:0] B,
    output [7:0] P // O produto (P) precisa de 8 bits
);

    // --- 1. Gerar todos os 16 Produtos Parciais (usando portas AND) ---
    // Cada fio pp_ij é o resultado de A[i] & B[j]
    wire pp_00, pp_01, pp_02, pp_03;
    wire pp_10, pp_11, pp_12, pp_13;
    wire pp_20, pp_21, pp_22, pp_23;
    wire pp_30, pp_31, pp_32, pp_33;

    assign pp_00 = A[0] & B[0]; assign pp_01 = A[0] & B[1]; assign pp_02 = A[0] & B[2]; assign pp_03 = A[0] & B[3];
    assign pp_10 = A[1] & B[0]; assign pp_11 = A[1] & B[1]; assign pp_12 = A[1] & B[2]; assign pp_13 = A[1] & B[3];
    assign pp_20 = A[2] & B[0]; assign pp_21 = A[2] & B[1]; assign pp_22 = A[2] & B[2]; assign pp_23 = A[2] & B[3];
    assign pp_30 = A[3] & B[0]; assign pp_31 = A[3] & B[1]; assign pp_32 = A[3] & B[2]; assign pp_33 = A[3] & B[3];

    // --- 2. Construir a matriz de Somadores de 1 Bit (Full Adders) ---
    // Fios para as saídas de soma (S) e carry (C) de cada somador
    wire S_10, S_11, S_12;
    wire C_10, C_11, C_12;

    wire S_20, S_21, S_22;
    wire C_20, C_21, C_22;
    
    wire S_30, S_31, S_32;
    wire C_30, C_31, C_32;

    // Primeira linha de somadores
    Somador1Bit FA_10 (S_10, C_10, pp_10, pp_01, 1'b0);
    Somador1Bit FA_11 (S_11, C_11, pp_11, pp_02, C_10);
    Somador1Bit FA_12 (S_12, C_12, pp_12, pp_03, C_11);

    // Segunda linha de somadores
    Somador1Bit FA_20 (S_20, C_20, pp_20, S_10, 1'b0);
    Somador1Bit FA_21 (S_21, C_21, pp_21, S_11, C_20);
    Somador1Bit FA_22 (S_22, C_22, pp_22, S_12, C_21);

    // Terceira linha de somadores
    Somador1Bit FA_30 (S_30, C_30, pp_30, S_20, 1'b0);
    Somador1Bit FA_31 (S_31, C_31, pp_31, S_21, C_30);
    Somador1Bit FA_32 (S_32, C_32, pp_32, S_22, C_31);
    
    // --- 3. Montar o Produto Final (P de 8 bits) ---
    // O resultado é formado pelos bits que "saem" pelas bordas da matriz de somadores
    assign P[0] = pp_00;
    assign P[1] = S_10;
    assign P[2] = S_20;
    assign P[3] = S_30;
    assign P[4] = S_31;
    assign P[5] = S_32;
    // O último estágio de soma para os bits mais significativos
    wire final_sum, final_carry;
    Somador1Bit FA_final1 (final_sum, final_carry, C_12, C_22, 1'b0);
    Somador1Bit FA_final2 (P[6], P[7], final_sum, C_32, final_carry);
    
endmodule