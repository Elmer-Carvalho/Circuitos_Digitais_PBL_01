// Módulo para operação OR de 4 bits em estilo ESTRUTURAL
module OperacaoOr4Bits(
    input [3:0] A,
    input [3:0] B,
    output [3:0] Y
);
    // Instancia uma porta OR para cada par de bits
    or or0(Y[0], A[0], B[0]);
    or or1(Y[1], A[1], B[1]);
    or or2(Y[2], A[2], B[2]);
    or or3(Y[3], A[3], B[3]);
endmodule