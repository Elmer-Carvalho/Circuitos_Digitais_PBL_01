// Módulo para divisão de dois números de 4 bits
module Divisor4Bits(
    input [3:0] A,  // Dividendo
    input [3:0] B,  // Divisor
    output [3:0] Q, // Quociente
    output [3:0] R, // Resto
    output ERR      // Flag de erro (1 para divisão por zero)
);

    // Usa o operador ternário para evitar a divisão por zero
    // Se B for 0, o quociente é 0 e o resto é A.
    assign Q = (B == 4'b0) ? 4'b0 : A / B;
    assign R = (B == 4'b0) ? A    : A % B;

    // Ativa o flag de erro se o divisor B for zero
    assign ERR = (B == 4'b0);

endmodule