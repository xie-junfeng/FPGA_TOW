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


module  Pruning_Butfly_Process
#(
	parameter DATA_INPUT_WITDH	= 12,
	parameter TWIDDLE_PRECISION	= 16,
	parameter LOG2_FFT_LEN		= 11,
	parameter PEAK_NUM			= 2
)
(
	input	wire							clk,
	input	wire							reset_n,
	input	wire							Repeat_Peak_en,
	input	wire							mem_switch,
	input	wire							source_eop,
	input	signed[DATA_INPUT_WITDH-1:0]	sink_real,
	input	signed[DATA_INPUT_WITDH-1:0]	sink_imag,
	input	wire [3:0]						Current_state,
	input	wire [LOG2_FFT_LEN:0]			Repeat_Cnt,
	input	wire [4:0]						FFT_stage,
	input	wire [31:0]						Stage_Cnt,
	input	wire [31:0]						Addr_xout_32b,
	input	wire [LOG2_FFT_LEN-1:0]			Addr_xout,
	input	wire [31:0]						Stage_Cnt_Peak,
	input	wire [2*TWIDDLE_PRECISION-1:0]	Twiddle_factor0,
	input	wire [2*TWIDDLE_PRECISION-1:0]	Twiddle_factor1,
	
	input	wire [LOG2_FFT_LEN-4:0]			Butfly_waddr_a,
	input	wire [LOG2_FFT_LEN-4:0]			Butfly_waddr_b,
	
	input	wire [LOG2_FFT_LEN-4:0]			Butfly_raddr_a,
	input	wire [LOG2_FFT_LEN-4:0]			Butfly_raddr_b,
	output	wire							source_exp_ml,
	output	wire							source_exp_mh,
	output	reg								Result_Cache_Wr,
	output	reg  [4:0]						source_exp,
	output	reg  [DATA_INPUT_WITDH*2+3:0]	dpr0_q_a,
	output	reg  [DATA_INPUT_WITDH*2+3:0]	dpr1_q_a
);

// -----------------------------------------------------------------
//* FSM
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

localparam	DPRAM_LEN			= 2**(LOG2_FFT_LEN-3)-1;
localparam	DPRAM_LEN_DIV2		= 2**(LOG2_FFT_LEN-4)-1;
localparam	ADDR_DPRAM0			= 2**(LOG2_FFT_LEN-3);
localparam	ADDR_DPRAM1			= 2**(LOG2_FFT_LEN-3)*2;
localparam	ADDR_DPRAM2			= 2**(LOG2_FFT_LEN-3)*3;
localparam	ADDR_DPRAM3			= 2**(LOG2_FFT_LEN-3)*4;
localparam	ADDR_DPRAM4			= 2**(LOG2_FFT_LEN-3)*5;
localparam	ADDR_DPRAM5			= 2**(LOG2_FFT_LEN-3)*6;
localparam	ADDR_DPRAM6			= 2**(LOG2_FFT_LEN-3)*7;
localparam	ADDR_DPRAM7			= 2**(LOG2_FFT_LEN-3)*8;

// -----------------------------------------------------------------
//* REG
reg								Butfly_Wr;
reg								Butfly_Wr1;
reg								Butfly_vaild;
reg	[7:0]						Flip_Wr_dpram;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram[7:0];

reg [LOG2_FFT_LEN-1:0]			source_addr_r0;
reg [LOG2_FFT_LEN-1:0]			source_addr_r1;
reg [LOG2_FFT_LEN-1:0]			source_addr_r2;
// Butfly
reg [2*DATA_INPUT_WITDH+3:0]	Butfly_qa_x1[7:0];
reg [2*DATA_INPUT_WITDH+3:0]	Butfly_qb_x2[7:0];
reg [2*TWIDDLE_PRECISION-1:0]	Twiddle_Wn[7:0];
reg [2*DATA_INPUT_WITDH+3:0]	Dpram_Butfly_X1[7:0];
reg [2*DATA_INPUT_WITDH+3:0]	Dpram_Butfly_X2[7:0];
reg [2*DATA_INPUT_WITDH+3:0]	Butterfly_rslt1[7:0];
reg [2*DATA_INPUT_WITDH+3:0]	Butterfly_rslt2[7:0];

