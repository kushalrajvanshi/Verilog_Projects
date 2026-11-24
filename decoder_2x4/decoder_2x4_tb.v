`timescale 1ns/1ps

module tb_decoder;
    reg  [1:0] a;
    reg        en;
    wire [3:0] y_dataflow, y_behavioral;
    reg  [3:0] expected;

    integer i, errors;

    decoder_2to4_dataflow dut_df (
        .a(a), .en(en), .y(y_dataflow)
    );

    decoder_2to4_behavioral dut_bh (
        .a(a), .en(en), .y(y_behavioral)
    );

    initial begin
        // Waveform generation
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_decoder);

        $timeformat(-9, 0, " ns", 0);
        $monitor("t=%0t | en=%b a=%b | dataflow=%b behavioral=%b",
                 $time, en, a, y_dataflow, y_behavioral);

        errors = 0;

        // {en, a} runs from 000 to 111.
        for (i = 0; i < 8; i = i + 1) begin
            {en, a} = i[2:0];
            #10;

            expected = en ? (4'b0001 << a) : 4'b0000;

            if ((y_dataflow !== expected) ||
                (y_behavioral !== expected)) begin
                errors = errors + 1;
                $display("FAIL: en=%b a=%b expected=%b dataflow=%b behavioral=%b",
                         en, a, expected, y_dataflow, y_behavioral);
            end
        end

        // Check enable changing from 1 to 0.
        en = 0;
        #10;

        if ((y_dataflow !== 4'b0000) ||
            (y_behavioral !== 4'b0000)) begin
            errors = errors + 1;
            $display("FAIL: outputs not 0000 after enable goes low");
        end

        // Final change so the disable segment is drawn in EPWave (ends at 90ns)
        a = 2'b00;
        #10;

        if (errors == 0)
            $display("PASS: Both decoder models passed all inputs and disable check.");
        else
            $display("FAIL: %0d decoder checks failed.", errors);

        $finish;
    end
endmodule