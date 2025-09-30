module OperacaoAnd4Bits(
    input [3:0] A,
    input [3:0] B,
    output [3:0] Y
);
    and And0(Y[0], A[0], B[0]);
    and And1(Y[1], A[1], B[1]);
    and And2(Y[2], A[2], B[2]);
    and And3(Y[3], A[3], B[3]);
endmodule