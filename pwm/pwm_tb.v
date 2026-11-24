`timescale 1ns/1ps

module tb_pwm;
    parameter WIDTH  = 4;                 // small width -> short, readable waveform
    parameter PERIOD = (1 << WIDTH);      // 16 clock cycles per PWM period

    reg              clk, rst;
    reg  [WIDTH-1:0] duty;
    wire             pwm_out;

    integer errors, highs;

    pwm_generator #(.WIDTH(WIDTH)) dut (
        .clk(clk), .rst(rst), .duty(duty), .pwm_out(pwm_out)
    );

    // 10 ns clock
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Apply a duty value, let it settle, then count high cycles in one full period
    task check_duty(input [WIDTH-1:0] d);
        begin
            duty = d;
            repeat (2*PERIOD) @(posedge clk);     // new duty is latched at the next period end
            highs = 0;
            repeat (PERIOD) begin
                @(posedge clk);
                #1;
                if (pwm_out) highs = highs + 1;
            end
            $display("duty=%0d/%0d (%0d%%) -> high cycles=%0d", d, PERIOD, (d*100)/PERIOD, highs);
            if (highs !== d) begin
                errors = errors + 1;
                $display("FAIL: expected %0d high cycles, got %0d", d, highs);
            end
        end
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_pwm);

        errors = 0;
        rst    = 1'b1;
        duty   = 4'd4;
        repeat (3) @(posedge clk);
        rst = 1'b0;

        check_duty(4'd4);     // 25 %
        check_duty(4'd8);     // 50 %
        check_duty(4'd12);    // 75 %
        check_duty(4'd0);     //  0 %  (always low)
        check_duty(4'd15);    // 15/16 (max)

        if (errors == 0)
            $display("PASS: all duty cycles correct.");
        else
            $display("FAIL: %0d checks failed.", errors);

        duty = 4'd4;          // final change so EPWave shows the last segment
        repeat (PERIOD) @(posedge clk);
        $finish;
    end
endmodule