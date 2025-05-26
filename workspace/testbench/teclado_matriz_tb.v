module teclado_matriz_tb;

    // Parameters
    logic clk;
    logic rst;
    logic [3:0] entrada_teclado;
    logic [3:0] saida_conf_teclado;
    logic bcd_out;
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
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        rst = 1;
        entrada_teclado = 4'b0000;
        #10;

        // Release reset
        rst = 0;
        #10;

        // Test case 1: Simulate key press
        entrada_teclado = 4'b0001; // Simulate key press
        #10;

        // Test case 2: Simulate another key press
        entrada_teclado = 4'b0010; // Simulate key press
        #10;

        // Test case 3: Reset the module
        rst = 1;
        #10;
        rst = 0;
        #10;

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | entrada_teclado: %b | saida_conf_teclado: %b | bcd_out: %b | key_valid: %b", 
                 $time, entrada_teclado, saida_conf_teclado, bcd_out, key_valid);
    end

endmodule