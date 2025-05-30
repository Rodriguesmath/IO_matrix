module teclado_matriz (
	
	input logic clk, rst,
	input logic [3:0] entrada_teclado,
	output logic [3:0] saida_conf_teclado,
	bcd_out,
	output logic key_valid
);

	parameter DEBOUNCE_P = 300;
	parameter logic [3:0] HIGH = 4'b1111;

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
	logic [8:0] Tp;
	int index;
	localparam logic [3:0] array [3:0] = '{W, X, Y, Z};


	always_ff @(posedge clk or posedge rst) begin:state_block
		if (rst) begin
			current_state <= INICIAL;
		end else begin
			current_state <= next_state;
		end
	end:state_block

	always_ff @(posedge clk or posedge rst) begin:counter
		if (rst) begin
			Tp <= 0;
		end else begin
			Tp <= Tp;
			case (current_state)
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
			index <= 0;
			saida_conf_teclado <= array[0];
            key_valid <= 0;
		end else case (current_state)

			INICIAL: begin
				index <= index + 1;
				if (index > 3) begin
					index <= 0; 
				end
				saida_conf_teclado <= array[index];
				if (entrada_teclado != HIGH) begin
					next_state <= DB;
				end else begin
					next_state <= INICIAL;
				end
			end

			DB: begin
				if (Tp + 3 == DEBOUNCE_P) begin
					if (entrada_teclado != HIGH) begin
						next_state <= PRESS_STATE;
					end else begin
						next_state <= INICIAL;
					end
				end else begin
					next_state <= DB;
				end
			end

			PRESS_STATE: begin

				saida_conf_teclado <= array[index];

				case (saida_conf_teclado)	
					W: begin
						if (entrada_teclado == W) begin
							bcd_out <= um;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else if (entrada_teclado == X) begin
							bcd_out <= dois;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else if (entrada_teclado == Y) begin
							bcd_out <= tres;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else if (entrada_teclado == Z) begin
							bcd_out <= A;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else begin
							bcd_out <= 0;
							key_valid <= 0;
							next_state <= INICIAL;
						end
					end
					X: begin
						if (entrada_teclado == W) begin
							bcd_out <= quatro;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else if (entrada_teclado == X) begin
							bcd_out <= cinco;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else if (entrada_teclado == Y) begin
							bcd_out <= seis;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else if (entrada_teclado == Z) begin
							bcd_out <= B;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else begin
							bcd_out <= 0;
							key_valid <= 0;
							next_state <= INICIAL;
						end
					end
					Y: begin
						if (entrada_teclado == W) begin
							bcd_out <= sete;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else if (entrada_teclado == X) begin
							bcd_out <= oito;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else if (entrada_teclado == Y) begin
							bcd_out <= nove;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else if (entrada_teclado == Z) begin
							bcd_out <= C;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else begin
							bcd_out <= 0;
							key_valid <= 0;
							next_state <= INICIAL;
						end
					end
					Z: begin
						if (entrada_teclado == W) begin
							bcd_out <= asterisco;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else if (entrada_teclado == X) begin
							bcd_out <= zero;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else if (entrada_teclado == Y) begin
							bcd_out <= hashtag;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else if (entrada_teclado == Z) begin
							bcd_out <= D;
							key_valid <= 1;
							next_state <= INICIAL;
						end
						else begin
							bcd_out <= 0;
							key_valid <= 0;
							next_state <= INICIAL;
						end
					end
					default: begin
						bcd_out <= 0;
						key_valid <= 0;
						next_state <= INICIAL;
					end
				endcase

			end

			default: begin
				next_state <= PRESS_STATE;
			end

		endcase
	end:FSM

endmodule