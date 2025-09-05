// FILE_HEADER--------------------------------------------------------------------------------------
// Copyright (c) 2020, Chengdu Mecs Technology Co,Inc.
// All rights reserved.
//--------------------------------------------------------------------------------------------------
// FILE NAME             : rx_chx_1to4.v
// DEPARTMENT            : MECS-TECH PT&D
// CREATER               : wuxinjie
// CREATER'S EMAIL       : wuxinjie@mecs-tech.com
//--------------------------------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION               : DATE          : AUTHOR          : EMAIL
// 1.0                   : 2022-04-23    : wuxinjie    : wuxinjie@mecs-tech.com
//--------------------------------------------------------------------------------------------------
// KEYWORDS              :
//--------------------------------------------------------------------------------------------------
// PURPOSE               :
//--------------------------------------------------------------------------------------------------
// PARAM_NAME            : RANGE         : DESCRIPTION     : DEFAULT         : UNITS
// 
//--------------------------------------------------------------------------------------------------
// Reset Strategy        : synchronous
// Clock  Domains        : synchronous
// Simulation            : Questa Sim 10.6c
// Synthesis             : Vivado 2018.3
// Implementation        : Vivado 2018.3
// Other                 : 
//END_HEADER----------------------------------------------------------------------------------------


`timescale 1ps/10fs

module rx_chx_1to2 # (
      parameter integer LINES        = 12,       // Number of data lines 
      parameter integer SIPOWD       = 2,
      parameter integer IODLYWD      = 5,
      parameter real    REF_FREQ     = 300        // Reference clock frequency for idelay control
   ) (
      input                clk1_io,
//      input                clk1_r,
      input                tap_clk,
      input                serdes_rst,
      input  [LINES-1:0]   datain_p,             // Data input LVDS P-side
      input  [LINES-1:0]   datain_n,             // Data input LVDS N-side

      input                rx_dlyload,
      input  [IODLYWD-1:0] rx_cntval,

      output [LINES-1:0]   oData0,
      output [LINES-1:0]   oData1
   );

genvar             i;

wire    [IODLYWD-1:0]   rx_cntvalo  [LINES-1:0];
wire    [LINES*SIPOWD-1:0]          oData;

generate
   for (i = 0 ; i < LINES ; i = i+1) begin : rxd
      rx_sipo_1to2 # (
            .SIPOWD      (SIPOWD      ),   // 
            .IODLYWD     (IODLYWD     ),   // 
            .REF_FREQ    (REF_FREQ    ),   // 
            .IDELAYVAL   (  0         ),   // 320
            .IDELAY_TYPE ("VAR_LOAD"  )    // 
         )
         sipo
         (
            .datain_p     (datain_p[i]   ),
            .datain_n     (datain_n[i]   ),
            //
            .iodelay_clk  (tap_clk        ),
            .iodelay_rst  (1'b0           ),

            .rx_dlyload   (rx_dlyload     ),
            .rx_cntval    (rx_cntval      ),

            .clk1_io      (clk1_io       ),
            .serdes_rst   (serdes_rst    ),
            //
            .data_pos     (oData[LINES*1+i]),
            .data_neg     (oData[LINES*0+i]),
            .rx_cntvalo   (rx_cntvalo[i] )
         );
   end
endgenerate

assign oData0 = oData[023:012];
assign oData1 = oData[011:000];

endmodule
