`timescale 1ns / 1ps

module shift_reg(
        input clk,
        input reset,
        input enter,
        input [3:0] switches,
        output reg [7:0] MASK,
        output reg [31:0] NUMB
    );
    
    initial begin
        NUMB <= 0;
        MASK <= 8'b11111111;
    end

    always@(posedge clk) begin
        if (enter) begin
            NUMB <= {NUMB[27:0], switches};
            MASK <= MASK << 1;
        end
        else if (reset) begin
            NUMB <= 0;
            MASK <= 8'b11111111;
        end
        else begin
            NUMB <= NUMB;
        end
    end
endmodule
