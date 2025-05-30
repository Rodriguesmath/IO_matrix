// tb_teclado_matriz.sv
`timescale 1ns / 1ps

module tb_teclado_matriz;

	// Declare signals for the UUT
	logic clk;
	logic rst;
	logic [3:0] entrada_teclado;
	logic [3:0] saida_conf_teclado;
	logic [3:0] bcd_out;
	logic key_valid;

	// Instantiate the Unit Under Test (UUT)
	teclado_matriz uut (
		.clk(clk),
		.rst(rst),
		.entrada_teclado(entrada_teclado),
		.saida_conf_teclado(saida_conf_teclado),
		.bcd_out(bcd_out),
		.key_valid(key_valid)
	);

	// Clock generation
	parameter CLK_PERIOD = 1_000_000; // 1,000,000 ns for 1 kHz clock
	initial begin
		clk = 0;
		forever #(CLK_PERIOD / 2) clk = ~clk;
	end

	// Test sequence
	initial begin
		// Initialize inputs
		rst             = 1;
		entrada_teclado = 4'b1111; // No key pressed initially

		// Apply reset
		repeat (2) @(posedge clk);
		rst = 0;
		@(posedge clk);
		$display("Reset complete. Starting test sequence.");

		// --- Test Case 1: Press '1' ---
		$display("--- Testing key '1' (Row W, Col W) ---");
		// Simulate row scan for 'W' (4'b0111)
		wait (uut.saida_conf_teclado == uut.W) @(posedge clk);
		$display("saida_conf_teclado is W. Simulating key '1' press.");
		entrada_teclado = uut.W; // Simulate key '1' press (row W, col W)
		repeat (uut.DEBOUNCE_P + 10) @(posedge clk); // Wait for debounce and processing
		if (bcd_out == uut.um && key_valid == 1) begin
			$display("Test '1' PASSED. bcd_out = %h, key_valid = %b", bcd_out, key_valid);
		end else begin
			$display("Test '1' FAILED. bcd_out = %h, key_valid = %b (Expected: %h, 1)", bcd_out, key_valid, uut.um);
		end
		entrada_teclado = 4'b1111; // Release key
		repeat (10) @(posedge clk); // Allow FSM to return to INICIAL

		// --- Test Case 2: Press '5' ---
		$display("--- Testing key '5' (Row X, Col X) ---");
		wait (uut.saida_conf_teclado == uut.X) @(posedge clk);
		$display("saida_conf_teclado is X. Simulating key '5' press.");
		entrada_teclado = uut.X; // Simulate key '5' press (row X, col X)
		repeat (uut.DEBOUNCE_P + 10) @(posedge clk);
		if (bcd_out == uut.cinco && key_valid == 1) begin
			$display("Test '5' PASSED. bcd_out = %h, key_valid = %b", bcd_out, key_valid);
		end else begin
			$display("Test '5' FAILED. bcd_out = %h, key_valid = %b (Expected: %h, 1)", bcd_out, key_valid, uut.cinco);
		end
		entrada_teclado = 4'b1111;
		repeat (10) @(posedge clk);






		// --- Test Case 3: Press 'D' ---
		$display("--- Testing key 'D' (Row Z, Col Z) ---");
		wait (uut.saida_conf_teclado == uut.Z) @(posedge clk);
		$display("saida_conf_teclado is Z. Simulating key 'D' press.");
		entrada_teclado = uut.Z; // Simulate key 'D' press (row Z, col Z)
		repeat (uut.DEBOUNCE_P + 10) @(posedge clk);
		if (bcd_out == uut.D && key_valid == 1) begin
			$display("Test 'D' PASSED. bcd_out = %h, key_valid = %b", bcd_out, key_valid);
		end else begin
			$display("Test 'D' FAILED. bcd_out = %h, key_valid = %b (Expected: %h, 1)", bcd_out, key_valid, uut.D);
		end
		entrada_teclado = 4'b1111;
		repeat (10) @(posedge clk);

		// --- Test Case 4: No key press (should not trigger) ---
		$display("--- Testing no key press ---");
		entrada_teclado = 4'b1111; // Ensure no key is pressed
		repeat (uut.DEBOUNCE_P + 20) @(posedge clk);
		if (key_valid == 0) begin
			$display("Test 'No Key' PASSED. key_valid = %b", key_valid);
		end else begin
			$display("Test 'No Key' FAILED. key_valid = %b (Expected: 0)", key_valid);
		end
		repeat (10) @(posedge clk);

		// --- Test Case 5: Press '*' (Row Z, Col W) ---
		$display("--- Testing key '*' (Row Z, Col W) ---");
		wait (uut.saida_conf_teclado == uut.Z) @(posedge clk);
		$display("saida_conf_teclado is Z. Simulating key '*' press.");
		entrada_teclado = uut.W; // Simulate key '*' press (row Z, col W)
		repeat (uut.DEBOUNCE_P + 10) @(posedge clk);
		if (bcd_out == uut.asterisco && key_valid == 1) begin
			$display("Test '*' PASSED. bcd_out = %h, key_valid = %b", bcd_out, key_valid);
		end else begin
			$display("Test '*' FAILED. bcd_out = %h, key_valid = %b (Expected: %h, 1)", bcd_out, key_valid, uut.asterisco);
		end
		entrada_teclado = 4'b1111;
		repeat (10) @(posedge clk);

		$display("Test sequence complete. Finishing simulation.");
		$finish;
	end

	// Dump waves for EPWave
	initial begin
		$dumpfile("teclado_matriz.vcd");
		$dumpvars(0, tb_teclado_matriz);
	end

endmodule