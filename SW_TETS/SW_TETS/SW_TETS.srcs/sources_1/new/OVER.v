`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/11 10:49:21
// Design Name: 
// Module Name: OVER_LED
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OVER(

 input					ADS_OVRB_P,
 input					ADS_OVRB_N,	

 input 					ADS_OVRA_P,	
 input 					ADS_OVRA_N,

 output                 ADS_OVRB,
 output                 ADS_OVRA
    );
    

    IBUFDS #(
      .DIFF_TERM("TRUE"),    // Differential Termination
      .IBUF_LOW_PWR("FALSE"),  // Low power="TRUE", Highest performance="FALSE" 
      .IOSTANDARD("LVDS")  // Specify the input I/O standard
   )  Uibufds (
        .I    (ADS_OVRA_P  ),
        .IB   (ADS_OVRA_N  ),
        .O    (ADS_OVRA    )
    );

    IBUFDS #(
      .DIFF_TERM("TRUE"),    // Differential Termination
      .IBUF_LOW_PWR("FALSE"),  // Low power="TRUE", Highest performance="FALSE" 
      .IOSTANDARD("LVDS")  // Specify the input I/O standard
   )  Uibufds0 (
        .I    (ADS_OVRB_P  ),
        .IB   (ADS_OVRB_N  ),
        .O    (ADS_OVRB    )
    );    
    
endmodule
