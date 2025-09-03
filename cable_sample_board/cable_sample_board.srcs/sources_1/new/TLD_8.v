`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SAU
// Engineer: XIE JUNBO
// 
// Create Date: 2023/09/18 14:58:37
// Design Name: 
// Module Name: TLD
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


module TLD_TWO_8
#(
  parameter DATA_WIDTH=8
)
(
    input                               clk   ,
    input                               rst_n ,
    //input singnal
    input       [DATA_WIDTH-1:0]        a     ,
    //output singnal
    output reg  [DATA_WIDTH-1:0]        b
    );
    reg [DATA_WIDTH-1:0]  a1;
    always@(posedge clk or negedge rst_n)
begin
 if(rst_n == 1'b0)
 begin
  a1<=1'd0  ;
  b<=1'd0   ;
 end
 else begin
        a1<=a;
        b<=a1;
 end
 end
endmodule 
