`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/24 10:41:24
// Design Name: 
// Module Name: DSA_Top
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
module DSA_Top
(
	input		    Clk_25MHz,
	input			Reset,
    
	input [7:0]		ALT_TIF_Gain_U91,
	input [7:0]		ALT_TRF_Gain_U92,
	input [7:0]		ALT_TRF_Gain_U94,
	input [7:0]		ALT_TRF_Gain_U37,
	input [7:0]		ALT_TIF_Gain_U81,	
	input [7:0]		ALT_RIF_Gain_U43,

    output          ALT_TIF_Gain_U91_LE,       //  TIF
	output          ALT_TIF_Gain_U91_CLK, 
	output          ALT_TIF_Gain_U91_SERNIN, 
	
    output          ALT_TIF_Gain_U92_LE,       //  TRF1
	output          ALT_TIF_Gain_U92_CLK, 
	output          ALT_TIF_Gain_U92_SERNIN, 
    	
    output          ALT_TIF_Gain_U94_LE,       //  TRF2
	output          ALT_TIF_Gain_U94_CLK, 
	output          ALT_TIF_Gain_U94_SERNIN, 
	
    output          ALT_TIF_Gain_U37_LE,       //  TRF3
	output          ALT_TIF_Gain_U37_CLK, 
	output          ALT_TIF_Gain_U37_SERNIN, 	


    output          ALT_TIF_Gain_U81_LE,       //  TRF3
	output          ALT_TIF_Gain_U81_CLK, 
	output          ALT_TIF_Gain_U81_SERNIN, 	

	
    output          ALT_TIF_Gain_U43_LE,       //  TRF1
	output          ALT_TIF_Gain_U43_CLK, 
	output          ALT_TIF_Gain_U43_SERNIN



	
	
//    output          HMC1119_4_LE,       //  TRF3
//	output          HMC1119_4_CLK, 
//	output          HMC1119_4_SERNIN, 

//    output          HMC1119_5_LE,       //  RRF
//	output          HMC1119_5_CLK, 
//	output          HMC1119_5_SERNIN
);




reg [7:0]           cnt1;
reg [15:0]          delay_240ms;
reg                 start_en;
reg                 start_en_d1;
reg                 start_en_d2;
reg                 start_en_d3;
reg                 start_en_d4;
reg                 start_en_pulse;

reg [7:0]		    ALT_TIF_Gain_tmp;
reg [7:0]		    ALT_TRF_Gain1_tmp;
reg [7:0]	     	ALT_TRF_Gain2_tmp;
reg [7:0]	    	ALT_TRF_Gain3_tmp;
reg [7:0]		    ALT_RRF_Gain_tmp;
reg [7:0]		    ALT_RIF_Gain_tmp;
reg                 Tx1_DSA_start;
reg                 Tx2_DSA_start;
reg                 Tx3_6_DSA_start;
reg                 Tx4_DSA_start;
reg                 Tx5_DSA_start;

wire                End_Config;

wire  HMC1119_3_CLK;
wire  HMC1119_6_CLK;
wire  HMC1119_3_SERNIN;
wire  HMC1119_6_SERNIN;

assign  ALT_TIF_Gain_U94_CLK    =  HMC1119_3_CLK | HMC1119_6_CLK;
assign  ALT_TIF_Gain_U94_SERNIN =  HMC1119_3_SERNIN | HMC1119_6_SERNIN;

// ===================================================================
// delay  240 ms after chip power up  
localparam   T_240ms    = 16'd47058;
localparam   T_interval = 16'hFFFF; 
//localparam   T_240ms    = 16'd2000;
//localparam   T_interval = 16'h2000; 
always @(posedge Clk_25MHz or negedge Reset)
begin
   if(!Reset)
	   cnt1 <= 8'd0;
	else
	   cnt1 <= cnt1 +1; 
end

always @(posedge Clk_25MHz or negedge Reset)
begin
   if(!Reset)
	  delay_240ms <= 16'd0;
   else if (cnt1 == 8'd255)
      begin 
         if (delay_240ms >= T_240ms)  
            delay_240ms <=delay_240ms;  //delay_240ms <=delay_240ms;
         else 
	        delay_240ms <= delay_240ms +1;
      end
   else 
      delay_240ms <= delay_240ms;
end
  
always @(posedge Clk_25MHz or negedge Reset)
begin
   if(!Reset)
      start_en <= 1'b0;
   else if (delay_240ms >= T_240ms)
      start_en <= 1'b1;
   else 
      start_en <= start_en ;//<= 1'b0;<= start_en  ////////////////////////////////
end

always @(posedge Clk_25MHz or negedge Reset)
begin
   if(!Reset)
      begin
         start_en_d1 <= 1'b0;
         start_en_d2 <= 1'b0;
         start_en_d3 <= 1'b0;
         start_en_d4 <= 1'b0;
      end   
   else 
      begin
         start_en_d1 <= start_en;
         start_en_d2 <= start_en_d1;
         start_en_d3 <= start_en_d2;
         start_en_d4 <= start_en_d3;
      end   
end

always @(posedge Clk_25MHz or negedge Reset)
begin
   if(!Reset)
      start_en_pulse <= 1'b0;
   else if (start_en && (!start_en_d1))
      start_en_pulse <= 1'b1;
   else if (start_en_d3 && (!start_en_d4))
      start_en_pulse <= 1'b0;
   else 
      start_en_pulse <= start_en_pulse;        
end


always @(posedge Clk_25MHz or negedge Reset)
begin
   if(!Reset)
	   begin
		   ALT_TIF_Gain_tmp  <= 8'd255;
           ALT_TRF_Gain1_tmp <= 8'd255;
           ALT_TRF_Gain2_tmp <= 8'd255;
           ALT_TRF_Gain3_tmp <= 8'd255;
           ALT_RRF_Gain_tmp  <= 8'd255;
           ALT_RIF_Gain_tmp  <= 8'd255;
       end
	else
	   begin
		   ALT_TIF_Gain_tmp  <= ALT_TIF_Gain_U91;
           ALT_TRF_Gain1_tmp <= ALT_TRF_Gain_U92;
           ALT_TRF_Gain2_tmp <= ALT_TRF_Gain_U94;
           ALT_TRF_Gain3_tmp <= ALT_TRF_Gain_U37;
           ALT_RRF_Gain_tmp  <= ALT_TIF_Gain_U81;
           ALT_RIF_Gain_tmp  <= ALT_RIF_Gain_U43;
      end
end


always @(posedge Clk_25MHz or negedge Reset)
begin
   if(!Reset)
      Tx1_DSA_start <= 1'b0;
   else if( start_en_pulse || ALT_TIF_Gain_U91 != ALT_TIF_Gain_tmp )
      Tx1_DSA_start <= 1'b1;
   else 
      Tx1_DSA_start <= 1'b0;
end

//////////////  
DSA_HMC1119_SER  ALT_TIF_DSA_CONFIG
(
    .clk                        ( Clk_25MHz ),     //  50MHz
    .rst_n                      ( Reset ),
	.start_tx				    ( Tx1_DSA_start ),	
    .atten                      ( ALT_TIF_Gain_U91 ), 

	.End_Config				    (  ),	   
    .SPI_LE                     ( ALT_TIF_Gain_U91_LE ),
    .SPI_CLK                    ( ALT_TIF_Gain_U91_CLK ),
    .SPI_SERNIN                 ( ALT_TIF_Gain_U91_SERNIN )
);

always @(posedge Clk_25MHz or negedge Reset)
begin
   if(!Reset)
      Tx2_DSA_start <= 1'b0;
   else if( start_en_pulse || ALT_TRF_Gain_U92 != ALT_TRF_Gain1_tmp )
      Tx2_DSA_start <= 1'b1;
   else 
      Tx2_DSA_start <= 1'b0;
end

DSA_HMC1119_SER  ALT_TRF1_DSA_CONFIG
(
    .clk                        ( Clk_25MHz ),     //  50MHz
    .rst_n                      ( Reset ),
	.start_tx				    ( Tx2_DSA_start ),	
    .atten                      ( ALT_TRF_Gain_U92 ), 

	.End_Config				    (  ),	   
    .SPI_LE                     ( ALT_TIF_Gain_U92_LE   ),
    .SPI_CLK                    (ALT_TIF_Gain_U92_CLK     ),
    .SPI_SERNIN                 (ALT_TIF_Gain_U92_SERNIN  )
);


always @(posedge Clk_25MHz or negedge Reset)
begin
   if(!Reset)
      Tx3_6_DSA_start <= 1'b0;
   else if( start_en_pulse || ALT_TRF_Gain_U94 != ALT_TRF_Gain2_tmp || ALT_RIF_Gain_U43 != ALT_RIF_Gain_tmp)
      Tx3_6_DSA_start <= 1'b1;
   else 
      Tx3_6_DSA_start <= 1'b0;
end


DSA_HMC1119_SER  ALT_TRF2_DSA_CONFIG
(
    .clk                        ( Clk_25MHz ),     //  50MHz
    .rst_n                      ( Reset ),
	.start_tx				    ( Tx3_6_DSA_start ),	
    .atten                      ( ALT_TRF_Gain_U94 ), 

	.End_Config				    ( End_Config ),	   
    .SPI_LE                     ( ALT_TIF_Gain_U94_LE ),
    .SPI_CLK                    ( HMC1119_3_CLK ),
    .SPI_SERNIN                 ( HMC1119_3_SERNIN )
);


DSA_HMC1119_SER  ALT_RIF_DSA_CONFIG
(
    .clk                        ( Clk_25MHz ),     //  50MHz
    .rst_n                      ( Reset ),
	.start_tx				    ( End_Config),	
    .atten                      ( ALT_RIF_Gain_U43 ), 

	.End_Config				    (  ),	  
    .SPI_LE                     ( ALT_TIF_Gain_U43_LE ),
    .SPI_CLK                    ( ALT_TIF_Gain_U43_CLK ),
    .SPI_SERNIN                 ( ALT_TIF_Gain_U43_SERNIN)
);


always @(posedge Clk_25MHz or negedge Reset)
begin
   if(!Reset)
      Tx4_DSA_start <= 1'b0;
   else if( start_en_pulse || ALT_TRF_Gain_U37 != ALT_TRF_Gain3_tmp )
      Tx4_DSA_start <= 1'b1;
   else 
      Tx4_DSA_start <= 1'b0;
end

DSA_HMC1119_SER  ALT_DSA_ARW637_SER
(
    .clk                        ( Clk_25MHz ),     //  50MHz
    .rst_n                      ( Reset ),
	.start_tx				    ( Tx4_DSA_start ),	
    .atten                      ( ALT_TRF_Gain_U37 ), 

	.End_Config				    (  ),	   
    .SPI_LE                     ( ALT_TIF_Gain_U37_LE ),
    .SPI_CLK                    (  ALT_TIF_Gain_U37_CLK   ),
    .SPI_SERNIN                 (  ALT_TIF_Gain_U37_SERNIN)
);

always @(posedge Clk_25MHz or negedge Reset)
begin
   if(!Reset)
      Tx5_DSA_start <= 1'b0;
   else if( start_en_pulse || ALT_TIF_Gain_U81 != ALT_RRF_Gain_tmp )
      Tx5_DSA_start <= 1'b1;
   else 
      Tx5_DSA_start <= 1'b0;
end

DSA_HMC1119_SER  ALT_RRF_DSA_CONFIG
(
    .clk                        ( Clk_25MHz ),     //  50MHz
    .rst_n                      ( Reset ),
	.start_tx				    ( Tx5_DSA_start ),	
    .atten                      ( ALT_TIF_Gain_U81 ), 

	.End_Config				    (  ),	  
    .SPI_LE                     ( ALT_TIF_Gain_U81_LE    ),
    .SPI_CLK                    ( ALT_TIF_Gain_U81_CLK   ),
    .SPI_SERNIN                 ( ALT_TIF_Gain_U81_SERNIN)
);

endmodule

