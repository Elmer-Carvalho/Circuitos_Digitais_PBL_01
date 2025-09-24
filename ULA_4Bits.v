// Módulo principal - ULA 4 bits com display decimal
module ULA_4Bits(
    // --- Entradas Físicas ---
    input [3:0] A_in,
    input [3:0] B_in,
    input Cin,
    input [2:0] OP_sel,

    // --- Saídas Físicas ---
    output [7:0] Result_out,  // LEDs continuam mostrando o resultado em binário/hex
    output Cout,
    output OV,
    output Z,
    output ERR,
    // Saídas para 4 displays de 7 segmentos
    output [6:0] HEX0,        // Display Unidades
    output [6:0] HEX1,        // Display Dezenas
    output [6:0] HEX2,        // Display Centenas
    output [6:0] HEX3         // Display de Sinal
);

    // --- Sinais Internos ---
    // Adicionado 'div_r' para conectar ao resto do divisor
    wire [3:0] soma_s, sub_s, and_y, or_y, xor_y, div_q, div_r;
    wire [7:0] mult_p;
    wire soma_cout, sub_bout, div_err;
    
    // Sinais para o resultado final e para o conversor BCD
    reg [7:0] result_reg;
    reg cout_reg, ov_reg;
    reg is_negative;
    wire [7:0] valor_abs;
    wire [3:0] bcd_c, bcd_d, bcd_u;

    // --- Instanciação dos Módulos de Operação ---
    Somador4Bits      U0_Soma (soma_s, soma_cout, A_in, B_in, Cin);
    Subtrator4Bits    U1_Sub  (sub_s, sub_bout, A_in, B_in, Cin);
    OperacaoAnd4Bits  U2_And  (and_y, A_in, B_in);
    OperacaoOr4Bits   U3_Or   (or_y, A_in, B_in);
    OperacaoXor4Bits  U4_Xor  (xor_y, A_in, B_in);
    Multiplicador4Bits U5_Mult (mult_p, A_in, B_in);
    // CORREÇÃO: Conectado o fio 'div_r' à saída de resto do divisor
    Divisor4Bits      U6_Div  (div_q, div_r, div_err, A_in, B_in);

    // --- Lógica de Seleção e Saídas ---
    assign Result_out = result_reg;
    assign Cout = cout_reg;
    assign OV = ov_reg;
    assign Z = (result_reg == 8'b0);
    assign ERR = div_err;

    // Lógica principal para selecionar a operação
    always @(*) begin
        is_negative = 1'b0; // Reseta o sinal negativo
        case(OP_sel)
            3'b000: begin // SOMA (A+B)
                result_reg = {4'b0, soma_s};
                cout_reg = soma_cout;
                ov_reg = (A_in[3] & B_in[3] & ~soma_s[3]) | (~A_in[3] & ~B_in[3] & soma_s[3]);
            end
            3'b001: begin // SUBTRAÇÃO (A-B)
                result_reg = {4'b0, sub_s};
                cout_reg = sub_bout;
                ov_reg = (A_in[3] & ~B_in[3] & ~sub_s[3]) | (~A_in[3] & B_in[3] & sub_s[3]);
                // Se o bit mais significativo do resultado da subtração for 1, o número é negativo
                if (sub_s[3]) is_negative = 1'b1;
            end
            3'b010: begin // AND
                result_reg = {4'b0, and_y}; cout_reg = 0; ov_reg = 0;
            end
            3'b011: begin // OR
                result_reg = {4'b0, or_y}; cout_reg = 0; ov_reg = 0;
            end
            3'b100: begin // XOR
                result_reg = {4'b0, xor_y}; cout_reg = 0; ov_reg = 0;
            end
            3'b101: begin // MULTIPLICAÇÃO (A*B)
                result_reg = mult_p; cout_reg = 0; ov_reg = 0;
            end
            3'b110: begin // DIVISÃO (A/B)
                result_reg = {4'b0, div_q}; cout_reg = 0; ov_reg = 0;
            end
            default: begin
                result_reg = 8'h00; cout_reg = 0; ov_reg = 0;
            end
        endcase
    end

    // --- Lógica de Display Decimal ---
    // Calcula o valor absoluto (módulo) do resultado para enviar ao conversor
    // Se for negativo, faz o complemento de 2. Senão, usa o valor original.
    assign valor_abs = is_negative ? (~result_reg + 1) : result_reg;

    // Instancia o conversor Binário para BCD
    BinarioParaBCD U7_Conversor (valor_abs, bcd_c, bcd_d, bcd_u);

    // Instancia os decodificadores para os 3 displays de resultado
    Decodificador7Seg U8_HEX0 (bcd_u, HEX0); // Unidades
    Decodificador7Seg U9_HEX1 (bcd_d, HEX1); // Dezenas
    Decodificador7Seg U10_HEX2 (bcd_c, HEX2); // Centenas
    
    // Lógica para o display de sinal: mostra '-' se negativo, senão fica apagado
    // O valor 7'b0000001 acende apenas o segmento 'g' do display, que forma o sinal de menos.
    assign HEX3 = is_negative ? 7'b0000001 : 7'b0000000;

endmodule