// -----------------------------------------------------------------
//* WIRE
wire[31:0]						ADDR_DPRAM[7:0];
wire[2*TWIDDLE_PRECISION-1:0]	Twiddle_factor_Third[7:0];
wire[2*TWIDDLE_PRECISION-1:0]	Twiddle_factor_Fourth[7:0];
wire[2*TWIDDLE_PRECISION-1:0]	Twiddle_factor_Fifth[7:0];
// Butfly0
wire							Carry_MH_flag;
wire							Carry_ML_flag;
wire[7:0]						source_exp_mladd;
wire[7:0]						source_exp_mhadd;
wire[7:0]						Carry_MH_flag_r0;
wire[7:0]						Carry_ML_flag_r0;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram_q0_a[7:0];
wire[DATA_INPUT_WITDH*2+3:0]	Dpram_q0_b[7:0];
wire[DATA_INPUT_WITDH*2+3:0]	Dpram_q1_a[7:0];
wire[DATA_INPUT_WITDH*2+3:0]	Dpram_q1_b[7:0];
wire[DATA_INPUT_WITDH*2+3:0]	Dpram_q2_a[7:0];
wire[DATA_INPUT_WITDH*2+3:0]	Dpram_q2_b[7:0];
wire[DATA_INPUT_WITDH*2+3:0]	Butfly_x1_m0[7:0];
wire[DATA_INPUT_WITDH*2+3:0]	Butfly_x2_m0[7:0];
wire[DATA_INPUT_WITDH*2+3:0]	Butfly_x1_m1[7:0];
wire[DATA_INPUT_WITDH*2+3:0]	Butfly_x2_m1[7:0];
wire[2*DATA_INPUT_WITDH+3:0]	Dpram_Butterfly1[7:0];
wire[2*DATA_INPUT_WITDH+3:0]	Dpram_Butterfly2[7:0];

// -----------------------------------------------------------------
genvar	k;
genvar	j;
genvar	i;

// -----------------------------------------------------------------
assign ADDR_DPRAM[0] = ADDR_DPRAM0;
assign ADDR_DPRAM[1] = ADDR_DPRAM1;
assign ADDR_DPRAM[2] = ADDR_DPRAM2;
assign ADDR_DPRAM[3] = ADDR_DPRAM3;
assign ADDR_DPRAM[4] = ADDR_DPRAM4;
assign ADDR_DPRAM[5] = ADDR_DPRAM5;
assign ADDR_DPRAM[6] = ADDR_DPRAM6;
assign ADDR_DPRAM[7] = ADDR_DPRAM7;
assign Twiddle_factor_Third[0] = Twiddle_factor0;
assign Twiddle_factor_Third[1] = Twiddle_factor1;
assign Twiddle_factor_Third[2] = Twiddle_factor0;
assign Twiddle_factor_Third[3] = Twiddle_factor1;
assign Twiddle_factor_Third[4] = Twiddle_factor0;
assign Twiddle_factor_Third[5] = Twiddle_factor1;
assign Twiddle_factor_Third[6] = Twiddle_factor0;
assign Twiddle_factor_Third[7] = Twiddle_factor1;
assign Twiddle_factor_Fourth[0] = Twiddle_factor0;
assign Twiddle_factor_Fourth[1] = Twiddle_factor1;
assign Twiddle_factor_Fourth[2] = Twiddle_factor0;
assign Twiddle_factor_Fourth[3] = Twiddle_factor1;
assign Twiddle_factor_Fourth[4] = 32'd0;
assign Twiddle_factor_Fourth[5] = 32'd0;
assign Twiddle_factor_Fourth[6] = 32'd0;
assign Twiddle_factor_Fourth[7] = 32'd0;
assign Twiddle_factor_Fifth[0] = Twiddle_factor0;
assign Twiddle_factor_Fifth[1] = Twiddle_factor1;
assign Twiddle_factor_Fifth[2] = 32'd0;
assign Twiddle_factor_Fifth[3] = 32'd0;
assign Twiddle_factor_Fifth[4] = 32'd0;
assign Twiddle_factor_Fifth[5] = 32'd0;
assign Twiddle_factor_Fifth[6] = 32'd0;
assign Twiddle_factor_Fifth[7] = 32'd0;

