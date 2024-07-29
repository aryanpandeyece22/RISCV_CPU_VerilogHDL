
//// riscv_cpu.v - single-cycle RISC-V CPU Processor
//
//module riscv_cpu (
//    input clk, reset,
//    output [31:0] PC,
//    input  [31:0] Instr,
//    output MemWrite,
//    output [31:0] Mem_WrAddr, Mem_WrData,
//    input  [31:0] ReadData
//);
//
//// Uncomment the following lines if you are going to use module instantiation method
//
//// wire ALUSrc, RegWrite, Jump, Zero;
//// wire [1:0] ResultSrc, ImmSrc;
//// wire [2:0] ALUControl;
//
//// controller c (Instr[6:0], Instr[14:12], Instr[30], Zero,
////              ResultSrc, MemWrite, PCSrc,
////              ALUSrc, RegWrite, Jump, Op5, ImmSrc, ALUControl);
//
//// datapath dp (clk, reset, ResultSrc, PCSrc, Op5,
////              ALUSrc, RegWrite, ImmSrc, ALUControl,
////              Zero, PC, Instr, Mem_WrAddr, Mem_WrData, ReadData);
//
//endmodule


// riscv_cpu.v - single-cycle RISC-V CPU Processor

module riscv_cpu (
    input         clk, reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output        MemWrite,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
	 output flag
);

wire       ALUSrc, RegWrite, Zero, ALUR31,ltu,geu;
wire       PCSrc, Jalr, Jump, Op5;
wire [1:0] ResultSrc, ImmSrc, Store;
wire [3:0] ALUControl;
wire [2:0] Load;

controller  c  (Instr[6:0], Instr[14:12], Instr[30], Zero,ltu, geu, ALUR31,
                ResultSrc, MemWrite, PCSrc, Jalr, ALUSrc, RegWrite,
                Op5, ImmSrc, Store, Load, ALUControl);

datapath    dp (clk, reset, ResultSrc, PCSrc, Jalr, ALUSrc, RegWrite,
                Op5, ImmSrc, Store, Load, ALUControl, Zero,ltu, geu, ALUR31, PC,
                Instr, Mem_WrAddr, Mem_WrData, ReadData);
assign flag = ((Mem_WrAddr==32'h02000008) && MemWrite) ? 1 :0;

endmodule

