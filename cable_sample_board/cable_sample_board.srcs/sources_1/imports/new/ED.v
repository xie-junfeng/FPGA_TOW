`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/26 10:24:31
// Design Name: 
// Module Name: ED
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


module SEDD
(
    input                               clk   ,
    input                               rst_n ,
    //input singnal
    input                               a     ,
    //output flg
    output                              flg
    );
    reg               a1;
    reg               a2;
assign flg=~a2&a1;
always@(posedge clk or negedge rst_n)
begin
 if(rst_n == 1'b0)
 begin
  a1<=1'd0  ;
 end
 else begin
        a1<=a;
        a2<=a1;
 end
 end
 
endmodule                                 
