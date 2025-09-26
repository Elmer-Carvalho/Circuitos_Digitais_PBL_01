// Módulo para operação XOR de 4 bits em estilo ESTRUTURAL
module OperacaoXor4Bits(
    input [3:0] A,
    input [3:0] B,
    output [3:0] Y
);
    // Instancia uma porta XOR para cada par de bits
    xor x0(Y[0], A[0], B[0]);
    xor x1(Y[1], A[1], B[1]);
    xor x2(Y[2], A[2], B[2]);
    xor x3(Y[3], A[3], B[3]);
endmodule