assign Butfly_x1_m0[0] = Dpram_q1_a[0];
assign Butfly_x2_m0[0] = Dpram_q1_a[1];
assign Butfly_x1_m0[1] = Dpram_q1_b[0];
assign Butfly_x2_m0[1] = Dpram_q1_b[1];
assign Butfly_x1_m0[2] = Dpram_q1_a[2];
assign Butfly_x2_m0[2] = Dpram_q1_a[3];
assign Butfly_x1_m0[3] = Dpram_q1_b[2];
assign Butfly_x2_m0[3] = Dpram_q1_b[3];
assign Butfly_x1_m0[4] = Dpram_q1_a[4];
assign Butfly_x2_m0[4] = Dpram_q1_a[5];
assign Butfly_x1_m0[5] = Dpram_q1_b[4];
assign Butfly_x2_m0[5] = Dpram_q1_b[5];
assign Butfly_x1_m0[6] = Dpram_q1_a[6];
assign Butfly_x2_m0[6] = Dpram_q1_a[7];
assign Butfly_x1_m0[7] = Dpram_q1_b[6];
assign Butfly_x2_m0[7] = Dpram_q1_b[7];

assign Butfly_x1_m1[0] = Dpram_q0_a[0];
assign Butfly_x2_m1[0] = Dpram_q0_a[1];
assign Butfly_x1_m1[1] = Dpram_q0_b[0];
assign Butfly_x2_m1[1] = Dpram_q0_b[1];
assign Butfly_x1_m1[2] = Dpram_q0_a[2];
assign Butfly_x2_m1[2] = Dpram_q0_a[3];
assign Butfly_x1_m1[3] = Dpram_q0_b[2];
assign Butfly_x2_m1[3] = Dpram_q0_b[3];
assign Butfly_x1_m1[4] = Dpram_q0_a[4];
assign Butfly_x2_m1[4] = Dpram_q0_a[5];
assign Butfly_x1_m1[5] = Dpram_q0_b[4];
assign Butfly_x2_m1[5] = Dpram_q0_b[5];
assign Butfly_x1_m1[6] = Dpram_q0_a[6];
assign Butfly_x2_m1[6] = Dpram_q0_a[7];
assign Butfly_x1_m1[7] = Dpram_q0_b[6];
assign Butfly_x2_m1[7] = Dpram_q0_b[7];

assign source_exp_ml = source_exp_mladd[0] | source_exp_mladd[1] | source_exp_mladd[2] | source_exp_mladd[3] | source_exp_mladd[4] | source_exp_mladd[5] | source_exp_mladd[6] | source_exp_mladd[7];
assign source_exp_mh = source_exp_mhadd[0] | source_exp_mhadd[1] | source_exp_mhadd[2] | source_exp_mhadd[3] | source_exp_mhadd[4] | source_exp_mhadd[5] | source_exp_mhadd[6] | source_exp_mhadd[7];
assign Carry_MH_flag = Carry_MH_flag_r0[0] | Carry_MH_flag_r0[1] | Carry_MH_flag_r0[2] | Carry_MH_flag_r0[3] | Carry_MH_flag_r0[4] | Carry_MH_flag_r0[5] | Carry_MH_flag_r0[6] | Carry_MH_flag_r0[7];
assign Carry_ML_flag = Carry_ML_flag_r0[0] | Carry_ML_flag_r0[1] | Carry_ML_flag_r0[2] | Carry_ML_flag_r0[3] | Carry_ML_flag_r0[4] | Carry_ML_flag_r0[5] | Carry_ML_flag_r0[6] | Carry_ML_flag_r0[7];
// -----------------------------------------------------------------
//* Butterfly Ctrl
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Butfly_Wr <= 1'd0;
	else if(Current_state == FFT_STATE_FIRST)
		begin
			if(Stage_Cnt >= 8 && Stage_Cnt <= DPRAM_LEN+8)
				Butfly_Wr <= 1'd1;
			else
				Butfly_Wr <= 1'd0;
		end
	else if(Current_state == FFT_STATE_SECOND)
		begin
			if(Stage_Cnt >= 8 && Stage_Cnt <= Stage_Cnt_Peak+8)
				Butfly_Wr <= 1'd1;
			else
				Butfly_Wr <= 1'd0;
		end
	else if(Current_state == FFT_STATE_THIRD)
		begin
			if(Stage_Cnt == 7)
				Butfly_Wr <= 1'd1;
			else
				Butfly_Wr <= 1'd0;
		end
	else if(Current_state == FFT_STATE_FOURTH)
		begin
			if(Stage_Cnt == 5)
				Butfly_Wr <= 1'd1;
			else
				Butfly_Wr <= 1'd0;
		end
	else if(Current_state == FFT_STATE_FIFTH)
		begin
			if(Stage_Cnt == 5)
				Butfly_Wr <= 1'd1;
			else
				Butfly_Wr <= 1'd0;
		end
	else
		Butfly_Wr <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Butfly_vaild <= 1'd0;
	else if(Current_state == FFT_STATE_FIRST)
		begin
			if(Stage_Cnt >= 2 && Stage_Cnt <= DPRAM_LEN+2)
				Butfly_vaild <= 1'd1;
			else
				Butfly_vaild <= 1'd0;
		end
	else if(Current_state == FFT_STATE_SECOND)
		begin
			if(Stage_Cnt >= 2 && Stage_Cnt <= Stage_Cnt_Peak+2)
				Butfly_vaild <= 1'd1;
			else
				Butfly_vaild <= 1'd0;
		end
	else if(Current_state == FFT_STATE_THIRD)
		begin
			if(Stage_Cnt == 2)
				Butfly_vaild <= 1'd1;
			else
				Butfly_vaild <= 1'd0;
		end
	else
		Butfly_vaild <= 1'd0;
