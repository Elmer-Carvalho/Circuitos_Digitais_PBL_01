module Subtrator1Bit(S, Bout, A, B, Bin);
   input A, B, Bin;
   output S, Bout;
   wire T1, T2, T3;
	
	wire nA, nT1;

	not(nA, A);
	not(nT1, T1);
	
   xor Xor0(T1, A, B);
   and And0(T2, nA, B);
   and And1(T3, nT1, Bin);
   or Or0(Bout, T2, T3);
   xor Xor1 (S, T1, Bin);
endmodule