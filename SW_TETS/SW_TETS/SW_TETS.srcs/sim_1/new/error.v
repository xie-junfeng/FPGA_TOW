`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/27 15:55:08
// Design Name: 
// Module Name: error
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


module error (
        input  wire                         clk     ,   // ʱ���ź�
        input  wire                         rstn    ,   // ��λ�ź�
        input  wire     signed     [31:0]   sig_in  ,   // �����ź�����
        input  wire     signed     [31:0]   target  ,   // Ŀ���ź�
 
        output reg      signed     [31:0]   error   ,   // ��ǰ״̬����ź�
        output reg      signed     [31:0]   error1  ,   // ��һ״̬����ź�
        output reg      signed     [31:0]   sum_e       // ����ź��ۼ�ֵ ���ڻ��ֻ���
    );
 
    parameter [31:0] itg_max = 32'd100000000     ;       // �����޷�������ۼ�ֵΪ100
    parameter [31:0] itg_min = -32'd100000000    ;       // �����޷�����С�ۼ�ֵΪ-100
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin             // ��λ
            error  <= 32'd0 ;
            error1 <= 32'd0 ;
            sum_e  <= 32'd0 ;
        end
        else begin
            error  <= target - sig_in   ;       // ����ź�e = Ŀ���ź�t - �����ź�s
            error1 <= error             ;       // ������źŴ�һ�� �õ���һʱ�̵����ֵ
            // ���ڶ�������ʹ�ò����ʾ����������޷���������򵥵�ʮ��������ʾ�������ڲ���
            if ((sum_e > itg_max) && (sum_e < 32'h7FFF_FFFF)) begin
                sum_e <= itg_max;
            end
            else if ((sum_e < itg_min) && (sum_e > 32'h8000_0000)) begin
                sum_e <= itg_min;
            end
            else
                sum_e  <= sum_e + error     ;       // ��������ۼ�                     
        end
    end
 
endmodule
