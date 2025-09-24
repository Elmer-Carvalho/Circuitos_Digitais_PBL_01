module Subtrator1Bit(S, Bout, A, B, Bin);
   input A, B, Bin;
   output S, Bout;
   wire T1, T2, T3;

   xor Xor0(T1, A, B);
   and And0(T2, ~A, B);
   and And1(T3, ~T1, Bin);
   or Or0(Bout, T2, T3);
   xor Xor1 (S, T1, Bin);
endmodule