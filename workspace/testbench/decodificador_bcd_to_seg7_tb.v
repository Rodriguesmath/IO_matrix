// Testbench for the decodificador_bcd_to_seg7 module
module decodificador_bcd_to_seg7_tb;

    logic clk;
    logic rst;
    logic [3:0] bcd_in;
    logic key_valid;
    logic [6:0] bcd1, bcd2, bcd3, bcd4, bcd5, bcd6;

    // Instantiate the decodificador_bcd_to_seg7 module
    decodificador_bcd_to_seg7 uut (
        .clk(clk),
        .rst(rst),
        .bcd_in(bcd_in),
        .key_valid(key_valid),
        .bcd1(bcd1),
        .bcd2(bcd2),
        .bcd3(bcd3),
        .bcd4(bcd4),
        .bcd5(bcd5),
        .bcd6(bcd6)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units period
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        key_valid = 0;
        bcd_in = 4'b0000;

        // Release reset
        #10 rst = 0;

        // Test various BCD inputs
        key_valid = 1;
        bcd_in = 4'b0001; // Test input 1
        #10;

        bcd_in = 4'b0010; // Test input 2
        #10;

        bcd_in = 4'b0011; // Test input 3
        #10;

        bcd_in = 4'b0100; // Test input 4
        #10;

        bcd_in = 4'b0101; // Test input 5
        #10;

        // Finish simulation
        key_valid = 0;
        #10;
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | BCD Input: %b | Key Valid: %b | Outputs: %b %b %b %b %b %b", 
                 $time, bcd_in, key_valid, bcd1, bcd2, bcd3, bcd4, bcd5, bcd6);
    end

endmodule