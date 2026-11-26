module alu4 (
    input [3:0] A, B,
    input [2:0] op,
    output reg [3:0] result,
    output zero,
    output reg carry, overflow
);

    always @(*) begin
        result = 0;
        carry = 0;
        overflow = 0;

        case (op)
            3'b000: begin // ADD
                {carry, result} = A + B;
                overflow = (A[3] == B[3]) &&
                           (result[3] != A[3]);
            end

            3'b001: begin // SUB
                result = A - B;
                carry = (A >= B);
                overflow = (A[3] != B[3]) &&
                           (result[3] != A[3]);
            end

            3'b010: result = A & B; // AND
            3'b011: result = A | B; // OR
            3'b100: result = A ^ B; // XOR
            3'b101: result = ~A;    // NOT A

            3'b110: begin
                result = A * 2;
                carry = A[3];
            end

            3'b111: begin
                result = A / 2;
                carry = A[0];
            end
        endcase
    end

    assign zero = (result == 0);

endmodule