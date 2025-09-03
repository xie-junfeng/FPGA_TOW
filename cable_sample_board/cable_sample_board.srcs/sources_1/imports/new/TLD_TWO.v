`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/26 10:31:22
// Design Name: 
// Module Name: TLD_TWO
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
module TLD_TWO
#(
  parameter DATA_WIDTH=1
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