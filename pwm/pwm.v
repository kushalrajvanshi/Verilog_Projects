
// Variable duty cycle PWM generator
// Period     = 2^WIDTH clock cycles
// Duty cycle = duty / 2^WIDTH   (duty = 0 -> always low)
module pwm_generator #(
    parameter WIDTH = 8
)(
    input  wire             clk,
    input  wire             rst,      // synchronous, active high
    input  wire [WIDTH-1:0] duty,     // compare value
    output reg              pwm_out
);
    reg [WIDTH-1:0] cnt;
    reg [WIDTH-1:0] duty_reg;         // duty latched once per period

    always @(posedge clk) begin
        if (rst) begin
            cnt      <= {WIDTH{1'b0}};
            duty_reg <= duty;
            pwm_out  <= 1'b0;
        end else begin
            cnt <= cnt + 1'b1;                    // wraps at 2^WIDTH
            if (cnt == {WIDTH{1'b1}})
                duty_reg <= duty;                 // update only at period end -> no glitches
            pwm_out <= (cnt < duty_reg);
        end
    end
endmodule