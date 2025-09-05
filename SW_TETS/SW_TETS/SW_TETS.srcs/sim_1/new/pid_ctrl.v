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
        input  wire                clk     ,    // ʱ��
        input  wire                rstn    ,    // ��λ
        input  wire signed [31:0]  error   ,    // ���
        input  wire signed [31:0]  error1  ,    // ��һʱ�����
        input  wire signed [31:0]  sum_e   ,    // ����ۼ�ֵ
 
        input  wire signed [7:0]   kp      ,    // ����ϵ��
        input  wire signed [7:0]   ki      ,    // ����ϵ��
        input  wire signed [7:0]   kd      ,    // ΢��ϵ��
 
        output reg  signed [63:0]  ctrl_out     // ���������
    );
 
    always @(posedge clk or negedge rstn) begin
        if(! rstn) begin
            ctrl_out <= 64'd0;
        end
        else begin
            ctrl_out <= (kp*error) + (ki*sum_e) + (kd*(error - error1));    // PID����
        end
    end
endmodule
