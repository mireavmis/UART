module UART_Input_Manager #
(
    parameter CLOCK_RATE  = 100_000_000,
    parameter BAUD_RATE   = 9600,
    parameter DIGIT_COUNT = 4 // Result array size
)
(
    input clk, 
    input reset, 
    input RsRx,
    output reg [DIGIT_COUNT * 4 - 1 : 0] out, 
    output reg ready_out 
);

reg [1:0] cnt;
wire UART_RX_Ready_Out;
wire [7:0] UART_RX_Data_Out;
wire [3:0] UART_RX_Data_Out_hex;
initial begin
    cnt = 0;
    ready_out = 0;
    out = 0;
end

always@(posedge clk) begin

    if (ready_out)
        ready_out <= 0;

    if (UART_RX_Ready_Out) begin

        case(cnt)
        0: out[3:0] <= UART_RX_Data_Out_hex;
        1: out[7:4] <= UART_RX_Data_Out_hex;
        2: out[11:8] <= UART_RX_Data_Out_hex;
        3: out[15:12] <= UART_RX_Data_Out_hex;
        endcase
        if (cnt == (DIGIT_COUNT - 1))
            ready_out <= 1;
        cnt <= cnt + 1;
    end
end



UART_RX #(.CLOCK_RATE(CLOCK_RATE), .BAUD_RATE(BAUD_RATE)) uart_rx
(
    .clk               (clk              ), 
    .rx                (RsRx             ), 
    .UART_RX_Ready_Out (UART_RX_Ready_Out), 
    .UART_RX_Data_Out  (UART_RX_Data_Out ) 
);


ASCII_To_HEX AtH(.ASCII_in(UART_RX_Data_Out), .HEX_out(UART_RX_Data_Out_hex));

endmodule
