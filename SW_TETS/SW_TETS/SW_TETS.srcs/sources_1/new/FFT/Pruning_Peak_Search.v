`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:51:53
// Design Name: 
// Module Name: Pruning_Peak_Search
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

module  Pruning_Peak_Search
#(
	parameter	FFT_DATA_WITDH			= 12,
	parameter	LOG2_FFT_NORZEROS_LEN	= 11,
	parameter	LOG2_FFT_LEN			= 11,
	parameter	SHIFT_BITS_LEN			= 11,
	parameter	PEAK_NUM				= 2
)
(
	input								clk,
	input								reset_n,
	input								source_valid,
	input signed[FFT_DATA_WITDH-1:0]	source_rel,
	input signed[FFT_DATA_WITDH-1:0]	source_img,
	input	wire[LOG2_FFT_NORZEROS_LEN-1:0]peak_location,
	input	wire[LOG2_FFT_LEN-1:0]		Freq_Shift_Nums,
	input		[31:0]					Freq_Sample,//Unit:Hz

	output								peak_place_en,
	output		reg[31:0]				peak_place
);

// localparam	FFT_LEN					= 2**LOG2_FFT_LEN-1;
localparam	RESOLUTION_RATIO_ZERO	= 2**LOG2_FFT_LEN-2**SHIFT_BITS_LEN;
localparam	RESOLUTION_RATIO_DIV2	= 2**(SHIFT_BITS_LEN-1);

reg									source_v;
reg									source_v1;
reg									source_v2;
reg									source_v3;
reg									source_v4;
reg									source_v5;
reg									peak_place_flag;
reg									peak_place_en1;
reg									peak_place_en2;
reg  [31:0]							Repeat_Out_Cnt;
reg  [LOG2_FFT_NORZEROS_LEN-1:0]	fft_cnt;
reg  [LOG2_FFT_NORZEROS_LEN-1:0]	max_amp_lp_buf/*synthesis noprune*/;
reg  [LOG2_FFT_NORZEROS_LEN-1:0]	max_amp_location/*synthesis noprune*/;
reg  [LOG2_FFT_NORZEROS_LEN-1:0]	Peak_amp_location/*synthesis noprune*/;
reg  signed[2*FFT_DATA_WITDH-1:0]	max_amplitude/*synthesis noprune*/;
reg  signed[2*FFT_DATA_WITDH-1:0]	max_amp_cache;
reg  signed[2*FFT_DATA_WITDH-1:0]	max_amp;
reg  signed[2*FFT_DATA_WITDH-1:0]	result_add;
reg  signed[2*FFT_DATA_WITDH-1:0]	rel_saquar;
reg  signed[2*FFT_DATA_WITDH-1:0]	img_saquar;
reg		   [LOG2_FFT_NORZEROS_LEN-1:0]	peak_location_reg;
reg		   [LOG2_FFT_LEN-1:0]		pruning_location;

// ----------------------------------------------------------
always@(posedge clk)
begin
	rel_saquar <= source_rel * source_rel;
	img_saquar <= source_img * source_img;
	result_add <= rel_saquar + img_saquar;
end

always @(posedge clk or negedge reset_n)					
begin
	if(!reset_n)
		pruning_location <= 'd0;
	else if(peak_location_reg == 0)
		pruning_location <= {peak_location_reg,{SHIFT_BITS_LEN{1'd0}}};
	else
		pruning_location <= {peak_location_reg,{SHIFT_BITS_LEN{1'd0}}}-RESOLUTION_RATIO_DIV2;
end

// ------------ Keep Sync with result_add ------------									
always @(posedge clk or negedge reset_n)					
begin
	if(!reset_n)
		begin
			source_v1	<= 1'b0;
			source_v2	<= 1'b0;
			source_v3	<= 1'b0;
			source_v4	<= 1'b0;
			source_v5	<= 1'b0;
			source_v	<= 1'b0;
		end
	else
		begin
			source_v1	<= source_valid;
			source_v	<= source_v1;
			source_v2	<= source_v;
			source_v3	<= source_v2;
			source_v4	<= source_v3;
			source_v5	<= source_v4;
		end
end

always@(posedge clk or negedge reset_n)//记录FFT的fem
begin
	if(!reset_n)
		fft_cnt <= 0;
	else if(source_v == 1)
		fft_cnt <= fft_cnt + 1;
	else
		fft_cnt <= 0;
end

always@(posedge clk or negedge reset_n)//Max(abs(FFT))
begin
	if(!reset_n)
		begin
			max_amplitude		<= 'd0;
			max_amp_lp_buf		<= 17'd0;
		end
	else if(result_add > max_amplitude)	
		begin 
			max_amplitude		<= result_add;
			max_amp_lp_buf		<= fft_cnt;
		end
	else if(source_v2 == 0 && source_v3 == 1)
		begin
			max_amplitude		<= 'd0;
			max_amp_lp_buf		<= 17'd0;
		end
	else
		begin
			max_amplitude		<= max_amplitude;
			max_amp_lp_buf		<= max_amp_lp_buf;
		end
end

always@(posedge clk or negedge reset_n)//Max(abs(FFT))
begin
	if(!reset_n)
		begin
			max_amp_location <= 'd0;
			max_amp_cache <= 'd0;
		end
	else if(Repeat_Out_Cnt >= PEAK_NUM)
		begin
			max_amp_location <= 'd0;
			max_amp_cache <= 'd0;
		end
	else if(source_v == 0 && source_v2 == 1)
		begin
			max_amp_location <= max_amp_lp_buf;
			max_amp_cache <= max_amplitude;
		end 
	else
		begin
			max_amp_location <= max_amp_location;
			max_amp_cache <= max_amp_cache;
		end 
end

always@(posedge clk or negedge reset_n)//Max(abs(FFT))
begin
	if(!reset_n)
		begin
			peak_location_reg <= 0;
			Peak_amp_location <= 'd0;
			max_amp <= 'd0;
		end
	else if(Repeat_Out_Cnt >= PEAK_NUM)
		begin
			peak_location_reg <= 0;
			Peak_amp_location <= 'd0;
			max_amp <= 'd0;
		end
	else if(max_amp < max_amp_cache)
		begin
			peak_location_reg <= peak_location;
			Peak_amp_location <= max_amp_location;
			max_amp <= max_amp_cache;
		end 
	else
		begin
			peak_location_reg <= peak_location_reg;
			Peak_amp_location <= Peak_amp_location;
			max_amp <= max_amp;
		end 
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
        Repeat_Out_Cnt <= 0;
	else if(Repeat_Out_Cnt >= PEAK_NUM)
		Repeat_Out_Cnt <= 0;
	else if(source_v4 == 0 && source_v5 == 1)
        Repeat_Out_Cnt <= Repeat_Out_Cnt + 1;
	else
		Repeat_Out_Cnt <= Repeat_Out_Cnt;
end

//  --------- 定位频谱图中峰值所在位置 -------------
always @(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		peak_place <= 'd0;
	else if(source_v4 == 0 && source_v5 == 1)
		begin
			if(peak_location_reg == 0 && Peak_amp_location >= RESOLUTION_RATIO_DIV2)
				peak_place <= RESOLUTION_RATIO_ZERO + Peak_amp_location;
			else
				peak_place <= pruning_location + Peak_amp_location;
		end
	else if(peak_place_en2 == 1)
		peak_place <= 'd0;
	else
		peak_place <= peak_place;
end

always @(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		peak_place_flag <= 1'd0;
	else if(Repeat_Out_Cnt == PEAK_NUM-1)
		peak_place_flag <= (~source_v3) & source_v4;
	else
		peak_place_flag <= 1'd0;
end

always @(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			peak_place_en1 <= 1'd0;
			peak_place_en2 <= 1'd0;
		end
	else
		begin
			peak_place_en1 <= peak_place_flag;
			peak_place_en2 <= peak_place_en1;
		end
end
assign peak_place_en = peak_place_en1;

endmodule
// -------------- end module ---------------	

