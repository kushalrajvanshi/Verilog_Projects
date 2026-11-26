`timescale 1ns/1ps

module tb;

    reg  [7:0] in;
    wire [2:0] y;
    wire       valid;
    integer    errors;

    priority_encoder_8to3 dut (.in(in), .y(y), .valid(valid));

    // Reference model: highest set bit wins
    function [2:0] exp_y(input [7:0] v);
        integer k;
        begin
            exp_y = 3'd0;
            for (k = 0; k < 8; k = k + 1)
                if (v[k]) exp_y = k;
        end
    endfunction

    // Apply an input, wait, then compare against the reference
    task apply(input [7:0] v);
        begin
            in = v;
            #10;
            if ((y !== exp_y(v)) || (valid !== (v != 8'b0))) begin
                errors = errors + 1;
                $display("FAIL: in=%b y=%b valid=%b (expected y=%b valid=%b)",
                         v, y, valid, exp_y(v), (v != 8'b0));
            end
        end
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        $monitor("time=%0t  in=%b  y=%b  valid=%b", $time, in, y, valid);

        errors = 0;

        apply(8'b00000000);   // no input active
        apply(8'b00000001);   // only 0
        apply(8'b00000010);   // only 1
        apply(8'b00000100);   // only 2
        apply(8'b00001000);   // only 3
        apply(8'b00010000);   // only 4
        apply(8'b00100000);   // only 5
        apply(8'b01000000);   // only 6
        apply(8'b10000000);   // only 7

        apply(8'b00000011);   // 1 and 0   -> 1
        apply(8'b00001101);   // 3,2,0     -> 3
        apply(8'b00110010);   // 5,4,1     -> 5
        apply(8'b01010101);   // 6,4,2,0   -> 6
        apply(8'b10101010);   // 7,5,3,1   -> 7
        apply(8'b11111111);   // all       -> 7

        // Final change so EPWave shows the last segment
        apply(8'b00000000);

        if (errors == 0)
            $display("PASS: all priority encoder cases correct.");
        else
            $display("FAIL: %0d checks failed.", errors);

        $finish;
    end

endmodule