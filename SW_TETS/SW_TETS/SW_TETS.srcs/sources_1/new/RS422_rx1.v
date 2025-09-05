`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/20 10:49:12
// Design Name: 
// Module Name: RS422_rx1
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


module RS422_rx1
(
	input					clk,
	input					reset,
	input					UART_in,
	
	output reg		     	Rx_flag,
	output reg[7:0]	        UART_PDout,
	output reg[5:0]	        Bps_cnt,
	output reg			    Clk_16xBps
);

// ----------------------------------------------------------------
//* FSM PARAMETER
localparam	IDLE			= 5'b00001;
localparam	START_BIT	= 5'b00010;
localparam	SAMPLE		= 5'b00100;
localparam	STOP_BIT		= 5'b01000;
localparam	RECV_END		= 5'b10000;

// ----------------------------------------------------------------
//* REG & WIRE
reg			UART_din1;
reg			UART_din2;
reg			UART_din3;
reg			UART_din4;
reg			UART_din5;
reg			Data_reg;
reg [4:0]	State;
reg [4:0]	State_Reg;
reg [4:0]	Start_Cnt;
reg [3:0]	Sample_Cnt;
reg [3:0]	Cnt;
reg [7:0]	Parallel_Data;

wire			Down_Edge;

// ----------------------------------------------------
//* 16倍波特率
//* 波特率：115200bps
// ----------------------------------------------------
always@(posedge clk or negedge reset)
begin
	if(!reset)
		Bps_cnt <= 6'd0;
	else if(Bps_cnt < 6'd53)
		Bps_cnt <= Bps_cnt + 6'd1;
	else
		Bps_cnt <= 6'd0;
end

always@(posedge clk or negedge reset)
begin
	if(!reset)
		Clk_16xBps <= 1'b0;
	else if(Bps_cnt <= 6'd26)
		Clk_16xBps <= 1'b1;
	else
		Clk_16xBps <= 1'b0;
end

// ------------- Begin Bit --------------
always@(posedge Clk_16xBps or negedge reset)
begin
	if(!reset)
		begin
			UART_din1 <= 1'b1;
			UART_din2 <= 1'b1;
			UART_din3 <= 1'b1;
			UART_din4 <= 1'b1;
			UART_din5 <= 1'b1;
		end
	else
		begin
			UART_din1 <= UART_in;
			UART_din2 <= UART_din1;
			UART_din3 <= UART_din2;
			UART_din4 <= UART_din3;
			UART_din5 <= UART_din4;
		end
end
assign Down_Edge = (~UART_din2) & UART_din3;

// ----------- Begin Of Recv --------------
always@(posedge Clk_16xBps or negedge reset)
begin
	if(!reset)
		begin
			State <= IDLE;
			Start_Cnt <= 5'd0;
			Sample_Cnt <= 4'd0;
			Data_reg <= 1;
			Cnt <= 4'd0;
			//Rx_flag <= 1'b0;
			Parallel_Data <= 8'd0;
		end
	else
		begin
			case(State)
				IDLE :
					begin
						//Rx_flag <= 1'b0;
						Start_Cnt <= 5'd0;
						Sample_Cnt <= 4'd0;
						Cnt <= 4'd0;
						if(Down_Edge == 1'b1)
							State <= START_BIT;
						else
							State <= IDLE;
					end
				
				START_BIT:
					begin
						if(Start_Cnt < 5'd8)
							begin
								if(UART_din3 == 1'b1)
									begin
										State <= IDLE;
										Start_Cnt <= 5'd0;
									end
								else if(UART_din3 == 1'b0)
									begin
										State <= START_BIT;
										Start_Cnt <= Start_Cnt + 1;
									end
							end
						else
							begin
								if(UART_din3 == 1'b0)
									State <= SAMPLE;
								else
									State <= IDLE;
								Start_Cnt <= 5'd0;
							end
					end
				
				SAMPLE:
					begin
						Sample_Cnt <= Sample_Cnt + 1;
						if(Sample_Cnt == 4'd15)
							begin
								Cnt <= Cnt + 1;
								if( ((UART_din3 && UART_din4 && UART_din5) == 1) || ((UART_din3 && UART_din4) == 1) || ((UART_din4 && UART_din5) == 1) || ((UART_din3 && UART_din5 ) == 1))
									Data_reg <= 1'b1;//三判二
								else
									Data_reg <= 1'b0;
							end
						else if(Cnt == 8)
							begin
								Cnt <= 0;
								State <= STOP_BIT;
							end
						else
							begin
								Cnt <= Cnt;
								Data_reg <= Data_reg;
							end
						
						case(Cnt)
							4'd1: Parallel_Data[0] <= Data_reg;
							4'd2: Parallel_Data[1] <= Data_reg;
							4'd3: Parallel_Data[2] <= Data_reg;
							4'd4: Parallel_Data[3] <= Data_reg;
							4'd5: Parallel_Data[4] <= Data_reg;
							4'd6: Parallel_Data[5] <= Data_reg;
							4'd7: Parallel_Data[6] <= Data_reg;
							4'd8: Parallel_Data[7] <= Data_reg;
							default:;
						endcase
					end
				
				STOP_BIT:
					begin
						Sample_Cnt <= Sample_Cnt + 1;
						if(Sample_Cnt == 4'd15)
							begin
								Sample_Cnt <= 4'd0;
								if( ((UART_din3 && UART_din4 && UART_din5) == 1) || ((UART_din3 && UART_din4) == 1) || ((UART_din4 && UART_din5) == 1) || ((UART_din3 && UART_din5 ) == 1))
									State <= RECV_END;//三判二
								else
									State <= IDLE;
							end
					end
				
				RECV_END:
					begin
						//Rx_flag <= 1'b1;
						State <= IDLE;
					end
					
				default:State <= IDLE;
			endcase
		end
end

always@(posedge clk or negedge reset)
begin
	if(!reset)
		State_Reg <= IDLE;
	else
		State_Reg <= State;
end


always@(posedge clk or negedge reset)
begin
	if(!reset)
		Rx_flag <= 1'b0;
	else if( State == RECV_END && State_Reg == STOP_BIT )	
		Rx_flag <= 1'b1;
	else
		Rx_flag <= 1'b0;
end

always@(posedge clk or negedge reset)
begin
	if(!reset)
		UART_PDout <= 8'd0;
	else if( State == RECV_END && State_Reg == STOP_BIT )	
		UART_PDout <= Parallel_Data;
	else
		UART_PDout <= UART_PDout;
end

endmodule

