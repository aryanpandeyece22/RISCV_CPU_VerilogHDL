
// t1c_riscv_cpu.v - Top Module to test riscv_cpu

module t1c_riscv_cpu (
    input         clk, reset,
    input         Ext_MemWrite,
    input  [31:0] Ext_WriteData, Ext_DataAdr,
    output        MemWrite,
    output [31:0] WriteData, DataAdr, ReadData,
    output [31:0] PC, Result
);

wire [31:0] Instr;
wire [31:0] DataAdr_rv32, WriteData_rv32;
wire        MemWrite_rv32;

// instantiate processor and memories
riscv_cpu rvcpu    (clk, reset, PC, Instr,
                    MemWrite_rv32, DataAdr_rv32,
                    WriteData_rv32, ReadData, Result);
instr_mem instrmem (PC, Instr);

wire [2:0] Store;
// data_mem dmem (clk, MemWrite, Instr[14:12], DataAdr, WriteData, ReadData);
data_mem dmem (clk, MemWrite, Store, DataAdr, WriteData, ReadData);

// output assignments
// default sw, lw while reset
assign Store = (Ext_MemWrite && reset) ? 3'b010 : Instr[14:12];

assign MemWrite  = (Ext_MemWrite && reset) ? 1 : MemWrite_rv32;
assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteData_rv32;
assign DataAdr   = reset ? Ext_DataAdr : DataAdr_rv32;

endmodule

