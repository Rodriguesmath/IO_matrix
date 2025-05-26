module teclado_matriz (
	
	input logic clk, rst,
	input logic [3:0] entrada_teclado,
	output logic [3:0] saida_conf_teclado,
	output logic bcd_out,
	output logic key_valid
);
parameter DEBOUNCE_P = 300;
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

	logic [3:0] array [3:0];

	state_t current_state, next_state;
	logic [8:0] Tp;


	always_ff @(posedge clk or posedge rst) begin:state_block
		if (rst) begin
			current_state <= INICIAL;
			array[0] <= W;
			array[1] <= X;
			array[2] <= Y;
			array[3] <= Z;
		end else begin
			current_state <= next_state;
		end
	end:state_block

	always_ff @(posedge clk or posedge rst) begin:counter
		if (rst) begin
			Tp <= 0;
		end else begin
			Tp <= Tp;
			case (next_state)
				DB: begin
					Tp <= Tp + 1;
				end
				default: begin
					Tp <= 0;
				end
			endcase
		end
	end:counter

	always_ff @(posedge clk or posedge rst) begin:FSM
		if (rst) begin
			next_state <= INICIAL;
		end else case (current_state)

			INICIAL: begin
				if (entrada_teclado != 4'b1111) begin
					next_state <= DB;
				end else begin
					next_state <= INICIAL;
				end
			end

			DB: begin
				if (Tp + 3 == DEBOUNCE_P) begin
					if (entrada_teclado != 4'b1111) begin
						next_state <= PRESS_STATE;
					end else begin
						next_state <= INICIAL;
					end
				end else begin
					next_state <= DB;
				end
			end

			PRESS_STATE: begin

				// FIXME: Esta parte do código é apenas um protótipo e precisa ser revisada/implementada corretamente.
				case (saida_conf_teclado)
					W: begin
						if (entrada_teclado == array[0]) begin
							bcd_out <= 1;
							key_valid <= 1;
						end else begin
							bcd_out <= 0;
							key_valid <= 0;
						end
					end
					X: begin
						if (entrada_teclado == array[1]) begin
							bcd_out <= 1;
							key_valid <= 1;
						end else begin
							bcd_out <= 0;
							key_valid <= 0;
						end
					end
					Y: begin
						if (entrada_teclado == array[2]) begin
							bcd_out <= 1;
							key_valid <= 1;
						end else begin
							bcd_out <= 0;
							key_valid <= 0;
						end
					end
					Z: begin
						if (entrada_teclado == array[3]) begin
							bcd_out <= 1;
							key_valid <= 1;
						end else begin
							bcd_out <= 0;
							key_valid <= 0;
						end
					end
					default: begin
						saida_conf_teclado <= entrada_teclado;
						bcd_out <= 0;
						key_valid <= 0;
					end
				endcase

			end

			default: begin
				next_state <= INICIAL;
			end

		endcase
	end:FSM

endmodule