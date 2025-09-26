module Subtrator1Bit(S, Bout, A, B, Bin);
   input A, B, Bin;
   output S, Bout;
   wire T1, T2, T3;
   wire notA, notT1; // Wires para as saídas dos inversores

   // Instancia inversores para A e T1
   not invA(notA, A);
   not invT1(notT1, T1);

   xor Xor0(T1, A, B);
   and And0(T2, notA, B); // Usa o fio invertido notA
   and And1(T3, notT1, Bin); // Usa o fio invertido notT1
   or Or0(Bout, T2, T3);
   xor Xor1 (S, T1, Bin);
endmodule