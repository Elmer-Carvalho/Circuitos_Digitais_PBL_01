// Módulo para decodificar um valor de 4 bits para display de 7 segmentos
// Mapeamento: segments = {a, b, c, d, e, f, g}
//             segments[6]=a, [5]=b, [4]=c, [3]=d, [2]=e, [1]=f, [0]=g

module Decodificador7Seg(
    input [3:0] I,           // Entrada de 4 bits (0-15)
    output [6:0] segments    // Saída: {a,b,c,d,e,f,g}
);
    wire [3:0] n;  // Versões invertidas de I
    
    // Inversores para cada bit
    not inv0(n[0], I[0]);
    not inv1(n[1], I[1]);
    not inv2(n[2], I[2]);
    not inv3(n[3], I[3]);

    // Expressões booleanas minimizadas (quando segmento deve estar LIGADO = 1)
    // Para anodo comum, invertemos no final
    
    // Segmento 'a' - Liga para: 0,2,3,5,6,7,8,9
    // a = n[3]&n[2]&n[1]&n[0] | n[3]&n[2]&I[1]&n[0] | n[3]&n[2]&I[1]&I[0] |
    //     n[3]&I[2]&n[1]&I[0] | n[3]&I[2]&I[1]&n[0] | n[3]&I[2]&I[1]&I[0] |
    //     I[3]&n[2]&n[1]&n[0] | I[3]&n[2]&n[1]&I[0]
    // Simplificando: a = I[2] | I[1] | (I[3]&n[0]) | (n[3]&n[1]&n[0])
    wire a_t1, a_t2, a_t3, a_logic;
    and a_and1(a_t1, I[3], n[0]);
    and a_and2(a_t2, n[3], n[1], n[0]);
    or a_or(a_logic, I[2], I[1], a_t1, a_t2);
    not a_inv(segments[6], a_logic);  // Inverte para anodo comum

    // Segmento 'b' - Liga para: 0,1,2,3,4,7,8,9
    // Simplificando: b = n[2] | (n[1]&n[0]) | (I[1]&I[0])
    wire b_t1, b_t2, b_logic;
    and b_and1(b_t1, n[1], n[0]);
    and b_and2(b_t2, I[1], I[0]);
    or b_or(b_logic, n[2], b_t1, b_t2);
    not b_inv(segments[5], b_logic);

    // Segmento 'c' - Liga para: 0,1,3,4,5,6,7,8,9
    // Simplificando: c = n[1] | I[0] | I[2]
    wire c_logic;
    or c_or(c_logic, n[1], I[0], I[2]);
    not c_inv(segments[4], c_logic);

    // Segmento 'd' - Liga para: 0,2,3,5,6,8,9
    // d = (n[2]&n[1]&n[0]) | (n[2]&I[1]&I[0]) | (I[2]&n[1]&I[0]) | 
    //     (I[2]&I[1]&n[0]) | I[3]
    wire d_t1, d_t2, d_t3, d_t4, d_logic;
    and d_and1(d_t1, n[2], n[1], n[0]);
    and d_and2(d_t2, n[2], I[1], I[0]);
    and d_and3(d_t3, I[2], n[1], I[0]);
    and d_and4(d_t4, I[2], I[1], n[0]);
    or d_or(d_logic, d_t1, d_t2, d_t3, d_t4, I[3]);
    not d_inv(segments[3], d_logic);

    // Segmento 'e' - Liga para: 0,2,6,8
    // e = (n[2]&n[0]) | (I[1]&n[0])
    wire e_t1, e_t2, e_logic;
    and e_and1(e_t1, n[2], n[0]);
    and e_and2(e_t2, I[1], n[0]);
    or e_or(e_logic, e_t1, e_t2);
    not e_inv(segments[2], e_logic);

    // Segmento 'f' - Liga para: 0,4,5,6,8,9
    // f = (n[2]&n[1]) | (n[1]&n[0]) | (I[2]&n[0]) | I[3]
    wire f_t1, f_t2, f_logic;
    and f_and1(f_t1, n[2], n[1]);
    and f_and2(f_t2, I[2], n[0]);
    or f_or(f_logic, f_t1, b_t1, f_t2, I[3]);  // Reutiliza b_t1 = (n[1]&n[0])
    not f_inv(segments[1], f_logic);

    // Segmento 'g' - Liga para: 2,3,4,5,6,8,9
    // g = (n[3]&I[2]) | (I[1]&n[0]) | (n[2]&I[1]) | I[3]
    wire g_t1, g_t2, g_logic;
    and g_and1(g_t1, n[3], I[2]);
    and g_and2(g_t2, n[2], I[1]);
    or g_or(g_logic, g_t1, e_t2, g_t2, I[3]);  // Reutiliza e_t2 = (I[1]&n[0])
    not g_inv(segments[0], g_logic);

endmodule