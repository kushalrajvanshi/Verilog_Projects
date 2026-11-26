// 8-to-3 Priority Encoder
// Input 7 = highest priority, input 0 = lowest priority
// valid = 1 when at least one input is active

module priority_encoder_8to3 (
    input  wire [7:0] in,     // request lines
    output reg  [2:0] y,      // binary code of highest-priority active input
    output reg valid   // high when any input is active
);

    always @(*) begin
        valid = 1'b1;
        casez (in)
            8'b1???????: y = 3'd7;
            8'b01??????: y = 3'd6;
            8'b001?????: y = 3'd5;
            8'b0001????: y = 3'd4;
            8'b00001???: y = 3'd3;
            8'b000001??: y = 3'd2;
            8'b0000001?: y = 3'd1;
            8'b00000001: y = 3'd0;
            default: begin       // no input active
                y     = 3'd0;
                valid = 1'b0;
            end
        endcase
    end

endmodule