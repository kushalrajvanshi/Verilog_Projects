module half_adder (
    input  wire a, b,
    output wire sum, carry
);
    xor (sum, a, b);
    and (carry, a, b);
endmodule

module full_adder (
    input  wire a, b, cin,
    output wire sum, cout
);
    wire s1, c1, c2;

    half_adder ha1 (.a(a),  .b(b),   .sum(s1),  .carry(c1));
    half_adder ha2 (.a(s1), .b(cin), .sum(sum), .carry(c2));

    or (cout, c1, c2);
endmodule

module ripple_carry_adder_4bit (
    input  wire [3:0] a, b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout, overflow
);
    wire [4:0] c;

    assign c[0] = cin;

    full_adder fa0 (
        .a(a[0]), .b(b[0]), .cin(c[0]),
        .sum(sum[0]), .cout(c[1])
    );

    full_adder fa1 (
        .a(a[1]), .b(b[1]), .cin(c[1]),
        .sum(sum[1]), .cout(c[2])
    );

    full_adder fa2 (
        .a(a[2]), .b(b[2]), .cin(c[2]),
        .sum(sum[2]), .cout(c[3])
    );

    full_adder fa3 (
        .a(a[3]), .b(b[3]), .cin(c[3]),
        .sum(sum[3]), .cout(c[4])
    );

    assign cout = c[4];

    // Signed overflow: carry into MSB XOR carry out.
    xor (overflow, c[3], c[4]);
endmodule