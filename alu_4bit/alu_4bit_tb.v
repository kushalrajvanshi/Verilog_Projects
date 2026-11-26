`timescale 1ns/1ps

module tb_alu4;

    reg  [3:0] A, B;
    reg  [2:0] op;
    wire [3:0] result;
    wire       zero, carry, overflow;
    integer    errors;

    alu4 dut (
        .A(A), .B(B), .op(op),
        .result(result), .zero(zero), .carry(carry), .overflow(overflow)
    );

    // Apply one vector, wait, then compare with the expected result and flags
    task apply(input [3:0] a_in, input [3:0] b_in, input [2:0] op_in,
               input [3:0] exp_r, input exp_z, input exp_c, input exp_v);
        begin
            A = a_in; B = b_in; op = op_in;
            #10;
            if ((result !== exp_r) || (zero !== exp_z) ||
                (carry !== exp_c) || (overflow !== exp_v)) begin
                errors = errors + 1;
                $display("FAIL: A=%0d B=%0d op=%b -> result=%b Z=%b C=%b V=%b (expected %b Z=%b C=%b V=%b)",
                         a_in, b_in, op_in, result, zero, carry, overflow,
                         exp_r, exp_z, exp_c, exp_v);
            end
        end
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_alu4);
        $monitor("A=%04b B=%04b op=%03b result=%04b Z=%b C=%b V=%b",
                  A, B, op, result, zero, carry, overflow);

        errors = 0;

        //     A   B   op       result  Z  C  V
        apply( 4,  3, 3'b000, 4'b0111, 0, 0, 0);   // ADD   4+3 = 7
        apply( 4,  3, 3'b001, 4'b0001, 0, 0, 0);   // SUB   4-3 = 1
        apply( 4,  3, 3'b010, 4'b0000, 1, 0, 0);   // AND   0100 & 0011 = 0
        apply( 4,  3, 3'b011, 4'b0111, 0, 0, 0);   // OR
        apply( 4,  3, 3'b100, 4'b0111, 0, 0, 0);   // XOR
        apply( 4,  3, 3'b101, 4'b1011, 0, 0, 0);   // NOT A
        apply( 4,  3, 3'b110, 4'b1000, 0, 0, 0);   // A*2
        apply( 4,  3, 3'b111, 4'b0010, 0, 0, 0);   // A/2

        // Flag examples
        apply(15,  1, 3'b000, 4'b0000, 1, 1, 0);   // ADD  15+1 : carry and zero
        apply( 7,  1, 3'b000, 4'b1000, 0, 0, 1);   // ADD  7+1  : signed overflow
        apply( 3,  5, 3'b001, 4'b1110, 0, 1, 0);   // SUB  3-5  : borrow
        apply( 5,  5, 3'b001, 4'b0000, 1, 0, 0);   // SUB  5-5  : zero
        apply( 8,  1, 3'b001, 4'b0111, 0, 0, 1);   // SUB  -8-1 : signed overflow
        apply( 9,  0, 3'b110, 4'b0010, 0, 1, 0);   // A*2  1001 : bit shifted out
        apply( 9,  0, 3'b111, 4'b0100, 0, 1, 0);   // A/2  1001 : bit shifted out

        // Final change so EPWave shows the last segment
        A = 4'd0; B = 4'd0; op = 3'b000;
        #10;

        if (errors == 0)
            $display("PASS: all ALU cases correct.");
        else
            $display("FAIL: %0d ALU checks failed.", errors);

        $finish;
    end

endmodule