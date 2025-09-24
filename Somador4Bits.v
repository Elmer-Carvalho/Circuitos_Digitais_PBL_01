module Somador4Bits(S, Cout, A, B, Cin);
    input [3:0] A, B;    // Array de inputs
    input Cin;           // Carry-in  (Entrada)
    output [3:0] S;      // Resultado da soma
    output Cout;         // Carry-out (Saida)

    wire C1, C2, C3;

    // Instanciando 4 somadores de 1 bit
    Somador1Bit bit0(S[0], C1, A[0], B[0], Cin);
    Somador1Bit bit1(S[1], C2, A[1], B[1], C1);
    Somador1Bit bit2(S[2], C3, A[2], B[2], C2);
    Somador1Bit bit3(S[3], Cout, A[3], B[3], C3);
endmodule