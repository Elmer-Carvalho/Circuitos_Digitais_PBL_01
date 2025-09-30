
# 💡 ULA de 4 Bits em Verilog | Projeto de Circuitos Digitais

Projeto de uma Unidade Lógica e Aritmética (ULA) de 4 bits. Este trabalho foi desenvolvido para a disciplina de Circuitos Digitais, explorando na prática como os blocos lógicos que estudamos se unem para criar uma ULA.

A top-level design entity deste projeto é o módulo `ULA_4Bits`, que, através de um seletor de operação, pode executar diversas funções aritméticas e lógicas. O resultado é processado, convertido para um formato decimal e exibido em até quatro displays de 7 segmentos.

## ✨ Funcionalidades do Circuito

O módulo principal foi projetado com um conjunto robusto de funcionalidades, demonstrando uma ULA completa com múltiplos operadores e um sistema de exibição de dados avançado.

* **Operações Aritméticas e Lógicas:** O circuito recebe dois operandos de 4 bits (`A_in`, `B_in`) e executa uma das sete operações disponíveis, selecionadas pela entrada `OP_sel`:
    * Soma (`A + B`)
    * Subtração (`A - B`)
    * AND Lógico (`A & B`)
    * OR Lógico (`A | B`)
    * XOR Lógico (`A ^ B`)
    * Multiplicação (`A * B`)
    * Divisão (`A / B`)
* **Manipulação de Resultados:** O resultado da operação selecionada (que pode ter até 8 bits, no caso da multiplicação) é processado para exibição. Para a subtração, o circuito detecta resultados negativos e calcula o valor absoluto usando complemento de dois para a correta conversão.
* **Conversão Binário para BCD:** O resultado final (de 8 bits) é convertido para seu equivalente em três dígitos BCD (Centenas, Dezenas e Unidades), permitindo a representação de números de 0 a 255.
* **Saída para Displays de 7 Segmentos:** Os dígitos BCD são enviados para decodificadores que geram os sinais para acionar quatro displays de 7 segmentos (anodo comum), incluindo um display dedicado para o sinal de negativo.
* **Sinalização de Status (Flags):** A ULA gera flags de status com base na operação realizada:
    * `LED_Cout`: Ativado para o *carry-out* da soma ou o *borrow-out* da subtração.
    * `LED_OV`: Indica a ocorrência de *overflow* (transbordamento) nas operações de soma e subtração.
    * `LED_Z`: Sinaliza que o resultado da operação foi exatamente zero.
    * `LED_ERR`: Ativado exclusivamente se ocorrer uma divisão por zero.

## 📐 Arquitetura do Projeto

O projeto foi implementado utilizando um estilo de modelagem **estrutural** em Verilog. Essa abordagem consiste em instanciar e conectar sub-módulos, de forma análoga à montagem de um circuito com CIs discretos. A hierarquia é composta pelos seguintes blocos:

1.  **Módulos Operacionais**: Cada um executa uma função específica da ULA.
    * `Somador4Bits`
    * `Subtrator4Bits`
    * `OperacaoAnd4Bits`
    * `OperacaoOr4Bits`
    * `OperacaoXor4Bits`
    * `Multiplicador4Bits`
    * `Divisor4Bits`
2.  **`Mux8para1`**: Oito multiplexadores (um para cada bit do barramento de resultado) selecionam a saída do módulo operacional correto com base na entrada `OP_sel`.
3.  **`ComplementoDeDois8Bits`**: Converte resultados negativos da subtração para seu valor absoluto antes da exibição.
4.  **`BinarioBCD`**: Realiza a conversão do resultado binário de 8 bits para três dígitos BCD.
5.  **`DecodificadorDisplay`**: Traduz cada dígito BCD para o código de 7 segmentos correspondente, acionando os displays.

## 🔌 Interface do Módulo (Entradas e Saídas)

A seguir, a descrição das portas de interface do top-level module `ULA_4Bits`:

### Entradas

| Porta    | Tamanho | Descrição                                                                                               |
| :------- | :------ | :-------------------------------------------------------------------------------------------------------- |
| `A_in`   | 4 bits  | Primeiro operando de 4 bits.                                                                            |
| `B_in`   | 4 bits  | Segundo operando de 4 bits.                                                                             |
| `Cin`    | 1 bit   | Bit de Carry/Borrow de entrada para as operações de soma e subtração.                                   |
| `OP_sel` | 3 bits  | Seletor de 3 bits que define qual operação a ULA irá executar (ver tabela de operações abaixo).         |

### Saídas

| Porta      | Tamanho | Descrição                                                              |
| :--------- | :------ | :----------------------------------------------------------------------- |
| `HEX0`     | 7 bits  | Saída para o display de 7 segmentos do dígito das **unidades**.          |
| `HEX1`     | 7 bits  | Saída para o display de 7 segmentos do dígito das **dezenas**.           |
| `HEX2`     | 7 bits  | Saída para o display de 7 segmentos do dígito das **centenas**.          |
| `HEX3`     | 7 bits  | Saída para o display de 7 segmentos do **sinal** ('-' ou apagado).       |
| `LED_Cout` | 1 bit   | Flag de Carry/Borrow.                                                  |
| `LED_OV`   | 1 bit   | Flag de Overflow.                                                      |
| `LED_Z`    | 1 bit   | Flag de Resultado Zero.                                                |
| `LED_ERR`  | 1 bit   | Flag de Erro (para divisão por zero).                                  |
