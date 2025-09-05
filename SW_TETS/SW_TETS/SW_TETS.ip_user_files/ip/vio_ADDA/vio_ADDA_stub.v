// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Wed Jun 18 15:13:26 2025
// Host        : xie running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/xie/Desktop/SW_TETS/SW_TETS/SW_TETS.gen/sources_1/ip/vio_ADDA/vio_ADDA_stub.v
// Design      : vio_ADDA
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tfbv484-3
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2023.2" *)
module vio_ADDA(clk, probe_out0, probe_out1)
/* synthesis syn_black_box black_box_pad_pin="probe_out0[0:0],probe_out1[15:0]" */
/* synthesis syn_force_seq_prim="clk" */;
  input clk /* synthesis syn_isclock = 1 */;
  output [0:0]probe_out0;
  output [15:0]probe_out1;
endmodule
