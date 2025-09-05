`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 14:59:28
// Design Name: 
// Module Name: FFT_OUT_PROCESS
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


module FFT_OUT_PROCESS  
#(
	parameter	DATA_INPUT_WITDH	= 12,
	parameter	LOG2_FFT_LEN		= 11
)
(
	input	wire							clk,
	input	wire							reset_n,
	input	wire							mem_switch,
	input	wire							Carry_MH_flag,
	input	wire							Carry_ML_flag,
	input	wire							sink_sop,
	input	wire							source_exp_flag,
	input	wire							source_v,
	input	wire							source_s,
	input	wire							source_e,
	input	wire[2*DATA_INPUT_WITDH+3:0]	dpr0_q_a,
	input	wire[2*DATA_INPUT_WITDH+3:0]	dpr1_q_a,
	
	output	reg	[LOG2_FFT_LEN-1:0]			source_addr,
	output	wire       						source_valid,
	output	wire       						source_sop,
	output	wire       						source_eop,
	output	wire [1:0]						source_error,
	output	reg  [4:0]						source_exp,
	output	signed[DATA_INPUT_WITDH-1:0]	source_real,
	output	signed[DATA_INPUT_WITDH-1:0]	source_imag
);

reg	signed[DATA_INPUT_WITDH+1:0]	Xout_rel;
reg	signed[DATA_INPUT_WITDH+1:0]	Xout_img;
reg	signed[DATA_INPUT_WITDH-1:0]	source_real1;
reg	signed[DATA_INPUT_WITDH-1:0]	source_imag1;
reg	[6:0]							source_valid_r;
reg	[6:0]							source_sop_r;
reg	[6:0]							source_eop_r;
reg	[15:0]							source_exp1;

// =============================================================================================================
//*FFT Output Result Process
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			Xout_rel <= 'd0;
			Xout_img <= 'd0;
		end
	else if(source_valid_r[3] == 1 && mem_switch == 1)
		begin
			Xout_rel <= dpr0_q_a[2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+2];
			Xout_img <= dpr0_q_a[DATA_INPUT_WITDH+1:0];
		end
	else if(source_valid_r[3] == 1 && mem_switch == 0)
		begin
			Xout_rel <= dpr1_q_a[2*DATA_INPUT_WITDH+3:DATA_INPUT_WITDH+2];
			Xout_img <= dpr1_q_a[DATA_INPUT_WITDH+1:0];
		end
	else
		begin
			Xout_rel <= 'd0;
			Xout_img <= 'd0;
		end
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			source_real1 <= 'd0;
			source_imag1 <= 'd0;
		end
	else if(Carry_MH_flag == 1)
		begin
			source_real1 <= Xout_rel[DATA_INPUT_WITDH+1:2];
			source_imag1 <= Xout_img[DATA_INPUT_WITDH+1:2];
		end
	else if(Carry_ML_flag == 1)
		begin
			source_real1 <= {Xout_rel[DATA_INPUT_WITDH+1],Xout_rel[DATA_INPUT_WITDH-1:1]};
			source_imag1 <= {Xout_img[DATA_INPUT_WITDH+1],Xout_img[DATA_INPUT_WITDH-1:1]};
		end
	else
		begin
			source_real1 <= {Xout_rel[DATA_INPUT_WITDH+1],Xout_rel[DATA_INPUT_WITDH-2:0]};
			source_imag1 <= {Xout_img[DATA_INPUT_WITDH+1],Xout_img[DATA_INPUT_WITDH-2:0]};
		end
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_exp1 <= 'd0;
	else if(source_exp_flag == 1)
		begin
			if(Carry_MH_flag == 1)
				source_exp1 <= source_exp1 + 2;
			else if(Carry_ML_flag == 1)
				source_exp1 <= source_exp1 + 1;
			else
				source_exp1 <= source_exp1;
		end
	else if(source_s == 1)
		begin
			if(Carry_MH_flag == 1)
				source_exp1 <= source_exp1 + 2;
			else if(Carry_ML_flag == 1)
				source_exp1 <= source_exp1 + 1;
			else
				source_exp1 <= source_exp1;
		end
	else if(source_e == 1)
		source_exp1 <= 'd0;
	else
		source_exp1 <= source_exp1;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_exp <= 'd0;
	else if(source_sop_r[0] == 1)
		source_exp <= source_exp1[4:0];
	else
		source_exp <= source_exp;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_addr <= 'd0;
	else if(source_v == 1)
		source_addr <= source_addr + 'd1;
	else
		source_addr <= 'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			source_valid_r <= 7'd0;
			source_sop_r <= 7'd0;
			source_eop_r <= 7'd0;
		end
	else
		begin
			source_valid_r <= {source_valid_r[5:0],source_v};
			source_sop_r <= {source_sop_r[5:0],source_s};
			source_eop_r <= {source_eop_r[5:0],source_e};
		end
end

assign source_valid = source_valid_r[5];
assign source_sop = source_sop_r[5];
assign source_eop = source_eop_r[5];
assign source_real = source_real1;
assign source_imag = source_imag1;
assign source_error = 2'd0;

endmodule
// =======================================================================================