end

reg		Cnt;
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Cnt <= 0;
	else if(Butfly_vaild == 1)
		Cnt <= Cnt + 1;
	else
		Cnt <= 0;
end

generate
	for(j=0;j<8;j=j+1)
		begin : Twiddle_Wn_ctrl
			always@(posedge clk or negedge reset_n)
			begin
				if(!reset_n)
					Twiddle_Wn[j] <= 'd0;
				else if((Current_state == FFT_STATE_FIRST || Current_state == FFT_STATE_SECOND) && Butfly_vaild == 1)
					begin
						if(Cnt == 0)
							Twiddle_Wn[j] <= Twiddle_factor0;
						else
							Twiddle_Wn[j] <= Twiddle_factor1;
					end
				else if(Current_state == FFT_STATE_THIRD)
					Twiddle_Wn[j] <= Twiddle_factor_Third[j];
				else if(Current_state == FFT_STATE_FOURTH)
					Twiddle_Wn[j] <= Twiddle_factor_Fourth[j];
				else if(Current_state == FFT_STATE_FIFTH)
					Twiddle_Wn[j] <= Twiddle_factor_Fifth[j];
				else
					Twiddle_Wn[j] <= 'd0;
			end
		end
endgenerate

generate
	for(j=0;j<8;j=j+1)
		begin : Butfly_qa_x
			always@(posedge clk or negedge reset_n)
			begin
				if(!reset_n)
					begin
						Butfly_qa_x1[j] <= 'd0;
						Butfly_qb_x2[j] <= 'd0;
					end
				else if(Current_state == FFT_STATE_FIRST && Butfly_vaild == 1)
					begin
						if(Repeat_Peak_en == 0)
							begin
								if(Repeat_Cnt == 0)
									begin
										if(mem_switch == 0)
											begin
												Butfly_qa_x1[j] <= Dpram_q1_a[j];
												Butfly_qb_x2[j] <= Dpram_q1_b[j];
											end
										else
											begin
												Butfly_qa_x1[j] <= Dpram_q0_a[j];
												Butfly_qb_x2[j] <= Dpram_q0_b[j];
											end
									end
								else
									begin
										Butfly_qa_x1[j] <= Dpram_q2_a[j];
										Butfly_qb_x2[j] <= Dpram_q2_b[j];
									end
							end
						else
							begin
								Butfly_qa_x1[j] <= Dpram_q2_a[j];
								Butfly_qb_x2[j] <= Dpram_q2_b[j];
							end
					end
				else if(Current_state == FFT_STATE_SECOND && Butfly_vaild == 1)
					begin
						if(mem_switch == 0)
							begin
								Butfly_qa_x1[j] <= Dpram_q1_a[j];
								Butfly_qb_x2[j] <= Dpram_q1_b[j];
							end
						else
							begin
								Butfly_qa_x1[j] <= Dpram_q0_a[j];
								Butfly_qb_x2[j] <= Dpram_q0_b[j];
							end
					end
				else if(Current_state == FFT_STATE_THIRD && Butfly_vaild == 1)
					begin
						if(mem_switch == 0)
							begin
								Butfly_qa_x1[j] <= Butfly_x1_m0[j];
								Butfly_qb_x2[j] <= Butfly_x2_m0[j];
							end
						else
							begin
								Butfly_qa_x1[j] <= Butfly_x1_m1[j];
								Butfly_qb_x2[j] <= Butfly_x2_m1[j];
							end
					end
				else if((Current_state == FFT_STATE_FOURTH || Current_state == FFT_STATE_FIFTH) && Stage_Cnt == 1)
					begin
						Butfly_qa_x1[j] <= Butterfly_rslt1[j];
						Butfly_qb_x2[j] <= Butterfly_rslt2[j];
					end
				else
					begin
						Butfly_qa_x1[j] <= 'd0;
						Butfly_qb_x2[j] <= 'd0;
					end
			end
			
			always@(posedge clk or negedge reset_n)
			begin
				if(!reset_n)
					begin
						Dpram_Butfly_X1[j] <= 'd0;
						Dpram_Butfly_X2[j] <= 'd0;
					end
				else if(Current_state == FFT_STATE_FIRST || Current_state == FFT_STATE_SECOND)
					begin
						Dpram_Butfly_X1[j] <= Dpram_Butterfly1[j];
						Dpram_Butfly_X2[j] <= Dpram_Butterfly2[j];
					end
				else
					begin
						Dpram_Butfly_X1[j] <= 'd0;
						Dpram_Butfly_X2[j] <= 'd0;
					end
			end
		end
