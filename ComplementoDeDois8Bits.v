// Módulo para calcular o valor absoluto de um número de 8 bits
// usando a operação de complemento de dois quando o sinal 'neg' é '1'.
module ComplementoDeDois8Bits(
    input [7:0] data_in,
    input neg, // Sinal que indica se o número é negativo
    output [7:0] abs_value
);
    wire [7:0] inverted_data;
    wire [7:0] one;
    wire gnd, vcc;
    wire temp_gnd;

    // --- Geração de Constantes ---
    not gnd_not_inst(temp_gnd, neg);
    and gnd_and_inst(gnd, neg, temp_gnd);
    or vcc_or_inst(vcc, neg, temp_gnd);

    // --- Inversão Condicional ---
    // Se neg=0, data_in ^ 0 = data_in
    // Se neg=1, data_in ^ 1 = ~data_in
    xor xor0(inverted_data[0], data_in[0], neg);
    xor xor1(inverted_data[1], data_in[1], neg);
    xor xor2(inverted_data[2], data_in[2], neg);
    xor xor3(inverted_data[3], data_in[3], neg);
    xor xor4(inverted_data[4], data_in[4], neg);
    xor xor5(inverted_data[5], data_in[5], neg);
    xor xor6(inverted_data[6], data_in[6], neg);
    xor xor7(inverted_data[7], data_in[7], neg);

    // --- Soma Condicional de 1 ---
    // Instancia um somador de 8 bits para adicionar 'neg' (0 ou 1)
    // ao resultado invertido.
    wire c0, c1, c2, c3, c4, c5, c6, c7, c_out;
    Somador1Bit adder0(abs_value[0], c0, inverted_data[0], gnd, neg);
    Somador1Bit adder1(abs_value[1], c1, inverted_data[1], gnd, c0);
    Somador1Bit adder2(abs_value[2], c2, inverted_data[2], gnd, c1);
    Somador1Bit adder3(abs_value[3], c3, inverted_data[3], gnd, c2);
    Somador1Bit adder4(abs_value[4], c4, inverted_data[4], gnd, c3);
    Somador1Bit adder5(abs_value[5], c5, inverted_data[5], gnd, c4);
    Somador1Bit adder6(abs_value[6], c6, inverted_data[6], gnd, c5);
    Somador1Bit adder7(abs_value[7], c_out, inverted_data[7], gnd, c6);

endmodule