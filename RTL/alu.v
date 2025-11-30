

module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    input       [3:0] alu_ctrl,         // ALU control
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output      zero, LT, LTU           // Zero flag, Less Than, Less Than Unsigned flag
);

// For add/sub logic
wire [WIDTH-1:0] bxorc = b ^ {WIDTH{alu_ctrl[0]}};  // XOR b with alu_ctrl[0] to prepare for add/sub
wire c = alu_ctrl[0];  // Control signal for addition or subtraction
wire [WIDTH:0] result = {1'b0, a} + {1'b1, bxorc} + c;  // Perform add/sub with carry-out
wire [4:0] b5 = b[4:0];

always @* begin
    casez (alu_ctrl)
        // ADD/SUB based on alu_ctrl[0]
        4'b000?:
            alu_out <= result[WIDTH-1:0];  // Take the lower part of the result for ALU output (ADD/SUB)
        

        // SLL (Shift Left Logical)
        4'b0011: alu_out <= a << b5;   // Shift left logical, using lower 5 bits of 'b' to specify shift amount
        
        // SLT (Set Less Than) - Signed comparison
        4'b0100: alu_out <= {31'b0, LT};   // Output the LT signal for signed comparison
        
        // SLTU (Set Less Than Unsigned)
        4'b0101: alu_out <= {31'b0, LTU};  // Output the LTU signal for unsigned comparison
        
        // XOR
        4'b0110: alu_out <= a ^ b;         // Perform bitwise XOR
        //SRA
        4'b0111: alu_out <= (a >> b5) | ({32{a[WIDTH-1]}} << (32 - b5));

        // SRL (Shift Right Logical)
        4'b1000: alu_out <= a >> b5;   // Logical shift right, using lower 5 bits of 'b'
		 
        
        // OR
        4'b1001: alu_out <= a | b;         // Perform bitwise OR
        
        // AND
        4'b1010: alu_out <= a & b;         // Perform bitwise AND
        
        // Default case
        default: alu_out <= 0;
    endcase
end

// Zero flag is asserted if alu_out is zero
assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

// Assign LT and LTU
assign LT = result[WIDTH-1]; // Most significant bit determines if signed a < b
assign LTU = result[WIDTH];  // Carry-out determines if unsigned a < b

endmodule

