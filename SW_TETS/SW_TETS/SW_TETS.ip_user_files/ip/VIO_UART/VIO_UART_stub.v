// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Wed Jun 18 15:13:36 2025
// Host        : xie running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/xie/Desktop/SW_TETS/SW_TETS/SW_TETS.gen/sources_1/ip/VIO_UART/VIO_UART_stub.v
// Design      : VIO_UART
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tfbv484-3
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2023.2" *)
module VIO_UART(clk, probe_in0, probe_in1, probe_in2, probe_in3, 
  probe_in4, probe_in5, probe_in6, probe_in7, probe_in8, probe_in9, probe_in10, probe_in11, 
  probe_in12, probe_out0, probe_out1, probe_out2, probe_out3, probe_out4, probe_out5, probe_out6, 
  probe_out7, probe_out8, probe_out9, probe_out10, probe_out11)
/* synthesis syn_black_box black_box_pad_pin="probe_in0[7:0],probe_in1[0:0],probe_in2[7:0],probe_in3[7:0],probe_in4[31:0],probe_in5[0:0],probe_in6[1:0],probe_in7[0:0],probe_in8[0:0],probe_in9[31:0],probe_in10[7:0],probe_in11[0:0],probe_in12[31:0],probe_out0[7:0],probe_out1[0:0],probe_out2[7:0],probe_out3[7:0],probe_out4[0:0],probe_out5[0:0],probe_out6[31:0],probe_out7[7:0],probe_out8[1:0],probe_out9[0:0],probe_out10[7:0],probe_out11[0:0]" */
/* synthesis syn_force_seq_prim="clk" */;
  input clk /* synthesis syn_isclock = 1 */;
  input [7:0]probe_in0;
  input [0:0]probe_in1;
  input [7:0]probe_in2;
  input [7:0]probe_in3;
  input [31:0]probe_in4;
  input [0:0]probe_in5;
  input [1:0]probe_in6;
  input [0:0]probe_in7;
  input [0:0]probe_in8;
  input [31:0]probe_in9;
  input [7:0]probe_in10;
  input [0:0]probe_in11;
  input [31:0]probe_in12;
  output [7:0]probe_out0;
  output [0:0]probe_out1;
  output [7:0]probe_out2;
  output [7:0]probe_out3;
  output [0:0]probe_out4;
  output [0:0]probe_out5;
  output [31:0]probe_out6;
  output [7:0]probe_out7;
  output [1:0]probe_out8;
  output [0:0]probe_out9;
  output [7:0]probe_out10;
  output [0:0]probe_out11;
endmodule
