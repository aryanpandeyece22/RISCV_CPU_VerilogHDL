
// instr_mem.v - instruction memory

module instr_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 512) (
    input       [ADDR_WIDTH-1:0] instr_addr,
    output      [DATA_WIDTH-1:0] instr
);

// array of 64 32-bit words or instructions
reg [DATA_WIDTH-1:0] instr_ram [0:MEM_SIZE-1];          //512 words can be stored

initial begin
   // $readmemh("rv32i_book.hex", instr_ram);
    $readmemh("program.hex", instr_ram);
end

// word-aligned memory access
// combinational read logic
assign instr = instr_ram[instr_addr[31:2]];

endmodule

