module decodificador_bcd_to_seg7 (
	input logic clk, rst,
	input logic [3:0] bcd_in,
	input logic key_valid,
	output logic [6:0] bcd1,
	bcd2, bcd3, bcd4, bcd5, bcd6
);

	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin
			bcd1 <= 7'b0000000;
			bcd2 <= 7'b0000000;
			bcd3 <= 7'b0000000;
			bcd4 <= 7'b0000000;
			bcd5 <= 7'b0000000;
			bcd6 <= 7'b0000000;
		end else if (key_valid) begin
			case (bcd_in)
				4'b0000: bcd1 <= 7'b0111111; // 0
				4'b0001: bcd1 <= 7'b0000110; // 1
				4'b0010: bcd1 <= 7'b1011011; // 2
				4'b0011: bcd1 <= 7'b1001111; // 3
				4'b0100: bcd1 <= 7'b1100110; // 4
				4'b0101: bcd1 <= 7'b1101101; // 5
				4'b0110: bcd1 <= 7'b1111101; // 6
				4'b0111: bcd1 <= 7'b0000111; // 7
				4'b1000: bcd1 <= 7'b1111111; // 8
				4'b1001: bcd1 <= 7'b1100111; // 9
				default: bcd1 <= 7'b0000000; // Default case
			endcase

		end
	end

endmodule