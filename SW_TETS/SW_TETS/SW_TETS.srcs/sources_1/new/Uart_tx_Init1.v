`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/20 10:49:41
// Design Name: 
// Module Name: Uart_tx_Init1
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


module Uart_tx_Init1
(
	input			clk,
	input			reset,
	input	 [7:0]	Rs232_tx,
	input			Tx_en,	
	
	output reg		Tx_flag,
	output			Rs232_out
);

reg [9:0]	Bps_cnt;
reg [3:0]	Cnt;
reg			data_tx;
				
//*----------------------------- //
//* ²¨ÌØÂÊ:115200bps              //
//* Clk:50MHz                    //
//*----------------------------- //
always@(posedge clk or negedge reset)
begin
	if(!reset)
		Bps_cnt <= 10'd0;
	else if(Tx_en)
		begin
			if(Bps_cnt < 10'd867)
				Bps_cnt <= Bps_cnt + 10'd1;
			else
				Bps_cnt <= 10'd0;
		end
	else
		Bps_cnt <= 10'd0;
end

always@(posedge clk or negedge reset)
begin
	if(!reset)
		Cnt <= 4'd0;
	else if( Bps_cnt == 10'd867 )
		begin
			if(Cnt < 4'd10)
				Cnt <= Cnt + 4'd1;
			else
				Cnt <= 4'd0;
		end
	else
		Cnt <= Cnt;
end

always@(posedge clk or negedge reset)
begin
	if(!reset)
		Tx_flag <= 1'd0;
	else if( (Bps_cnt == 10'd867) && (Cnt == 4'd10) )
		Tx_flag <= 1'd1;
	else
		Tx_flag <= 1'd0;
end

always@(posedge clk or negedge reset)
begin
	if(!reset)
		data_tx <= 1'b1;
	else if(Tx_en)
		begin
			case(Cnt)
				4'd0: data_tx <= 1'b1;//interval
				4'd1: data_tx <= 1'b0;//Start Bit
				
				4'd2: data_tx <= Rs232_tx[0];
				4'd3: data_tx <= Rs232_tx[1];
				4'd4: data_tx <= Rs232_tx[2];
				4'd5: data_tx <= Rs232_tx[3];
				4'd6: data_tx <= Rs232_tx[4];
				4'd7: data_tx <= Rs232_tx[5];
				4'd8: data_tx <= Rs232_tx[6];
				4'd9: data_tx <= Rs232_tx[7];
				
				4'd10: data_tx <= 1'b1;//Stop Bit
			endcase
		end
end
assign Rs232_out = data_tx;

endmodule
