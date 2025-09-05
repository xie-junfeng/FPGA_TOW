`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 16:05:15
// Design Name: 
// Module Name: Pruning_Butfly_Process
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

module Pruning_Butterfly
#(
	parameter	DATA_INPUT_WITDH	= 12,
	parameter	TWIDDLE_WITDH		= 24,
	parameter	LOG2_FFT_LEN		= 11
)
(
	input	wire							clk,
	input	wire							reset_n,
	input	wire							Butfly_Wr,
	input	wire							source_end,
	input	wire							Carry_MH,
	input	wire							Carry_ML,
	input	wire[3:0]						Current_state,
	input	wire[31:0]						Stage_Cnt,
	input	wire[2*DATA_INPUT_WITDH+3:0]	Butterfly_xin1,
	input	wire[2*DATA_INPUT_WITDH+3:0]	Butterfly_xin2,
	input	wire[2*TWIDDLE_WITDH-1:0]		Twiddle_factor,

	output	wire							source_exp_mh,
	output	wire							source_exp_ml,
	output	reg								Carry_MH_flag,
	output	reg								Carry_ML_flag,
	output	reg [2*DATA_INPUT_WITDH+3:0]	Butterfly_xout1,
	output	reg [2*DATA_INPUT_WITDH+3:0]	Butterfly_xout2
);
// -----------------------------------------------------------------
//* FSM & PARA
localparam	FFT_STATE_RESET		= 4'b0000;
localparam	FFT_STATE_READ		= 4'b0001;
localparam	FFT_STATE_WAIT		= 4'b0010;
localparam	FFT_STATE_WN_PRE	= 4'b0011;
localparam	FFT_STATE_FIRST		= 4'b0100;
localparam	FFT_STATE_SECOND	= 4'b0101;
localparam	FFT_STATE_THIRD		= 4'b0110;
localparam	FFT_STATE_FOURTH	= 4'b0111;
localparam	FFT_STATE_FIFTH		= 4'b1000;
localparam	FFT_STATE_REPEAT	= 4'b1001;

// -----------------------------------------------------------------
//* REG
reg		signed[TWIDDLE_WITDH+DATA_INPUT_WITDH-1:0]	Mult_rr;
reg		signed[TWIDDLE_WITDH+DATA_INPUT_WITDH-1:0]	Mult_ii;
reg		signed[TWIDDLE_WITDH+DATA_INPUT_WITDH-1:0]	Mult_ri;
reg		signed[TWIDDLE_WITDH+DATA_INPUT_WITDH-1:0]	Mult_ir;
reg		signed[DATA_INPUT_WITDH-1:0]				Mult_rr1;
reg		signed[DATA_INPUT_WITDH-1:0]				Mult_ii1;
reg		signed[DATA_INPUT_WITDH-1:0]				Mult_ri1;
reg		signed[DATA_INPUT_WITDH-1:0]				Mult_ir1;
reg		signed[DATA_INPUT_WITDH-1:0]				Xin1_r;
reg		signed[DATA_INPUT_WITDH-1:0]				Xin1_i;
reg		signed[DATA_INPUT_WITDH-1:0]				Xin2_r;
reg		signed[DATA_INPUT_WITDH-1:0]				Xin2_i;
reg		signed[DATA_INPUT_WITDH-1:0]				Xin1_r_buf1;
reg		signed[DATA_INPUT_WITDH-1:0]				Xin1_r_buf2;
reg		signed[DATA_INPUT_WITDH-1:0]				Xin1_i_buf1;
reg		signed[DATA_INPUT_WITDH-1:0]				Xin1_i_buf2;
reg		signed[DATA_INPUT_WITDH+1:0]				Xout1_r;
reg		signed[DATA_INPUT_WITDH+1:0]				Xout1_i;
reg		signed[DATA_INPUT_WITDH+1:0]				Xout2_r;
reg		signed[DATA_INPUT_WITDH+1:0]				Xout2_i;
reg													Butfly_Wr1;
reg													Butfly_Wr2;
reg													Butfly_Wr3;
reg													Butfly_Wr4;
reg													Carry_MH_flag1;
reg													Carry_ML_flag1;

// -----------------------------------------------------------------
//* WIRE
wire	signed[TWIDDLE_WITDH-1:0]					Twiddle_r;
wire	signed[TWIDDLE_WITDH-1:0]					Twiddle_i;

// -------------------------------------------------------------------------------
assign Twiddle_r = Twiddle_factor[2*TWIDDLE_WITDH-1:TWIDDLE_WITDH];
assign Twiddle_i = Twiddle_factor[TWIDDLE_WITDH-1:0];
always@(*)
begin
	if(!reset_n)
		Xin1_r = 'd0;
	else if(Carry_MH == 1)
		begin
			if(Butterfly_xin1[2*DATA_INPUT_WITDH+3] == 0 && Butterfly_xin1[DATA_INPUT_WITDH+3] == 1)
				Xin1_r = Butterfly_xin1[2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+4] + 1;
			else if(Butterfly_xin1[2*DATA_INPUT_WITDH+3] == 0 && Butterfly_xin1[DATA_INPUT_WITDH+3] == 0)
				Xin1_r = Butterfly_xin1[2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+4];
			else if(Butterfly_xin1[2*DATA_INPUT_WITDH+3] == 1 && Butterfly_xin1[DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+2] > 2'b10)
				Xin1_r = Butterfly_xin1[2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+4] + 1;
			else //if(Butterfly_xin1[2*DATA_INPUT_WITDH+3] == 1)
				Xin1_r = Butterfly_xin1[2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+4];
		end
	else if(Carry_ML == 1)
		begin
			if(Butterfly_xin1[2*DATA_INPUT_WITDH+3] == 0 && Butterfly_xin1[DATA_INPUT_WITDH+2] == 1)
				Xin1_r = {Butterfly_xin1[2*DATA_INPUT_WITDH+3],Butterfly_xin1[2*DATA_INPUT_WITDH+1:DATA_INPUT_WITDH+3]} + 1;
			else
				Xin1_r = {Butterfly_xin1[2*DATA_INPUT_WITDH+3],Butterfly_xin1[2*DATA_INPUT_WITDH+1:DATA_INPUT_WITDH+3]};
		end
	else
		Xin1_r = {Butterfly_xin1[2*DATA_INPUT_WITDH+3],Butterfly_xin1[2*DATA_INPUT_WITDH:DATA_INPUT_WITDH+2]};
end

always@(*)
begin
	if(!reset_n)
		Xin1_i = 'd0;
	else if(Carry_MH == 1)
		begin
			if(Butterfly_xin1[DATA_INPUT_WITDH+1] == 0 && Butterfly_xin1[1] == 1)
				Xin1_i = Butterfly_xin1[DATA_INPUT_WITDH+1:2] + 1;
			else if(Butterfly_xin1[DATA_INPUT_WITDH+1] == 0 && Butterfly_xin1[1] == 0)
				Xin1_i = Butterfly_xin1[DATA_INPUT_WITDH+1:2];
			else if(Butterfly_xin1[DATA_INPUT_WITDH+1] == 1 && Butterfly_xin1[1:0] > 2'b10)
				Xin1_i = Butterfly_xin1[DATA_INPUT_WITDH+1:2] + 1;
			else
				Xin1_i = Butterfly_xin1[DATA_INPUT_WITDH+1:2];
		end
	else if(Carry_ML == 1)
		begin
			if(Butterfly_xin1[DATA_INPUT_WITDH+1] == 0 && Butterfly_xin1[0] == 1)
				Xin1_i = {Butterfly_xin1[DATA_INPUT_WITDH+1],Butterfly_xin1[DATA_INPUT_WITDH-1:1]} + 1;
			else
				Xin1_i = {Butterfly_xin1[DATA_INPUT_WITDH+1],Butterfly_xin1[DATA_INPUT_WITDH-1:1]};
		end
	else
		Xin1_i = {Butterfly_xin1[DATA_INPUT_WITDH+1],Butterfly_xin1[DATA_INPUT_WITDH-2:0]};
end

always@(*)
begin
	if(!reset_n)
		Xin2_r = 'd0;
	else if(Carry_MH == 1)
		begin
			if(Butterfly_xin2[2*DATA_INPUT_WITDH+3] == 0 && Butterfly_xin2[DATA_INPUT_WITDH+3] == 1)
				Xin2_r = Butterfly_xin2[2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+4] + 1;
			else if(Butterfly_xin2[2*DATA_INPUT_WITDH+3] == 0 && Butterfly_xin2[DATA_INPUT_WITDH+3] == 0)
				Xin2_r = Butterfly_xin2[2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+4];
			else if(Butterfly_xin2[2*DATA_INPUT_WITDH+3] == 1 && Butterfly_xin2[DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+2] > 2'b10)
				Xin2_r = Butterfly_xin2[2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+4] + 1;
			else //if(Butterfly_xin2[2*DATA_INPUT_WITDH+3] == 1)
				Xin2_r = Butterfly_xin2[2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+4];
		end
	else if(Carry_ML == 1)
		begin
			if(Butterfly_xin2[2*DATA_INPUT_WITDH+3] == 0 && Butterfly_xin2[DATA_INPUT_WITDH+2] == 1)
				Xin2_r = {Butterfly_xin2[2*DATA_INPUT_WITDH+3],Butterfly_xin2[2*DATA_INPUT_WITDH+1:DATA_INPUT_WITDH+3]} + 1;
			else
				Xin2_r = {Butterfly_xin2[2*DATA_INPUT_WITDH+3],Butterfly_xin2[2*DATA_INPUT_WITDH+1:DATA_INPUT_WITDH+3]};
		end
	else
		Xin2_r = {Butterfly_xin2[2*DATA_INPUT_WITDH+3],Butterfly_xin2[2*DATA_INPUT_WITDH:DATA_INPUT_WITDH+2]};
end

always@(*)
begin
	if(!reset_n)
		Xin2_i = 'd0;
	else if(Carry_MH == 1)
		begin
			if(Butterfly_xin2[DATA_INPUT_WITDH+1] == 0 && Butterfly_xin2[1] == 1)
				Xin2_i = Butterfly_xin2[DATA_INPUT_WITDH+1:2] + 1;
			else if(Butterfly_xin2[DATA_INPUT_WITDH+1] == 0 && Butterfly_xin2[1] == 0)
				Xin2_i = Butterfly_xin2[DATA_INPUT_WITDH+1:2];
			else if(Butterfly_xin2[DATA_INPUT_WITDH+1] == 1 && Butterfly_xin2[1:0] > 2'b10)
				Xin2_i = Butterfly_xin2[DATA_INPUT_WITDH+1:2] + 1;
			else
				Xin2_i = Butterfly_xin2[DATA_INPUT_WITDH+1:2];
		end
	else if(Carry_ML == 1)
		begin
			if(Butterfly_xin2[DATA_INPUT_WITDH+1] == 0 && Butterfly_xin2[0] == 1)
				Xin2_i = {Butterfly_xin2[DATA_INPUT_WITDH+1],Butterfly_xin2[DATA_INPUT_WITDH-1:1]} + 1;
			else
				Xin2_i = {Butterfly_xin2[DATA_INPUT_WITDH+1],Butterfly_xin2[DATA_INPUT_WITDH-1:1]};
		end
	else
		Xin2_i = {Butterfly_xin2[DATA_INPUT_WITDH+1],Butterfly_xin2[DATA_INPUT_WITDH-2:0]};
end

// -----------------------------------------------------------------------------------
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Mult_rr <= 'd0;
	else
		Mult_rr <= Twiddle_r * Xin2_r;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Mult_ii <= 'd0;
	else
		Mult_ii <= Twiddle_i * Xin2_i;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Mult_ri <= 'd0;
	else
		Mult_ri <= Twiddle_r * Xin2_i;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Mult_ir <= 'd0;
	else
		Mult_ir <= Twiddle_i * Xin2_r;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			Xin1_r_buf1 <= 'd0;
			Xin1_r_buf2 <= 'd0;
		end
	else
		begin
			Xin1_r_buf1 <= Xin1_r;
			Xin1_r_buf2 <= Xin1_r_buf1;
		end
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			Xin1_i_buf1 <= 'd0;
			Xin1_i_buf2 <= 'd0;
		end
	else
		begin
			Xin1_i_buf1 <= Xin1_i;
			Xin1_i_buf2 <= Xin1_i_buf1;
		end
end

// ---------------------------------------------------------------------------
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Mult_rr1 <= 'd0;
	else if(Mult_rr[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 0 && Mult_rr[TWIDDLE_WITDH-2] == 1)
		Mult_rr1 <= {Mult_rr[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_rr[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]} + 'd1;
	else if(Mult_rr[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 0 && Mult_rr[TWIDDLE_WITDH-2] == 0)
		Mult_rr1 <= {Mult_rr[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_rr[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]};
	else if(Mult_rr[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 1 && Mult_rr[TWIDDLE_WITDH-2:0] > 15'h4000)
		Mult_rr1 <= {Mult_rr[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_rr[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]} + 'd1;
	else if(Mult_rr[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 1)
		Mult_rr1 <= {Mult_rr[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_rr[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]};
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Mult_ii1 <= 'd0;
	else if(Mult_ii[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 0 && Mult_ii[TWIDDLE_WITDH-2] == 1)
		Mult_ii1 <= {Mult_ii[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_ii[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]} + 'd1;
	else if(Mult_ii[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 0 && Mult_ii[TWIDDLE_WITDH-2] == 0)
		Mult_ii1 <= {Mult_ii[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_ii[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]};
	else if(Mult_ii[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 1 && Mult_ii[TWIDDLE_WITDH-2:0] > 15'h4000)
		Mult_ii1 <= {Mult_ii[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_ii[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]} + 'd1;
	else if(Mult_ii[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 1)
		Mult_ii1 <= {Mult_ii[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_ii[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]};
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Mult_ri1 <= 'd0;
	else if(Mult_ri[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 0 && Mult_ri[TWIDDLE_WITDH-2] == 1)
		Mult_ri1 <= {Mult_ri[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_ri[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]} + 'd1;
	else if(Mult_ri[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 0 && Mult_ri[TWIDDLE_WITDH-2] == 0)
		Mult_ri1 <= {Mult_ri[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_ri[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]};
	else if(Mult_ri[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 1 && Mult_ri[TWIDDLE_WITDH-2:0] > 15'h4000)
		Mult_ri1 <= {Mult_ri[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_ri[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]} + 'd1;
	else if(Mult_ri[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 1)
		Mult_ri1 <= {Mult_ri[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_ri[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]};
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Mult_ir1 <= 'd0;
	else if(Mult_ir[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 0 && Mult_ir[TWIDDLE_WITDH-2] == 1)
		Mult_ir1 <= {Mult_ir[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_ir[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]} + 'd1;
	else if(Mult_ir[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 0 && Mult_ir[TWIDDLE_WITDH-2] == 0)
		Mult_ir1 <= {Mult_ir[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_ir[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]};
	else if(Mult_ir[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 1 && Mult_ir[TWIDDLE_WITDH-2:0] > 15'h4000)
		Mult_ir1 <= {Mult_ir[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_ir[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]} + 'd1;
	else if(Mult_ir[TWIDDLE_WITDH+DATA_INPUT_WITDH-1] == 1)
		Mult_ir1 <= {Mult_ir[TWIDDLE_WITDH+DATA_INPUT_WITDH-1],Mult_ir[TWIDDLE_WITDH+DATA_INPUT_WITDH-3:TWIDDLE_WITDH-1]};
end

// ---------------------------------------------------------------------------
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Xout1_r <= 'd0;
	else
		Xout1_r <= {{2{Xin1_r_buf2[DATA_INPUT_WITDH-1]}},Xin1_r_buf2} + {{2{Mult_rr1[DATA_INPUT_WITDH-1]}},Mult_rr1} - {{2{Mult_ii1[DATA_INPUT_WITDH-1]}},Mult_ii1};
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Xout1_i <= 'd0;
	else
		Xout1_i <= {{2{Xin1_i_buf2[DATA_INPUT_WITDH-1]}},Xin1_i_buf2} + {{2{Mult_ri1[DATA_INPUT_WITDH-1]}},Mult_ri1} + {{2{Mult_ir1[DATA_INPUT_WITDH-1]}},Mult_ir1};
end
		
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Xout2_r <= 'd0;
	else
		Xout2_r <= {{2{Xin1_r_buf2[DATA_INPUT_WITDH-1]}},Xin1_r_buf2} - {{2{Mult_rr1[DATA_INPUT_WITDH-1]}},Mult_rr1} + {{2{Mult_ii1[DATA_INPUT_WITDH-1]}},Mult_ii1};
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Xout2_i <= 'd0;
	else
		Xout2_i <= {{2{Xin1_i_buf2[DATA_INPUT_WITDH-1]}},Xin1_i_buf2} - {{2{Mult_ri1[DATA_INPUT_WITDH-1]}},Mult_ri1} - {{2{Mult_ir1[DATA_INPUT_WITDH-1]}},Mult_ir1};
end

// ---------------------------------------------------------------------------
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Butterfly_xout1 <= 'd0;
	else
		Butterfly_xout1 <= {Xout1_r,Xout1_i};
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Butterfly_xout2 <= 'd0;
	else
		Butterfly_xout2 <= {Xout2_r,Xout2_i};
end

// ---------------------------------------------------------------------------
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			Butfly_Wr1 <= 1'd0;
			Butfly_Wr2 <= 1'd0;
			Butfly_Wr3 <= 1'd0;
			Butfly_Wr4 <= 1'd0;
		end
	else
		begin
			Butfly_Wr1 <= Butfly_Wr;
			Butfly_Wr2 <= Butfly_Wr1;
			Butfly_Wr3 <= Butfly_Wr2;
			Butfly_Wr4 <= Butfly_Wr3;
		end
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Carry_ML_flag1 <= 1'd0;
	else if(Butfly_Wr1 == 0 && Butfly_Wr2 == 1 || source_end == 1)
		Carry_ML_flag1 <= 1'd0;
	else if((Xout1_r[DATA_INPUT_WITDH+1] == 0 && Xout1_r[DATA_INPUT_WITDH-1] == 1) || (Xout1_i[DATA_INPUT_WITDH+1] == 0 && Xout1_i[DATA_INPUT_WITDH-1] == 1)
			|| (Xout1_r[DATA_INPUT_WITDH+1] == 1 && Xout1_r[DATA_INPUT_WITDH-1] == 0) || (Xout1_i[DATA_INPUT_WITDH+1] == 1 && Xout1_i[DATA_INPUT_WITDH-1] == 0)
			|| (Xout2_r[DATA_INPUT_WITDH+1] == 0 && Xout2_r[DATA_INPUT_WITDH-1] == 1) || (Xout2_i[DATA_INPUT_WITDH+1] == 0 && Xout2_i[DATA_INPUT_WITDH-1] == 1)
			|| (Xout2_r[DATA_INPUT_WITDH+1] == 1 && Xout2_r[DATA_INPUT_WITDH-1] == 0) || (Xout2_i[DATA_INPUT_WITDH+1] == 1 && Xout2_i[DATA_INPUT_WITDH-1] == 0))
		Carry_ML_flag1 <= 1'd1;
	else
		Carry_ML_flag1 <= Carry_ML_flag1;
end
assign source_exp_ml = Carry_ML_flag1;

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Carry_MH_flag1 <= 1'd0;
	else if(Butfly_Wr1 == 0 && Butfly_Wr2 == 1 || source_end == 1)
		Carry_MH_flag1 <= 1'd0;
	else if((Xout1_r[DATA_INPUT_WITDH+1] == 0 && Xout1_r[DATA_INPUT_WITDH] == 1) || (Xout1_i[DATA_INPUT_WITDH+1] == 0 && Xout1_i[DATA_INPUT_WITDH] == 1)
			|| (Xout1_r[DATA_INPUT_WITDH+1] == 1 && Xout1_r[DATA_INPUT_WITDH] == 0) || (Xout1_i[DATA_INPUT_WITDH+1] == 1 && Xout1_i[DATA_INPUT_WITDH] == 0)
			|| (Xout2_r[DATA_INPUT_WITDH+1] == 0 && Xout2_r[DATA_INPUT_WITDH] == 1) || (Xout2_i[DATA_INPUT_WITDH+1] == 0 && Xout2_i[DATA_INPUT_WITDH] == 1)
			|| (Xout2_r[DATA_INPUT_WITDH+1] == 1 && Xout2_r[DATA_INPUT_WITDH] == 0) || (Xout2_i[DATA_INPUT_WITDH+1] == 1 && Xout2_i[DATA_INPUT_WITDH] == 0))
		Carry_MH_flag1 <= 1'd1;
	else
		Carry_MH_flag1 <= Carry_MH_flag1;
end
assign source_exp_mh = Carry_MH_flag1;

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			Carry_MH_flag <= 1'd0;
			Carry_ML_flag <= 1'd0;
		end
	else if(Current_state == FFT_STATE_FIRST && Stage_Cnt == 2)
		begin
			Carry_MH_flag <= 1'd0;
			Carry_ML_flag <= 1'd0;
		end
	else if(Butfly_Wr == 0 && Butfly_Wr1 == 1)
		begin
			Carry_MH_flag <= Carry_MH_flag1;
			Carry_ML_flag <= Carry_ML_flag1;
		end
	else
		begin
			Carry_MH_flag <= Carry_MH_flag;
			Carry_ML_flag <= Carry_ML_flag;
		end
end




wire	signed[DATA_INPUT_WITDH+1:0]					Xin1_It;
wire	signed[DATA_INPUT_WITDH+1:0]					Xin1_Qt;
wire	signed[DATA_INPUT_WITDH+1:0]					Xin2_It;
wire	signed[DATA_INPUT_WITDH+1:0]					Xin2_Qt;
assign Xin1_It = Butterfly_xin1[2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+2];
assign Xin1_Qt = Butterfly_xin1[DATA_INPUT_WITDH+1:0];
assign Xin2_It = Butterfly_xin2[2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+2];
assign Xin2_Qt = Butterfly_xin2[DATA_INPUT_WITDH+1:0];

endmodule
// -------------------------------------------------------------------------------