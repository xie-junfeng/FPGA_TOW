`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/27 13:38:05
// Design Name: 
// Module Name: DECDDE
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


module DECODE(
input                      clk , 
input                      rst_n ,

output reg                 decode_write_ready, 
input                      decode_write_valid, 
input  [7:0]               decode_write_data,   

input                      decode_read_ready,     
output  reg                decode_read_valid, 
output  reg [7:0]          decode_read_data_8

    );

reg [23:0]          preamble;
reg [7:0]            decode_read_data_r;
reg [7:0]            cnt;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        preamble <= 0;
        decode_read_data_8 <= 0;
        decode_read_data_r <= 0;
        decode_write_ready<= 1;
        decode_read_valid<=0;
        cnt<=0;
        end
    else begin
    decode_read_valid<=0;
    decode_write_ready<= 1;
        if(decode_write_valid&decode_read_ready)begin
           
            if(cnt==0)begin
                decode_write_ready<= 0;
                preamble[23:16]<=decode_write_data;
                cnt<=cnt+1'd1;
            end
            else if(cnt==1)begin
                decode_write_ready<= 0;
                preamble[15:8]<=decode_write_data;
                cnt<=cnt+1'd1;
            end
            else if(cnt==2)begin
                decode_write_ready<= 0;
                preamble[7:0]<=decode_write_data;
                cnt<=cnt+1'd1;
            end
            else if(cnt==3)begin
                decode_write_ready<= 0;  
                decode_read_data_r<=decode_write_data;
                cnt<=cnt+1'd1;
            end
            else if(cnt==4)begin
              decode_write_ready<= 0;
              if(preamble[0]==1&&preamble[9]==1&&preamble[18]==1)begin
                   decode_read_valid<=1;                            //CHEACK
                   decode_read_data_8<=decode_read_data_r;
              end
              cnt<=cnt+1'd1;
              
            end
            else begin
            decode_write_ready<= 0;
            preamble <= preamble;
            decode_read_valid<=0;
            decode_read_data_8 <= decode_read_data_8;
            decode_read_data_r <=decode_read_data_r;
            cnt<=cnt;
            end
            end
         else begin
            preamble <= preamble;
            decode_read_data_r <= 0;
            decode_read_data_8 <= decode_read_data_8;
            cnt<=1'd0;
        end
        end
 end
endmodule
