
//module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
//    input       clk, wr_en,                // Clock and write enable
//    input [2:0] funct3,                    // funct3 to differentiate sb, sh, sw, and load instructions
//    input [ADDR_WIDTH-1:0] wr_addr,        // Write address
//    input [DATA_WIDTH-1:0] wr_data,        // Data to write
//    output reg [DATA_WIDTH-1:0] rd_data_mem // Data read from memory
//);
//
//// Array of 64 32-bit words (memory storage)
//reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];
//
//// Compute the word-aligned memory address
//wire [31:0] word_address = wr_addr[DATA_WIDTH-1:2] % 64;
//
//// Combinational read logic (load instructions)
//always @(*) begin
//    case (funct3)
//        3'b000: begin  // lb: Load byte (sign-extended)
//            case (wr_addr[1:0])
//                2'b00: rd_data_mem = {{24{data_ram[word_address][7]}}, data_ram[word_address][7:0]};   // Load byte from offset 0
//                2'b01: rd_data_mem = {{24{data_ram[word_address][15]}}, data_ram[word_address][15:8]};  // Load byte from offset 1
//                2'b10: rd_data_mem = {{24{data_ram[word_address][23]}}, data_ram[word_address][23:16]}; // Load byte from offset 2
//                2'b11: rd_data_mem = {{24{data_ram[word_address][31]}}, data_ram[word_address][31:24]}; // Load byte from offset 3
//            endcase
//        end
//
//        3'b001: begin  // lh: Load halfword (sign-extended)
//            case (wr_addr[1])
//                1'b0: rd_data_mem = {{16{data_ram[word_address][15]}}, data_ram[word_address][15:0]};   // Load halfword from offset 0
//                1'b1: rd_data_mem = {{16{data_ram[word_address][31]}}, data_ram[word_address][31:16]};  // Load halfword from offset 1
//            endcase
//        end
//
//        3'b010: begin  // lw: Load word (full 32-bit load)
//            rd_data_mem = data_ram[word_address];  // Load full word
//        end
//
//        3'b100: begin  // lbu: Load byte unsigned (zero-extended)
//            case (wr_addr[1:0])
//                2'b00: rd_data_mem = {24'b0, data_ram[word_address][7:0]};    // Load byte from offset 0
//                2'b01: rd_data_mem = {24'b0, data_ram[word_address][15:8]};   // Load byte from offset 1
//                2'b10: rd_data_mem = {24'b0, data_ram[word_address][23:16]};  // Load byte from offset 2
//                2'b11: rd_data_mem = {24'b0, data_ram[word_address][31:24]};  // Load byte from offset 3
//            endcase
//        end
//
//        3'b101: begin  // lhu: Load halfword unsigned (zero-extended)
//            case (wr_addr[1])
//                1'b0: rd_data_mem = {16'b0, data_ram[word_address][15:0]};    // Load halfword from offset 0
//                1'b1: rd_data_mem = {16'b0, data_ram[word_address][31:16]};   // Load halfword from offset 1
//            endcase
//        end
//
//        default: rd_data_mem = 32'b0; // Default case (undefined load instruction)
//    endcase
//end
//
//// Synchronous write logic (store instructions)
//always @(posedge clk) begin
//    if (wr_en) begin
//        case (funct3)
//            3'b000: begin  // sb: Store byte
//                case (wr_addr[1:0])
//                    2'b00: data_ram[word_address][7:0]   <= wr_data[7:0];   // Store byte at offset 0
//                    2'b01: data_ram[word_address][15:8]  <= wr_data[7:0];   // Store byte at offset 1
//                    2'b10: data_ram[word_address][23:16] <= wr_data[7:0];   // Store byte at offset 2
//                    2'b11: data_ram[word_address][31:24] <= wr_data[7:0];   // Store byte at offset 3
//                endcase
//            end
//
//            3'b001: begin  // sh: Store halfword
//                case (wr_addr[1])
//                    1'b0: data_ram[word_address][15:0]  <= wr_data[15:0];  // Store halfword at offset 0
//                    1'b1: data_ram[word_address][31:16] <= wr_data[15:0];  // Store halfword at offset 1
//                endcase
//            end
//
//            3'b010: begin  // sw: Store word
//                data_ram[word_address] <= wr_data;  // Store full word
//            end
//
//            default: ; // Undefined funct3 for other operations
//        endcase
//    end
//end
//
//endmodule


module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
    input       clk, wr_en,
    input [2:0] funct3,
    input [ADDR_WIDTH-1:0] wr_addr,
    input [DATA_WIDTH-1:0] wr_data,
    output reg [DATA_WIDTH-1:0] rd_data_mem
);

// Memory storage
reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];

// Word address calculation (simplified)
wire [5:0] word_address = wr_addr[7:2];  // Direct 6-bit addressing for 64 words
wire [1:0] byte_offset = wr_addr[1:0];   // Byte offset within word
wire byte_access = funct3[1:0] == 2'b00; // True for lb/lbu
wire half_access = funct3[1:0] == 2'b01; // True for lh/lhu
wire unsigned_access = funct3[2];        // True for lbu/lhu

// Read word from memory
wire [31:0] word_data = data_ram[word_address];

// Extracted data based on size
wire [7:0] byte_data = byte_offset[1] ? 
                       (byte_offset[0] ? word_data[31:24] : word_data[23:16]) :
                       (byte_offset[0] ? word_data[15:8]  : word_data[7:0]);

wire [15:0] half_data = wr_addr[1] ? word_data[31:16] : word_data[15:0];

// Sign extension bits
wire sign_bit_byte = byte_data[7] & !unsigned_access;
wire sign_bit_half = half_data[15] & !unsigned_access;

// Simplified read logic
always @(*) begin
    if (byte_access)
        rd_data_mem = {{24{sign_bit_byte}}, byte_data};
    else if (half_access)
        rd_data_mem = {{16{sign_bit_half}}, half_data};
    else
        rd_data_mem = word_data;
end

// Simplified write logic
always @(posedge clk) begin
    if (wr_en) begin
        case (funct3[1:0])
            2'b00: begin // Store byte
                case (byte_offset)
                    2'b00: data_ram[word_address][7:0]   <= wr_data[7:0];
                    2'b01: data_ram[word_address][15:8]  <= wr_data[7:0];
                    2'b10: data_ram[word_address][23:16] <= wr_data[7:0];
                    2'b11: data_ram[word_address][31:24] <= wr_data[7:0];
                endcase
            end
            2'b01: begin // Store halfword
                if (wr_addr[1])
                    data_ram[word_address][31:16] <= wr_data[15:0];
                else
                    data_ram[word_address][15:0]  <= wr_data[15:0];
            end
            2'b10: data_ram[word_address] <= wr_data; // Store word
            default: ; // No operation
        endcase
    end
end

endmodule
