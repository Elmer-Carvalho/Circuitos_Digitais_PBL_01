module Nova_ULA_4Bits(
    input [3:0] A_in,
    input [3:0] B_in,
    input Cin,
    input [2:0] OP_sel,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output LED_Cout,
    output LED_OV,
    output LED_Z,
    output LED_ERR
);
    wire [3:0] S;
    wire Cout;
    wire NCin;
    wire [4:0] bin_entrada;
    wire [3:0] unidades, dezenas;
    wire zero, um;
    
    // Criando constantes
    and(zero, Cin, NCin);
    or(um, Cin, NCin);
    not(NCin, Cin);
    
    // Somador
    Somador4Bits somador(S, Cout, A_in, B_in, NCin);
    
    // Montando entrada de 5 bits para conversor
    or(bin_entrada[0], S[0], zero);
    or(bin_entrada[1], S[1], zero);
    or(bin_entrada[2], S[2], zero);
    or(bin_entrada[3], S[3], zero);
    or(bin_entrada[4], Cout, zero);
    
    // Conversor BCD
    BinarioBCD conversor(bin_entrada, unidades, dezenas);
    
    // Displays
    DecodificadorDisplay dec0(unidades, 
        HEX0[0], HEX0[1], HEX0[2], HEX0[3],
        HEX0[4], HEX0[5], HEX0[6]);
    
    DecodificadorDisplay dec1(dezenas,
        HEX1[0], HEX1[1], HEX1[2], HEX1[3],
        HEX1[4], HEX1[5], HEX1[6]);
    
    // HEX2 mostra zero
    wire [3:0] zero_display;
    and(zero_display[0], S[0], zero);
    and(zero_display[1], S[0], zero);
    and(zero_display[2], S[0], zero);
    and(zero_display[3], S[0], zero);
    
    DecodificadorDisplay dec2(zero_display,
        HEX2[0], HEX2[1], HEX2[2], HEX2[3],
        HEX2[4], HEX2[5], HEX2[6]);
    
    // LEDs
    or(LED_Cout, Cout, zero);
    
    // LED_Z
    wire s01, s23, all;
    or(s01, S[0], S[1]);
    or(s23, S[2], S[3]);
    or(all, s01, s23);
    not(LED_Z, all);
    
    // LED_OV
    wire xor_ab, eq_ab, xor_as;
    xor(xor_ab, A_in[3], B_in[3]);
    not(eq_ab, xor_ab);
    xor(xor_as, A_in[3], S[3]);
    and(LED_OV, eq_ab, xor_as);
    
    // LED_ERR
    and(LED_ERR, S[0], zero);
    
endmodule