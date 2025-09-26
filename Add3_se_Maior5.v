// Módulo estrutural que soma 3 a uma entrada de 4 bits
// se o valor da entrada for maior ou igual a 5.
module Add3_if_GTE5(
    input [3:0] data_in,
    output [3:0] data_out
);
    wire gte5; // Sinal que será '1' se data_in >= 5
    wire w1, w2;

    // Lógica para gte5 = D + C.(B+A)  (onde D,C,B,A são os bits de data_in)
    or or_gte5_1(w1, data_in[1], data_in[0]);
    and and_gte5_1(w2, data_in[2], w1);
    or or_gte5_2(gte5, data_in[3], w2);

    // Um somador de 4 bits para adicionar '0011' (3) se gte5 for '1'
    wire c0, c1, c2, c3;
    wire b1_in, b2_in;
    
    // As entradas do somador para o segundo operando são (0, 0, gte5, gte5)
    // que corresponde a somar 3 (0011) ou 0 (0000)
    and and_b1(b1_in, gte5, 1'b1);
    and and_b2(b2_in, gte5, 1'b1);

    Somador1Bit adder0(data_out[0], c0, data_in[0], b1_in, 1'b0);
    Somador1Bit adder1(data_out[1], c1, data_in[1], b2_in, c0);
    Somador1Bit adder2(data_out[2], c2, data_in[2], 1'b0, c1);
    Somador1Bit adder3(data_out[3], c3, data_in[3], 1'b0, c2);

endmodule