endgenerate

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			Butterfly_rslt1[0] <= 'd0; Butterfly_rslt2[0] <= 'd0;
			Butterfly_rslt1[1] <= 'd0; Butterfly_rslt2[1] <= 'd0;
			Butterfly_rslt1[2] <= 'd0; Butterfly_rslt2[2] <= 'd0;
			Butterfly_rslt1[3] <= 'd0; Butterfly_rslt2[3] <= 'd0;
			Butterfly_rslt1[4] <= 'd0; Butterfly_rslt2[4] <= 'd0;
			Butterfly_rslt1[5] <= 'd0; Butterfly_rslt2[5] <= 'd0;
			Butterfly_rslt1[6] <= 'd0; Butterfly_rslt2[6] <= 'd0;
			Butterfly_rslt1[7] <= 'd0; Butterfly_rslt2[7] <= 'd0;
		end
	else if(Current_state == FFT_STATE_THIRD && Butfly_Wr == 1)
		begin
			Butterfly_rslt1[0] <= Dpram_Butterfly1[0];	Butterfly_rslt2[0] <= Dpram_Butterfly1[2];
			Butterfly_rslt1[1] <= Dpram_Butterfly1[1];	Butterfly_rslt2[1] <= Dpram_Butterfly1[3];
			Butterfly_rslt1[2] <= Dpram_Butterfly1[4];	Butterfly_rslt2[2] <= Dpram_Butterfly1[6];
			Butterfly_rslt1[3] <= Dpram_Butterfly1[5];	Butterfly_rslt2[3] <= Dpram_Butterfly1[7];
			Butterfly_rslt1[4] <= 'd0;					Butterfly_rslt2[4] <= 'd0;
			Butterfly_rslt1[5] <= 'd0;					Butterfly_rslt2[5] <= 'd0;
			Butterfly_rslt1[6] <= 'd0;					Butterfly_rslt2[6] <= 'd0;
			Butterfly_rslt1[7] <= 'd0;					Butterfly_rslt2[7] <= 'd0;
		end
	else if(Current_state == FFT_STATE_FOURTH && Butfly_Wr == 1)
		begin
			Butterfly_rslt1[0] <= Dpram_Butterfly1[0];	Butterfly_rslt2[0] <= Dpram_Butterfly1[2];
			Butterfly_rslt1[1] <= Dpram_Butterfly1[1];	Butterfly_rslt2[1] <= Dpram_Butterfly1[3];
			Butterfly_rslt1[2] <= 'd0;					Butterfly_rslt2[2] <= 'd0;
			Butterfly_rslt1[3] <= 'd0;					Butterfly_rslt2[3] <= 'd0;
			Butterfly_rslt1[4] <= 'd0;					Butterfly_rslt2[4] <= 'd0;
			Butterfly_rslt1[5] <= 'd0;					Butterfly_rslt2[5] <= 'd0;
			Butterfly_rslt1[6] <= 'd0;					Butterfly_rslt2[6] <= 'd0;
			Butterfly_rslt1[7] <= 'd0;					Butterfly_rslt2[7] <= 'd0;
		end
	else
		begin
			Butterfly_rslt1[0] <= Butterfly_rslt1[0];	Butterfly_rslt2[0] <= Butterfly_rslt2[0];
			Butterfly_rslt1[1] <= Butterfly_rslt1[1];	Butterfly_rslt2[1] <= Butterfly_rslt2[1];
			Butterfly_rslt1[2] <= Butterfly_rslt1[2];	Butterfly_rslt2[2] <= Butterfly_rslt2[2];
			Butterfly_rslt1[3] <= Butterfly_rslt1[3];	Butterfly_rslt2[3] <= Butterfly_rslt2[3];
			Butterfly_rslt1[4] <= Butterfly_rslt1[4];	Butterfly_rslt2[4] <= Butterfly_rslt2[4];
			Butterfly_rslt1[5] <= Butterfly_rslt1[5];	Butterfly_rslt2[5] <= Butterfly_rslt2[5];
			Butterfly_rslt1[6] <= Butterfly_rslt1[6];	Butterfly_rslt2[6] <= Butterfly_rslt2[6];
			Butterfly_rslt1[7] <= Butterfly_rslt1[7];	Butterfly_rslt2[7] <= Butterfly_rslt2[7];
		end
