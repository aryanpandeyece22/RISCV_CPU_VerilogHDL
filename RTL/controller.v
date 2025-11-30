
// controller.v - controller for RISC-V CPU

module controller (
    input [6:0]  op,
    input [2:0]  funct3,
    input        funct7b5,
    input        Zero, LT,LTU,
    output       [1:0] ResultSrc,
    output       MemWrite,
    output       PCSrc, ALUSrc,
    output       RegWrite, Jump,jalr,
    output [2:0] ImmSrc,
    output [3:0] ALUControl
);

wire [1:0] ALUOp;
wire       Branch;

main_decoder    md (op, Zero, LT, LTU,  funct3, ResultSrc, MemWrite, Branch,
                    ALUSrc, RegWrite, Jump, jalr, ImmSrc, ALUOp);

alu_decoder     ad (op[5], funct3, funct7b5, ALUOp, ALUControl);

// for jump and branch
assign PCSrc = Branch  | Jump;

endmodule

