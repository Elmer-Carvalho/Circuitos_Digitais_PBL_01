// Módulo para multiplicação de 4x4 bits em estilo ESTRUTURAL (VERSÃO FINAL CORRIGIDA)
// Utiliza o algoritmo "Shift and Add"
module Multiplicador4Bits(
    input [3:0] A,
    input [3:0] B,
    output [7:0] P // O produto (P) precisa de 8 bits
);

    // --- 1. Gerar Produtos Parciais (usando portas AND) ---
    wire [3:0] pp0, pp1, pp2, pp3;
    assign pp0 = A & {4{B[0]}}; // A * B[0]
    assign pp1 = A & {4{B[1]}}; // A * B[1]
    assign pp2 = A & {4{B[2]}}; // A * B[2]
    assign pp3 = A & {4{B[3]}}; // A * B[3]

    // --- 2. Somar os Produtos Parciais em Cascata ---
    wire [3:0] soma1_s, soma2_s, soma3_s;
    wire c1, c2, c3;

    // Estágio 1: Soma os dois primeiros produtos parciais (pp0 e pp1)
    Somador4Bits ADD1 (soma1_s, c1, {1'b0, pp0[3:1]}, pp1, 1'b0);

    // Estágio 2: Soma o resultado anterior com o terceiro produto parcial (pp2)
    Somador4Bits ADD2 (soma2_s, c2, {c1, soma1_s[3:1]}, pp2, soma1_s[0]);

    // Estágio 3: Soma o resultado anterior com o último produto parcial (pp3)
    Somador4Bits ADD3 (soma3_s, c3, {c2, soma2_s[3:1]}, pp3, soma2_s[0]);

    // --- 3. Montar o Produto Final (P de 8 bits) ---
    // O resultado é a combinação das saídas de todos os estágios.
    assign P[0] = pp0[0];
    assign P[1] = soma1_s[0];
    assign P[2] = soma2_s[0];
    assign P[3] = soma3_s[0];
    assign P[4] = soma3_s[1];
    assign P[5] = soma3_s[2];
    assign P[6] = soma3_s[3];
    assign P[7] = c3;
    
endmodule