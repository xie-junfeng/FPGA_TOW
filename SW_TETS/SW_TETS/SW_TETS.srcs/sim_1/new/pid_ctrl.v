`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/27 15:55:08
// Design Name: 
// Module Name: pid_ctrl
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


module pid_ctrl (
        input  wire                clk     ,    // 时钟
        input  wire                rstn    ,    // 复位
        input  wire signed [31:0]  error   ,    // 误差
        input  wire signed [31:0]  error1  ,    // 上一时刻误差
        input  wire signed [31:0]  sum_e   ,    // 误差累加值
 
        input  wire signed [7:0]   kp      ,    // 比例系数
        input  wire signed [7:0]   ki      ,    // 积分系数
        input  wire signed [7:0]   kd      ,    // 微分系数
 
        output reg  signed [63:0]  ctrl_out     // 控制器输出
    );
 
    always @(posedge clk or negedge rstn) begin
        if(! rstn) begin
            ctrl_out <= 64'd0;
        end
        else begin
            ctrl_out <= (kp*error) + (ki*sum_e) + (kd*(error - error1));    // PID计算
        end
    end
endmodule
