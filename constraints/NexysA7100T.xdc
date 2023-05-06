## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_35 Sch=gclk[100]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }];


## USB-UART Interface
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { RsRx }]; #IO_L19N_T3_VREF_16 Sch=RsRx
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { RsTx }]; #IO_L14N_T2_SRCC_16 Sch=RsTx


