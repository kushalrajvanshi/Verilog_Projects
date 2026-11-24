`timescale 1ns/1ps

module tb_adder_waves;
    reg  [3:0] a, b;
    reg        cin;
    wire [3:0] sum;
    wire       cout, overflow;

    ripple_carry_adder_4bit dut (
        .a(a), .b(b), .cin(cin),
        .sum(sum), .cout(cout), .overflow(overflow)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_adder_waves);

        $monitor("t=%0t | a=%b b=%b cin=%b | sum=%b cout=%b overflow=%b",
                 $time, a, b, cin, sum, cout, overflow);

        a = 4'd0;  b = 4'd0;  cin = 0; #10;  // 0+0         -> sum=0000 cout=0 ov=0
        a = 4'd3;  b = 4'd4;  cin = 0; #10;  // 3+4=7       -> sum=0111 cout=0 ov=0
        a = 4'd7;  b = 4'd1;  cin = 0; #10;  // 7+1         -> sum=1000 cout=0 ov=1 (signed overflow)
        a = 4'd15; b = 4'd1;  cin = 0; #10;  // 15+1=16     -> sum=0000 cout=1 ov=0
        a = 4'd8;  b = 4'd8;  cin = 0; #10;  // -8 + -8     -> sum=0000 cout=1 ov=1
        a = 4'd5;  b = 4'd10; cin = 1; #10;  // 5+10+1=16   -> sum=0000 cout=1 ov=0
        a = 4'd15; b = 4'd15; cin = 1; #10;  // 15+15+1=31  -> sum=1111 cout=1 ov=0
        a = 4'd0;  b = 4'd0;  cin = 0; #10;  // final change so the view reaches 70ns

        $finish;
    end
endmodule