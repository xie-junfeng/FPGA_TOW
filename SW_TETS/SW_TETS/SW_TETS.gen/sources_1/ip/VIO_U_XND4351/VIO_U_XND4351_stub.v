// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Wed Jun 18 15:13:29 2025
// Host        : xie running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/xie/Desktop/SW_TETS/SW_TETS/SW_TETS.gen/sources_1/ip/VIO_U_XND4351/VIO_U_XND4351_stub.v
// Design      : VIO_U_XND4351
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tfbv484-3
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2023.2" *)
module VIO_U_XND4351(clk, probe_in0, probe_in1, probe_in2, probe_in3, 
  probe_out0, probe_out1, probe_out2)
/* synthesis syn_black_box black_box_pad_pin="probe_in0[0:0],probe_in1[0:0],probe_in2[31:0],probe_in3[7:0],probe_out0[0:0],probe_out1[7:0],probe_out2[31:0]" */
/* synthesis syn_force_seq_prim="clk" */;
  input clk /* synthesis syn_isclock = 1 */;
  input [0:0]probe_in0;
  input [0:0]probe_in1;
  input [31:0]probe_in2;
  input [7:0]probe_in3;
  output [0:0]probe_out0;
  output [7:0]probe_out1;
  output [31:0]probe_out2;
endmodule
