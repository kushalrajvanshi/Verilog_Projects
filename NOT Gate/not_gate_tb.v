module test_bench();
  reg a;
  wire out;

  // Instantiate Design Under Test
  not_gate dut(a, out);

  initial begin
    // Enable waveform dumping
    $dumpfile("dump.vcd");
    $dumpvars(0, test_bench);

    // Print changes to the log window
    $monitor("Time=%0t | a=%b -> out=%b", $time, a, out);

    // Apply inputs
    a = 1'b0;
    #10;
    a = 1'b1;
    #10;
    a = 1'b0;   // returns to 0, so there is a change at 20ns
    #10;

    $finish;
  end
endmodule