module UART_Input_Manager #
(
    CLOCK_RATE  = 100_000_000,
    BAUD_RATE   = 9600,
    DIGIT_COUNT = 4 // Result array size
)
(
    input clk, 
    input reset, 
    input RsRx,
    output reg [DIGIT_COUNT * 4 - 1 : 0] out, 
    output reg ready_out 
);

reg [1:0] cnt;

initial begin
    cnt = 0;
end

always@(posedge clk) begin


    if (cnt == (DIGIT_CONT - 1))
        ready_out <= 1;
    else
        ready_out <= 0;

    if (UART_RX_Ready_Out) begin
        out[3+cnt*4:cnt*4] <= UART_RX_Data_Out_hex;
        cnt <= cnt + 1;
    end

end


wire UART_RX_Ready_Out, UART_RX_Data_Out;
UART_RX #(.CLOCK_RATE(CLOCK_RATE), .BAUD_RATE(BAUD_RATE)) uart_rx
(
    .clk               (clki             ), 
    .rx                (RsRx             ), 
    .UART_RX_Ready_Out (UART_RX_Ready_Out), 
    .UART_RX_Data_Out  (UART_RX_Data_Out ) 
);

wire [3:0] UART_RX_Data_Out_hex;
ASCII_To_HEX AtH(.ASCII_in(UART_RX_Data_Out), .HEX_OUT(UART_RX_Data_Out_hex));

endmodule
