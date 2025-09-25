// Módulo para multiplicação de 4x4 bits em estilo ESTRUTURAL
// Utiliza o algoritmo "Shift and Add"
module Multiplicador4Bits(
    input [3:0] A,
    input [3:0] B,
    output [7:0] P // O produto (P) precisa de 8 bits
);

    // --- 1. Gerar Produtos Parciais (usando portas AND) ---
    // Cada fio pp (partial product) terá 4 bits.
    wire [3:0] pp0, pp1, pp2, pp3;

    // A sintaxe {4{B[0]}} replica o bit B[0] quatro vezes (ex: {1,1,1,1} ou {0,0,0,0})
    // Isso é uma forma compacta de fazer a porta AND de cada bit de A com o bit de B.
    assign pp0 = A & {4{B[0]}}; // A * B[0]
    assign pp1 = A & {4{B[1]}}; // A * B[1]
    assign pp2 = A & {4{B[2]}}; // A * B[2]
    assign pp3 = A & {4{B[3]}}; // A * B[3]

    // --- 2. Somar os Produtos Parciais em Cascata ---
    // Fios para carregar os resultados intermediários das somas
    wire [3:0] soma1_s;
    wire c1; // Carry out da primeira soma
    wire [4:0] resultado1;

    wire [3:0] soma2_s;
    wire c2; // Carry out da segunda soma
    wire [5:0] resultado2;

    wire [3:0] soma3_s;
    wire c3; // Carry out da terceira soma

    // Primeiro estágio de soma:
    // Soma pp0 com pp1 (deslocado). O resultado terá 5 bits.
    Somador4Bits ADD1 (soma1_s, c1, pp0, {1'b0, pp1[3:1]}, 1'b0);
    assign resultado1 = {c1, soma1_s};

    // Segundo estágio de soma:
    // Soma o resultado anterior com pp2 (deslocado).
    Somador4Bits ADD2 (soma2_s, c2, resultado1[4:1], {1'b0, pp2[3:1]}, resultado1[0]);
    assign resultado2 = {c2, soma2_s};
    
    // Terceiro estágio de soma:
    // Soma o resultado anterior com pp3 (deslocado).
    Somador4Bits ADD3 (soma3_s, c3, resultado2[5:2], pp3, resultado2[1]);


    // --- 3. Montar o Produto Final (P de 8 bits) ---
    assign P[0]   = pp0[0];
    assign P[1]   = pp1[0];
    assign P[2]   = resultado2[0];
    assign P[3]   = resultado2[1];
    assign P[4]   = soma3_s[0];
    assign P[5]   = soma3_s[1];
    assign P[6]   = soma3_s[2];
    assign P[7]   = c3;
    
endmodule