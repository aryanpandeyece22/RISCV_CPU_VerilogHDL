`timescale 1 ns/1 ns

module tb;

reg clk, reset, Ext_MemWrite;
reg [31:0] Ext_WriteData, Ext_DataAdr;

wire [31:0] WriteData, DataAdr, ReadData, PC, Result;
wire MemWrite;

reg [4:0] SP = 0, EP = 0;

integer error_count = 0, i = 0;
integer fw = 0, fd = 0, num_values = 16;
reg [4:0] register_array [0:15];
integer value = 0;

integer data_1 = 0, data_2 = 0, data_3, cpu_data = 0;
reg flag = 0;

t1c_riscv_cpu uut (clk, reset, Ext_MemWrite, Ext_WriteData, Ext_DataAdr, MemWrite, WriteData, DataAdr, ReadData, PC, Result);

initial begin
    for (i = 0; i < 16; i = i + 1'b1) begin
        register_array[i] = 0;
    end
end

always begin
    clk <= 1; # 5; clk <= 0; # 5;
end

// For Sum of Natural Number - t2b_ex1.c
// initial begin
//     reset = 1;

//     // set N variable as ten in the memory address 02000000
//     Ext_MemWrite = 1; Ext_WriteData = 15; Ext_DataAdr = 32'h02000000;
//     data_2 = Ext_WriteData; #8;
//     Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h02000000; #11;

//     // Write Sum as 0 in the memory address 02000004
//     Ext_MemWrite = 1; Ext_WriteData = 00; Ext_DataAdr = 32'h02000004;
//     data_1 = Ext_WriteData; #8;
//     // compute cpu_data
//     for (i = 1; i <= data_2; i = i + 1'b1) begin
//         cpu_data = cpu_data + i;
//     end
//     Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h02000004; #12;

//     // Write CPU_Done as 0 in the memory address 02000008
//     Ext_MemWrite = 1; Ext_WriteData = 00; Ext_DataAdr = 32'h02000008; #8;
//     Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #11;

//     Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #12;

//     reset = 0;
//     // External Memory Access Disabled
//     Ext_MemWrite = 0; Ext_WriteData = 0; Ext_DataAdr = 0;
// end

// always @(negedge clk) begin
//     if(MemWrite && !reset) begin
//         if (DataAdr === 32'h02000004 & WriteData === cpu_data) flag = 1;
//         if(flag === 1 & DataAdr === 32'h02000008 & WriteData === 1) begin
//             $display("Simulation succeeded");
//             $stop;
//         end
//     end
// end

// //

// For Arithmetic Progression - t2b_ex2.c
// initial begin
//     reset = 1;

//     // Write A in the memory address 02000000
//     Ext_MemWrite = 1; Ext_WriteData = 05; Ext_DataAdr = 32'h02000000;
//     data_1 = Ext_WriteData; #8;
//     Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #11;

//     // Write D in the memory address 02000004
//     Ext_MemWrite = 1; Ext_WriteData = 06; Ext_DataAdr = 32'h02000004;
//     data_2 = Ext_WriteData; #8;
//     Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h4; #12;

//     // Write N in the memory address 02000008
//     Ext_MemWrite = 1; Ext_WriteData = 15; Ext_DataAdr = 32'h02000008;
//     data_3 = Ext_WriteData; #8;
//     Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h8; #11;

//     // Write CPU_DATA as 0 in the memory address 0200000c
//     Ext_MemWrite = 1; Ext_WriteData = 00; Ext_DataAdr = 32'h0200000c;
//     cpu_data = Ext_WriteData; #8;
//     // compute a_n
//     for (i = 0; i < data_3; i = i + 1'b1) begin
//         cpu_data = data_1 + i * data_2;
//     end
//     Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #12;

//     Ext_MemWrite = 1; Ext_WriteData = 00; Ext_DataAdr = 32'h02000010;
//     data_2 = Ext_WriteData; #8;
//     Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #12;

//     reset = 0;
//     // External Memory Access Disabled
//     Ext_MemWrite = 0; Ext_WriteData = 0; Ext_DataAdr = 0;
// end

// always @(negedge clk) begin
//     if(MemWrite && !reset) begin
//         if (DataAdr === 32'h0200000c & WriteData === cpu_data) flag = 1;
//         if(flag === 1 & DataAdr === 32'h02000010 & WriteData === 1) begin
//             $display("Simulation succeeded");
//             $stop;
//         end
//     end
// end

// //

// For path planning algorithm - path_planner.c
initial begin
    i = 0;
    fd = $fopen("dump_txt.txt", "r");
    while (!$feof(fd) && i < num_values) begin
        if ($fscanf(fd, "%d", value) == 1) register_array[i] = value;
        else begin
            EP = value; num_values = 16;
        end
        i = i + 1;
    end
    $fclose(fd);
    SP = register_array[0];

    reset = 1;

    // write START_POINT variable in the memory address 02000000
    Ext_MemWrite = 1; Ext_WriteData = SP; Ext_DataAdr = 32'h02000000; #8;
    Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #11;

    // write END_POINT in the memory address 02000004
    Ext_MemWrite = 1; Ext_WriteData = EP; Ext_DataAdr = 32'h02000004; #8;
    Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #12;

    // write NODE_POINT as 00 in the memory address 02000008
    Ext_MemWrite = 1; Ext_WriteData = 00; Ext_DataAdr = 32'h02000008; #8;
    Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #11;

    // write NODE_POINT as 00 in the memory address 0200000c
    Ext_MemWrite = 1; Ext_WriteData = 00; Ext_DataAdr = 32'h0200000c; #8;
    Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #12;

    reset = 0;
    // External Memory Access Disabled
    Ext_MemWrite = 0; Ext_WriteData = 0; Ext_DataAdr = 0;
    i = 0;
end

always @(negedge clk) begin
    if(MemWrite && !reset) begin
        if (DataAdr === 32'h02000008) begin
            $display("Expected NODE POINT = %d, Actual NODE POINT = %d", register_array[i], WriteData);
            if (register_array[i] != WriteData || WriteData[0] === 1'bx) begin
                error_count = error_count + 1'b1;
                $display("Error Count  %d -> Mismatch in Node Points, Check your design.\n", error_count);
            end
            else $display("No Error in this Node Point.\n");
            i = i + 1'b1;
        end
        if (DataAdr === 32'h0200000c & WriteData === 32'h1) begin
            fw = $fopen("results.txt","w");
            if (error_count === 0 && i != 0) begin
                $fdisplay(fw, "%02h", "No Errors");
                $display("No errors encountered, congratulations!");
            end
            else begin
                $fdisplay(fw, "%02h", "Errors");
                $display("Error(s) encountered, please check your design!");
            end
            $fclose(fw);
            $stop;
        end
    end
end

endmodule
