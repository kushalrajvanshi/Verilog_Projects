module test_bench();
  reg a, b;
  wire out;

  // Instantiate Design Under Test
  xor_gate dut(a, b, out);

  initial begin
    // Enable waveform dumping
    $dumpfile("dump.vcd");
    $dumpvars(0, test_bench);

    // Print changes to the log window
    $monitor("Time=%0t | a=%b b=%b -> out=%b", $time, a, b, out);

    // Apply inputs
    a = 1'b0; b = 1'b0;
    #10;
    a = 1'b0; b = 1'b1;
    #10;
    a = 1'b1; b = 1'b0;
    #10;
    a = 1'b1; b = 1'b1;
    #10;
    a = 1'b0; b = 1'b0;   // returns to 00, so there is a change at 40ns
    #10;

    $finish;
  end
endmodule