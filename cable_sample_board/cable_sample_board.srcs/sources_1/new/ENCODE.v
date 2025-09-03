`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/27 14:39:18
// Design Name: 
// Module Name: ENCODE
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


module ENCODE(
input                 clk, 
input                 rst_n ,
//encode data signal

output reg            encode0_write_ready, 
input                 encode0_write_valid,
input  [7:0]          encode0_write_data_8, 

output reg            encode1_write_ready, 
input                 encode1_write_valid,
input  [7:0]          encode1_write_data_8,

output reg            encode2_write_ready, 
input                 encode2_write_valid,
input  [7:0]          encode2_write_data_8,

//signal delay

input                 encode0_read_ready, 
output  reg           encode0_read_valid,
output  reg   [7:0]   encode0_read_data_8, 

input                 encode1_read_ready, 
output  reg           encode1_read_valid,
output  reg   [7:0]   encode1_read_data_8, 


//encode data signal
input                 encode_read_ready,   
output reg            encode_read_valid,       
output reg   [7:0]    encode_read_data

    );
    
    
    
reg [11:0]  cnt;

parameter   DATA_NUMBER_8    = 10'd960; 
parameter   DATA_NUMBER_32    = 8'd18; 
parameter   NUMBER_HEAD    = 11'd18; 
parameter   NUMBER_DATA    = 11'd978; 



always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        encode0_write_ready <= 1'd1;
        encode1_write_ready <= 1'd1;
        encode2_write_ready <= 1'd0;


        encode0_read_valid<= 1'd0    ;
        encode1_read_valid<= 1'd0    ;



        encode0_read_data_8<= 8'd0   ;
        encode1_read_data_8<= 8'd0   ;

       
              
        encode_read_valid   <= 1'd0;    
        encode_read_data    <= 8'd0;
        cnt <= 12'd0;
        end
    else begin
        encode0_read_valid<= 1'd0    ;
        encode1_read_valid<= 1'd0    ;
        encode_read_valid   <= 1'd0;       
        encode_read_data    <= 8'd0;
        encode0_write_ready <= 1'd1;
        encode1_write_ready <= 1'd1;
        encode2_write_ready <= 1'd0;

            //Send ACK
            if(cnt==0 && encode0_write_valid && encode_read_ready)
            begin
                encode0_write_ready <= 1'd0;
                encode_read_valid<=1'd1;
                encode_read_data<=encode0_write_data_8;
                cnt<=cnt+1'd1;
            end
            
           else if(cnt==1 && encode0_read_ready)
            begin
                encode0_read_valid<= 1'd1;
                encode0_read_data_8<= encode_read_data   ;
                cnt<=cnt+1'd1;
            end
            
             //Send adress
            else if(cnt==2 && encode1_write_valid&& encode_read_ready)
            begin
                encode1_write_ready <= 1'd0;
                encode_read_valid<=1'd1;
                encode_read_data<=encode1_write_data_8;
                cnt<=cnt+1'd1;
            end
            
           else if(cnt==3 && encode1_read_ready)
            begin
                encode1_read_valid<= 1'd1;
                encode1_read_data_8<= encode_read_data   ;
                cnt<=cnt+1'd1;
            end
            //send  zero
            else if(3<cnt && cnt<(NUMBER_HEAD+2) )
            begin
                encode_read_valid<=1'd1;
                encode_read_data<=0;
                cnt<=cnt+1'd1;
            end
            //Send DA data
            else if((NUMBER_HEAD+1) <cnt&& cnt<NUMBER_DATA&&encode_read_ready)begin
                    encode2_write_ready <= 1'd1;
                    if(encode2_write_valid )begin
                        encode_read_valid<=1'd1;
                        encode_read_data<=encode2_write_data_8;
                        cnt<=cnt+1'd1;
                    end
                    else begin
                           cnt<=cnt;
                     end
                    end
             else if(cnt==NUMBER_DATA)begin
                           cnt<=0;
                    end           
            else begin
                   cnt<=cnt;
            end              
        end

 end
endmodule