end

// -----------------------------------------------------------------
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			dpr0_q_a <= 'd0;
			dpr1_q_a <= 'd0;
		end
	else if(Current_state == FFT_STATE_FIFTH && Butfly_Wr == 1)
		begin
			dpr0_q_a <= Dpram_Butterfly1[0];
			dpr1_q_a <= Dpram_Butterfly1[1];
		end
	else
		begin
			dpr0_q_a <= dpr0_q_a;
			dpr1_q_a <= dpr1_q_a;
		end
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Result_Cache_Wr <= 1'd0;
	else if(Current_state == FFT_STATE_FIFTH && Butfly_Wr == 1)
		Result_Cache_Wr <= Butfly_Wr;
	else
		Result_Cache_Wr <= 1'd0;
end

// -----------------------------------------------------------------
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Wr_dpram[0] <= 1'd0;
	else if(Addr_xout_32b < ADDR_DPRAM[0])
		Flip_Wr_dpram[0] <= 1'd1;
	else
		Flip_Wr_dpram[0] <= 1'd0;
end
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Addr_dpram[0] <= 'd0;
	else if(Addr_xout_32b < ADDR_DPRAM[0])
		Flip_Addr_dpram[0] <= Addr_xout;
	else
		Flip_Addr_dpram[0] <= Flip_Addr_dpram[0];
end

generate
	for(j=1;j<8;j=j+1)
		begin : Dpram_Wr_ctrl
			always@(posedge clk or negedge reset_n)
			begin
				if(!reset_n)
					Flip_Wr_dpram[j] <= 1'd0;
				else if(Addr_xout_32b >= ADDR_DPRAM[j-1] && Addr_xout_32b < ADDR_DPRAM[j])
					Flip_Wr_dpram[j] <= 1'd1;
				else
					Flip_Wr_dpram[j] <= 1'd0;
			end
			
			always@(posedge clk or negedge reset_n)
			begin
				if(!reset_n)
					Flip_Addr_dpram[j] <= 'd0;
				else if(Addr_xout_32b >= ADDR_DPRAM[j-1] && Addr_xout_32b < ADDR_DPRAM[j])
					Flip_Addr_dpram[j] <= Addr_xout-ADDR_DPRAM[j-1];
				else
					Flip_Addr_dpram[j] <= Flip_Addr_dpram[j];
			end
		end
endgenerate

