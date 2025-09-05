`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/24 10:42:18
// Design Name: 
// Module Name: DSA_HMC1119_SER
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

module DSA_HMC1119_SER
(
input              clk,     // 50MHz
input              rst_n,
input              start_tx,
input [7:0]        atten,

output reg         End_Config,
output reg         SPI_LE,
output reg         SPI_CLK,
output reg         SPI_SERNIN
);

reg [1:0]  clk_div;  //    50MHz/4
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      clk_div <= 2'd0;
   else 
      clk_div <= clk_div + 2'd1;		
end


reg [5:0]  bit_cnt;


always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      bit_cnt <= 6'd0;
   else if (start_tx)
      bit_cnt <= 6'd1;   
   else if (clk_div == 2'd1)
      begin
         if (bit_cnt >= 6'd1 && bit_cnt <= 6'd48)
            bit_cnt <= bit_cnt + 1'd1;
         else 
            bit_cnt <= 6'd0;
      end   
   else 
      bit_cnt <= bit_cnt;
end    

always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      SPI_SERNIN <= 1'b0;
   else if (clk_div == 2'd0)
      begin
         case (bit_cnt)
            2: SPI_SERNIN <= atten[0];
            3: SPI_SERNIN <= atten[1];
            4: SPI_SERNIN <= atten[2];
            5: SPI_SERNIN <= atten[3];
            6: SPI_SERNIN <= atten[4];
            7: SPI_SERNIN <= atten[5];
            8: SPI_SERNIN <= atten[6];
            9: SPI_SERNIN <= atten[7];
            10: SPI_SERNIN <= 1'b0   ;
            default: SPI_SERNIN<= SPI_SERNIN;
         endcase
      end
   else 
      SPI_SERNIN<= SPI_SERNIN;
end


always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      SPI_CLK <= 1'b0;
   else if ((bit_cnt >= 24'd3) && (bit_cnt <= 24'd10))
      begin
         if (clk_div == 2'd2)
            SPI_CLK <= 1'b1;
         else if (clk_div == 2'd0)
            SPI_CLK <= 1'b0;
         else  
            SPI_CLK <= SPI_CLK;
      end
   else 
      SPI_CLK <= 1'b0;
end
  

always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      SPI_LE <= 1'b0;
   else if ((bit_cnt == 24'd11))
      begin
         if (clk_div == 2'd2)
            SPI_LE <= 1'b1;
         else if (clk_div == 2'd0)
            SPI_LE <= 1'b0;
         else  
            SPI_LE <= SPI_LE;
      end
   else 
      SPI_LE <= 1'b0;
end

always @(posedge clk or negedge rst_n)
begin
     if(!rst_n)
		End_Config <= 1'd0;
	else if(bit_cnt >= 6'd44 && bit_cnt <= 6'd48)
		End_Config <= 1'd1;
	else
		End_Config <= 1'd0;		
end


endmodule

