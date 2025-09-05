`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:46:34
// Design Name: 
// Module Name: FFT_FREQ_CAL
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

module  FFT_FREQ_CAL
#(
	parameter	FFT_DATA_WITDH	= 32'd12,
	parameter	LOG2_FFT_LEN	= 32'd11
)
(
	input							Clk,
	input							Reset,
	input							Pruning_finish,
	input							Pruning_sink_ready,
	input							source_valid,
	input signed[FFT_DATA_WITDH-1:0]rel,
	input signed[FFT_DATA_WITDH-1:0]img,
	
	output	reg						pruning_sop,
	output	reg[LOG2_FFT_LEN-1:0]	peak_location
);

// -----------------------------------------------------------------
//* PARAMETER
localparam	FFT_LEN		= 2**LOG2_FFT_LEN;//2^11

// -----------------------------------------------------------------
//* REG
reg									emend_en;
reg									source_v;
reg									source_v1;
reg									source_v2;
reg									source_v3;
reg									Pruning_finish1;
reg									Pruning_finish2;
reg									Pruning_finish3;
reg									Pruning_finish4;
reg		  [31:0]					Pruning_Cnt;
reg		  [LOG2_FFT_LEN-1:0]		fft_cnt;
reg		  [LOG2_FFT_LEN-1:0]		max_amp_location;
reg		  [LOG2_FFT_LEN-1:0]		max_amp_location1;
reg		  [LOG2_FFT_LEN-1:0]		max_amp_location2;
reg		  [LOG2_FFT_LEN-1:0]		max_amp_location3;
reg		  [LOG2_FFT_LEN-1:0]		max_amp_location4;
reg		  [LOG2_FFT_LEN-1:0]		max_amp_location5;
reg		  [LOG2_FFT_LEN-1:0]		max_amp_lp_buf;
reg		  [LOG2_FFT_LEN-1:0]		max_amp_lp_buf1;
reg		  [LOG2_FFT_LEN-1:0]		max_amp_lp_buf2;
reg		  [LOG2_FFT_LEN-1:0]		max_amp_lp_buf3;
reg		  [LOG2_FFT_LEN-1:0]		max_amp_lp_buf4;
reg		  [LOG2_FFT_LEN-1:0]		max_amp_lp_buf5;
reg									pruning_sop1;
reg									pruning_sop2;
reg									pruning_sop3;
reg		  [LOG2_FFT_LEN-1:0]		peak_location1;
reg		  [LOG2_FFT_LEN-1:0]		peak_location2;
reg		  [LOG2_FFT_LEN-1:0]		peak_location3;
reg	signed[2*FFT_DATA_WITDH-1:0]	max_amplitude;
reg	signed[2*FFT_DATA_WITDH-1:0]	max_amplitude1;
reg	signed[2*FFT_DATA_WITDH-1:0]	max_amplitude2;
reg	signed[2*FFT_DATA_WITDH-1:0]	max_amplitude3;
reg	signed[2*FFT_DATA_WITDH-1:0]	max_amplitude4;
reg	signed[2*FFT_DATA_WITDH-1:0]	max_amplitude5;
reg	signed[2*FFT_DATA_WITDH-1:0]	rel_saquar;
reg	signed[2*FFT_DATA_WITDH-1:0]	img_saquar;
reg	signed[2*FFT_DATA_WITDH-1:0]	result_add;

// -----------------------------------------------------------------
always@(posedge Clk)
begin
	rel_saquar <= rel * rel;
	img_saquar <= img * img;
	result_add <= rel_saquar + img_saquar;
end
						
// ------------ Keep Sync with result_add ------------
always @(posedge Clk or negedge Reset)					
begin
	if(!Reset)
		begin
			source_v1	<= 1'b0;
			source_v2	<= 1'b0;
			source_v3	<= 1'b0;
			source_v	<= 1'b0;
		end
	else
		begin
			source_v1	<= source_valid;
			source_v	<= source_v1;
			source_v2	<= source_v;
			source_v3	<= source_v2;
		end
end

always@(posedge Clk or negedge Reset)//记录FFT的fem
begin
	if(!Reset)
		fft_cnt <= 'd0;
	else if(source_v == 1)
		fft_cnt <= fft_cnt + 1;
	else
		fft_cnt <= 'd0;
end

always@(posedge Clk or negedge Reset)//Max(abs(FFT))
begin
	if(!Reset)
		begin
			max_amplitude		<= 'd0;
			max_amplitude1		<= 'd0;
			max_amplitude2		<= 'd0;
			max_amplitude3		<= 'd0;
			max_amplitude4		<= 'd0;
			max_amplitude5		<= 'd0;
			max_amp_lp_buf		<= 'd0;
			max_amp_lp_buf1		<= 'd0;
			max_amp_lp_buf2		<= 'd0;
			max_amp_lp_buf3		<= 'd0;
			max_amp_lp_buf4		<= 'd0;
			max_amp_lp_buf5		<= 'd0;
		end
	else if(result_add > max_amplitude)	
		begin
			max_amplitude		<= result_add;
			max_amplitude1		<= max_amplitude;
			max_amplitude2		<= max_amplitude1;
			max_amplitude3		<= max_amplitude2;
			max_amplitude4		<= max_amplitude3;
			max_amplitude5		<= max_amplitude4;
			max_amp_lp_buf		<= fft_cnt;
			max_amp_lp_buf1		<= max_amp_lp_buf;
			max_amp_lp_buf2		<= max_amp_lp_buf1;
			max_amp_lp_buf3		<= max_amp_lp_buf2;
			max_amp_lp_buf4		<= max_amp_lp_buf3;
			max_amp_lp_buf5		<= max_amp_lp_buf4;
		end
	else if(result_add > max_amplitude1)	
		begin
			max_amplitude		<= max_amplitude;
			max_amplitude1		<= result_add;
			max_amplitude2		<= max_amplitude1;
			max_amplitude3		<= max_amplitude2;
			max_amplitude4		<= max_amplitude3;
			max_amplitude5		<= max_amplitude4;
			max_amp_lp_buf		<= max_amp_lp_buf;
			max_amp_lp_buf1		<= fft_cnt;
			max_amp_lp_buf2		<= max_amp_lp_buf1;
			max_amp_lp_buf3		<= max_amp_lp_buf2;
			max_amp_lp_buf4		<= max_amp_lp_buf3;
			max_amp_lp_buf5		<= max_amp_lp_buf4;
		end
	else if(result_add > max_amplitude2)	
		begin
			max_amplitude		<= max_amplitude;
			max_amplitude1		<= max_amplitude1;
			max_amplitude2		<= result_add;
			max_amplitude3		<= max_amplitude2;
			max_amplitude4		<= max_amplitude3;
			max_amplitude5		<= max_amplitude4;
			max_amp_lp_buf		<= max_amp_lp_buf;
			max_amp_lp_buf1		<= max_amp_lp_buf1;
			max_amp_lp_buf2		<= fft_cnt;
			max_amp_lp_buf3		<= max_amp_lp_buf2;
			max_amp_lp_buf4		<= max_amp_lp_buf3;
			max_amp_lp_buf5		<= max_amp_lp_buf4;
		end
	else if(result_add > max_amplitude3)	
		begin
			max_amplitude		<= max_amplitude;
			max_amplitude1		<= max_amplitude1;
			max_amplitude2		<= max_amplitude2;
			max_amplitude3		<= result_add;
			max_amplitude4		<= max_amplitude3;
			max_amplitude5		<= max_amplitude4;
			max_amp_lp_buf		<= max_amp_lp_buf;
			max_amp_lp_buf1		<= max_amp_lp_buf1;
			max_amp_lp_buf2		<= max_amp_lp_buf2;
			max_amp_lp_buf3		<= fft_cnt;
			max_amp_lp_buf4		<= max_amp_lp_buf3;
			max_amp_lp_buf5		<= max_amp_lp_buf4;
		end
	else if(result_add > max_amplitude4)	
		begin
			max_amplitude		<= max_amplitude;
			max_amplitude1		<= max_amplitude1;
			max_amplitude2		<= max_amplitude2;
			max_amplitude3		<= max_amplitude3;
			max_amplitude4		<= result_add;
			max_amplitude5		<= max_amplitude4;
			max_amp_lp_buf		<= max_amp_lp_buf;
			max_amp_lp_buf1		<= max_amp_lp_buf1;
			max_amp_lp_buf2		<= max_amp_lp_buf2;
			max_amp_lp_buf3		<= max_amp_lp_buf3;
			max_amp_lp_buf4		<= fft_cnt;
			max_amp_lp_buf5		<= max_amp_lp_buf4;
		end
	else if(result_add > max_amplitude5)	
		begin
			max_amplitude		<= max_amplitude;
			max_amplitude1		<= max_amplitude1;
			max_amplitude2		<= max_amplitude2;
			max_amplitude3		<= max_amplitude3;
			max_amplitude4		<= max_amplitude4;
			max_amplitude5		<= result_add;
			max_amp_lp_buf		<= max_amp_lp_buf;
			max_amp_lp_buf1		<= max_amp_lp_buf1;
			max_amp_lp_buf2		<= max_amp_lp_buf2;
			max_amp_lp_buf3		<= max_amp_lp_buf3;
			max_amp_lp_buf4		<= max_amp_lp_buf4;
			max_amp_lp_buf5		<= fft_cnt;
		end
	else if(source_v2 == 0 && source_v3 == 1)
		begin
			max_amplitude		<= 'd0;
			max_amplitude1		<= 'd0;
			max_amplitude2		<= 'd0;
			max_amplitude3		<= 'd0;
			max_amplitude4		<= 'd0;
			max_amplitude5		<= 'd0;
			max_amp_lp_buf		<= 'd0;
			max_amp_lp_buf1		<= 'd0;
			max_amp_lp_buf2		<= 'd0;
			max_amp_lp_buf3		<= 'd0;
			max_amp_lp_buf4		<= 'd0;
			max_amp_lp_buf5		<= 'd0;
		end
	else
		begin
			max_amplitude		<= max_amplitude;
			max_amplitude1		<= max_amplitude1;
			max_amplitude2		<= max_amplitude2;
			max_amplitude3		<= max_amplitude3;
			max_amplitude4		<= max_amplitude4;
			max_amplitude5		<= max_amplitude5;
			max_amp_lp_buf		<= max_amp_lp_buf;
			max_amp_lp_buf1		<= max_amp_lp_buf1;
			max_amp_lp_buf2		<= max_amp_lp_buf2;
			max_amp_lp_buf3		<= max_amp_lp_buf3;
			max_amp_lp_buf4		<= max_amp_lp_buf4;
			max_amp_lp_buf5		<= max_amp_lp_buf5;
		end
end

always@(posedge Clk or negedge Reset)//Max(abs(FFT))
begin
	if(!Reset)
		begin
			max_amp_location	<= 'd0;
			max_amp_location1	<= 'd0;
			max_amp_location2	<= 'd0;
			max_amp_location3	<= 'd0;
			max_amp_location4	<= 'd0;
			max_amp_location5	<= 'd0;
		end
	else if(Pruning_sink_ready == 1)
		begin
			max_amp_location	<= 'd0;
			max_amp_location1	<= 'd0;
			max_amp_location2	<= 'd0;
			max_amp_location3	<= 'd0;
			max_amp_location4	<= 'd0;
			max_amp_location5	<= 'd0;
		end 
	else if(source_v == 0 && source_v2 == 1)
		begin
			max_amp_location <= max_amp_lp_buf;
			max_amp_location1 <= max_amp_lp_buf1;
			max_amp_location2 <= max_amp_lp_buf2;
			max_amp_location3 <= max_amp_lp_buf3;
			max_amp_location4 <= max_amp_lp_buf4;
			max_amp_location5 <= max_amp_lp_buf5;
		end 
	else
		begin
			max_amp_location <= max_amp_location;
			max_amp_location1 <= max_amp_location1;
			max_amp_location2 <= max_amp_location2;
			max_amp_location3 <= max_amp_location3;
			max_amp_location4 <= max_amp_location4;
			max_amp_location5 <= max_amp_location5;
		end 
end

//  --------- 定位频谱图中峰值所在位置 -------------
always@(posedge Clk or negedge Reset)//Max(abs(FFT))
begin
	if(!Reset)
		emend_en <= 1'b0;
	else if((source_v == 0 && source_v2 == 1) || (Pruning_finish3 == 1 && Pruning_finish4 == 0 && Pruning_sink_ready == 0))
		emend_en <= 1'b1;
	else
		emend_en <= 1'b0;
end

always @(posedge Clk or negedge Reset)					
begin
	if(!Reset)
		begin
			Pruning_finish1 <= 1'b0;
			Pruning_finish2 <= 1'b0;
			Pruning_finish3 <= 1'b0;
			Pruning_finish4 <= 1'b0;
		end
	else
		begin
			Pruning_finish1	<= Pruning_finish;
			Pruning_finish2	<= Pruning_finish1;
			Pruning_finish3	<= Pruning_finish2;
			Pruning_finish4	<= Pruning_finish3;
		end
end

always @(posedge Clk or negedge Reset)
begin
	if(!Reset)
		Pruning_Cnt <= 'd0;
	else if(Pruning_finish2 == 1'b1 && Pruning_finish3 == 1'b0 && Pruning_sink_ready == 0)
		Pruning_Cnt <= Pruning_Cnt + 1;
	else if(Pruning_sink_ready == 1)
		Pruning_Cnt <= 'd0;
	else
		Pruning_Cnt <= Pruning_Cnt;
end

always @(posedge Clk or negedge Reset)
begin
	if(!Reset)
		peak_location1 <= 'd0;
	else if(emend_en == 1'b1)
		case(Pruning_Cnt)
			32'd0 : peak_location1 <= max_amp_location;
			32'd1 : peak_location1 <= max_amp_location1;
			32'd2 : peak_location1 <= max_amp_location2;
			32'd3 : peak_location1 <= max_amp_location3;
			32'd4 : peak_location1 <= max_amp_location4;
			32'd5 : peak_location1 <= max_amp_location5;
			default: peak_location1 <= max_amp_location;
		endcase
	else
		peak_location1 <= peak_location1;
end

always @(posedge Clk or negedge Reset)
begin
	if(!Reset)
		pruning_sop1 <= 1'd0;
	else
		pruning_sop1 <= emend_en;
end

always @(posedge Clk or negedge Reset)
begin
	if(!Reset)
		begin
			pruning_sop2 <= 1'd0;
			pruning_sop3 <= 1'd0;
			pruning_sop <= 1'd0;
			peak_location2 <= 'd0;
			peak_location3 <= 'd0;
			peak_location <= 'd0;
		end
	else
		begin
			pruning_sop2 <= pruning_sop1;
			pruning_sop3 <= pruning_sop2;
			pruning_sop <= pruning_sop3;
			peak_location2 <= peak_location1;
			peak_location3 <= peak_location2;
			peak_location <= peak_location3;
		end
end

endmodule
// -------------- end module ---------------	

