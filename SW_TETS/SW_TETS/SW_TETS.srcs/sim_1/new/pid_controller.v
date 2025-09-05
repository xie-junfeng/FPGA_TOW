`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/27 15:53:01
// Design Name: 
// Module Name: pid_controller
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


module pid_controller (
        input  wire                  clk      ,      // ʱ��50MHz
        input  wire                  rstn     ,      // ��λ�ź�
        input  wire signed [31:0]    sig_in   ,      // �����ź�����
        input  wire signed [31:0]    target   ,      // Ŀ���ź�
 
        input  wire signed [7:0]     kp       ,      // ��������ϵ��
        input  wire signed [7:0]     ki       ,      // ���ֻ���ϵ��
        input  wire signed [7:0]     kd       ,      // ΢�ֻ���ϵ��
 
        output wire signed [63:0]    ctrl_out        // �����ź����
    );
 
    wire     [31:0]  error   ;
    wire     [31:0]  error1  ;
    wire     [31:0]  sum_e   ;
    error error_inst (
              .clk            (clk)       ,
              .rstn           (rstn)      ,
              .sig_in         (sig_in)    ,
              .target         (target)    ,
              .error          (error)     ,
              .error1         (error1)    ,
              .sum_e          (sum_e)
          );
 
    pid_ctrl pid_ctrl_inst (
                 .clk            (clk)     ,
                 .rstn           (rstn)    ,
                 .error          (error)   ,
                 .error1         (error1)  ,
                 .sum_e          (sum_e)   ,
                 .kp             (kp)      ,
                 .ki             (ki)      ,
                 .kd             (kd)      ,
                 .ctrl_out       (ctrl_out)
             );
 
endmodule
