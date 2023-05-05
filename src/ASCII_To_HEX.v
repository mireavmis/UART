module ASCII_To_HEX
(
    input [7:0] ASCII_in,
    output reg [3:0] HEX_out
);

always @* begin
    case (ASCII_in)
        8'h30: HEX_out = 4'h0;
        8'h31: HEX_out = 4'h1;
        8'h32: HEX_out = 4'h2;
        8'h33: HEX_out = 4'h3;
        8'h34: HEX_out = 4'h4;
        8'h35: HEX_out = 4'h5;
        8'h36: HEX_out = 4'h6;
        8'h37: HEX_out = 4'h7;
        8'h38: HEX_out = 4'h8;
        8'h39: HEX_out = 4'h9;
        8'h41: HEX_out = 4'ha; // A
        8'h42: HEX_out = 4'hb; // B
        8'h43: HEX_out = 4'hc; // C
        8'h44: HEX_out = 4'hd; // D
        8'h45: HEX_out = 4'he; // E
        8'h46: HEX_out = 4'hf; // F
        default: HEX_out = 4'h0; // Invalid input
    endcase
end

endmodule

