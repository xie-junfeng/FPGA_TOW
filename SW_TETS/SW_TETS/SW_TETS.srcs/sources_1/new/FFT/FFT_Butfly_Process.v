`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 14:55:39
// Design Name: 
// Module Name: FFT_Butfly_Process
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


module  FFT_Butfly_Process
#(
	parameter DATA_INPUT_WITDH	= 12,
	parameter TWIDDLE_PRECISION	= 16,
	parameter LOG2_FFT_LEN		= 11
)
(
	input	wire							clk,
	input	wire							reset_n,
	input	wire							mem_switch,
	input	wire							source_eop,
	input	signed[DATA_INPUT_WITDH-1:0]	sink_real,
	input	signed[DATA_INPUT_WITDH-1:0]	sink_imag,
	input	wire [2:0]						Current_state,
	input	wire [4:0]						FFT_stage,
	input	wire [19:0]						Stage_Cnt,
	input	wire [19:0]						FFT_Cnt,
	input	wire [31:0]						Addr_xout_32b,
	input	wire [LOG2_FFT_LEN-1:0]			Addr_xout,
	input	wire [LOG2_FFT_LEN-1:0]			source_addr,
	input	wire [31:0]						Twiddle_factor0,
	input	wire [31:0]						Twiddle_factor1,
	input	wire [31:0]						Twiddle_factor2,
	input	wire [31:0]						Twiddle_factor3,
	input	wire [31:0]						Twiddle_factor4,
	input	wire [31:0]						Twiddle_factor5,
	input	wire [31:0]						Twiddle_factor6,
	input	wire [31:0]						Twiddle_factor7,
	
	input	wire [LOG2_FFT_LEN-4:0]			Butfly_waddr_a,
	input	wire [LOG2_FFT_LEN-4:0]			Butfly_waddr_b,
	
	input	wire [LOG2_FFT_LEN-4:0]			Butfly_raddr_a,
	input	wire [LOG2_FFT_LEN-4:0]			Butfly_raddr_b,
	output	wire							Carry_MH_flag,
	output	wire							Carry_ML_flag,
	output	reg  [DATA_INPUT_WITDH*2+3:0]	dpr0_q_a,
	output	reg  [DATA_INPUT_WITDH*2+3:0]	dpr1_q_a
);

// -----------------------------------------------------------------
//* FSM
localparam	FFT_STATE_RESET		= 3'b000;
localparam	FFT_STATE_READ		= 3'b001;
localparam	FFT_STATE_FIRST		= 3'b010;
localparam	FFT_STATE_SECOND	= 3'b011;
localparam	FFT_STATE_THIRD		= 3'b100;
localparam	FFT_STATE_FOURTH	= 3'b101;
localparam	FFT_STATE_TWIDDLE	= 3'b110;
localparam	FFT_STATE_END		= 3'b111;

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
reg								Butfly_vaild;
reg								Flip_Wr_dpram0;
reg								Flip_Wr_dpram1;
reg								Flip_Wr_dpram2;
reg								Flip_Wr_dpram3;
reg								Flip_Wr_dpram4;
reg								Flip_Wr_dpram5;
reg								Flip_Wr_dpram6;
reg								Flip_Wr_dpram7;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram0;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram1;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram2;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram3;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram4;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram5;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram6;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram7;
reg [LOG2_FFT_LEN-4:0]			source_addr0;
reg [LOG2_FFT_LEN-4:0]			source_addr1;
reg [LOG2_FFT_LEN-4:0]			source_addr2;
reg [LOG2_FFT_LEN-4:0]			source_addr3;
reg [LOG2_FFT_LEN-4:0]			source_addr4;
reg [LOG2_FFT_LEN-4:0]			source_addr5;
reg [LOG2_FFT_LEN-4:0]			source_addr6;
reg [LOG2_FFT_LEN-4:0]			source_addr7;
reg [LOG2_FFT_LEN-1:0]			source_addr_r0;
reg [LOG2_FFT_LEN-1:0]			source_addr_r1;
reg [LOG2_FFT_LEN-1:0]			source_addr_r2;
// Butfly0
reg [2*DATA_INPUT_WITDH+3:0]	Butfly0_qa_x1;
reg [2*DATA_INPUT_WITDH+3:0]	Butfly0_qb_x2;
reg [31:0]						Twiddle_W0;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram0_Butfly_X1;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram0_Butfly_X2;
// Butfly1
reg [2*DATA_INPUT_WITDH+3:0]	Butfly1_qa_x1;
reg [2*DATA_INPUT_WITDH+3:0]	Butfly1_qb_x2;
reg [31:0]						Twiddle_W1;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram1_Butfly_X1;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram1_Butfly_X2;
// Butfly2
reg [2*DATA_INPUT_WITDH+3:0]	Butfly2_qa_x1;
reg [2*DATA_INPUT_WITDH+3:0]	Butfly2_qb_x2;
reg [31:0]						Twiddle_W2;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram2_Butfly_X1;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram2_Butfly_X2;
// Butfly3
reg [2*DATA_INPUT_WITDH+3:0]	Butfly3_qa_x1;
reg [2*DATA_INPUT_WITDH+3:0]	Butfly3_qb_x2;
reg [31:0]						Twiddle_W3;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram3_Butfly_X1;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram3_Butfly_X2;
// Butfly4
reg [2*DATA_INPUT_WITDH+3:0]	Butfly4_qa_x1;
reg [2*DATA_INPUT_WITDH+3:0]	Butfly4_qb_x2;
reg [31:0]						Twiddle_W4;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram4_Butfly_X1;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram4_Butfly_X2;
// Butfly5
reg [2*DATA_INPUT_WITDH+3:0]	Butfly5_qa_x1;
reg [2*DATA_INPUT_WITDH+3:0]	Butfly5_qb_x2;
reg [31:0]						Twiddle_W5;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram5_Butfly_X1;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram5_Butfly_X2;
// Butfly6
reg [2*DATA_INPUT_WITDH+3:0]	Butfly6_qa_x1;
reg [2*DATA_INPUT_WITDH+3:0]	Butfly6_qb_x2;
reg [31:0]						Twiddle_W6;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram6_Butfly_X1;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram6_Butfly_X2;
// Butfly7
reg [2*DATA_INPUT_WITDH+3:0]	Butfly7_qa_x1;
reg [2*DATA_INPUT_WITDH+3:0]	Butfly7_qb_x2;
reg [31:0]						Twiddle_W7;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram7_Butfly_X1;
reg [2*DATA_INPUT_WITDH+3:0]	Dpram7_Butfly_X2;

// -----------------------------------------------------------------
//* WIRE
// Butfly0
wire							Carry_MH_flag0;
wire							Carry_ML_flag0;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram0_q0_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram0_q0_b;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram0_q1_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram0_q1_b;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram0_Butterfly1;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram0_Butterfly2;
// Butfly1
wire							Carry_MH_flag1;
wire							Carry_ML_flag1;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram1_q0_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram1_q0_b;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram1_q1_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram1_q1_b;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram1_Butterfly1;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram1_Butterfly2;
// Butfly2
wire							Carry_MH_flag2;
wire							Carry_ML_flag2;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram2_q0_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram2_q0_b;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram2_q1_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram2_q1_b;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram2_Butterfly1;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram2_Butterfly2;
// Butfly3
wire							Carry_MH_flag3;
wire							Carry_ML_flag3;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram3_q0_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram3_q0_b;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram3_q1_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram3_q1_b;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram3_Butterfly1;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram3_Butterfly2;
// Butfly4
wire							Carry_MH_flag4;
wire							Carry_ML_flag4;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram4_q0_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram4_q0_b;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram4_q1_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram4_q1_b;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram4_Butterfly1;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram4_Butterfly2;
// Butfly5
wire							Carry_MH_flag5;
wire							Carry_ML_flag5;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram5_q0_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram5_q0_b;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram5_q1_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram5_q1_b;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram5_Butterfly1;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram5_Butterfly2;
// Butfly6
wire							Carry_MH_flag6;
wire							Carry_ML_flag6;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram6_q0_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram6_q0_b;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram6_q1_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram6_q1_b;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram6_Butterfly1;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram6_Butterfly2;
// Butfly7
wire							Carry_MH_flag7;
wire							Carry_ML_flag7;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram7_q0_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram7_q0_b;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram7_q1_a;
wire[DATA_INPUT_WITDH*2+3:0]	Dpram7_q1_b;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram7_Butterfly1;
wire[2*DATA_INPUT_WITDH+3:0]	Dpram7_Butterfly2;

assign Carry_MH_flag = Carry_MH_flag0 | Carry_MH_flag1 | Carry_MH_flag2 | Carry_MH_flag3 | Carry_MH_flag4 | Carry_MH_flag5 | Carry_MH_flag6 | Carry_MH_flag7;
assign Carry_ML_flag = Carry_ML_flag0 | Carry_ML_flag1 | Carry_ML_flag2 | Carry_ML_flag3 | Carry_ML_flag4 | Carry_ML_flag5 | Carry_ML_flag6 | Carry_ML_flag7;
// -----------------------------------------------------------------
//* Butterfly Ctrl
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Butfly_Wr <= 1'd0;
	else if(Current_state == FFT_STATE_FIRST || Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
		begin
			if(Stage_Cnt >= 30 && Stage_Cnt < DPRAM_LEN_DIV2+31)
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
	else if(Current_state == FFT_STATE_FIRST || Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
		begin
			if(Stage_Cnt >= 24 && Stage_Cnt < DPRAM_LEN_DIV2+25)
				Butfly_vaild <= 1'd1;
			else
				Butfly_vaild <= 1'd0;
		end
	else
		Butfly_vaild <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			Twiddle_W0 <= 'd0;
			Twiddle_W1 <= 'd0;
			Twiddle_W2 <= 'd0;
			Twiddle_W3 <= 'd0;
			Twiddle_W4 <= 'd0;
			Twiddle_W5 <= 'd0;
			Twiddle_W6 <= 'd0;
			Twiddle_W7 <= 'd0;
		end
	else if(Butfly_vaild == 1)
		begin
			Twiddle_W0 <= Twiddle_factor0;
			Twiddle_W1 <= Twiddle_factor1;
			Twiddle_W2 <= Twiddle_factor2;
			Twiddle_W3 <= Twiddle_factor3;
			Twiddle_W4 <= Twiddle_factor4;
			Twiddle_W5 <= Twiddle_factor5;
			Twiddle_W6 <= Twiddle_factor6;
			Twiddle_W7 <= Twiddle_factor7;
		end
	else
		begin
			Twiddle_W0 <= 'd0;
			Twiddle_W1 <= 'd0;
			Twiddle_W2 <= 'd0;
			Twiddle_W3 <= 'd0;
			Twiddle_W4 <= 'd0;
			Twiddle_W5 <= 'd0;
			Twiddle_W6 <= 'd0;
			Twiddle_W7 <= 'd0;
		end
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			Butfly0_qa_x1 <= 'd0;
			Butfly0_qb_x2 <= 'd0;
			Butfly1_qa_x1 <= 'd0;
			Butfly1_qb_x2 <= 'd0;
			Butfly2_qa_x1 <= 'd0;
			Butfly2_qb_x2 <= 'd0;
			Butfly3_qa_x1 <= 'd0;
			Butfly3_qb_x2 <= 'd0;
			Butfly4_qa_x1 <= 'd0;
			Butfly4_qb_x2 <= 'd0;
			Butfly5_qa_x1 <= 'd0;
			Butfly5_qb_x2 <= 'd0;
			Butfly6_qa_x1 <= 'd0;
			Butfly6_qb_x2 <= 'd0;
			Butfly7_qa_x1 <= 'd0;
			Butfly7_qb_x2 <= 'd0;
		end
	else if(Butfly_vaild == 1)
		begin
			case(Current_state)
				FFT_STATE_FIRST:
					if(mem_switch == 0)
						begin
							Butfly0_qa_x1 <= Dpram0_q1_a;
							Butfly0_qb_x2 <= Dpram0_q1_b;
							Butfly1_qa_x1 <= Dpram1_q1_a;
							Butfly1_qb_x2 <= Dpram1_q1_b;
							Butfly2_qa_x1 <= Dpram2_q1_a;
							Butfly2_qb_x2 <= Dpram2_q1_b;
							Butfly3_qa_x1 <= Dpram3_q1_a;
							Butfly3_qb_x2 <= Dpram3_q1_b;
							Butfly4_qa_x1 <= Dpram4_q1_a;
							Butfly4_qb_x2 <= Dpram4_q1_b;
							Butfly5_qa_x1 <= Dpram5_q1_a;
							Butfly5_qb_x2 <= Dpram5_q1_b;
							Butfly6_qa_x1 <= Dpram6_q1_a;
							Butfly6_qb_x2 <= Dpram6_q1_b;
							Butfly7_qa_x1 <= Dpram7_q1_a;
							Butfly7_qb_x2 <= Dpram7_q1_b;
						end
					else
						begin
							Butfly0_qa_x1 <= Dpram0_q0_a;
							Butfly0_qb_x2 <= Dpram0_q0_b;
							Butfly1_qa_x1 <= Dpram1_q0_a;
							Butfly1_qb_x2 <= Dpram1_q0_b;
							Butfly2_qa_x1 <= Dpram2_q0_a;
							Butfly2_qb_x2 <= Dpram2_q0_b;
							Butfly3_qa_x1 <= Dpram3_q0_a;
							Butfly3_qb_x2 <= Dpram3_q0_b;
							Butfly4_qa_x1 <= Dpram4_q0_a;
							Butfly4_qb_x2 <= Dpram4_q0_b;
							Butfly5_qa_x1 <= Dpram5_q0_a;
							Butfly5_qb_x2 <= Dpram5_q0_b;
							Butfly6_qa_x1 <= Dpram6_q0_a;
							Butfly6_qb_x2 <= Dpram6_q0_b;
							Butfly7_qa_x1 <= Dpram7_q0_a;
							Butfly7_qb_x2 <= Dpram7_q0_b;
						end
				FFT_STATE_SECOND:
					if(mem_switch == 0)
						begin
							Butfly0_qa_x1 <= Dpram0_q1_a;
							Butfly0_qb_x2 <= Dpram1_q1_a;
							Butfly1_qa_x1 <= Dpram0_q1_b;
							Butfly1_qb_x2 <= Dpram1_q1_b;
							
							Butfly2_qa_x1 <= Dpram2_q1_a;
							Butfly2_qb_x2 <= Dpram3_q1_a;
							Butfly3_qa_x1 <= Dpram2_q1_b;
							Butfly3_qb_x2 <= Dpram3_q1_b;
							
							Butfly4_qa_x1 <= Dpram4_q1_a;
							Butfly4_qb_x2 <= Dpram5_q1_a;
							Butfly5_qa_x1 <= Dpram4_q1_b;
							Butfly5_qb_x2 <= Dpram5_q1_b;
							
							Butfly6_qa_x1 <= Dpram6_q1_a;
							Butfly6_qb_x2 <= Dpram7_q1_a;
							Butfly7_qa_x1 <= Dpram6_q1_b;
							Butfly7_qb_x2 <= Dpram7_q1_b;
						end
					else
						begin
							Butfly0_qa_x1 <= Dpram0_q0_a;
							Butfly0_qb_x2 <= Dpram1_q0_a;
							Butfly1_qa_x1 <= Dpram0_q0_b;
							Butfly1_qb_x2 <= Dpram1_q0_b;
							
							Butfly2_qa_x1 <= Dpram2_q0_a;
							Butfly2_qb_x2 <= Dpram3_q0_a;
							Butfly3_qa_x1 <= Dpram2_q0_b;
							Butfly3_qb_x2 <= Dpram3_q0_b;
							
							Butfly4_qa_x1 <= Dpram4_q0_a;
							Butfly4_qb_x2 <= Dpram5_q0_a;
							Butfly5_qa_x1 <= Dpram4_q0_b;
							Butfly5_qb_x2 <= Dpram5_q0_b;
							
							Butfly6_qa_x1 <= Dpram6_q0_a;
							Butfly6_qb_x2 <= Dpram7_q0_a;
							Butfly7_qa_x1 <= Dpram6_q0_b;
							Butfly7_qb_x2 <= Dpram7_q0_b;
						end
				FFT_STATE_THIRD:
					if(mem_switch == 0)
						begin
							Butfly0_qa_x1 <= Dpram0_q1_a;
							Butfly0_qb_x2 <= Dpram2_q1_a;
							Butfly1_qa_x1 <= Dpram0_q1_b;
							Butfly1_qb_x2 <= Dpram2_q1_b;
							Butfly2_qa_x1 <= Dpram1_q1_a;
							Butfly2_qb_x2 <= Dpram3_q1_a;
							Butfly3_qa_x1 <= Dpram1_q1_b;
							Butfly3_qb_x2 <= Dpram3_q1_b;
							
							Butfly4_qa_x1 <= Dpram4_q1_a;
							Butfly4_qb_x2 <= Dpram6_q1_a;
							Butfly5_qa_x1 <= Dpram4_q1_b;
							Butfly5_qb_x2 <= Dpram6_q1_b;
							Butfly6_qa_x1 <= Dpram5_q1_a;
							Butfly6_qb_x2 <= Dpram7_q1_a;
							Butfly7_qa_x1 <= Dpram5_q1_b;
							Butfly7_qb_x2 <= Dpram7_q1_b;
						end
					else
						begin
							Butfly0_qa_x1 <= Dpram0_q0_a;
							Butfly0_qb_x2 <= Dpram2_q0_a;
							Butfly1_qa_x1 <= Dpram0_q0_b;
							Butfly1_qb_x2 <= Dpram2_q0_b;
							Butfly2_qa_x1 <= Dpram1_q0_a;
							Butfly2_qb_x2 <= Dpram3_q0_a;
							Butfly3_qa_x1 <= Dpram1_q0_b;
							Butfly3_qb_x2 <= Dpram3_q0_b;
							
							Butfly4_qa_x1 <= Dpram4_q0_a;
							Butfly4_qb_x2 <= Dpram6_q0_a;
							Butfly5_qa_x1 <= Dpram4_q0_b;
							Butfly5_qb_x2 <= Dpram6_q0_b;
							Butfly6_qa_x1 <= Dpram5_q0_a;
							Butfly6_qb_x2 <= Dpram7_q0_a;
							Butfly7_qa_x1 <= Dpram5_q0_b;
							Butfly7_qb_x2 <= Dpram7_q0_b;
						end
				FFT_STATE_FOURTH:
					if(mem_switch == 0)
						begin
							Butfly0_qa_x1 <= Dpram0_q1_a;
							Butfly0_qb_x2 <= Dpram4_q1_a;
							Butfly1_qa_x1 <= Dpram0_q1_b;
							Butfly1_qb_x2 <= Dpram4_q1_b;
							Butfly2_qa_x1 <= Dpram1_q1_a;
							Butfly2_qb_x2 <= Dpram5_q1_a;
							Butfly3_qa_x1 <= Dpram1_q1_b;
							Butfly3_qb_x2 <= Dpram5_q1_b;							
							Butfly4_qa_x1 <= Dpram2_q1_a;
							Butfly4_qb_x2 <= Dpram6_q1_a;
							Butfly5_qa_x1 <= Dpram2_q1_b;
							Butfly5_qb_x2 <= Dpram6_q1_b;
							Butfly6_qa_x1 <= Dpram3_q1_a;
							Butfly6_qb_x2 <= Dpram7_q1_a;
							Butfly7_qa_x1 <= Dpram3_q1_b;
							Butfly7_qb_x2 <= Dpram7_q1_b;
						end
					else
						begin
							Butfly0_qa_x1 <= Dpram0_q0_a;
							Butfly0_qb_x2 <= Dpram4_q0_a;
							Butfly1_qa_x1 <= Dpram0_q0_b;
							Butfly1_qb_x2 <= Dpram4_q0_b;
							Butfly2_qa_x1 <= Dpram1_q0_a;
							Butfly2_qb_x2 <= Dpram5_q0_a;
							Butfly3_qa_x1 <= Dpram1_q0_b;
							Butfly3_qb_x2 <= Dpram5_q0_b;							
							Butfly4_qa_x1 <= Dpram2_q0_a;
							Butfly4_qb_x2 <= Dpram6_q0_a;
							Butfly5_qa_x1 <= Dpram2_q0_b;
							Butfly5_qb_x2 <= Dpram6_q0_b;
							Butfly6_qa_x1 <= Dpram3_q0_a;
							Butfly6_qb_x2 <= Dpram7_q0_a;
							Butfly7_qa_x1 <= Dpram3_q0_b;
							Butfly7_qb_x2 <= Dpram7_q0_b;
						end
				default:
						begin
							Butfly0_qa_x1 <= Butfly0_qa_x1;
							Butfly0_qb_x2 <= Butfly0_qb_x2;
						end	
			endcase
		end
	else
		begin
			Butfly0_qa_x1 <= 'd0;
			Butfly0_qb_x2 <= 'd0;
		end
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			Dpram0_Butfly_X1 <= 'd0;
			Dpram0_Butfly_X2 <= 'd0;
			Dpram1_Butfly_X1 <= 'd0;
			Dpram1_Butfly_X2 <= 'd0;
			Dpram2_Butfly_X1 <= 'd0;
			Dpram2_Butfly_X2 <= 'd0;
			Dpram3_Butfly_X1 <= 'd0;
			Dpram3_Butfly_X2 <= 'd0;
			Dpram4_Butfly_X1 <= 'd0;
			Dpram4_Butfly_X2 <= 'd0;
			Dpram5_Butfly_X1 <= 'd0;
			Dpram5_Butfly_X2 <= 'd0;
			Dpram6_Butfly_X1 <= 'd0;
			Dpram6_Butfly_X2 <= 'd0;
			Dpram7_Butfly_X1 <= 'd0;
			Dpram7_Butfly_X2 <= 'd0;
		end
	else if(Current_state == FFT_STATE_FIRST)
		begin
			Dpram0_Butfly_X1 <= Dpram0_Butterfly1;
			Dpram0_Butfly_X2 <= Dpram0_Butterfly2;
			Dpram1_Butfly_X1 <= Dpram1_Butterfly1;
			Dpram1_Butfly_X2 <= Dpram1_Butterfly2;
			Dpram2_Butfly_X1 <= Dpram2_Butterfly1;
			Dpram2_Butfly_X2 <= Dpram2_Butterfly2;
			Dpram3_Butfly_X1 <= Dpram3_Butterfly1;
			Dpram3_Butfly_X2 <= Dpram3_Butterfly2;
			Dpram4_Butfly_X1 <= Dpram4_Butterfly1;
			Dpram4_Butfly_X2 <= Dpram4_Butterfly2;
			Dpram5_Butfly_X1 <= Dpram5_Butterfly1;
			Dpram5_Butfly_X2 <= Dpram5_Butterfly2;
			Dpram6_Butfly_X1 <= Dpram6_Butterfly1;
			Dpram6_Butfly_X2 <= Dpram6_Butterfly2;
			Dpram7_Butfly_X1 <= Dpram7_Butterfly1;
			Dpram7_Butfly_X2 <= Dpram7_Butterfly2;
		end
	else if(Current_state == FFT_STATE_SECOND)
		begin
			Dpram0_Butfly_X1 <= Dpram0_Butterfly1;
			Dpram0_Butfly_X2 <= Dpram1_Butterfly1;
			Dpram1_Butfly_X1 <= Dpram0_Butterfly2;
			Dpram1_Butfly_X2 <= Dpram1_Butterfly2;
			
			Dpram2_Butfly_X1 <= Dpram2_Butterfly1;
			Dpram2_Butfly_X2 <= Dpram3_Butterfly1;
			Dpram3_Butfly_X1 <= Dpram2_Butterfly2;
			Dpram3_Butfly_X2 <= Dpram3_Butterfly2;
			
			Dpram4_Butfly_X1 <= Dpram4_Butterfly1;
			Dpram4_Butfly_X2 <= Dpram5_Butterfly1;
			Dpram5_Butfly_X1 <= Dpram4_Butterfly2;
			Dpram5_Butfly_X2 <= Dpram5_Butterfly2;
			
			Dpram6_Butfly_X1 <= Dpram6_Butterfly1;
			Dpram6_Butfly_X2 <= Dpram7_Butterfly1;
			Dpram7_Butfly_X1 <= Dpram6_Butterfly2;
			Dpram7_Butfly_X2 <= Dpram7_Butterfly2;
		end
	else if(Current_state == FFT_STATE_THIRD)
		begin
			Dpram0_Butfly_X1 <= Dpram0_Butterfly1;
			Dpram0_Butfly_X2 <= Dpram1_Butterfly1;
			Dpram1_Butfly_X1 <= Dpram2_Butterfly1;
			Dpram1_Butfly_X2 <= Dpram3_Butterfly1;			
			Dpram2_Butfly_X1 <= Dpram0_Butterfly2;
			Dpram2_Butfly_X2 <= Dpram1_Butterfly2;
			Dpram3_Butfly_X1 <= Dpram2_Butterfly2;
			Dpram3_Butfly_X2 <= Dpram3_Butterfly2;
			
			Dpram4_Butfly_X1 <= Dpram4_Butterfly1;
			Dpram4_Butfly_X2 <= Dpram5_Butterfly1;
			Dpram5_Butfly_X1 <= Dpram6_Butterfly1;
			Dpram5_Butfly_X2 <= Dpram7_Butterfly1;			
			Dpram6_Butfly_X1 <= Dpram4_Butterfly2;
			Dpram6_Butfly_X2 <= Dpram5_Butterfly2;
			Dpram7_Butfly_X1 <= Dpram6_Butterfly2;
			Dpram7_Butfly_X2 <= Dpram7_Butterfly2;
		end
	else if(Current_state == FFT_STATE_FOURTH)
		begin
			Dpram0_Butfly_X1 <= Dpram0_Butterfly1;
			Dpram0_Butfly_X2 <= Dpram1_Butterfly1;
			Dpram1_Butfly_X1 <= Dpram2_Butterfly1;
			Dpram1_Butfly_X2 <= Dpram3_Butterfly1;			
			Dpram2_Butfly_X1 <= Dpram4_Butterfly1;
			Dpram2_Butfly_X2 <= Dpram5_Butterfly1;
			Dpram3_Butfly_X1 <= Dpram6_Butterfly1;
			Dpram3_Butfly_X2 <= Dpram7_Butterfly1;			
			Dpram4_Butfly_X1 <= Dpram0_Butterfly2;
			Dpram4_Butfly_X2 <= Dpram1_Butterfly2;
			Dpram5_Butfly_X1 <= Dpram2_Butterfly2;
			Dpram5_Butfly_X2 <= Dpram3_Butterfly2;			
			Dpram6_Butfly_X1 <= Dpram4_Butterfly2;
			Dpram6_Butfly_X2 <= Dpram5_Butterfly2;
			Dpram7_Butfly_X1 <= Dpram6_Butterfly2;
			Dpram7_Butfly_X2 <= Dpram7_Butterfly2;
		end
	else
		begin
			Dpram0_Butfly_X1 <= 'd0;
			Dpram0_Butfly_X2 <= 'd0;
		end
end

// -----------------------------------------------------------------
//* DPRAM0
FFT_Dpram_Ctrl
#(
	.DATA_INPUT_WITDH		( DATA_INPUT_WITDH ),
	.LOG2_FFT_LEN			( LOG2_FFT_LEN )
)
FFT_Dpram_Ctrl_0
(
	.clk					( clk ),
	.reset_n				( reset_n ),
	.mem_switch				( mem_switch ),//
	.Current_state			( Current_state ),
	.source_addr			( source_addr0 ),
	
	.sink_valid				( Flip_Wr_dpram0 ),
	.sink_addr				( Flip_Addr_dpram0 ),
	.sink_data				( {{2{sink_real[DATA_INPUT_WITDH-1]}},sink_real,{2{sink_imag[DATA_INPUT_WITDH-1]}},sink_imag} ),
	.Butfly_raddr_a			( Butfly_raddr_a ),
	.Butfly_raddr_b			( Butfly_raddr_b ),

	.Butfly_Wr				( Butfly_Wr ),
	.Butfly_addr_a			( Butfly_waddr_a ),
	.Butfly_addr_b			( Butfly_waddr_b ),
	.Butfly_data_a			( Dpram0_Butfly_X1 ),
	.Butfly_data_b			( Dpram0_Butfly_X2 ),

	//output
	.dpr0_q_a				( Dpram0_q0_a ),
	.dpr0_q_b				( Dpram0_q0_b ),
	.dpr1_q_a				( Dpram0_q1_a ),
	.dpr1_q_b				( Dpram0_q1_b )
);

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Wr_dpram0 <= 1'd0;
	else if(Addr_xout_32b < ADDR_DPRAM0)
		Flip_Wr_dpram0 <= 1'd1;
	else
		Flip_Wr_dpram0 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Addr_dpram0 <= 'd0;
	else if(Addr_xout_32b < ADDR_DPRAM0)
		Flip_Addr_dpram0 <= Addr_xout;
	else
		Flip_Addr_dpram0 <= Flip_Addr_dpram0;
end

Butterfly
#(
	.DATA_INPUT_WITDH	( DATA_INPUT_WITDH ),
	.TWIDDLE_WITDH		( TWIDDLE_PRECISION ),
	.LOG2_FFT_LEN		( LOG2_FFT_LEN )
)
Butterfly_Init0
(
	.clk				( clk ),
	.reset_n			( reset_n ),
	.Butfly_Wr			( Butfly_Wr ),
	.source_end			( source_eop ),
	.Carry_MH			( Carry_MH_flag ),
	.Carry_ML			( Carry_ML_flag ),
	.Butterfly_xin1		( Butfly0_qa_x1 ),
	.Butterfly_xin2		( Butfly0_qb_x2 ),
	.Twiddle_factor		( Twiddle_W0 ),
	
	.Carry_MH_flag		( Carry_MH_flag0 ),
	.Carry_ML_flag		( Carry_ML_flag0 ),
	.Butterfly_xout1	( Dpram0_Butterfly1 ),
	.Butterfly_xout2	( Dpram0_Butterfly2 )
);

// -----------------------------------------------------------------
//* DPRAM1
FFT_Dpram_Ctrl
#(
	.DATA_INPUT_WITDH		( DATA_INPUT_WITDH ),
	.LOG2_FFT_LEN			( LOG2_FFT_LEN )
)
FFT_Dpram_Ctrl_1
(
	.clk					( clk ),
	.reset_n				( reset_n ),
	.mem_switch				( mem_switch ),
	.Current_state			( Current_state ),
	.source_addr			( source_addr1 ),
	
	.sink_valid				( Flip_Wr_dpram1 ),
	.sink_addr				( Flip_Addr_dpram1 ),
	.sink_data				( {{2{sink_real[DATA_INPUT_WITDH-1]}},sink_real,{2{sink_imag[DATA_INPUT_WITDH-1]}},sink_imag} ),
	.Butfly_raddr_a			( Butfly_raddr_a ),
	.Butfly_raddr_b			( Butfly_raddr_b ),

	.Butfly_Wr				( Butfly_Wr ),
	.Butfly_addr_a			( Butfly_waddr_a ),
	.Butfly_addr_b			( Butfly_waddr_b ),
	.Butfly_data_a			( Dpram1_Butfly_X1 ),
	.Butfly_data_b			( Dpram1_Butfly_X2 ),

	//output
	.dpr0_q_a				( Dpram1_q0_a ),
	.dpr0_q_b				( Dpram1_q0_b ),
	.dpr1_q_a				( Dpram1_q1_a ),
	.dpr1_q_b				( Dpram1_q1_b )
);
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Wr_dpram1 <= 1'd0;
	else if(Addr_xout_32b >= ADDR_DPRAM0 && Addr_xout_32b < ADDR_DPRAM1)
		Flip_Wr_dpram1 <= 1'd1;
	else
		Flip_Wr_dpram1 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Addr_dpram1 <= 'd0;
	else if(Addr_xout_32b >= ADDR_DPRAM0 && Addr_xout_32b < ADDR_DPRAM1)
		Flip_Addr_dpram1 <= Addr_xout-ADDR_DPRAM0;
	else
		Flip_Addr_dpram1 <= Flip_Addr_dpram1;
end

Butterfly
#(
	.DATA_INPUT_WITDH	( DATA_INPUT_WITDH ),
	.TWIDDLE_WITDH		( TWIDDLE_PRECISION ),
	.LOG2_FFT_LEN		( LOG2_FFT_LEN )
)
Butterfly_Init1
(
	.clk				( clk ),
	.reset_n			( reset_n ),
	.Butfly_Wr			( Butfly_Wr ),
	.source_end			( source_eop ),
	.Carry_MH			( Carry_MH_flag ),
	.Carry_ML			( Carry_ML_flag ),
	.Butterfly_xin1		( Butfly1_qa_x1 ),
	.Butterfly_xin2		( Butfly1_qb_x2 ),
	.Twiddle_factor		( Twiddle_W1 ),
	
	.Carry_MH_flag		( Carry_MH_flag1 ),
	.Carry_ML_flag		( Carry_ML_flag1 ),
	.Butterfly_xout1	( Dpram1_Butterfly1 ),
	.Butterfly_xout2	( Dpram1_Butterfly2 )
);

// -----------------------------------------------------------------
//* DPRAM2
FFT_Dpram_Ctrl
#(
	.DATA_INPUT_WITDH		( DATA_INPUT_WITDH ),
	.LOG2_FFT_LEN			( LOG2_FFT_LEN )
)
FFT_Dpram_Ctrl_2
(
	.clk					( clk ),
	.reset_n				( reset_n ),
	.mem_switch				( mem_switch ),
	.Current_state			( Current_state ),
	.source_addr			( source_addr2 ),
	
	.sink_valid				( Flip_Wr_dpram2 ),
	.sink_addr				( Flip_Addr_dpram2 ),
	.sink_data				( {{2{sink_real[DATA_INPUT_WITDH-1]}},sink_real,{2{sink_imag[DATA_INPUT_WITDH-1]}},sink_imag} ),
	.Butfly_raddr_a			( Butfly_raddr_a ),
	.Butfly_raddr_b			( Butfly_raddr_b ),

	.Butfly_Wr				( Butfly_Wr ),
	.Butfly_addr_a			( Butfly_waddr_a ),
	.Butfly_addr_b			( Butfly_waddr_b ),
	.Butfly_data_a			( Dpram2_Butfly_X1 ),
	.Butfly_data_b			( Dpram2_Butfly_X2 ),

	//output
	.dpr0_q_a				( Dpram2_q0_a ),
	.dpr0_q_b				( Dpram2_q0_b ),
	.dpr1_q_a				( Dpram2_q1_a ),
	.dpr1_q_b				( Dpram2_q1_b )
);
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Wr_dpram2 <= 1'd0;
	else if(Addr_xout_32b >= ADDR_DPRAM1 && Addr_xout_32b < ADDR_DPRAM2)
		Flip_Wr_dpram2 <= 1'd1;
	else
		Flip_Wr_dpram2 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Addr_dpram2 <= 'd0;
	else if(Addr_xout_32b >= ADDR_DPRAM1 && Addr_xout_32b < ADDR_DPRAM2)
		Flip_Addr_dpram2 <= Addr_xout-ADDR_DPRAM1;
	else
		Flip_Addr_dpram2 <= Flip_Addr_dpram2;
end

Butterfly
#(
	.DATA_INPUT_WITDH	( DATA_INPUT_WITDH ),
	.TWIDDLE_WITDH		( TWIDDLE_PRECISION ),
	.LOG2_FFT_LEN		( LOG2_FFT_LEN )
)
Butterfly_Init2
(
	.clk				( clk ),
	.reset_n			( reset_n ),
	.Butfly_Wr			( Butfly_Wr ),
	.source_end			( source_eop ),
	.Carry_MH			( Carry_MH_flag ),
	.Carry_ML			( Carry_ML_flag ),
	.Butterfly_xin1		( Butfly2_qa_x1 ),
	.Butterfly_xin2		( Butfly2_qb_x2 ),
	.Twiddle_factor		( Twiddle_W2 ),
	
	.Carry_MH_flag		( Carry_MH_flag2 ),
	.Carry_ML_flag		( Carry_ML_flag2 ),
	.Butterfly_xout1	( Dpram2_Butterfly1 ),
	.Butterfly_xout2	( Dpram2_Butterfly2 )
);

// -----------------------------------------------------------------
//* DPRAM3
FFT_Dpram_Ctrl
#(
	.DATA_INPUT_WITDH		( DATA_INPUT_WITDH ),
	.LOG2_FFT_LEN			( LOG2_FFT_LEN )
)
FFT_Dpram_Ctrl_3
(
	.clk					( clk ),
	.reset_n				( reset_n ),
	.mem_switch				( mem_switch ),
	.Current_state			( Current_state ),
	.source_addr			( source_addr3 ),
	
	.sink_valid				( Flip_Wr_dpram3 ),
	.sink_addr				( Flip_Addr_dpram3 ),
	.sink_data				( {{2{sink_real[DATA_INPUT_WITDH-1]}},sink_real,{2{sink_imag[DATA_INPUT_WITDH-1]}},sink_imag} ),
	.Butfly_raddr_a			( Butfly_raddr_a ),
	.Butfly_raddr_b			( Butfly_raddr_b ),

	.Butfly_Wr				( Butfly_Wr ),
	.Butfly_addr_a			( Butfly_waddr_a ),
	.Butfly_addr_b			( Butfly_waddr_b ),
	.Butfly_data_a			( Dpram3_Butfly_X1 ),
	.Butfly_data_b			( Dpram3_Butfly_X2 ),

	//output
	.dpr0_q_a				( Dpram3_q0_a ),
	.dpr0_q_b				( Dpram3_q0_b ),
	.dpr1_q_a				( Dpram3_q1_a ),
	.dpr1_q_b				( Dpram3_q1_b )
);
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Wr_dpram3 <= 1'd0;
	else if(Addr_xout_32b >= ADDR_DPRAM2 && Addr_xout_32b < ADDR_DPRAM3)
		Flip_Wr_dpram3 <= 1'd1;
	else
		Flip_Wr_dpram3 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Addr_dpram3 <= 'd0;
	else if(Addr_xout_32b >= ADDR_DPRAM2 && Addr_xout_32b < ADDR_DPRAM3)
		Flip_Addr_dpram3 <= Addr_xout-ADDR_DPRAM2;
	else
		Flip_Addr_dpram3 <= Flip_Addr_dpram3;
end

Butterfly
#(
	.DATA_INPUT_WITDH	( DATA_INPUT_WITDH ),
	.TWIDDLE_WITDH		( TWIDDLE_PRECISION ),
	.LOG2_FFT_LEN		( LOG2_FFT_LEN )
)
Butterfly_Init3
(
	.clk				( clk ),
	.reset_n			( reset_n ),
	.Butfly_Wr			( Butfly_Wr ),
	.source_end			( source_eop ),
	.Carry_MH			( Carry_MH_flag ),
	.Carry_ML			( Carry_ML_flag ),
	.Butterfly_xin1		( Butfly3_qa_x1 ),
	.Butterfly_xin2		( Butfly3_qb_x2 ),
	.Twiddle_factor		( Twiddle_W3 ),
	
	.Carry_MH_flag		( Carry_MH_flag3 ),
	.Carry_ML_flag		( Carry_ML_flag3 ),
	.Butterfly_xout1	( Dpram3_Butterfly1 ),
	.Butterfly_xout2	( Dpram3_Butterfly2 )
);

// -----------------------------------------------------------------
//* DPRAM4
FFT_Dpram_Ctrl
#(
	.DATA_INPUT_WITDH		( DATA_INPUT_WITDH ),
	.LOG2_FFT_LEN			( LOG2_FFT_LEN )
)
FFT_Dpram_Ctrl_4
(
	.clk					( clk ),
	.reset_n				( reset_n ),
	.mem_switch				( mem_switch ),
	.Current_state			( Current_state ),
	.source_addr			( source_addr4 ),
	
	.sink_valid				( Flip_Wr_dpram4 ),
	.sink_addr				( Flip_Addr_dpram4 ),
	.sink_data				( {{2{sink_real[DATA_INPUT_WITDH-1]}},sink_real,{2{sink_imag[DATA_INPUT_WITDH-1]}},sink_imag} ),
	.Butfly_raddr_a			( Butfly_raddr_a ),
	.Butfly_raddr_b			( Butfly_raddr_b ),

	.Butfly_Wr				( Butfly_Wr ),
	.Butfly_addr_a			( Butfly_waddr_a ),
	.Butfly_addr_b			( Butfly_waddr_b ),
	.Butfly_data_a			( Dpram4_Butfly_X1 ),
	.Butfly_data_b			( Dpram4_Butfly_X2 ),

	//output
	.dpr0_q_a				( Dpram4_q0_a ),
	.dpr0_q_b				( Dpram4_q0_b ),
	.dpr1_q_a				( Dpram4_q1_a ),
	.dpr1_q_b				( Dpram4_q1_b )
);
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Wr_dpram4 <= 1'd0;
	else if(Addr_xout_32b >= ADDR_DPRAM3 && Addr_xout_32b < ADDR_DPRAM4)
		Flip_Wr_dpram4 <= 1'd1;
	else
		Flip_Wr_dpram4 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Addr_dpram4 <= 'd0;
	else if(Addr_xout_32b >= ADDR_DPRAM3 && Addr_xout_32b < ADDR_DPRAM4)
		Flip_Addr_dpram4 <= Addr_xout-ADDR_DPRAM3;
	else
		Flip_Addr_dpram4 <= Flip_Addr_dpram4;
end

Butterfly
#(
	.DATA_INPUT_WITDH	( DATA_INPUT_WITDH ),
	.TWIDDLE_WITDH		( TWIDDLE_PRECISION ),
	.LOG2_FFT_LEN		( LOG2_FFT_LEN )
)
Butterfly_Init4
(
	.clk				( clk ),
	.reset_n			( reset_n ),
	.Butfly_Wr			( Butfly_Wr ),
	.source_end			( source_eop ),
	.Carry_MH			( Carry_MH_flag ),
	.Carry_ML			( Carry_ML_flag ),
	.Butterfly_xin1		( Butfly4_qa_x1 ),
	.Butterfly_xin2		( Butfly4_qb_x2 ),
	.Twiddle_factor		( Twiddle_W4 ),
	
	.Carry_MH_flag		( Carry_MH_flag4 ),
	.Carry_ML_flag		( Carry_ML_flag4 ),
	.Butterfly_xout1	( Dpram4_Butterfly1 ),
	.Butterfly_xout2	( Dpram4_Butterfly2 )
);

// -----------------------------------------------------------------
//* DPRAM5
FFT_Dpram_Ctrl
#(
	.DATA_INPUT_WITDH		( DATA_INPUT_WITDH ),
	.LOG2_FFT_LEN			( LOG2_FFT_LEN )
)
FFT_Dpram_Ctrl_5
(
	.clk					( clk ),
	.reset_n				( reset_n ),
	.mem_switch				( mem_switch ),
	.Current_state			( Current_state ),
	.source_addr			( source_addr5 ),
	
	.sink_valid				( Flip_Wr_dpram5 ),
	.sink_addr				( Flip_Addr_dpram5 ),
	.sink_data				( {{2{sink_real[DATA_INPUT_WITDH-1]}},sink_real,{2{sink_imag[DATA_INPUT_WITDH-1]}},sink_imag} ),
	.Butfly_raddr_a			( Butfly_raddr_a ),
	.Butfly_raddr_b			( Butfly_raddr_b ),

	.Butfly_Wr				( Butfly_Wr ),
	.Butfly_addr_a			( Butfly_waddr_a ),
	.Butfly_addr_b			( Butfly_waddr_b ),
	.Butfly_data_a			( Dpram5_Butfly_X1 ),
	.Butfly_data_b			( Dpram5_Butfly_X2 ),

	//output
	.dpr0_q_a				( Dpram5_q0_a ),
	.dpr0_q_b				( Dpram5_q0_b ),
	.dpr1_q_a				( Dpram5_q1_a ),
	.dpr1_q_b				( Dpram5_q1_b )
);
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Wr_dpram5 <= 1'd0;
	else if(Addr_xout_32b >= ADDR_DPRAM4 && Addr_xout_32b < ADDR_DPRAM5)
		Flip_Wr_dpram5 <= 1'd1;
	else
		Flip_Wr_dpram5 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Addr_dpram5 <= 'd0;
	else if(Addr_xout_32b >= ADDR_DPRAM4 && Addr_xout_32b < ADDR_DPRAM5)
		Flip_Addr_dpram5 <= Addr_xout-ADDR_DPRAM4;
	else
		Flip_Addr_dpram5 <= Flip_Addr_dpram5;
end

Butterfly
#(
	.DATA_INPUT_WITDH	( DATA_INPUT_WITDH ),
	.TWIDDLE_WITDH		( TWIDDLE_PRECISION ),
	.LOG2_FFT_LEN		( LOG2_FFT_LEN )
)
Butterfly_Init5
(
	.clk				( clk ),
	.reset_n			( reset_n ),
	.Butfly_Wr			( Butfly_Wr ),
	.source_end			( source_eop ),
	.Carry_MH			( Carry_MH_flag ),
	.Carry_ML			( Carry_ML_flag ),
	.Butterfly_xin1		( Butfly5_qa_x1 ),
	.Butterfly_xin2		( Butfly5_qb_x2 ),
	.Twiddle_factor		( Twiddle_W5 ),
	
	.Carry_MH_flag		( Carry_MH_flag5 ),
	.Carry_ML_flag		( Carry_ML_flag5 ),
	.Butterfly_xout1	( Dpram5_Butterfly1 ),
	.Butterfly_xout2	( Dpram5_Butterfly2 )
);

// -----------------------------------------------------------------
//* DPRAM6
FFT_Dpram_Ctrl
#(
	.DATA_INPUT_WITDH		( DATA_INPUT_WITDH ),
	.LOG2_FFT_LEN			( LOG2_FFT_LEN )
)
FFT_Dpram_Ctrl_6
(
	.clk					( clk ),
	.reset_n				( reset_n ),
	.mem_switch				( mem_switch ),
	.Current_state			( Current_state ),
	.source_addr			( source_addr6 ),
	
	.sink_valid				( Flip_Wr_dpram6 ),
	.sink_addr				( Flip_Addr_dpram6 ),
	.sink_data				( {{2{sink_real[DATA_INPUT_WITDH-1]}},sink_real,{2{sink_imag[DATA_INPUT_WITDH-1]}},sink_imag} ),
	.Butfly_raddr_a			( Butfly_raddr_a ),
	.Butfly_raddr_b			( Butfly_raddr_b ),

	.Butfly_Wr				( Butfly_Wr ),
	.Butfly_addr_a			( Butfly_waddr_a ),
	.Butfly_addr_b			( Butfly_waddr_b ),
	.Butfly_data_a			( Dpram6_Butfly_X1 ),
	.Butfly_data_b			( Dpram6_Butfly_X2 ),

	//output
	.dpr0_q_a				( Dpram6_q0_a ),
	.dpr0_q_b				( Dpram6_q0_b ),
	.dpr1_q_a				( Dpram6_q1_a ),
	.dpr1_q_b				( Dpram6_q1_b )
);
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Wr_dpram6 <= 1'd0;
	else if(Addr_xout_32b >= ADDR_DPRAM5 && Addr_xout_32b < ADDR_DPRAM6)
		Flip_Wr_dpram6 <= 1'd1;
	else
		Flip_Wr_dpram6 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Addr_dpram6 <= 'd0;
	else if(Addr_xout_32b >= ADDR_DPRAM5 && Addr_xout_32b < ADDR_DPRAM6)
		Flip_Addr_dpram6 <= Addr_xout-ADDR_DPRAM5;
	else
		Flip_Addr_dpram6 <= Flip_Addr_dpram6;
end

Butterfly
#(
	.DATA_INPUT_WITDH	( DATA_INPUT_WITDH ),
	.TWIDDLE_WITDH		( TWIDDLE_PRECISION ),
	.LOG2_FFT_LEN		( LOG2_FFT_LEN )
)
Butterfly_Init6
(
	.clk				( clk ),
	.reset_n			( reset_n ),
	.Butfly_Wr			( Butfly_Wr ),
	.source_end			( source_eop ),
	.Carry_MH			( Carry_MH_flag ),
	.Carry_ML			( Carry_ML_flag ),
	.Butterfly_xin1		( Butfly6_qa_x1 ),
	.Butterfly_xin2		( Butfly6_qb_x2 ),
	.Twiddle_factor		( Twiddle_W6 ),
	
	.Carry_MH_flag		( Carry_MH_flag6 ),
	.Carry_ML_flag		( Carry_ML_flag6 ),
	.Butterfly_xout1	( Dpram6_Butterfly1 ),
	.Butterfly_xout2	( Dpram6_Butterfly2 )
);

// -----------------------------------------------------------------
//* DPRAM7
FFT_Dpram_Ctrl
#(
	.DATA_INPUT_WITDH		( DATA_INPUT_WITDH ),
	.LOG2_FFT_LEN			( LOG2_FFT_LEN )
)
FFT_Dpram_Ctrl_7
(
	.clk					( clk ),
	.reset_n				( reset_n ),
	.mem_switch				( mem_switch ),//mem_switch
	.Current_state			( Current_state ),
	.source_addr			( source_addr7 ),
	
	.sink_valid				( Flip_Wr_dpram7 ),
	.sink_addr				( Flip_Addr_dpram7 ),
	.sink_data				( {{2{sink_real[DATA_INPUT_WITDH-1]}},sink_real,{2{sink_imag[DATA_INPUT_WITDH-1]}},sink_imag} ),
	.Butfly_raddr_a			( Butfly_raddr_a ),
	.Butfly_raddr_b			( Butfly_raddr_b ),

	.Butfly_Wr				( Butfly_Wr ),
	.Butfly_addr_a			( Butfly_waddr_a ),
	.Butfly_addr_b			( Butfly_waddr_b ),
	.Butfly_data_a			( Dpram7_Butfly_X1 ),
	.Butfly_data_b			( Dpram7_Butfly_X2 ),

	//output
	.dpr0_q_a				( Dpram7_q0_a ),
	.dpr0_q_b				( Dpram7_q0_b ),
	.dpr1_q_a				( Dpram7_q1_a ),
	.dpr1_q_b				( Dpram7_q1_b )
);
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Wr_dpram7 <= 1'd0;
	else if(Addr_xout_32b >= ADDR_DPRAM6 && Addr_xout_32b < ADDR_DPRAM7)
		Flip_Wr_dpram7 <= 1'd1;
	else
		Flip_Wr_dpram7 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Flip_Addr_dpram7 <= 'd0;
	else if(Addr_xout_32b >= ADDR_DPRAM6 && Addr_xout_32b < ADDR_DPRAM7)
		Flip_Addr_dpram7 <= Addr_xout-ADDR_DPRAM6;
	else
		Flip_Addr_dpram7 <= Flip_Addr_dpram7;
end

Butterfly
#(
	.DATA_INPUT_WITDH	( DATA_INPUT_WITDH ),
	.TWIDDLE_WITDH		( TWIDDLE_PRECISION ),
	.LOG2_FFT_LEN		( LOG2_FFT_LEN )
)
Butterfly_Init7
(
	.clk				( clk ),
	.reset_n			( reset_n ),
	.Butfly_Wr			( Butfly_Wr ),
	.source_end			( source_eop ),
	.Carry_MH			( Carry_MH_flag ),
	.Carry_ML			( Carry_ML_flag ),
	.Butterfly_xin1		( Butfly7_qa_x1 ),
	.Butterfly_xin2		( Butfly7_qb_x2 ),
	.Twiddle_factor		( Twiddle_W7 ),
	
	.Carry_MH_flag		( Carry_MH_flag7 ),
	.Carry_ML_flag		( Carry_ML_flag7 ),
	.Butterfly_xout1	( Dpram7_Butterfly1 ),
	.Butterfly_xout2	( Dpram7_Butterfly2 )
);

// -----------------------------------------------------------------
//* FFT OUTPUT
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_addr0 <= 'd0;
	else if(source_addr < ADDR_DPRAM0)
		source_addr0 <= source_addr[LOG2_FFT_LEN-4:0];
	else
		source_addr0 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_addr1 <= 'd0;
	else if(source_addr >= ADDR_DPRAM0 && source_addr < ADDR_DPRAM1)
		source_addr1 <= source_addr[LOG2_FFT_LEN-4:0];
	else
		source_addr1 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_addr2 <= 'd0;
	else if(source_addr >= ADDR_DPRAM1 && source_addr < ADDR_DPRAM2)
		source_addr2 <= source_addr[LOG2_FFT_LEN-4:0];
	else
		source_addr2 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_addr3 <= 'd0;
	else if(source_addr >= ADDR_DPRAM2 && source_addr < ADDR_DPRAM3)
		source_addr3 <= source_addr[LOG2_FFT_LEN-4:0];
	else
		source_addr3 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_addr4 <= 'd0;
	else if(source_addr >= ADDR_DPRAM3 && source_addr < ADDR_DPRAM4)
		source_addr4 <= source_addr[LOG2_FFT_LEN-4:0];
	else
		source_addr4 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_addr5 <= 'd0;
	else if(source_addr >= ADDR_DPRAM4 && source_addr < ADDR_DPRAM5)
		source_addr5 <= source_addr[LOG2_FFT_LEN-4:0];
	else
		source_addr5 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_addr6 <= 'd0;
	else if(source_addr >= ADDR_DPRAM5 && source_addr < ADDR_DPRAM6)
		source_addr6 <= source_addr[LOG2_FFT_LEN-4:0];
	else
		source_addr6 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_addr7 <= 'd0;
	else if(source_addr >= ADDR_DPRAM6 && source_addr < ADDR_DPRAM7)
		source_addr7 <= source_addr[LOG2_FFT_LEN-4:0];
	else
		source_addr7 <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			source_addr_r0 <= 'd0;
			source_addr_r1 <= 'd0;
			source_addr_r2 <= 'd0;
		end
	else
		begin
			source_addr_r0 <= source_addr;
			source_addr_r1 <= source_addr_r0;
			source_addr_r2 <= source_addr_r1;
		end
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			dpr0_q_a <= 'd0;
			dpr1_q_a <= 'd0;
		end
	else if(source_addr_r2 < ADDR_DPRAM0)
		begin
			dpr0_q_a <= Dpram0_q0_a;
			dpr1_q_a <= Dpram0_q1_a;
		end
	else if(source_addr_r2 >= ADDR_DPRAM0 && source_addr_r2 < ADDR_DPRAM1)
		begin
			dpr0_q_a <= Dpram1_q0_a;
			dpr1_q_a <= Dpram1_q1_a;
		end
	else if(source_addr_r2 >= ADDR_DPRAM1 && source_addr_r2 < ADDR_DPRAM2)
		begin
			dpr0_q_a <= Dpram2_q0_a;
			dpr1_q_a <= Dpram2_q1_a;
		end
	else if(source_addr_r2 >= ADDR_DPRAM2 && source_addr_r2 < ADDR_DPRAM3)
		begin
			dpr0_q_a <= Dpram3_q0_a;
			dpr1_q_a <= Dpram3_q1_a;
		end
	else if(source_addr_r2 >= ADDR_DPRAM3 && source_addr_r2 < ADDR_DPRAM4)
		begin
			dpr0_q_a <= Dpram4_q0_a;
			dpr1_q_a <= Dpram4_q1_a;
		end
	else if(source_addr_r2 >= ADDR_DPRAM4 && source_addr_r2 < ADDR_DPRAM5)
		begin
			dpr0_q_a <= Dpram5_q0_a;
			dpr1_q_a <= Dpram5_q1_a;
		end
	else if(source_addr_r2 >= ADDR_DPRAM5 && source_addr_r2 < ADDR_DPRAM6)
		begin
			dpr0_q_a <= Dpram6_q0_a;
			dpr1_q_a <= Dpram6_q1_a;
		end
	else if(source_addr_r2 >= ADDR_DPRAM6 && source_addr_r2 < ADDR_DPRAM7)
		begin
			dpr0_q_a <= Dpram7_q0_a;
			dpr1_q_a <= Dpram7_q1_a;
		end
	else
		begin
			dpr0_q_a <= 'd0;
			dpr1_q_a <= 'd0;
		end
end

endmodule
