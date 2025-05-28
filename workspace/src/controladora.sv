//=======================================================
//  REG/WIRE declarations
//=======================================================
wire clk_1khz;
wire  [3:0] bcd_out;
wire key_valid;
//=======================================================
//  Structural coding
//=======================================================


teclado_matriz teclado(
	.clk(CLOCK_50), .rst(!KEY[0]),
	.entrada_teclado({GPIO_1[16], GPIO_1[14], GPIO_1[12], GPIO_1[10]}),
	.saida_conf_teclado({GPIO_1[24], GPIO_1[22], GPIO_1[20], GPIO_1[18]}),
	.bcd_out(bcd_out),
	.key_valid(key_valid)
);

decodificador_bcd_to_seg7 decoder(
	.clk(CLOCK_50), .rst(!KEY[0]),
	.bcd_in(bcd_out),
	.key_valid(key_valid),
	.bcd1(HEX5),
	.bcd2(HEX4), .bcd3(HEX3), .bcd4(HEX2), .bcd5(HEX1), .bcd6(HEX0)
	);


divfreq my_div(.reset(!KEY[0]), .clock(CLOCK_50), .clk_i(clk_1khz));

endmodule
