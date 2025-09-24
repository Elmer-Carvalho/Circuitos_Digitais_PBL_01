// Módulo para decodificar um valor de 4 bits para um display de 7 segmentos
module Decodificador7Seg(
    input [3:0] data_in,      // Entrada de 4 bits (0-F)
    output [6:0] segments    // Saída para os 7 segmentos (a-g)
);
    // segments[6] -> a
    // segments[5] -> b
    // segments[4] -> c
    // segments[3] -> d
    // segments[2] -> e
    // segments[1] -> f
    // segments[0] -> g

    reg [6:0] segments_reg;
    assign segments = segments_reg;

    always @(data_in)
    begin
        case(data_in)
            4'h0: segments_reg = 7'b1111110; // 0
            4'h1: segments_reg = 7'b0110000; // 1
            4'h2: segments_reg = 7'b1101101; // 2
            4'h3: segments_reg = 7'b1111001; // 3
            4'h4: segments_reg = 7'b0110011; // 4
            4'h5: segments_reg = 7'b1011011; // 5
            4'h6: segments_reg = 7'b1011111; // 6
            4'h7: segments_reg = 7'b1110000; // 7
            4'h8: segments_reg = 7'b1111111; // 8
            4'h9: segments_reg = 7'b1111011; // 9
            4'hA: segments_reg = 7'b1110111; // A
            4'hB: segments_reg = 7'b0011111; // b
            4'hC: segments_reg = 7'b1001110; // C
            4'hD: segments_reg = 7'b0111101; // d
            4'hE: segments_reg = 7'b1001111; // E
            4'hF: segments_reg = 7'b1000111; // F
            default: segments_reg = 7'b0000000; // Apagado
        endcase
    end
endmodule