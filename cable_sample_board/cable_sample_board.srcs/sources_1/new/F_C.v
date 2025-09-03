`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 14:09:40
// Design Name: 
// Module Name: F_C
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



module F_C(
    input                  clk                    ,
    input                 rst_n                   ,  

    output   reg             fifo_rst_n                   
    );
    
    reg[5:0] cnt;
    
    always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
            fifo_rst_n<= 0;
            cnt <= 0;
            end
    else begin
        fifo_rst_n<= 0;
        if(cnt==6'd20)begin
            cnt <= cnt;
            end
        else if(6'd15<=cnt<=6'd19) begin
            fifo_rst_n<= 1;
            cnt <= cnt+'d1;
            end
        else
            cnt <= cnt+'d1;
        end
end
    
endmodule
