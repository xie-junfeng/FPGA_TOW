// FILE_HEADER--------------------------------------------------------------------------------------
// Copyright (c) 2020, Chengdu Mecs Technology Co,Inc.
// All rights reserved.
//--------------------------------------------------------------------------------------------------
// FILE NAME             : rx_sipo_1to4.v
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

module rx_sipo_1to2 #(
parameter integer         SIPOWD        = 4,
parameter integer         IODLYWD       = 9,
parameter real            REF_FREQ      = 200,
parameter                 IDELAYVAL     = 200,
parameter                 IDELAY_TYPE   = "VAR_LOAD"
) (
input                           datain_p,           //cha LVDS DatIn, from AdInterface
input                           datain_n,           //cha LVDS DatIn, from AdInterface

input                           iodelay_clk,        //clk_156_25m
input                           iodelay_rst,        //
input                           rx_dlyload,         //load
input       [IODLYWD-1:0]       rx_cntval,          //load_val

input                           clk1_io,            //clk_625m
input                           serdes_rst,         //rst_125m

output                          data_pos,
output                          data_neg,
output      [IODLYWD-1:0]       rx_cntvalo          //val_out
);

//--------------------------------------------------------------------------------
//-- Internal Signals
//--------------------------------------------------------------------------------
// --IBUFDS -> IDELAY ---> ISERDES(DATA)
wire datain_i;
wire datain_d;

//--------------------------------------------------------------------------------
//*****************************
//--------------------------------------------------------------------------------
//1. Data Input LVDS Buffer
    IBUFDS #(
      .DIFF_TERM("TRUE"),    // Differential Termination
      .IBUF_LOW_PWR("FALSE"),  // Low power="TRUE", Highest performance="FALSE" 
      .IOSTANDARD("LVDS")  // Specify the input I/O standard
   )  Uibufds (
        .I    (datain_p  ),
        .IB   (datain_n  ),
        .O    (datain_i  )
    );

(* IODELAY_GROUP = "IODELAY_GRP_ADC" *) // Specifies group name for associated IDELAYs/ODELAYs and IDELAYCTRL
 IDELAYE2 # (
     .CINVCTRL_SEL            ( "TRUE"                               ), // Enable dynamic clock inversion (FALSE, TRUE)
     .DELAY_SRC               ( "IDATAIN"                            ), // Delay input (IDATAIN, DATAIN)
     .HIGH_PERFORMANCE_MODE   ( "FALSE"                              ), // Reduced jitter ("TRUE"), Reduced power ("FALSE")
     .IDELAY_TYPE             ( IDELAY_TYPE                          ), // FIXED, VARIABLE, VAR_LOAD, VAR_LOAD_PIPE
     .IDELAY_VALUE            ( IDELAYVAL                            ), // Input delay tap setting (0-31)
     .PIPE_SEL                ( "FALSE"                              ), // Select pipelined mode, FALSE, TRUE
     .REFCLK_FREQUENCY        ( REF_FREQ                             ), // IDELAYCTRL clock input frequency in MHz (190.0-210.0, 290.0-310.0).
     .SIGNAL_PATTERN          ( "DATA"                               )  // DATA, CLOCK input signal
 ) IDELAYE2_inst (
     .CNTVALUEOUT             ( rx_cntvalo                           ), // 5-bit output: Counter value output
     .DATAOUT                 ( datain_d                             ), // 1-bit output: Delayed data output
     .C                       ( iodelay_clk                          ), // 1-bit input: Clock input
     .CE                      ( 1'b0                                 ), // 1-bit input: Active high enable increment/decrement input
     .CINVCTRL                ( 1'b0                                 ), // 1-bit input: Dynamic clock inversion input
     .CNTVALUEIN              ( rx_cntval                            ), // 5-bit input: Counter value input
     .DATAIN                  ( 1'b0                                 ), // 1-bit input: Internal delay data input
     .IDATAIN                 ( datain_i                             ), // 1-bit input: Data input from the I/O
     .INC                     ( 1'b0                                 ), // 1-bit input: Increment / Decrement tap delay input
     .LD                      ( rx_dlyload                           ), // 1-bit input: Load IDELAY_VALUE input
     .LDPIPEEN                ( 1'b0                                 ), // 1-bit input: Enable PIPELINE register to load data input
     .REGRST                  ( iodelay_rst                          )// 1-bit input: Active-high reset tap-delay input
 );

 IDDR #(
   .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" 
                                   //    or "SAME_EDGE_PIPELINED" 
   .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
   .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
   .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
) IDDR_inst (
   .Q1(data_pos), // 1-bit output for positive edge of clock
   .Q2(data_neg), // 1-bit output for negative edge of clock
   .C(clk1_io),   // 1-bit clock input
   .CE(1'b1), // 1-bit clock enable input
   .D(datain_d),   // 1-bit DDR data input
   .R(1'b0),   // 1-bit reset
   .S(1'b0)    // 1-bit set
);

endmodule

