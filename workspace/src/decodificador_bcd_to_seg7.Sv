module decodificador_bcd_to_seg7 (
    input  logic clk, rst,
    input  logic [3:0] bcd_in,
    input  logic key_valid,
    output logic [6:0] bcd1, bcd2, bcd3, bcd4, bcd5, bcd6
);

    // Registradores para armazenar os valores dos 6 dígitos
    logic [3:0] digits [5:0];

    // Função para converter BCD para 7 segmentos
    function logic [6:0] bcd_to_7seg(input logic [3:0] bcd);
        case (bcd)
            4'h0: bcd_to_7seg = 7'b0111111;
            4'h1: bcd_to_7seg = 7'b0000110;
            4'h2: bcd_to_7seg = 7'b1011011;
            4'h3: bcd_to_7seg = 7'b1001111;
            4'h4: bcd_to_7seg = 7'b1100110;
            4'h5: bcd_to_7seg = 7'b1101101;
            4'h6: bcd_to_7seg = 7'b1111101;
            4'h7: bcd_to_7seg = 7'b0000111;
            4'h8: bcd_to_7seg = 7'b1111111;
            4'h9: bcd_to_7seg = 7'b1100111;
            4'hA: bcd_to_7seg = 7'b1110111; // A
            4'hB: bcd_to_7seg = 7'b1111100; // b
            4'hC: bcd_to_7seg = 7'b0111001; // C
            4'hD: bcd_to_7seg = 7'b1011110; // d
            4'hE: bcd_to_7seg = 7'b1111001; // E
            4'hF: bcd_to_7seg = 7'b1110001; // F
            default: bcd_to_7seg = 7'b0000000;
        endcase
    endfunction

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            digits[0] <= 4'd0;
            digits[1] <= 4'd0;
            digits[2] <= 4'd0;
            digits[3] <= 4'd0;
            digits[4] <= 4'd0;
            digits[5] <= 4'd0;
        end else if (key_valid) begin
            // Desloca todos para a direita
            digits[5] <= digits[4];
            digits[4] <= digits[3];
            digits[3] <= digits[2];
            digits[2] <= digits[1];
            digits[1] <= digits[0];
            digits[0] <= bcd_in; // Novo valor entra à esquerda
        end
    end

    // Atualiza os displays
    assign bcd1 = ~bcd_to_7seg(digits[0]);
    assign bcd2 = ~bcd_to_7seg(digits[1]);
    assign bcd3 = ~bcd_to_7seg(digits[2]);
    assign bcd4 = ~bcd_to_7seg(digits[3]);
    assign bcd5 = ~bcd_to_7seg(digits[4]);
    assign bcd6 = ~bcd_to_7seg(digits[5]);

endmodule