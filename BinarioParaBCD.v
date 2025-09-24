// Módulo para converter um número binário de 8 bits para 3 dígitos BCD
module BinarioParaBCD(
    input [7:0] bin_in,         // Entrada binária de 8 bits (0-255)
    output [3:0] bcd_centenas,  // Dígito das centenas (0-2)
    output [3:0] bcd_dezenas,   // Dígito das dezenas (0-9)
    output [3:0] bcd_unidades   // Dígito das unidades (0-9)
);

    reg [3:0] centenas, dezenas, unidades;
    integer i;

    always @(bin_in) begin
        // Inicializa os registradores BCD
        centenas = 4'd0;
        dezenas = 4'd0;
        unidades = 4'd0;

        // Algoritmo "Double Dabble" (Shift and Add 3)
        for (i = 0; i < 8; i = i + 1) begin
            // Adiciona 3 se a coluna for 5 ou maior (antes de shiftar)
            if (unidades >= 5) unidades = unidades + 3;
            if (dezenas >= 5) dezenas = dezenas + 3;
            if (centenas >= 5) centenas = centenas + 3;

            // Shift para a esquerda
            centenas = {centenas[2:0], dezenas[3]};
            dezenas = {dezenas[2:0], unidades[3]};
            unidades = {unidades[2:0], bin_in[7-i]};
        end
    end

    assign bcd_centenas = centenas;
    assign bcd_dezenas = dezenas;
    assign bcd_unidades = unidades;

endmodule