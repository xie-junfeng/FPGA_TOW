// FILE_HEADER--------------------------------------------------------------------------------------
// Copyright (c) 2020, Chengdu Mecs Technology Co,Inc.
// All rights reserved.
//--------------------------------------------------------------------------------------------------
// FILE NAME             : rx_chipx.v
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

module ms12dl3200_intf_v1p0 #(
      parameter integer LINES        = 12, // Number of data lines
      parameter integer IODLYWD      = 5,
      parameter integer SIPOWD       = 2,
      parameter real    REF_FREQ     = 200 //300.0
)(
    input                                      clk1_io                               ,
    input                                      tap_clk                               ,
    input                                      tap_rst                               ,
    input                                      serdes_rst                            ,                 // reset (active high)

    input                                      adc_idelay_load                       ,
    input  [IODLYWD-1:0]                       adc_idelay_a_tap                      ,
    input  [IODLYWD-1:0]                       adc_idelay_b_tap                      ,


    // Receivers                                                                     
    input  [LINES-1:0]                         datain1_p                             ,// A channel
    input  [LINES-1:0]                         datain1_n                             ,
    input  [LINES-1:0]                         datain2_p                             ,// B channel
    input  [LINES-1:0]                         datain2_n                             ,

                                                                                     
    output [LINES-1:0]                         oAData0                               ,
    output [LINES-1:0]                         oAData1                               ,
                                                                                
    output [LINES-1:0]                         oBData0                               ,
    output [LINES-1:0]                         oBData1                               
                                                                                

                                                     
) ;
//===============================================================================
// Internal Signals
//===============================================================================

    reg   [IODLYWD-1:0]                        rx_acnt_val                           ;                                                                              
    reg   [IODLYWD-1:0]                        rx_bcnt_val                           ;                                                                                



    wire  [LINES-1:0]                          Ad1Data0                              ;
    wire  [LINES-1:0]                          Ad1Data1                              ;

    wire  [LINES-1:0]                          Ad2Data0                              ;
    wire  [LINES-1:0]                          Ad2Data1                              ;




    reg                                        rx_ad1_load                           ;
    reg                                        rx_ad2_load                           ;

//===============================================================================


//Receiver 1 Channels{{{
rx_chx_1to2 # (
      .LINES        (LINES          ),        // Number of data lines
      .SIPOWD       (SIPOWD         ),   //
      .IODLYWD      (IODLYWD        ),
      .REF_FREQ     (REF_FREQ       )      // Reference clock frequency for idelay control
   )
   rx_channel1 (
      .clk1_io      (clk1_io        ),      // Input from LVDS clock receiver pin
      .tap_clk      (tap_clk        ),
      .serdes_rst   (serdes_rst     ),
      .datain_p     (datain1_p      ),     // Input from LVDS data pins
      .datain_n     (datain1_n      ),     // Input from LVDS data pins
      .rx_dlyload   (rx_ad1_load    ),     // Input from LVDS data pins
      .rx_cntval    (rx_acnt_val    ),
      .oData0       (Ad1Data0       ),    // Pixel clock output
      .oData1       (Ad1Data1       )     // Pixel clock output

   );

//Receiver 2 Channels{{{
rx_chx_1to2 # (
      .LINES        (LINES          ),        // Number of data lines
      .SIPOWD       (SIPOWD         ),   //
      .IODLYWD      (IODLYWD        ),
      .REF_FREQ     (REF_FREQ       )      // Reference clock frequency for idelay control
   )
   rx_channel2 (
      .clk1_io      (clk1_io        ),      // Input from LVDS clock receiver pin
      .tap_clk      (tap_clk        ), 
      .serdes_rst   (serdes_rst     ),
      .datain_p     (datain2_p      ),     // Input from LVDS data pins
      .datain_n     (datain2_n      ),     // Input from LVDS data pins
      .rx_dlyload   (rx_ad2_load    ),     // Input from LVDS data pins
      .rx_cntval    (rx_bcnt_val    ),
      .oData0       (Ad2Data0       ),    // Pixel clock output
      .oData1       (Ad2Data1       )     // Pixel clock output

   );


//===============================================================================
// Data pro
//===============================================================================
always @(posedge tap_clk)
    if (tap_rst)
        begin
             rx_acnt_val <= 'd0;
             rx_bcnt_val <= 'd0;
        end
    else 
        begin
             rx_acnt_val <= adc_idelay_a_tap;
             rx_bcnt_val <= adc_idelay_b_tap;
        end

always @(posedge tap_clk)
    if (tap_rst)
        begin
            rx_ad1_load <= 'd0;
            rx_ad2_load <= 'd0;
        end
    else
        begin
            rx_ad1_load <= adc_idelay_load;
            rx_ad2_load <= adc_idelay_load;
        end
        

assign    oAData0  = Ad1Data0;// A channel  
assign    oAData1  = Ad1Data1;               
              
assign    oBData0  = Ad2Data0;// B channel 
assign    oBData1  = Ad2Data1;               
               

endmodule

