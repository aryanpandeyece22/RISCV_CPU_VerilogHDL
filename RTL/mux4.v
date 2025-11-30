
// mux4.v - logic for 4-to-1 multiplexer
//
//module mux4 #(parameter WIDTH = 8) (
//    input       [WIDTH-1:0] d0, d1, d2, d3,
//    input       [1:0] sel,
//    output      [WIDTH-1:0] y
//);
//
//assign y = sel[1] ? (sel[0] ? d3 : d2) : (sel[0] ? d1 : d0);
//
//endmodule
//
//// mux4.v - logic for 4-to-1 multiplexer with case statement and default

module mux4 #(parameter WIDTH = 8) (
    input       [WIDTH-1:0] d0, d1, d2, d3,
    input       [1:0] sel,
    output reg  [WIDTH-1:0] y   // reg type for y because we use it in always block
);

always @(*) begin
    case (sel)
        2'b00: y = d0;  // select d0 when sel is 00
        2'b01: y = d1;  // select d1 when sel is 01
        2'b10: y = d2;  // select d2 when sel is 10
        2'b11: y = d3;  // select d3 when sel is 11
        default: y = {WIDTH{1'bx}};  // Default case when sel is invalid
    endcase
end

endmodule
