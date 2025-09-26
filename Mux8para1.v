// Módulo ESTRUTURAL genérico para um Multiplexador de 8 para 1 de 1 bit
module Mux8para1(
    output out,
    input i0, i1, i2, i3, i4, i5, i6, i7,
    input [2:0] sel
);
    wire ns0, ns1, ns2;
    wire t0, t1, t2, t3, t4, t5, t6, t7;

    // Inversores para os sinais de seleção
    not not_s0(ns0, sel[0]);
    not not_s1(ns1, sel[1]);
    not not_s2(ns2, sel[2]);

    // Lógica do decodificador para selecionar a entrada correta
    and and0(t0, ns2, ns1, ns0, i0);
    and and1(t1, ns2, ns1, sel[0], i1);
    and and2(t2, ns2, sel[1], ns0, i2);
    and and3(t3, ns2, sel[1], sel[0], i3);
    and and4(t4, sel[2], ns1, ns0, i4);
    and and5(t5, sel[2], ns1, sel[0], i5);
    and and6(t6, sel[2], sel[1], ns0, i6);
    and and7(t7, sel[2], sel[1], sel[0], i7);

    // Porta OR final para combinar as saídas do decodificador
    or final_or(out, t0, t1, t2, t3, t4, t5, t6, t7);
endmodule