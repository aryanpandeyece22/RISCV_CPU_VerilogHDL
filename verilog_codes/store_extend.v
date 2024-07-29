
// store_extend.v - logic for extending the data and addr for storing word, half and byte

module store_extend (
	 input	[31:0] old_data,
	 input	[31:0] data_addr,
    input   [31:0] y,
    input   [1:0] sel,
    output reg [31:0] data
);

always @(*) begin
    case(sel)
        2'b10: data = y;
        2'b00: begin 
						case ({data_addr[1],data_addr[0]})
							2'b00: data = {old_data[31:8], y[7:0]};
							2'b01: data = {old_data[31:16], y[7:0],old_data[7:0]};
							2'b10: data = {old_data[31:24], y[7:0],old_data[15:0]};
							2'b11: data = {y[7:0],old_data[23:0]};
							default : data = {old_data[31:8], y[7:0]};
						endcase
					end//{{24{y[7]}},y[7:0]};//{24'b0, y[7:0]};
        2'b01: data = {16'b0, y[15:0]};//{{16{y[15]}},y[15:0]};//{16'b0, y[15:0]};
        default: data = y;
    endcase
end

endmodule
