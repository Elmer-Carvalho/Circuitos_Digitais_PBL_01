// Módulo para divisão de 4x4 bits em estilo ESTRUTURAL (VERSÃO CORRIGIDA)
// Utiliza o algoritmo de Divisão com Restauração (combinacional)
module Divisor4Bits(
    input [3:0] A,  // Dividendo
    input [3:0] B,  // Divisor
    output [3:0] Q, // Quocien_tentativate
    output [3:0] R, // Resto
    output ERR      // Flag de erro (1 para divisão por zero)
);

    // --- Sinais Intermediários ---
    // O resto parcial (R_partial) precisa de 5 bits para a comparação
    wire [4:0] R_partial1_shifted, R_partial1_sub, R_partial1;
    wire [4:0] R_partial2_shifted, R_partial2_sub, R_partial2;
    wire [4:0] R_partial3_shifted, R_partial3_sub, R_partial3;
    wire [4:0] R_partial4_shifted, R_partial4_sub, R_final;

    // --- Lógica de Erro ---
    assign ERR = (B == 4'b0);

    // --- Estágios da Divisão ---

    // Estágio 1 (para o bit Q[3])
    assign R_partial1_shifted = {1'b0, A[3:1]}; // Inicia com 0 e os 3 bits mais significativos de A
    assign R_partial1_sub = R_partial1_shifted - {1'b0, B};
    assign Q[3] = ~R_partial1_sub[4]; // Se o resultado for negativo (bit 5 = 1), Q[3] = 0
    assign R_partial1 = R_partial1_sub[4] ? R_partial1_shifted : R_partial1_sub;

    // Estágio 2 (para o bit Q[2])
    assign R_partial2_shifted = {R_partial1[3:0], A[2]}; // Shift e traz o próximo bit de A
    assign R_partial2_sub = R_partial2_shifted - {1'b0, B};
    assign Q[2] = ~R_partial2_sub[4];
    assign R_partial2 = R_partial2_sub[4] ? R_partial2_shifted : R_partial2_sub;

    // Estágio 3 (para o bit Q[1])
    assign R_partial3_shifted = {R_partial2[3:0], A[1]}; // Shift e traz o próximo bit de A
    assign R_partial3_sub = R_partial3_shifted - {1'b0, B};
    assign Q[1] = ~R_partial3_sub[4];
    assign R_partial3 = R_partial3_sub[4] ? R_partial3_shifted : R_partial3_sub;
    
    // Estágio 4 (para o bit Q[0])
    assign R_partial4_shifted = {R_partial3[3:0], A[0]}; // Shift e traz o último bit de A
    assign R_partial4_sub = R_partial4_shifted - {1'b0, B};
    assign Q[0] = ~R_partial4_sub[4];
    assign R_final = R_partial4_sub[4] ? R_partial4_shifted : R_partial4_sub;
    
    // O resto final são os 4 bits menos significativos do último resto parcial
    assign R = R_final[3:0];

endmodule