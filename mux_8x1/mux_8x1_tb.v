`timescale 1ns/1ps

module tb_mux_waves;
    reg  [7:0] d;
    reg  [2:0] sel;
    wire y_beh, y_hier;
    integer j;

    mux8_behavioral   dut1 (.d(d), .sel(sel), .y(y_beh));
    mux8_hierarchical dut2 (.d(d), .sel(sel), .y(y_hier));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_mux_waves);

        $monitor("t=%0t d=%b sel=%d y_beh=%b y_hier=%b",
                 $time, d, sel, y_beh, y_hier);

        // Pattern 1: sweep sel 0..7  -> y = 0,0,1,0,1,1,0,1
        d = 8'b10110100;
        for (j = 0; j < 8; j = j + 1) begin
            sel = j;
            #10;
        end

        // Pattern 2: inverted data, sweep again -> y = 1,1,0,1,0,0,1,0
        d = 8'b01001011;
        for (j = 0; j < 8; j = j + 1) begin
            sel = j;
            #10;
        end

        // Final change so EPWave shows the last segment
        d = 8'h00;
        #10;

        $finish;
    end
endmodule