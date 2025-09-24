module Subtrator4Bits(S, Bout, A, B, Bin);
    input [3:0] A, B;    // Array de inputs
    input Bin;           // Borrow-in  (Entrada)
    output [3:0] S;      // Resultado da soma
    output Bout;         // Borrow-out (Saida)

    wire C1, C2, C3;

    // Instanciando 4 subtrator de 1 bit
    Subtrator1Bit bit0(S[0], C1, A[0], B[0], Bin);
    Subtrator1Bit bit1(S[1], C2, A[1], B[1], C1);
    Subtrator1Bit bit2(S[2], C3, A[2], B[2], C2);
    Subtrator1Bit bit3(S[3], Bout, A[3], B[3], C3);
endmodule