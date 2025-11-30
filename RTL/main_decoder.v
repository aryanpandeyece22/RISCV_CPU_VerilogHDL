
module main_decoder (
    input  [6:0] op,         // Opcode
    input        Zero,       // Zero flag
    input        LT,         // Less than (signed)
    input        LTU,        // Less than unsigned
    input  [2:0] funct3,     // funct3 for B-type instructions
    output [1:0] ResultSrc,  // Result selection signal
    output       MemWrite,   // Memory write enable
    output       Branch,     // Branch control
    output       ALUSrc,     // ALU source selection
    output       RegWrite,   // Register write enable
    output       Jump,       // Jump control signal
    output       jalr,       // JALR control signal
    output [2:0] ImmSrc,     // Immediate selection (extended to 3 bits for U-type)
    output [1:0] ALUOp       // ALU operation selection
);


reg [10:0] controls;     // Control bundle (removed Branch)
reg TakeBranch;          // Take branch control
reg takejalr;            // Take JALR control

always @(*) begin
    TakeBranch = 1'b0;   // Default value for TakeBranch
    takejalr = 1'b0;     // Default value for takejalr
                             // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_ALUOp_Jump
    casez (op)
        7'b0000011: controls = 11'b1______000______1______0_________01_____00____0;  // I-type: Load word
        7'b0100011: controls = 11'b0______001______1______1_________xx_____00____0;  // S-type: Store word
        7'b0110011: controls = 11'b1______000______0______0_________00_____10____0;  // R-type: ALU operations
        7'b0010011: controls = 11'b1______000______1______0_________00_____10____0;  // I-type: ALU operations
		  7'b0?10111: controls = 11'b1______100______0______0_________11_____00____0;  // U-type: LUI or AUIPC
		  7'b1100011: begin
                    controls = 11'b0______010______0______0_________xx_____01____0;          // B-type: Branch common controls
            case (funct3)
                3'b000: TakeBranch = Zero;         // beq: Branch if equal
                3'b001: TakeBranch = !Zero;        // bne: Branch if not equal
                3'b100: TakeBranch = LT;           // blt: Branch if less than (signed)
                3'b101: TakeBranch = !LT;          // bge: Branch if greater than or equal (signed)
                3'b110: TakeBranch = LTU;          // bltu: Branch if less than (unsigned)
                3'b111: TakeBranch = !LTU;         // bgeu: Branch if greater than or equal (unsigned)
                default: TakeBranch = 1'b0;        // Undefined case
            endcase
        end
       
        7'b110?111: begin
            controls =        {1'b1, 1'b0, op[3], op[3], 1'b1, 1'b0, 2'b10, 2'b00, op[3]};  // JAL/JALR: JAL (op[3] = 0), JALR (op[3] = 1)
            takejalr = ~op[3];  // Set takejalr for JALR (op[3] = 1)
        end
        
        default:    controls = 11'bx______xxx______x______x_________xx_____xx____x;  // Undefined case
    endcase
end

// Assign the control signals from the control register
assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUOp, Jump} = controls;
assign Branch = TakeBranch;  // Assign Branch signal from TakeBranch
assign jalr = takejalr;      // Assign jalr signal from takejalr

endmodule

