// Code your testbench here
// or browse Examples
module test_bench();
  reg a, b;
  wire out;

  // Instantiate Design Under Test
  and_gate dut(a, b, out);

  initial begin
    // Print changes to the log window
   // \(monitor("Time=%0t | a=%b b=%b -> out=%b",\)time, a, b, out);
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

    $finish;
  end
endmodule