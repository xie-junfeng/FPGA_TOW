`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/26 16:53:07
// Design Name: 
// Module Name: WC
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

//对来了多少次ask信号进行计数，
module WC(
    input                               clk    ,
    input                               rst_n  ,
    //other signal input
    output   reg                        signa_write_ready  , 
    input                               signa_write_valid  , 
    input                               signa_write_data   ,   
    //other signal output
    input                               count_read_ready,
    output   reg                        count_read_valid,
    output   reg        [8:0]           count_read_data
    );
    
wire flg;
    
SEDD U_SEDD (                                                      
     .clk             (clk),
     .rst_n           (rst_n),                                                                     
     .a               (signa_write_data),
     .flg             (flg)      
);      
//   ila_0 youe6 (
//	.clk(clk), // input wire clk
//	.probe0(count_read_ready), // input wire [0:0]  probe0  
//	.probe1(count_read_valid), // input wire [0:0]  probe1 
//	.probe2(count_read_data), // input wire [7:0]  probe3 
//	.probe3(signa_write_data), // input wire [10:0]  probe4 
//	.probe4(flg), // input wire [10:0]  probe5
//    .probe5(0)  // input wire [15:0]  probe4 

//);

always@(posedge clk or negedge rst_n)begin
    if(rst_n == 1'b0)begin
        count_read_data<=8'd0  ;
        count_read_valid<=1'd0;
        signa_write_ready<=1'd1;
    end
    else begin

    count_read_valid<=1'd0;
    signa_write_ready<=1'd1;
    if(flg&& count_read_ready==1'd1)begin
           if(count_read_data<9'd256)
                if(signa_write_valid)begin
                    signa_write_ready<=1'd0;
                    count_read_valid<=1'd1;
                    count_read_data<=count_read_data+8'd1 ;
                    end
                else begin
                    signa_write_ready<=1'd0;
                    count_read_valid<=1'd1;
                    count_read_data<=count_read_data;
                    end
           else begin
                count_read_valid<=1'd1;
                count_read_data<=8'd1 ;
                end
           end
    else begin
       count_read_data<=count_read_data;   
    end   
    end
 end    
endmodule
