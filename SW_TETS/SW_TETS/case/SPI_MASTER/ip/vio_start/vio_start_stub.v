// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Wed Jan  8 13:58:50 2025
// Host        : DESKTOP-VP1BO8E running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/fpga_interface/test/UART/UART_MASTER_V0_1/UART_MASTER_V0_1/UART_INTERFACE.srcs/sources_1/ip/vio_start/vio_start_stub.v
// Design      : vio_start
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2019.1" *)
module vio_start(clk, probe_out0)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_out0[0:0]" */;
  input clk;
  output [0:0]probe_out0;
endmodule
