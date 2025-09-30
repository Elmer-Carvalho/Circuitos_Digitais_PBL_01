// Módulo estrutural que soma 3 a uma entrada de 4 bits
// se o valor da entrada for maior ou igual a 5.
module Add3_if_GTE5(
    input [3:0] data_in,
    output [3:0] data_out
);
    wire gte5;
    wire w1, w2;
    wire gnd, vcc; // Fios para constantes 0 e 1

    // --- Geração Estrutural de Constantes ---
    // vcc (1) pode ser a saída de um OR com entradas opostas
    // gnd (0) pode ser a saída de um AND com entradas opostas
    wire temp;
    not gnd_not_inst(temp, data_in[0]);
    and gnd_and_inst(gnd, data_in[0], temp);
    or vcc_or_inst(vcc, data_in[0], temp);

    // --- Lógica de Comparação (gte5 = data_in >= 5) ---
    or or_gte5_1(w1, data_in[1], data_in[0]);
    and and_gte5_1(w2, data_in[2], w1);
    or or_gte5_2(gte5, data_in[3], w2);

    // --- Somador de 4 bits ---
    wire c0, c1, c2, c3;
    wire b1_in, b2_in;
    
    // O segundo operando da soma será 3 (0011) se gte5=1, ou 0 (0000) caso contrário.
    and and_b1(b1_in, gte5, vcc);
    and and_b2(b2_in, gte5, vcc);

    Somador1Bit adder0(data_out[0], c0, data_in[0], b1_in, gnd);
    Somador1Bit adder1(data_out[1], c1, data_in[1], b2_in, c0);
    Somador1Bit adder2(data_out[2], c2, data_in[2], gnd, c1);
    Somador1Bit adder3(data_out[3], c3, data_in[3], gnd, c2);

endmodule