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
    // O resto parcial precisa de um bit extra para a comparação
    wire [4:0] R0, R1_tentativa, R1, R2_tentativa, R2, R3_tentativa, R3, R4_tentativa;
    
    // Fios para os resultados das subtrações
    wire [3:0] sub1_s, sub2_s, sub3_s, sub4_s;
    wire bout1, bout2, bout3, bout4;

    // --- Lógica de Erro ---
    assign ERR = (B == 4'b0);

    // --- Estágios da Divisão ---

    // Estágio 1 (para o bit Q[3])
    assign R0 = {1'b0, A}; // Resto inicial é o próprio dividendo
    Subtrator4Bits SUB1 (sub1_s, bout1, R0[3:0], B, R0[4]);
    assign R1_tentativa = {bout1, sub1_s};
    // Se bout1=1 (negativo), restaura R0. Senão, usa o resultado da subtração.
    assign Q[3] = ~bout1;
    assign R1 = bout1 ? R0 : R1_tentativa;

    // Estágio 2 (para o bit Q[2])
    Subtrator4Bits SUB2 (sub2_s, bout2, R1[3:0], B, R1[4]);
    assign R2_tentativa = {bout2, sub2_s};
    assign Q[2] = ~bout2;
    assign R2 = bout2 ? R1 : R2_tentativa;

    // Estágio 3 (para o bit Q[1])
    Subtrator4Bits SUB3 (sub3_s, bout3, R2[3:0], B, R2[4]);
    assign R3_tentativa = {bout3, sub3_s};
    assign Q[1] = ~bout3;
    assign R3 = bout3 ? R2 : R3_tentativa;
    
    // Estágio 4 (para o bit Q[0])
    Subtrator4Bits SUB4 (sub4_s, bout4, R3[3:0], B, R3[4]);
    assign Q[0] = ~bout4;
    
    // O resto final é o resultado do último estágio válido
    assign R = bout4 ? R3[3:0] : sub4_s;

endmodule