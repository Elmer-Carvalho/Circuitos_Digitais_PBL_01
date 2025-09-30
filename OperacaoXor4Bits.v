module OperacaoXor4Bits(
    input [3:0] A,
    input [3:0] B,
    output [3:0] Y
);
	 xor Xor0(Y[0], A[0], B[0]);
    xor Xor1(Y[1], A[1], B[1]);
    xor Xor2(Y[2], A[2], B[2]);
    xor Xor3(Y[3], A[3], B[3]);
endmodule