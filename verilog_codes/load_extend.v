
// load_extend.v - logic for extending the data and addr for loading word, half and byte


module load_extend (
	 input [31:0] data_addr,
    input [31:0] y,
    input [ 2:0] sel,
    output reg [31:0] data
);

always @(*) begin
    case (sel)
    3'b000: begin
				case({data_addr[1],data_addr[0]})
					2'b00: data = {{24{y[7]}}, y[7:0]};
					2'b01: data = {{24{y[15]}}, y[15:8]};
					2'b10: data = {{24{y[23]}}, y[23:16]};
					2'b11: data = {{24{y[31]}}, y[31:24]};
					default: data = {{24{y[7]}}, y[7:0]};
				endcase
				end
    3'b001: data = {{16{y[15]}}, y[15:0]};
    3'b010: data = y;
    3'b011: begin
				case({data_addr[1],data_addr[0]})
					2'b00: data = {24'b0, y[7:0]};
					2'b01: data = {24'b0, y[15:8]};
					2'b10: data = {24'b0, y[23:16]};
					2'b11: data = {24'b0, y[31:24]};
					default: data = {24'b0, y[7:0]};
				endcase
				end
    3'b100: data = {16'b0, y[15:0]};
    default: data = y;
    endcase
end

endmodule
