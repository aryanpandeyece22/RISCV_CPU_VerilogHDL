

module alu_decoder (
    input            opb5,        // Bit 5 of the opcode (R-type or I-type)
    input [2:0]      funct3,      // funct3 field from the instruction
    input            funct7b5,    // Bit 5 of the funct7 field
    input [1:0]      ALUOp,       // ALU operation signal
    output reg [3:0] ALUControl   // ALU control signal (4-bit)
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 4'b0000;             // Addition for lw/sw (I-type load/store)
        2'b01: ALUControl = 4'b0001;             // Subtraction for branch comparison
        default: begin
            case (funct3)
                3'b000: begin
                    if (funct7b5 & opb5) ALUControl = 4'b0001;  // sub
                    else ALUControl = 4'b0000;                   // add
                end
                3'b001: ALUControl = 4'b0011;                    // sll (Shift left logical)
                3'b010: ALUControl = 4'b0100;                    // slt (Set less than)
                3'b011: ALUControl = 4'b0101;                    // sltu (Set less than unsigned)
                3'b100: ALUControl = 4'b0110;                    // xor
                3'b101: begin
                    if (funct7b5) ALUControl = 4'b0111;          // sra (Shift right arithmetic)
                    else ALUControl = 4'b1000;                   // srl (Shift right logical)
                end
                3'b110: ALUControl = 4'b1001;                    // or
                3'b111: ALUControl = 4'b1010;                    // and
                default: ALUControl = 4'bxxxx;                   // Undefined case
            endcase
        end
    endcase
end

endmodule