// -----------------------------------------------------------------
generate
	for(i=0;i<8;i=i+1)
		begin : Butfly_proc
			Pruning_Dpram_Ctrl
				#(
					.DATA_INPUT_WITDH		( DATA_INPUT_WITDH ),
					.LOG2_FFT_LEN			( LOG2_FFT_LEN )
				)
			Pruning_Dpram_Ctrl_Init
				(
					.clk					( clk ),
					.reset_n				( reset_n ),
					.mem_switch				( mem_switch ),//
					.Current_state			( Current_state ),
					.Repeat_Cnt				( Repeat_Cnt ),
					.Repeat_Peak_en			( Repeat_Peak_en ),
					
					.sink_valid				( Flip_Wr_dpram[i] ),
					.sink_addr				( Flip_Addr_dpram[i] ),
					.sink_data				( {{2{sink_real[DATA_INPUT_WITDH-1]}},sink_real,{2{sink_imag[DATA_INPUT_WITDH-1]}},sink_imag} ),
					.Butfly_raddr_a			( Butfly_raddr_a ),
					.Butfly_raddr_b			( Butfly_raddr_b ),

					.Butfly_Wr				( Butfly_Wr ),
					.Butfly_addr_a			( Butfly_waddr_a ),
					.Butfly_addr_b			( Butfly_waddr_b ),
					.Butfly_data_a			( Dpram_Butfly_X1[i] ),
					.Butfly_data_b			( Dpram_Butfly_X2[i] ),

					//output
					.dpr0_q_a				( Dpram_q0_a[i] ),
					.dpr0_q_b				( Dpram_q0_b[i] ),
					.dpr1_q_a				( Dpram_q1_a[i] ),
					.dpr1_q_b				( Dpram_q1_b[i] ),
					.dpr2_q_a				( Dpram_q2_a[i] ),
					.dpr2_q_b				( Dpram_q2_b[i] )
				);

			Pruning_Butterfly
			#(
				.DATA_INPUT_WITDH	( DATA_INPUT_WITDH ),
				.TWIDDLE_WITDH		( TWIDDLE_PRECISION ),
				.LOG2_FFT_LEN		( LOG2_FFT_LEN )
			)
			Butterfly_Init
			(
				.clk				( clk ),
				.reset_n			( reset_n ),
				.Butfly_Wr			( Butfly_Wr ),
				.source_end			( source_eop ),
				.Carry_MH			( Carry_MH_flag ),
				.Carry_ML			( Carry_ML_flag ),
				.Current_state		( Current_state ),
				.Stage_Cnt			( Stage_Cnt ),
				.Butterfly_xin1		( Butfly_qa_x1[i] ),
				.Butterfly_xin2		( Butfly_qb_x2[i] ),
				.Twiddle_factor		( Twiddle_Wn[i] ),
				// .Repeat_Cnt			( Repeat_Cnt ),
				
				.source_exp_ml		( source_exp_mladd[i] ),
				.source_exp_mh		( source_exp_mhadd[i] ),
				.Carry_MH_flag		( Carry_MH_flag_r0[i] ),
				.Carry_ML_flag		( Carry_ML_flag_r0[i] ),
				.Butterfly_xout1	( Dpram_Butterfly1[i] ),
				.Butterfly_xout2	( Dpram_Butterfly2[i] )
			);
		end
endgenerate

// ---------------------------------------------------------------------------
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Butfly_Wr1 <= 1'd0;
	else
		Butfly_Wr1 <= Butfly_Wr;
end
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_exp <= 5'd0;
	else if(Butfly_Wr == 0 && Butfly_Wr1 == 1)
		begin
			if(source_exp_mh == 1)
				source_exp <= source_exp + 5'd2;
			else if(source_exp_ml == 1)
				source_exp <= source_exp + 5'd1;
			else
				source_exp <= source_exp;
		end
	else if(Current_state == FFT_STATE_FIRST && Stage_Cnt == 2)
		source_exp <= 5'd0;
	else
		source_exp <= source_exp;
end


//
//// ************************************************************************************
////* 向文件中写数
//integer  fd0,fd1;
//initial
//begin
//	fd0=$fopen("mid0_I.txt");
//	fd1=$fopen("mid0_Q.txt");
//end
//reg wr_glfg=0;
//always@(posedge clk)
//begin
//	if( Repeat_Cnt == 210 && Current_state == FFT_STATE_FIRST && Stage_Cnt >= 8 && Stage_Cnt <= 135 )
//		begin
//			wr_glfg <= 1;
//			$fdisplay(fd0,"%d",$signed(Dpram_Butterfly1[0][2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+2]));
//			$fdisplay(fd1,"%d",$signed(Dpram_Butterfly1[0][DATA_INPUT_WITDH+1:0]));
//		end
//	else
//		wr_glfg <= 0;
//end

endmodule

