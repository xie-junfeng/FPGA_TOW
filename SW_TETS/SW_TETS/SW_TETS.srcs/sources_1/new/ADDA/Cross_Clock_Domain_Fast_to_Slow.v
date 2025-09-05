`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/20 09:57:21
// Design Name: 
// Module Name: Cross_Clock_Domain_Fast_to_Slow
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//1、此代码为单bit跨时钟域和多bit下采样式的跨时钟域
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module Cross_Clock_Domain_Fast_to_Slow
#
(
parameter             DATA_WITH    = 32 , //输入数据位宽
parameter             HOLD_TIME    = 5   //倍率：输入频率与输出频率的整数倍，2.5Mhz与1mhz为5
)


(
input      wire          fast_clk,
input      wire          slow_clk,
input      wire          reset,

input             [(DATA_WITH-1'D1):0]       data_i,
output    reg     [(DATA_WITH-1'D1):0]       data_o
);

reg [(DATA_WITH-1'D1):0] data_o1=16'd0;
reg [(DATA_WITH-1'D1):0] data_o2=16'd0;

  
 reg [15:0] cnt;
       always@(posedge fast_clk or negedge reset) begin
        if (reset == 1'b0) begin
           cnt <= 'd0    ; 
        end else begin
            if(cnt==HOLD_TIME)begin
                cnt <= 16'b0    ;
            end
            else begin
                cnt <= cnt+16'd1    ;
            end
        end
    end  
 
       always@(posedge slow_clk or negedge reset) begin
        if (reset == 1'b0) begin
            data_o1 <= 'd0    ;
        end else begin
            if(cnt==HOLD_TIME-1'd1)begin
                data_o1 <= data_i;
            end
            else begin
                data_o1 <= data_o1;
            end
        end
    end  
 
       always@(posedge slow_clk or negedge reset) begin
        if (reset == 1'b0) begin
            data_o2<= 'd0    ;
            data_o <= 'd0    ;
        end else begin
            data_o2<= data_o1 ;
            data_o <= data_o2 ;
        end
    end  
 
endmodule
