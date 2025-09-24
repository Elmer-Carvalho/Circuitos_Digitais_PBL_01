// Módulo para multiplicação de dois números de 4 bits
module Multiplicador4Bits(
    input [3:0] A,
    input [3:0] B,
    output [7:0] P // O produto (P) precisa de 8 bits
);

    // O Quartus sintetiza o operador '*' em um circuito multiplicador eficiente
    assign P = A * B;

endmodule