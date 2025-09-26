// Módulo principal - ULA 4 bits ESTRUTURAL com todas as funções, incluindo sinal.
module ULA_4Bits(
    input [3:0] A_in,
    input [3:0] B_in,
    input Cin,
    input [2:0] OP_sel,

    output [6:0] HEX0, // Display Unidades
    output [6:0] HEX1, // Display Dezenas
    output [6:0] HEX2, // Display Centenas
    output [6:0] HEX3, // Display Sinal

    output LED_Cout,
    output LED_OV,
    output LED_Z,
    output LED_ERR
);
    wire [3:0] soma_s, sub_s, and_y, or_y, xor_y, div_q;
    wire [7:0] mult_p;
    wire soma_cout, sub_bout, div_err;
    wire gnd;
    
    // --- Geração do GND ---
    wire temp_gnd; not gnd_not(temp_gnd, A_in[0]); and gnd_gate(gnd, A_in[0], temp_gnd);
    
    // --- Instanciação dos Módulos de Operação ---
    Somador4Bits      U0_Soma(.S(soma_s), .Cout(soma_cout), .A(A_in), .B(B_in), .Cin(Cin));
    Subtrator4Bits    U1_Sub(.S(sub_s), .Bout(sub_bout), .A(A_in), .B(B_in), .Bin(Cin));
    OperacaoAnd4Bits  U2_And(.A(A_in), .B(B_in), .Y(and_y));
    OperacaoOr4Bits   U3_Or(.A(A_in), .B(B_in), .Y(or_y));
    OperacaoXor4Bits  U4_Xor(.A(A_in), .B(B_in), .Y(xor_y));
    Multiplicador4Bits U5_Mult(.A(A_in), .B(B_in), .P(mult_p));
    Divisor4Bits      U6_Div(.A(A_in), .B(B_in), .Q(div_q), .ERR(div_err));
    
    // --- Lógica de Seleção do Resultado (Mux 8-para-1 de 8 bits) ---
    wire [7:0] result_final;
    // (Instanciação dos Muxs para result_final permanece a mesma)
    Mux8para1 mux_res0(.out(result_final[0]), .i0(soma_s[0]), .i1(sub_s[0]), .i2(and_y[0]), .i3(or_y[0]), .i4(xor_y[0]), .i5(mult_p[0]), .i6(div_q[0]), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_res1(.out(result_final[1]), .i0(soma_s[1]), .i1(sub_s[1]), .i2(and_y[1]), .i3(or_y[1]), .i4(xor_y[1]), .i5(mult_p[1]), .i6(div_q[1]), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_res2(.out(result_final[2]), .i0(soma_s[2]), .i1(sub_s[2]), .i2(and_y[2]), .i3(or_y[2]), .i4(xor_y[2]), .i5(mult_p[2]), .i6(div_q[2]), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_res3(.out(result_final[3]), .i0(soma_s[3]), .i1(sub_s[3]), .i2(and_y[3]), .i3(or_y[3]), .i4(xor_y[3]), .i5(mult_p[3]), .i6(div_q[3]), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_res4(.out(result_final[4]), .i0(gnd), .i1(gnd), .i2(gnd), .i3(gnd), .i4(gnd), .i5(mult_p[4]), .i6(gnd), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_res5(.out(result_final[5]), .i0(gnd), .i1(gnd), .i2(gnd), .i3(gnd), .i4(gnd), .i5(mult_p[5]), .i6(gnd), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_res6(.out(result_final[6]), .i0(gnd), .i1(gnd), .i2(gnd), .i3(gnd), .i4(gnd), .i5(mult_p[6]), .i6(gnd), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_res7(.out(result_final[7]), .i0(gnd), .i1(gnd), .i2(gnd), .i3(gnd), .i4(gnd), .i5(mult_p[7]), .i6(gnd), .i7(gnd), .sel(OP_sel));

    // --- Lógica de SINAL NEGATIVO ---
    wire op_is_sub, is_negative;
    wire not_op2, not_op1;
    not not_op_sel2(not_op2, OP_sel[2]);
    not not_op_sel1(not_op1, OP_sel[1]);
    
    // Decodifica a operação de subtração (OP_sel = 3'b001)
    and and_sub_op(op_is_sub, not_op2, not_op1, OP_sel[0]);
    
    // O número é negativo se a operação for subtração E o bit mais significativo do resultado for 1.
    and and_is_neg(is_negative, op_is_sub, sub_s[3]);

    // --- Lógica de Flags (permanece a mesma) ---
    // ... (código dos flags OV, Cout, Z, ERR)
    wire ov_soma, ov_sub, t1, t2, t3, t4, not_soma_s3, not_A3, not_B3, not_sub_s3;
    not ov_not1(not_soma_s3, soma_s[3]); not ov_not2(not_A3, A_in[3]); not ov_not3(not_B3, B_in[3]); not ov_not4(not_sub_s3, sub_s[3]);
    and ov_soma_t1(t1, A_in[3], B_in[3], not_soma_s3); and ov_soma_t2(t2, not_A3, not_B3, soma_s[3]); or ov_soma_or(ov_soma, t1, t2);
    and ov_sub_t1(t3, A_in[3], not_B3, not_sub_s3); and ov_sub_t2(t4, not_A3, B_in[3], sub_s[3]); or ov_sub_or(ov_sub, t3, t4);
    Mux8para1 mux_ov(.out(LED_OV), .i0(ov_soma), .i1(ov_sub), .i2(gnd), .i3(gnd), .i4(gnd), .i5(gnd), .i6(gnd), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_cout(.out(LED_Cout), .i0(soma_cout), .i1(sub_bout), .i2(gnd), .i3(gnd), .i4(gnd), .i5(gnd), .i6(gnd), .i7(gnd), .sel(OP_sel));
    wire not_z; or z_or(not_z, result_final[0], result_final[1], result_final[2], result_final[3], result_final[4], result_final[5], result_final[6], result_final[7]); not z_not(LED_Z, not_z);
    Mux8para1 mux_err(.out(LED_ERR), .i0(gnd), .i1(gnd), .i2(gnd), .i3(gnd), .i4(gnd), .i5(gnd), .i6(div_err), .i7(gnd), .sel(OP_sel));

    // --- Lógica de Display com VALOR ABSOLUTO e SINAL ---
    wire [7:0] valor_abs;
    ComplementoDeDois8Bits U_Comp2(.data_in(result_final), .neg(is_negative), .abs_value(valor_abs));

    wire [3:0] bcd_c, bcd_d, bcd_u;
    BinarioParaBCD U_ConversorBCD(.bin_in(valor_abs), .bcd_centenas(bcd_c), .bcd_dezenas(bcd_d), .bcd_unidades(bcd_u));

    Decodificador7Seg U_HEX0 (.I(bcd_u), .segments(HEX0)); // Unidades
    Decodificador7Seg U_HEX1 (.I(bcd_d), .segments(HEX1)); // Dezenas
    Decodificador7Seg U_HEX2 (.I(bcd_c), .segments(HEX2)); // Centenas
    
    // Controlador do Display de Sinal (HEX3)
    // Acende apenas o segmento 'g' (HEX3[0]) para formar o sinal '-'
    buf buf_h3_g(HEX3[0], is_negative); // Segmento 'g'
    buf buf_h3_a(HEX3[6], gnd);
    buf buf_h3_b(HEX3[5], gnd);
    buf buf_h3_c(HEX3[4], gnd);
    buf buf_h3_d(HEX3[3], gnd);
    buf buf_h3_e(HEX3[2], gnd);
    buf buf_h3_f(HEX3[1], gnd);

endmodule