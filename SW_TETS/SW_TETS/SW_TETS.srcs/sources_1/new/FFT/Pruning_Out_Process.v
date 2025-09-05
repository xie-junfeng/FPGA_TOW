`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:49:50
// Design Name: 
// Module Name: Pruning_Out_Process
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


module Pruning_Out_Process  
#(
	parameter DATA_INPUT_WITDH			= 12,
	parameter LOG2_FFT_NORZEROS_LEN		= 11,
	parameter LOG2_FFT_LEN				= 11,
	parameter CACHE_ADDR_LEN			= 11,
	parameter PEAK_NUM					= 2
)
(
	input	wire							clk,
	input	wire							reset_n,
	input	wire							source_exp_ml,
	input	wire							source_exp_mh,
	input	wire							Result_Cache_Wr,
	input	wire[4:0]						Middle_exp,
	input	wire[LOG2_FFT_LEN-1:0]			Freq_Shift_Nums,
	input	wire[3:0]						Current_state,
	input	wire[2*DATA_INPUT_WITDH+3:0]	dpr0_q_a,
	input	wire[2*DATA_INPUT_WITDH+3:0]	dpr1_q_a,
	input	wire[LOG2_FFT_NORZEROS_LEN-1:0]	peak_location,
	
	output	reg       						FFT_finish,
	output	reg       						source_valid,
	output	reg       						source_sop,
	output	reg       						source_eop,
	output	reg [4:0]						source_exp,
	output	wire[1:0]						source_error,
	output	signed[DATA_INPUT_WITDH-1:0]	source_real,
	output	signed[DATA_INPUT_WITDH-1:0]	source_imag,
	output		[31:0]						peak_place,
	output									peak_place_en
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

localparam	CACHE_LEN			= 2**CACHE_ADDR_LEN;

// -----------------------------------------------------------------
//* REG
reg	signed[DATA_INPUT_WITDH-1:0]	Xout_rel;
reg	signed[DATA_INPUT_WITDH-1:0]	Xout_img;
reg	[4:0]							source_exp_max;

reg									Cache_Wr;
reg [3:0]							Current_state_reg;
reg [CACHE_ADDR_LEN-1:0]			Cache_Addr_A;
reg [CACHE_ADDR_LEN-1:0]			Cache_Addr_B;
reg [2*DATA_INPUT_WITDH-1:0]		Cache_Data_A;
reg [2*DATA_INPUT_WITDH-1:0]		Cache_Data_B;
// reg									FFT_finish;
reg									FFT_finish1;
reg [4:0]							Exp_Cnt;
reg [CACHE_ADDR_LEN:0]				Cache_Cnt;
reg [2*DATA_INPUT_WITDH-1:0]		Cache_Out_A1;

// -----------------------------------------------------------------
//* WIRE
wire[2*DATA_INPUT_WITDH+4:0]		Cache_Out_A;

// -----------------------------------------------------------------
//* Result Cache
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Cache_Wr <= 0;
	else
		Cache_Wr <= Result_Cache_Wr;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			Cache_Addr_A <= 0;
			Cache_Addr_B <= 1;
		end
	else if(Cache_Wr == 1)
		begin
			Cache_Addr_A <= Cache_Addr_A + 2;
			Cache_Addr_B <= Cache_Addr_B + 2;
		end
	else if(FFT_finish == 0 && FFT_finish1 == 1)//(Current_state == FFT_STATE_RESET && Current_state_reg == FFT_STATE_REPEAT) || source_eop == 1)
		begin
			Cache_Addr_A <= 0;
			Cache_Addr_B <= 1;
		end
	else if(FFT_finish == 1)
		begin
			Cache_Addr_A <= Cache_Cnt;
			Cache_Addr_B <= 0;
		end
	else 
		begin
			Cache_Addr_A <= Cache_Addr_A;
			Cache_Addr_B <= Cache_Addr_B;
		end
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			Cache_Data_A <= 0;
			Cache_Data_B <= 0;
		end
	else if(source_exp_mh == 1)
		begin
			Cache_Data_A <= {dpr0_q_a[2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+4],dpr0_q_a[DATA_INPUT_WITDH+1:2]};
			Cache_Data_B <= {dpr1_q_a[2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+4],dpr1_q_a[DATA_INPUT_WITDH+1:2]};
		end
	else if(source_exp_ml == 1)
		begin
			Cache_Data_A <= {dpr0_q_a[2*DATA_INPUT_WITDH+3],dpr0_q_a[2*DATA_INPUT_WITDH+1:DATA_INPUT_WITDH+3],dpr0_q_a[DATA_INPUT_WITDH+1],dpr0_q_a[DATA_INPUT_WITDH-1:1]};
			Cache_Data_B <= {dpr1_q_a[2*DATA_INPUT_WITDH+3],dpr1_q_a[2*DATA_INPUT_WITDH+1:DATA_INPUT_WITDH+3],dpr1_q_a[DATA_INPUT_WITDH+1],dpr1_q_a[DATA_INPUT_WITDH-1:1]};
		end
	else
		begin
			Cache_Data_A <= {dpr0_q_a[2*DATA_INPUT_WITDH+3],dpr0_q_a[2*DATA_INPUT_WITDH:DATA_INPUT_WITDH+2],dpr0_q_a[DATA_INPUT_WITDH+1],dpr0_q_a[DATA_INPUT_WITDH-2:0]};
			Cache_Data_B <= {dpr1_q_a[2*DATA_INPUT_WITDH+3],dpr1_q_a[2*DATA_INPUT_WITDH:DATA_INPUT_WITDH+2],dpr1_q_a[DATA_INPUT_WITDH+1],dpr1_q_a[DATA_INPUT_WITDH-2:0]};
		end
end

SYN_DPRAM  
#(
	.DATA_WIDTH		( DATA_INPUT_WITDH*2+5 ),
	.ADDR_WIDTH		( CACHE_ADDR_LEN )
)
Result_Cache
(
	.clk			( clk ),
	//Port A
	.we_a			( Cache_Wr ),
    .addr_a			( Cache_Addr_A ),
    .data_a			( {Middle_exp,Cache_Data_A} ),
    .q_a			( Cache_Out_A ),
	//Port B
	.we_b			( Cache_Wr ),
    .addr_b			( Cache_Addr_B ),
    .data_b			( {Middle_exp,Cache_Data_B} ),
    .q_b			(  )
);

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_exp_max <= 'd0;
	// else if(Current_state == FFT_STATE_FIRST && source_exp_max < Middle_exp)
	else if(Cache_Wr == 1 && source_exp_max < Middle_exp)
		source_exp_max <= Middle_exp;
	else if(Current_state == FFT_STATE_WAIT)
		source_exp_max <= 'd0;
	else
		source_exp_max <= source_exp_max;
end

// -----------------------------------------------------------------
//*FFT Output Result Process
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Current_state_reg <= FFT_STATE_RESET;
	else
		Current_state_reg <= Current_state;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		FFT_finish <= 0;
	else if(Current_state == FFT_STATE_RESET && Current_state_reg == FFT_STATE_REPEAT)
		FFT_finish <= 1;
	else if(Current_state == FFT_STATE_SECOND)
		FFT_finish <= 0;
	else
		FFT_finish <= FFT_finish;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		FFT_finish1 <= 0;
	else
		FFT_finish1 <= FFT_finish;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Cache_Cnt <= 0;
	else if(FFT_finish == 1 && Cache_Cnt < CACHE_LEN+5)
		Cache_Cnt <= Cache_Cnt + 1;
	else if(FFT_finish == 1 && Cache_Cnt >= CACHE_LEN+5)
		Cache_Cnt <= Cache_Cnt;
	else
		Cache_Cnt <= 0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Exp_Cnt <= 5'd0;
	else if(Cache_Cnt >= 2 && Cache_Cnt <= CACHE_LEN+1)
		Exp_Cnt <= source_exp_max - Cache_Out_A[DATA_INPUT_WITDH*2+4:DATA_INPUT_WITDH*2];
	else
		Exp_Cnt <= 5'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Cache_Out_A1 <= 'd0;
	else
		Cache_Out_A1 <= Cache_Out_A[2*DATA_INPUT_WITDH-1:0];
end
 
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			Xout_rel <= 'd0;
			Xout_img <= 'd0;
		end
	else if(Cache_Cnt >= 3 && Cache_Cnt <= CACHE_LEN+2)
		case(Exp_Cnt)
			5'd0 : begin
					Xout_rel <= Cache_Out_A1[DATA_INPUT_WITDH*2-1:DATA_INPUT_WITDH];
					Xout_img <= Cache_Out_A1[DATA_INPUT_WITDH-1:0];
				end
			5'd1 : begin
					Xout_rel <= {{1{Cache_Out_A1[DATA_INPUT_WITDH*2-1]}},Cache_Out_A1[DATA_INPUT_WITDH*2-1:DATA_INPUT_WITDH+1]};
					Xout_img <= {{1{Cache_Out_A1[DATA_INPUT_WITDH-1]}},Cache_Out_A1[DATA_INPUT_WITDH-1:1]};
				end
			5'd2 : begin
					Xout_rel <= {{2{Cache_Out_A1[DATA_INPUT_WITDH*2-1]}},Cache_Out_A1[DATA_INPUT_WITDH*2-1:DATA_INPUT_WITDH+2]};
					Xout_img <= {{2{Cache_Out_A1[DATA_INPUT_WITDH-1]}},Cache_Out_A1[DATA_INPUT_WITDH-1:2]};
				end
			5'd3 : begin
					Xout_rel <= {{3{Cache_Out_A1[DATA_INPUT_WITDH*2-1]}},Cache_Out_A1[DATA_INPUT_WITDH*2-1:DATA_INPUT_WITDH+3]};
					Xout_img <= {{3{Cache_Out_A1[DATA_INPUT_WITDH-1]}},Cache_Out_A1[DATA_INPUT_WITDH-1:3]};
				end
			5'd4 : begin
					Xout_rel <= {{4{Cache_Out_A1[DATA_INPUT_WITDH*2-1]}},Cache_Out_A1[DATA_INPUT_WITDH*2-1:DATA_INPUT_WITDH+4]};
					Xout_img <= {{4{Cache_Out_A1[DATA_INPUT_WITDH-1]}},Cache_Out_A1[DATA_INPUT_WITDH-1:4]};
				end
			5'd5 : begin
					Xout_rel <= {{5{Cache_Out_A1[DATA_INPUT_WITDH*2-1]}},Cache_Out_A1[DATA_INPUT_WITDH*2-1:DATA_INPUT_WITDH+5]};
					Xout_img <= {{5{Cache_Out_A1[DATA_INPUT_WITDH-1]}},Cache_Out_A1[DATA_INPUT_WITDH-1:5]};
				end
			5'd6 : begin
					Xout_rel <= {{6{Cache_Out_A1[DATA_INPUT_WITDH*2-1]}},Cache_Out_A1[DATA_INPUT_WITDH*2-1:DATA_INPUT_WITDH+6]};
					Xout_img <= {{6{Cache_Out_A1[DATA_INPUT_WITDH-1]}},Cache_Out_A1[DATA_INPUT_WITDH-1:6]};
				end
			5'd7 : begin
					Xout_rel <= {{7{Cache_Out_A1[DATA_INPUT_WITDH*2-1]}},Cache_Out_A1[DATA_INPUT_WITDH*2-1:DATA_INPUT_WITDH+7]};
					Xout_img <= {{7{Cache_Out_A1[DATA_INPUT_WITDH-1]}},Cache_Out_A1[DATA_INPUT_WITDH-1:7]};
				end
			5'd8 : begin
					Xout_rel <= {{8{Cache_Out_A1[DATA_INPUT_WITDH*2-1]}},Cache_Out_A1[DATA_INPUT_WITDH*2-1:DATA_INPUT_WITDH+8]};
					Xout_img <= {{8{Cache_Out_A1[DATA_INPUT_WITDH-1]}},Cache_Out_A1[DATA_INPUT_WITDH-1:8]};
				end
			5'd9 : begin
					Xout_rel <= {{9{Cache_Out_A1[DATA_INPUT_WITDH*2-1]}},Cache_Out_A1[DATA_INPUT_WITDH*2-1:DATA_INPUT_WITDH+9]};
					Xout_img <= {{9{Cache_Out_A1[DATA_INPUT_WITDH-1]}},Cache_Out_A1[DATA_INPUT_WITDH-1:9]};
				end
			default : begin
					Xout_rel <= Cache_Out_A1[DATA_INPUT_WITDH*2-1:DATA_INPUT_WITDH];
					Xout_img <= Cache_Out_A1[DATA_INPUT_WITDH-1:0];
				end
		endcase
	else
		begin
			Xout_rel <= 'd0;
			Xout_img <= 'd0;
		end
end
assign source_real = Xout_rel;
assign source_imag = Xout_img;

// -----------------------------------------------------------------
//*FFT Output Control Signal
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_valid <= 1'd0;
	else if(Cache_Cnt >= 3 && Cache_Cnt <= CACHE_LEN+2)
		source_valid <= 1'd1;
	else
		source_valid <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_sop <= 1'd0;
	else if(Cache_Cnt == 3)
		source_sop <= 1'd1;
	else
		source_sop <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_eop <= 1'd0;
	else if(Cache_Cnt == CACHE_LEN+2)
		source_eop <= 1'd1;
	else
		source_eop <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_exp <= 5'd0;
	else if(Cache_Cnt == 1)
		source_exp <= source_exp_max;
	else
		source_exp <= source_exp;
end
assign source_error = 2'd0; 


Pruning_Peak_Search
#(
	.FFT_DATA_WITDH					( DATA_INPUT_WITDH ),
	.LOG2_FFT_LEN					( LOG2_FFT_LEN ),
	.LOG2_FFT_NORZEROS_LEN			( LOG2_FFT_NORZEROS_LEN ),
	.SHIFT_BITS_LEN					( CACHE_ADDR_LEN ),
	.PEAK_NUM						( PEAK_NUM )
)
Pruning_Peak_Search_Init
(
	.clk							( clk ),
	.reset_n						( reset_n ),
	.source_valid					( source_valid ),
	.source_rel						( Xout_rel ),
	.source_img						( Xout_img ),
	.peak_location					( peak_location ),
	.Freq_Shift_Nums				( Freq_Shift_Nums ),
	.Freq_Sample					( 0 ),//Unit:Hz

	.peak_place_en					( peak_place_en ),
	.peak_place						( peak_place )
);

endmodule
// =======================================================================================


