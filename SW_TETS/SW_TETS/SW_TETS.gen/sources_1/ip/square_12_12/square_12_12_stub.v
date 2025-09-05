// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Wed Jun 18 15:13:26 2025
// Host        : xie running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/xie/Desktop/SW_TETS/SW_TETS/SW_TETS.gen/sources_1/ip/square_12_12/square_12_12_stub.v
// Design      : square_12_12
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tfbv484-3
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_19,Vivado 2023.2" *)
module square_12_12(CLK, A, B, P)
/* synthesis syn_black_box black_box_pad_pin="A[11:0],B[11:0],P[23:0]" */
/* synthesis syn_force_seq_prim="CLK" */;
  input CLK /* synthesis syn_isclock = 1 */;
  input [11:0]A;
  input [11:0]B;
  output [23:0]P;
endmodule
