// Módulo principal - Unidade Lógica e Aritmética de 4 bits
module ULA_4Bits(
    // --- Entradas Físicas ---
    input [3:0] A_in,         // Operando A (ex: SW3 a SW0)
    input [3:0] B_in,         // Operando B (ex: SW7 a SW4)
    input Cin,                // Carry-In   (ex: SW8)
    input [2:0] OP_sel,       // Seletor de Operação (ex: SW9 e KEY1 a KEY0)

    // --- Saídas Físicas ---
    output [7:0] Result_out,  // Saída principal para LEDs (ex: LEDR7 a LEDR0)
    output Cout,              // LED para Carry-out
    output OV,                // LED para Overflow
    output Z,                 // LED para Zero
    output ERR,               // LED para Erro (divisão por zero)
    output [6:0] HEX0,        // Display 0 (dígito menos significativo)
    output [6:0] HEX1         // Display 1 (dígito mais significativo)
);

    // --- Sinais Internos (Fios) ---
    // Saídas dos módulos de operação
    wire [3:0] soma_s, sub_s, and_y, or_y, xor_y, div_q, div_r;
    wire [7:0] mult_p;
    wire soma_cout, sub_bout, div_err;

    // --- Instanciação dos Módulos de Operação ---
    Somador4Bits      U0_Soma (soma_s, soma_cout, A_in, B_in, Cin);
    Subtrator4Bits    U1_Sub  (sub_s, sub_bout, A_in, B_in, Cin);
    OperacaoAnd4Bits  U2_And  (and_y, A_in, B_in);
    OperacaoOr4Bits   U3_Or   (or_y, A_in, B_in);
    OperacaoXor4Bits  U4_Xor  (xor_y, A_in, B_in);
    Multiplicador4Bits U5_Mult (mult_p, A_in, B_in);
    Divisor4Bits      U6_Div  (div_q, div_r, div_err, A_in, B_in);

    // --- Lógica de Seleção e Saídas ---
    reg [7:0] result_reg;
    reg cout_reg, ov_reg;

    assign Result_out = result_reg;
    assign Cout = cout_reg;
    assign OV = ov_reg;
    assign Z = (Result_out == 8'b0); // Flag Zero: ativa se o resultado for 0
    assign ERR = div_err; // Flag de Erro: vem direto do divisor

    // Lógica principal para selecionar a operação e definir as saídas
    always @(*) begin
        case(OP_sel)
            3'b000: begin // SOMA (A+B)
                result_reg = {4'b0, soma_s};
                cout_reg = soma_cout;
                // Lógica de Overflow para soma: (A[3]&B[3]&~S[3]) | (~A[3]&~B[3]&S[3])
                ov_reg = (A_in[3] & B_in[3] & ~soma_s[3]) | (~A_in[3] & ~B_in[3] & soma_s[3]);
            end
            3'b001: begin // SUBTRAÇÃO (A-B)
                result_reg = {4'b0, sub_s};
                cout_reg = sub_bout; // Na subtração, é o Borrow-out
                // Lógica de Overflow para subtração: (A[3]&~B[3]&~S[3]) | (~A[3]&B[3]&S[3])
                ov_reg = (A_in[3] & ~B_in[3] & ~sub_s[3]) | (~A_in[3] & B_in[3] & sub_s[3]);
            end
            3'b010: begin // AND
                result_reg = {4'b0, and_y};
                cout_reg = 0;
                ov_reg = 0;
            end
            3'b011: begin // OR
                result_reg = {4'b0, or_y};
                cout_reg = 0;
                ov_reg = 0;
            end
            3'b100: begin // XOR
                result_reg = {4'b0, xor_y};
                cout_reg = 0;
                ov_reg = 0;
            end
            3'b101: begin // MULTIPLICAÇÃO (A*B)
                result_reg = mult_p; // Resultado de 8 bits
                cout_reg = 0;
                ov_reg = 0;
            end
            3'b110: begin // DIVISÃO (A/B)
                // Mostra o quociente nos 4 bits baixos e o resto nos 4 bits altos
                result_reg = {div_r, div_q};
                cout_reg = 0;
                ov_reg = 0;
            end
            default: begin
                result_reg = 8'h00;
                cout_reg = 0;
                ov_reg = 0;
            end
        endcase
    end

    // --- Conexão com os Displays de 7 Segmentos ---
    // O display HEX0 mostra os 4 bits menos significativos do resultado
    Decodificador7Seg U7_HEX0 (Result_out[3:0], HEX0);
    // O display HEX1 mostra os 4 bits mais significativos do resultado
    Decodificador7Seg U8_HEX1 (Result_out[7:4], HEX1);

endmodule