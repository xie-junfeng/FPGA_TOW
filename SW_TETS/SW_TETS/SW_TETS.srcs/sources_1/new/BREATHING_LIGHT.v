`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/22 09:38:16
// Design Name: 
// Module Name: BREATHING_LIGHT
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

module BREATHING_LIGHT(
input                  CLK, 
input                  Reset,
output        reg      LED2
    );

 reg [31:0]cnt;
    
always@(posedge CLK or negedge Reset)
begin
	if(!Reset)begin
		LED2<= 1'd0;   
		end
	else if( cnt<= 32'd12000000 )begin
		LED2<= 1'd1;
	end        
    else begin
		LED2<= 1'd0;
        end
end   
 
 always@(posedge CLK or negedge Reset)
begin
	if(!Reset)begin
		cnt<= 32'd0;   
		end
	else begin
	 if( cnt== 32'd25000000 )begin
		cnt<= 32'd0;
	end        
    else begin
		cnt<= cnt+1'd1;
		end
  end
end  
    
endmodule
