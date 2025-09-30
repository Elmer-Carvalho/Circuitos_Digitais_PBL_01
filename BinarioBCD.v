module BinarioBCD(
    input [4:0] binario,
    output [3:0] unidades,
    output [3:0] dezenas
);
    wire [4:0] b;
    wire [4:0] nb;
    wire zero, um;
    
    // Propagando sinais
    or(b[0], binario[0], binario[0]);
    or(b[1], binario[1], binario[1]);
    or(b[2], binario[2], binario[2]);
    or(b[3], binario[3], binario[3]);
    or(b[4], binario[4], binario[4]);
    
    // Invertendo
    not(nb[0], b[0]);
    not(nb[1], b[1]);
    not(nb[2], b[2]);
    not(nb[3], b[3]);
    not(nb[4], b[4]);
    
    // Constantes
    and(zero, b[0], nb[0]);
    or(um, b[0], nb[0]);
    
    // ===== DEZENAS =====
    // dezenas = binario / 10
    // 0-9: dez=0, 10-19: dez=1, 20-29: dez=2, 30-31: dez=3
    
    and(dezenas[3], zero, zero);  // sempre 0
    and(dezenas[2], zero, zero);  // sempre 0
    
    // dezenas[1] = 1 se >= 20 (binario >= 20)
    // 20 = 10100, então b[4]=1
    and(dezenas[1], b[4], um);
    
    // dezenas[0] = 1 se está em [10-19] OU [30-31]
    // [10-19]: nb[4] & b[3] & (b[2] | b[1])
    // [30-31]: b[4] & b[3] & b[2] & b[1]
    wire dz_a, dz_b, dz_c, dz_d, dz_e;
    or(dz_a, b[2], b[1]);              // b[2]|b[1]
    and(dz_b, nb[4], b[3], dz_a);      // 10-15 (nb4 & b3 & (b2|b1))
    and(dz_c, b[4], b[3], b[2], b[1]); // 30-31
    or(dezenas[0], dz_b, dz_c);
    
    // ===== UNIDADES =====
    // unidades = binario % 10
    
    // Estratégia: subtrair 10 ou 20 conforme necessário
    // Se dezenas[1]=1 (>=20): unidade = binario - 20
    // Se dezenas[0]=1 e dezenas[1]=0 (10-19): unidade = binario - 10
    // Senão: unidade = binario
    
    // Subtração de 10 = subtrair 01010
    // Subtração de 20 = subtrair 10100
    
    wire sub10, sub20;
    wire ndz1;
    not(ndz1, dezenas[1]);
    and(sub10, dezenas[0], ndz1);  // subtrai 10 se dez=1 (faixa 10-19)
    and(sub20, dezenas[1], um);     // subtrai 20 se dez>=2
    
    // unidades[0] = b[0] (sempre, pois 10 e 20 são pares)
    or(unidades[0], b[0], zero);
    
    // unidades[1] = b[1] XOR sub10 (10 tem bit1=1, então inverte)
    xor(unidades[1], b[1], sub10);
    
    // unidades[2] = b[2] XOR sub20 (20 tem bit2=1, então inverte)
    xor(unidades[2], b[2], sub20);
    
    // unidades[3] = b[3] XOR (sub10 | sub20) (tanto 10 quanto 20 têm bit3=1)
    wire sub_any;
    or(sub_any, sub10, sub20);
    xor(unidades[3], b[3], sub_any);
    
endmodule