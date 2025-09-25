// Módulo para divisão de 4x4 bits em estilo ESTRUTURAL (VERSÃO FINAL CORRIGIDA)
// Utiliza o algoritmo de Divisão com Restauração (combinacional)
module Divisor4Bits(
    input [3:0] A,  // Dividendo
    input [3:0] B,  // Divisor
    output [3:0] Q, // Quociente
    output [3:0] R, // Resto
    output ERR      // Flag de erro (1 para divisão por zero)
);

    // --- Sinais Intermediários ---
    // O resto parcial (R_partial) precisa de 5 bits para a comparação
    wire [4:0] R_partial0, R_partial1_shifted, R_partial1_sub, R_partial1;
    wire [4:0] R_partial2_shifted, R_partial2_sub, R_partial2;
    wire [4:0] R_partial3_shifted, R_partial3_sub, R_partial3;
    wire [4:0] R_partial4_shifted, R_partial4_sub, R_final;
    
    // Fios para as saídas dos subtratores instanciados
    wire [3:0] sub1_s, sub2_s, sub3_s, sub4_s;
    wire bout1, bout2, bout3, bout4;

    // --- Lógica de Erro ---
    assign ERR = (B == 4'b0);

    // --- Estágios da Divisão ---
    assign R_partial0 = 5'b0; // Resto inicial é zero

    // Estágio 1 (para o bit Q[3])
    assign R_partial1_shifted = {R_partial0[3:0], A[3]};
    Subtrator4Bits SUB1 (sub1_s, bout1, R_partial1_shifted[3:0], B, R_partial1_shifted[4]);
    assign R_partial1_sub = {bout1, sub1_s};
    assign Q[3] = ~bout1;
    assign R_partial1 = bout1 ? R_partial1_shifted : R_partial1_sub;

    // Estágio 2 (para o bit Q[2])
    assign R_partial2_shifted = {R_partial1[3:0], A[2]}; // Shift e traz o próximo bit de A
    Subtrator4Bits SUB2 (sub2_s, bout2, R_partial2_shifted[3:0], B, R_partial2_shifted[4]);
    assign R_partial2_sub = {bout2, sub2_s};
    assign Q[2] = ~bout2;
    assign R_partial2 = bout2 ? R_partial2_shifted : R_partial2_sub;

    // Estágio 3 (para o bit Q[1])
    assign R_partial3_shifted = {R_partial2[3:0], A[1]}; // Shift e traz o próximo bit de A
    Subtrator4Bits SUB3 (sub3_s, bout3, R_partial3_shifted[3:0], B, R_partial3_shifted[4]);
    assign R_partial3_sub = {bout3, sub3_s};
    assign Q[1] = ~bout3;
    assign R_partial3 = bout3 ? R_partial3_shifted : R_partial3_sub;
    
    // Estágio 4 (para o bit Q[0])
    assign R_partial4_shifted = {R_partial3[3:0], A[0]}; // Shift e traz o último bit de A
    Subtrator4Bits SUB4 (sub4_s, bout4, R_partial4_shifted[3:0], B, R_partial4_shifted[4]);
    assign R_partial4_sub = {bout4, sub4_s};
    assign Q[0] = ~bout4;
    assign R_final = bout4 ? R_partial4_shifted : R_partial4_sub;
    
    // O resto final são os 4 bits menos significativos do último resto parcial
    assign R = R_final[3:0];

endmodule