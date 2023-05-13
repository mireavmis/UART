module UART_Output_Manager #
(
    parameter RESULT_SIZE = 4,
    parameter CLOCK_RATE = 100_000_000,
    parameter BAUD_RATE = 9600,
    parameter ASCII_SIZE = 8,
    parameter HEX_SIZE = 4,
    parameter ERROR_MSG_SIZE = 5
)
(
    input clk,
    input reset,
    input ready_in,
    input [RESULT_SIZE * HEX_SIZE-1:0] dataIn,
    input error_in,
    output RsTx
);

parameter RESET      = 0,
          READY_IN   = 1, // wait for input
          WAIT_TRANSMIT_D = 2,
          WAIT_ERROR = 3,
          TRANSMIT_D = 4, // transmit fsm's data
          ERROR      = 5; // transmit Error string

reg [ASCII_SIZE * ERROR_MSG_SIZE-1:0] error_msg = "Error";
reg [2:0] state;
reg [2:0] cnt;
reg [15:0] data_in;
reg UART_TX_Ready_In;
reg [7:0] UART_TX_Data_In;
wire uart_ready_in;
reg [7:0] package_error_msg; // letter to transmit
reg [3:0] package;
wire [7:0] package_out;

initial begin
    cnt = 0;
    state = RESET;
    package_error_msg = 0;
    package = 0;
    UART_TX_Ready_In = 0;
    UART_TX_Data_In = 0;
    data_in = 0;
end

always@(posedge clk) begin
    if (reset)
        state <= RESET;
    else begin
        case(state)
            RESET: begin
                cnt <= 0;
                state <= READY_IN;
            end
            READY_IN: begin
                if (ready_in) begin
                    if (error_in)
                        state <= WAIT_ERROR;
                    else
                        state <= WAIT_TRANSMIT_D;
                end
                else
                    state <= state;
            end
            WAIT_ERROR: begin
                state <= ERROR;
                UART_TX_Ready_In <= 1;
            end
            WAIT_TRANSMIT_D: begin
                state <= TRANSMIT_D;
                UART_TX_Ready_In <= 1;
            end
            TRANSMIT_D: begin
                if (uart_ready_in) begin
                    UART_TX_Data_In <= package_out;
                    if (cnt == RESULT_SIZE - 1) begin
                        UART_TX_Ready_In <= 0;
                        state <= RESET;
                    end
                    cnt <= cnt + 1;
                end
            end
            ERROR: begin
                if (cnt == ERROR_MSG_SIZE - 1) 
                    state <= RESET;
                else if (uart_ready_in) begin
                    UART_TX_Data_In <= package_error_msg;
                    cnt <= cnt + 1;
                end
            end
        endcase
    end

end

always@(posedge clk) begin
    case(cnt)
        0: package <= data_in[3:0];
        1: package <= data_in[7:4];
        2: package <= data_in[11:8];
        3: package <= data_in[15:12];
    endcase
    case(cnt)
        0: package_error_msg <= error_msg[7:0]; // E
        1: package_error_msg <= error_msg[15:8]; // r
        2: package_error_msg <= error_msg[23:16]; // r
        3: package_error_msg <= error_msg[31:24]; // o
        4: package_error_msg <= error_msg[39:32]; // r
    endcase
end

always@(posedge clk) begin
    if (ready_in)
        data_in = dataIn;

end

HEX_To_ASCII HtA(.hex_in(package), .ascii_out(package_out));


UART_TX #(.CLOCK_RATE(CLOCK_RATE), .BAUD_RATE(BAUD_RATE)) uart_tx
(
    .clk              (clk               ),
    .UART_TX_Ready_In (UART_TX_Ready_In  ),
    .UART_TX_Data_In  (UART_TX_Data_In   ),
    .idle             (uart_ready_in     ),
    .tx               (RsTx              )
);

endmodule

