// Módulo para operação AND de 4 bits em estilo ESTRUTURAL
module OperacaoAnd4Bits(
    input [3:0] A,
    input [3:0] B,
    output [3:0] Y
);
    // Instancia uma porta AND para cada par de bits
    and a0(Y[0], A[0], B[0]);
    and a1(Y[1], A[1], B[1]);
    and a2(Y[2], A[2], B[2]);
    and a3(Y[3], A[3], B[3]);
endmodule