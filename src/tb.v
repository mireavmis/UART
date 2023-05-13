`timescale 1ns / 1ps

module tb();

reg clk100mhz = 0;
reg rst_n = 1;
reg [7:0] data;
reg RsRx;
wire RsTx;
reg [7:0] symbols [0:3];


parameter BAUD_RATE = 9600;
parameter CLOCK_RATE = (1_000_000_000); // 100MHz clock

integer i;

// Generate 100MHz clock
always #5 clk100mhz = ~clk100mhz;
wire UART_RX_Ready_Out;
wire [7:0] UART_RX_Data_Out;
// Instantiate top module
UART UUT(
    .clk(clk100mhz),
    .RsRx(RsRx),
    .reset(1'b0),
    .RsTx(RsTx)
);

// Test sequence
initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    // 00110011
    // 11001100
    symbols[0] = 8'h30; // ASCII for '0'
    symbols[1] = 8'h31; // ASCII for '1'
    symbols[2] = 8'h42; // ASCII for 'B'
    symbols[3] = 8'h41; // ASCII for 'A'

    RsRx = 1;
    #1000;
    send_uart_packet(8'h41);
    #1000;
    send_uart_packet(8'h42);
    #1000;
    send_uart_packet(8'h31);
    #1000;
    send_uart_packet(8'h30);
    #10000000;
    
    /*RsRx=0;

    #(CLOCK_RATE / BAUD_RATE);
    RsRx=1;
    #(CLOCK_RATE / BAUD_RATE);
    RsRx=1;
    #(CLOCK_RATE / BAUD_RATE);
    RsRx=0;
    #(CLOCK_RATE / BAUD_RATE);
    RsRx=0;
    #(CLOCK_RATE / BAUD_RATE);
    RsRx=1;
    #(CLOCK_RATE / BAUD_RATE);
    RsRx=1;
    #(CLOCK_RATE / BAUD_RATE);
    RsRx=0;
    #(CLOCK_RATE / BAUD_RATE);
    RsRx=0;

    #(CLOCK_RATE / BAUD_RATE);
    RsRx=1;
    #100000;
*/
    $finish;
end
// Task to send UART packet
task send_uart_packet;
    input [7:0] data;
    integer i;
    begin
        RsRx = 0; // Start bit
        #(CLOCK_RATE / BAUD_RATE);
        for (i = 0; i < 8; i = i + 1) begin
            RsRx = data[i]; // Send data bits
            #(CLOCK_RATE / BAUD_RATE);
        end
        RsRx = 1; // Stop bit
        #(CLOCK_RATE / BAUD_RATE);
    end
endtask

endmodule

