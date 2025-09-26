// Módulo principal - ULA 4 bits ESTRUTURAL com multiplexadores
// VERSÃO PURAMENTE ESTRUTURAL SEM 'assign' OU 'generate'
module ULA_4Bits(
    input [3:0] A_in,
    input [3:0] B_in,
    input Cin,
    input [2:0] OP_sel,

    output [6:0] HEX0, // Display Unidades
    output [6:0] HEX1, // Display Dezenas
    output [6:0] HEX2, // Display Centenas
    output [6:0] HEX3, // Display Sinal (não usado)

    output LED_Cout,
    output LED_OV,
    output LED_Z,
    output LED_ERR
);

    // --- Sinais Internos ---
    wire [3:0] soma_s, sub_s, and_y, or_y, xor_y;
    wire [7:0] mult_p;
    wire soma_cout, sub_bout;

    // --- Fio de Terra (GND) para constantes '0' ---
    wire gnd;
    // Uma porta AND com uma entrada e sua negação sempre resulta em 0.
    // Esta é a forma puramente estrutural de criar um sinal '0' constante.
    wire temp_wire_for_gnd;
    not gnd_not(temp_wire_for_gnd, B_in[0]); // Pega qualquer sinal existente
    and gnd_gate(gnd, B_in[0], temp_wire_for_gnd);
    
    // --- Instanciação dos Módulos de Operação ---
    Somador4Bits      U0_Soma(.S(soma_s), .Cout(soma_cout), .A(A_in), .B(B_in), .Cin(Cin));
    Subtrator4Bits    U1_Sub(.S(sub_s), .Bout(sub_bout), .A(A_in), .B(B_in), .Bin(Cin));
    OperacaoAnd4Bits  U2_And(.A(A_in), .B(B_in), .Y(and_y));
    OperacaoOr4Bits   U3_Or(.A(A_in), .B(B_in), .Y(or_y));
    OperacaoXor4Bits  U4_Xor(.A(A_in), .B(B_in), .Y(xor_y));
    Multiplicador4Bits U5_Mult(.A(A_in), .B(B_in), .P(mult_p));
    // Divisor não incluído devido à alta complexidade da conversão estrutural
    
    // --- Lógica de Seleção do Resultado (Mux 8-para-1 de 8 bits desenrolado) ---
    wire [7:0] result_final;
    
    // Instanciação manual para cada bit do resultado
    Mux8para1 mux_res0(.out(result_final[0]), .i0(soma_s[0]), .i1(sub_s[0]), .i2(and_y[0]), .i3(or_y[0]), .i4(xor_y[0]), .i5(mult_p[0]), .i6(gnd), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_res1(.out(result_final[1]), .i0(soma_s[1]), .i1(sub_s[1]), .i2(and_y[1]), .i3(or_y[1]), .i4(xor_y[1]), .i5(mult_p[1]), .i6(gnd), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_res2(.out(result_final[2]), .i0(soma_s[2]), .i1(sub_s[2]), .i2(and_y[2]), .i3(or_y[2]), .i4(xor_y[2]), .i5(mult_p[2]), .i6(gnd), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_res3(.out(result_final[3]), .i0(soma_s[3]), .i1(sub_s[3]), .i2(and_y[3]), .i3(or_y[3]), .i4(xor_y[3]), .i5(mult_p[3]), .i6(gnd), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_res4(.out(result_final[4]), .i0(gnd), .i1(gnd), .i2(gnd), .i3(gnd), .i4(gnd), .i5(mult_p[4]), .i6(gnd), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_res5(.out(result_final[5]), .i0(gnd), .i1(gnd), .i2(gnd), .i3(gnd), .i4(gnd), .i5(mult_p[5]), .i6(gnd), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_res6(.out(result_final[6]), .i0(gnd), .i1(gnd), .i2(gnd), .i3(gnd), .i4(gnd), .i5(mult_p[6]), .i6(gnd), .i7(gnd), .sel(OP_sel));
    Mux8para1 mux_res7(.out(result_final[7]), .i0(gnd), .i1(gnd), .i2(gnd), .i3(gnd), .i4(gnd), .i5(mult_p[7]), .i6(gnd), .i7(gnd), .sel(OP_sel));

    // --- Lógica de Flags ---
    // Flag de Overflow (OV)
    wire ov_soma, ov_sub, t1, t2, t3, t4, not_soma_s3, not_A3, not_B3, not_sub_s3;
    not ov_not1(not_soma_s3, soma_s[3]); not ov_not2(not_A3, A_in[3]); not ov_not3(not_B3, B_in[3]); not ov_not4(not_sub_s3, sub_s[3]);
    and ov_soma_t1(t1, A_in[3], B_in[3], not_soma_s3);
    and ov_soma_t2(t2, not_A3, not_B3, soma_s[3]);
    or ov_soma_or(ov_soma, t1, t2);
    and ov_sub_t1(t3, A_in[3], not_B3, not_sub_s3);
    and ov_sub_t2(t4, not_A3, B_in[3], sub_s[3]);
    or ov_sub_or(ov_sub, t3, t4);
    Mux8para1 mux_ov(.out(LED_OV), .i0(ov_soma), .i1(ov_sub), .i2(gnd), .i3(gnd), .i4(gnd), .i5(gnd), .i6(gnd), .i7(gnd), .sel(OP_sel));

    // Flag de Carry Out (Cout)
    Mux8para1 mux_cout(.out(LED_Cout), .i0(soma_cout), .i1(sub_bout), .i2(gnd), .i3(gnd), .i4(gnd), .i5(gnd), .i6(gnd), .i7(gnd), .sel(OP_sel));
    
    // Flag de Zero (Z)
    wire not_z;
    or z_or(not_z, result_final[0], result_final[1], result_final[2], result_final[3], result_final[4], result_final[5], result_final[6], result_final[7]);
    not z_not(LED_Z, not_z);
    
    // Flag de Erro (ERR) - Conectado diretamente a terra
    buf buf_err(LED_ERR, gnd);
    
    // --- Lógica de Display (Conexão com os decodificadores) ---
    Decodificador7Seg U8_HEX0 (.I(result_final[3:0]), .segments(HEX0));
    Decodificador7Seg U9_HEX1 (.I(result_final[7:4]), .segments(HEX1));
    
    // Displays não utilizados ficam apagados conectando-os ao terra
    buf buf_h20(HEX2[0], gnd); buf buf_h21(HEX2[1], gnd); buf buf_h22(HEX2[2], gnd); buf buf_h23(HEX2[3], gnd); buf buf_h24(HEX2[4], gnd); buf buf_h25(HEX2[5], gnd); buf buf_h26(HEX2[6], gnd);
    buf buf_h30(HEX3[0], gnd); buf buf_h31(HEX3[1], gnd); buf buf_h32(HEX3[2], gnd); buf buf_h33(HEX3[3], gnd); buf buf_h34(HEX3[4], gnd); buf buf_h35(HEX3[5], gnd); buf buf_h36(HEX3[6], gnd);

endmodule