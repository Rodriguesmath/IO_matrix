module teclado_matriz (
    input logic clk, rst,
    input logic [3:0] entrada_teclado,
    output logic [3:0] saida_conf_teclado,
    output logic [3:0] bcd_out, // Adicionado como output
    output logic key_valid
);

    parameter DEBOUNCE_P = 300;
    parameter logic [3:0] HIGH = 4'b1111;
	localparam logic [3:0] array [3:0] = '{W, X, Y, Z};

    typedef enum logic [2:0] {
        INICIAL,
        DB,
        PRESS_STATE
    } state_t;

    typedef enum logic [3:0] {
        W = 4'b0111,
        X = 4'b1011,
        Y = 4'b1101,
        Z = 4'b1110
    } IO_t;

    typedef enum logic [3:0] {
        um        = 4'h1,
        dois      = 4'h2,
        tres      = 4'h3,
        quatro    = 4'h4,
        cinco     = 4'h5,
        seis      = 4'h6,
        sete      = 4'h7,
        oito      = 4'h8,
        nove      = 4'h9,
        zero      = 4'h0,
        asterisco = 4'hE,
        hashtag   = 4'hF,
        A         = 4'hA,
        B         = 4'hB,
        C         = 4'hC,
        D         = 4'hD
    } BCD_t;

    state_t current_state, next_state;
    logic [8:0] Tp; // Contador para debounce
    logic [1:0] scan_index; // Declaração do índice de varredura como logic [1:0] para 4 elementos (0 a 3)

    // FF para o estado atual
    always_ff @(posedge clk or posedge rst) begin: state_reg
        if (rst) begin
            current_state <= INICIAL;
        end else begin
            current_state <= next_state;
        end
    end: state_reg

    // FF para o contador de debounce
    always_ff @(posedge clk or posedge rst) begin: debounce_counter_reg
        if (rst) begin
            Tp <= 0;
        end else begin
            case (current_state)
                DB: begin
                    if (Tp < DEBOUNCE_P -1) begin // Previni overflow e garante contagem correta
                         Tp <= Tp + 1;
                    end else begin
                         Tp <= Tp; // Mantém o valor máximo ou reseta no próximo estado
                    end
                end
                default: begin
                    Tp <= 0;
                end
            endcase
        end
    end: debounce_counter_reg

    // --- NOVO FF para varredura do array (saida_conf_teclado e scan_index) ---
    always_ff @(posedge clk or posedge rst) begin: array_scan_reg
        if (rst) begin
            scan_index <= 0;
            saida_conf_teclado <= array[0]; // Inicializa com o primeiro elemento
        end else begin
            // O scan_index só avança quando estamos no estado INICIAL e entrada_teclado ainda é HIGH
            // (sem tecla pressionada, varrendo) ou quando voltamos para INICIAL após um evento.
            // Para garantir a varredura contínua ou controlada, ajustamos aqui.
            if (current_state == INICIAL) begin
                // Incrementar o índice para varrer as linhas
                scan_index <= (scan_index == 3) ? 0 : scan_index + 1;
                saida_conf_teclado <= array[scan_index]; // sairá o valor do 'próximo' scan_index
                                                         // se a atualização fosse no posedge
            end else if (current_state == PRESS_STATE) begin
                // Quando uma tecla é pressionada, mantemos o scan_index e saida_conf_teclado
                // fixos no valor que identificou a tecla para que a lógica de decodificação funcione.
                saida_conf_teclado <= array[scan_index];
            end else begin
                // Em outros estados (como DB), mantemos a última saída de varredura ativa.
                saida_conf_teclado <= saida_conf_teclado;
            end
        end
    end: array_scan_reg

    // Lógica para determinar o próximo estado (always_comb para lógica combinacional)
    always_comb begin: next_state_logic
        next_state = current_state; // Default: stay in current state
        bcd_out = 0; // Default outputs
        key_valid = 0;

        case (current_state)
            INICIAL: begin
                // Se detectar que alguma tecla foi pressionada (entrada_teclado não é HIGH)
                // transiciona para o estado de debounce.
                if (entrada_teclado != HIGH) begin
                    next_state = DB;
                end else begin
                    // Continua varrendo se nenhuma tecla for detectada
                    next_state = INICIAL;
                end
            end

            DB: begin
                // Espera o contador de debounce atingir o limite
                if (Tp == DEBOUNCE_P - 1) begin // Corrigido para ser mais preciso
                    // Após debounce, verifica se a tecla ainda está pressionada
                    if (entrada_teclado != HIGH) begin
                        next_state = PRESS_STATE;
                    end else begin
                        // Se a tecla foi solta durante o debounce, volta ao INICIAL
                        next_state = INICIAL;
                    end
                end else begin
                    // Continua no estado de debounce enquanto o contador não termina
                    next_state = DB;
                end
            end

            PRESS_STATE: begin
                // Lógica de decodificação da tecla (saída saida_conf_teclado agora é a linha ativa)
                key_valid = 1'b1; // Assume que a tecla é válida neste estado
                case (saida_conf_teclado)
                    W: begin // Coluna 1
                        case (entrada_teclado)
                            W: bcd_out = um; // Tecla na coluna W, linha W (não é uma matriz 4x4 típica)
                            X: bcd_out = dois; // Isso sugere que entrada_teclado é o valor da coluna
                            Y: bcd_out = tres;
                            Z: bcd_out = A;
                            default: begin bcd_out = 0; key_valid = 0; end
                        endcase
                    end
                    X: begin // Coluna 2
                        case (entrada_teclado)
                            W: bcd_out = quatro;
                            X: bcd_out = cinco;
                            Y: bcd_out = seis;
                            Z: bcd_out = B;
                            default: begin bcd_out = 0; key_valid = 0; end
                        endcase
                    end
                    Y: begin // Coluna 3
                        case (entrada_teclado)
                            W: bcd_out = sete;
                            X: bcd_out = oito;
                            Y: bcd_out = nove;
                            Z: bcd_out = C;
                            default: begin bcd_out = 0; key_valid = 0; end
                        endcase
                    end
                    Z: begin // Coluna 4
                        case (entrada_teclado)
                            W: bcd_out = asterisco;
                            X: bcd_out = zero;
                            Y: bcd_out = hashtag;
                            Z: bcd_out = D;
                            default: begin bcd_out = 0; key_valid = 0; end
                        endcase
                    end
                    default: begin // Caso algo inesperado aconteça
                        bcd_out = 0;
                        key_valid = 0;
                    end
                endcase

                // Se a tecla for solta, retorna para INICIAL
                if (entrada_teclado == HIGH) begin
                    next_state = INICIAL;
                    key_valid = 0; // Invalida a tecla ao soltar
                end else begin
                    next_state = PRESS_STATE; // Continua no estado enquanto a tecla estiver pressionada
                end
            end

            default: begin // Default case for safety
                next_state = INICIAL;
            end
        endcase
    end: next_state_logic

endmodule