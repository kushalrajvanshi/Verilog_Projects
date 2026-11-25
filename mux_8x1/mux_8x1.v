`timescale 1ns/1ps

// Behavioral 8-to-1 MUX
module mux8_behavioral (
    input  wire [7:0] d,
    input  wire [2:0] sel,
    output reg       y
);
    always @(*) begin
        case (sel)
            3'd0: y = d[0];
            3'd1: y = d[1];
            3'd2: y = d[2];
            3'd3: y = d[3];
            3'd4: y = d[4];
            3'd5: y = d[5];
            3'd6: y = d[6];
            3'd7: y = d[7];
            default: y = 1'bx;
        endcase
    end
endmodule

// 2-to-1 MUX
module mux2to1 (
    input  wire a, b, sel,
    output wire y
);
    assign y = sel ? b : a;
endmodule

// Hierarchical 8-to-1 MUX
module mux8_hierarchical (
    input  wire [7:0] d,
    input  wire [2:0] sel,
    output wire      y
);
    wire [3:0] s1;
    wire [1:0] s2;

    // First stage
    mux2to1 m0 (.a(d[0]), .b(d[1]), .sel(sel[0]), .y(s1[0]));
    mux2to1 m1 (.a(d[2]), .b(d[3]), .sel(sel[0]), .y(s1[1]));
    mux2to1 m2 (.a(d[4]), .b(d[5]), .sel(sel[0]), .y(s1[2]));
    mux2to1 m3 (.a(d[6]), .b(d[7]), .sel(sel[0]), .y(s1[3]));

    // Second stage
    mux2to1 m4 (.a(s1[0]), .b(s1[1]), .sel(sel[1]), .y(s2[0]));
    mux2to1 m5 (.a(s1[2]), .b(s1[3]), .sel(sel[1]), .y(s2[1]));

    // Third stage
    mux2to1 m6 (.a(s2[0]), .b(s2[1]), .sel(sel[2]), .y(y));
endmodule
