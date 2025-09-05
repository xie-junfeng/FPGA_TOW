`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:00:30
// Design Name: 
// Module Name: FFT_Process_Ctrl
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


module  FFT_Process_Ctrl
#(
	parameter LOG2_FFT_LEN		= 11
)
(
	input	wire							clk,
	input	wire							reset_n,
	input	wire							sink_eop,
	input	wire [2:0]						Current_state,
	
	output	reg								source_exp_flag,
	output	reg								mem_switch,
	output	reg	[4:0]						FFT_stage,
	output	reg [19:0]						Stage_Cnt,
	output	reg [19:0]						FFT_Wn_Cnt,
	output	reg	[LOG2_FFT_LEN-4:0]			Butfly_raddr_a,
	output	reg	[LOG2_FFT_LEN-4:0]			Butfly_raddr_b,
	output	wire[LOG2_FFT_LEN-4:0]			Butfly_waddr_a,
	output	wire[LOG2_FFT_LEN-4:0]			Butfly_waddr_b
);

// -----------------------------------------------------------------
//* FSM & PARA
localparam	FFT_STATE_RESET		= 3'b000;
localparam	FFT_STATE_READ		= 3'b001;
localparam	FFT_STATE_FIRST		= 3'b010;
localparam	FFT_STATE_SECOND	= 3'b011;
localparam	FFT_STATE_THIRD		= 3'b100;
localparam	FFT_STATE_FOURTH	= 3'b101;
localparam	FFT_STATE_TWIDDLE	= 3'b110;
localparam	FFT_STATE_END		= 3'b111;

localparam	DPRAM_LEN_DIV2		= 2**(LOG2_FFT_LEN-4)-1;
localparam	DPRAM_LEN_DIV4		= 2**(LOG2_FFT_LEN-5)-1;

// -----------------------------------------------------------------
//* REG
reg [19:0]						FFT_Cnt;
reg	[LOG2_FFT_LEN-4:0]			dpr_addr;
reg	[LOG2_FFT_LEN-4:0]			dpr_addr_a1,dpr_addr_b1;
reg	[LOG2_FFT_LEN-4:0]			dpr_addr_a2,dpr_addr_b2;
reg	[LOG2_FFT_LEN-4:0]			dpr_addr_a3,dpr_addr_b3;
reg	[LOG2_FFT_LEN-4:0]			dpr_addr_a4,dpr_addr_b4;
reg	[LOG2_FFT_LEN-4:0]			dpr_addr_a5,dpr_addr_b5;
reg	[LOG2_FFT_LEN-4:0]			dpr_addr_a6,dpr_addr_b6;
reg	[LOG2_FFT_LEN-4:0]			dpr_addr_a7,dpr_addr_b7;
reg	[LOG2_FFT_LEN-4:0]			dpr_addr_a8,dpr_addr_b8;

// -----------------------------------------------------------------
//* FFT_PROCESS
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			dpr_addr_a1 <= 'd0;
			dpr_addr_a2 <= 'd0;
			dpr_addr_a3 <= 'd0;
			dpr_addr_a4 <= 'd0;
			dpr_addr_a5 <= 'd0;
			dpr_addr_a6 <= 'd0;
			dpr_addr_a7 <= 'd0;
			dpr_addr_a8 <= 'd0;
			dpr_addr_b1 <= 'd0;
			dpr_addr_b2 <= 'd0;
			dpr_addr_b3 <= 'd0;
			dpr_addr_b4 <= 'd0;
			dpr_addr_b5 <= 'd0;
			dpr_addr_b6 <= 'd0;
			dpr_addr_b7 <= 'd0;
			dpr_addr_b8 <= 'd0;
		end
	else
		begin
			dpr_addr_a1 <= Butfly_raddr_a;
			dpr_addr_a2 <= dpr_addr_a1;
			dpr_addr_a3 <= dpr_addr_a2;
			dpr_addr_a4 <= dpr_addr_a3;
			dpr_addr_a5 <= dpr_addr_a4;
			dpr_addr_a6 <= dpr_addr_a5;
			dpr_addr_a7 <= dpr_addr_a6;
			dpr_addr_a8 <= dpr_addr_a7;
			dpr_addr_b1 <= Butfly_raddr_b;
			dpr_addr_b2 <= dpr_addr_b1;
			dpr_addr_b3 <= dpr_addr_b2;
			dpr_addr_b4 <= dpr_addr_b3;
			dpr_addr_b5 <= dpr_addr_b4;
			dpr_addr_b6 <= dpr_addr_b5;
			dpr_addr_b7 <= dpr_addr_b6;
			dpr_addr_b8 <= dpr_addr_b7;
		end
end
assign Butfly_waddr_a = dpr_addr_a8;
assign Butfly_waddr_b = dpr_addr_b8;

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_exp_flag <= 0;
	else if(Stage_Cnt == DPRAM_LEN_DIV4)
		source_exp_flag <= 1;
	else
		source_exp_flag <= 0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		mem_switch <= 0;
	else if(Current_state == FFT_STATE_READ && sink_eop == 1)
		mem_switch <= ~mem_switch;
	else if(Current_state == FFT_STATE_FIRST && Stage_Cnt >= DPRAM_LEN_DIV2+31)
		mem_switch <= ~mem_switch;
	else if(Current_state == FFT_STATE_SECOND && Stage_Cnt >= DPRAM_LEN_DIV2+31)
		mem_switch <= ~mem_switch;
	else if(Current_state == FFT_STATE_THIRD && Stage_Cnt >= DPRAM_LEN_DIV2+31)
		mem_switch <= ~mem_switch;
	else if(Current_state == FFT_STATE_FOURTH && Stage_Cnt >= DPRAM_LEN_DIV2+31)
		mem_switch <= ~mem_switch;
	else
		mem_switch <= mem_switch;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Stage_Cnt <= 'd0;
	else if(Current_state == FFT_STATE_FIRST || Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
		begin
			if(Stage_Cnt < DPRAM_LEN_DIV2+31)
				Stage_Cnt <= Stage_Cnt + 'd1;
			else
				Stage_Cnt <= 'd0;
		end
	else
		Stage_Cnt <= 'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		FFT_Wn_Cnt <= 'd0;
	else if(Current_state == FFT_STATE_FIRST || Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
		begin
			if(Stage_Cnt >= DPRAM_LEN_DIV2+31)
				FFT_Wn_Cnt <= 'd0;
			else if(FFT_Wn_Cnt < DPRAM_LEN_DIV2)
				FFT_Wn_Cnt <= FFT_Wn_Cnt + 'd1;
			else
				FFT_Wn_Cnt <= FFT_Wn_Cnt;
		end
	else
		FFT_Wn_Cnt <= 'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		FFT_Cnt <= 'd0;
	else if(Current_state == FFT_STATE_FIRST || Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
		begin
			if(Stage_Cnt >= DPRAM_LEN_DIV2+31)
				FFT_Cnt <= 'd0;
			else if(Stage_Cnt >= 21 && FFT_Cnt < DPRAM_LEN_DIV2)
				FFT_Cnt <= FFT_Cnt + 'd1;
			else
				FFT_Cnt <= FFT_Cnt;
		end
	else
		FFT_Cnt <= 'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		FFT_stage <= 5'd0;
	else if(Current_state == FFT_STATE_FIRST || Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
		begin
			if(Stage_Cnt >= DPRAM_LEN_DIV2+31)
				FFT_stage <= FFT_stage + 5'd1;
			else
				FFT_stage <= FFT_stage;
		end
	else
		FFT_stage <= 5'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		dpr_addr <= 'd0;
	else if(Current_state == FFT_STATE_FIRST)
		begin
			if(Stage_Cnt >= 21 && Stage_Cnt <= DPRAM_LEN_DIV2+21)
				case(FFT_stage)
					5'd0 :	dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
					5'd1 :	if(FFT_Cnt[1:0] == 2'b00 || FFT_Cnt[1:0] == 2'b10)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd2 :	if(FFT_Cnt[2:0] == 3'b000 || FFT_Cnt[2:0] == 3'b100)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd3 :	if(FFT_Cnt[3:0] == 4'b0000 || FFT_Cnt[3:0] == 4'b1000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd4 :	if(FFT_Cnt[4:0] == 5'b0000 || FFT_Cnt[4:0] == 5'b1_0000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd5 :	if(FFT_Cnt[5:0] == 6'b00000 || FFT_Cnt[5:0] == 6'b10_0000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd6 :	if(FFT_Cnt[6:0] == 7'd0 || FFT_Cnt[6:0] == 7'b100_0000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd7 :	if(FFT_Cnt[7:0] == 8'd0 || FFT_Cnt[7:0] == 8'b1000_0000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd8 :	if(FFT_Cnt[8:0] == 9'd0 || FFT_Cnt[8:0] == 9'b1_0000_0000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd9 :	if(FFT_Cnt[9:0] == 10'd0 || FFT_Cnt[9:0] == 10'b10_0000_0000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd10:	if(FFT_Cnt[10:0] == 11'd0 || FFT_Cnt[10:0] == 11'b100_0000_0000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd11:	if(FFT_Cnt[11:0] == 12'd0 || FFT_Cnt[11:0] == 12'b1000_0000_0000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd12:	if(FFT_Cnt[12:0] == 13'd0 || FFT_Cnt[12:0] == 13'b1_0000_0000_0000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd13:	if(FFT_Cnt[13:0] == 14'd0 || FFT_Cnt[13:0] == 14'b10_0000_0000_0000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd14:	if(FFT_Cnt[14:0] == 15'd0 || FFT_Cnt[14:0] == 15'b100_0000_0000_0000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd15:	if(FFT_Cnt[15:0] == 16'd0 || FFT_Cnt[15:0] == 16'b1000_0000_0000_0000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd16:	if(FFT_Cnt[16:0] == 17'd0 || FFT_Cnt[16:0] == 17'b1_0000_0000_0000_0000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					5'd17:	if(FFT_Cnt[17:0] == 18'd0 || FFT_Cnt[17:0] == 18'b10_0000_0000_0000_0000)
								dpr_addr <= {FFT_Cnt[LOG2_FFT_LEN-5:0],1'd0};
							else
								dpr_addr <= dpr_addr + 1;
					default:dpr_addr <= 'd0;
				endcase
			else if(Stage_Cnt >= DPRAM_LEN_DIV2+31)
				dpr_addr <= 'd0;
			else
				dpr_addr <= dpr_addr;
		end
	else if(Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
		begin
			if(Stage_Cnt > 21 && Stage_Cnt <= DPRAM_LEN_DIV2+21)
				dpr_addr <= dpr_addr + 2;
			else if(Stage_Cnt >= DPRAM_LEN_DIV2+31)
				dpr_addr <= 'd0;
			else
				dpr_addr <= dpr_addr;
		end
	else
		dpr_addr <= 'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Butfly_raddr_a <= 'd0;
	else if(Stage_Cnt > 20 && Stage_Cnt <= DPRAM_LEN_DIV2+23)
		Butfly_raddr_a <= dpr_addr;
	else
		Butfly_raddr_a <= Butfly_raddr_a;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Butfly_raddr_b <= 'd0;
	else if(Current_state == FFT_STATE_FIRST && Stage_Cnt > 20 && Stage_Cnt <= DPRAM_LEN_DIV2+23)
		case(FFT_stage)
			5'd0 : Butfly_raddr_b <= dpr_addr + 1;
			5'd1 : Butfly_raddr_b <= dpr_addr + 2;
			5'd2 : Butfly_raddr_b <= dpr_addr + 4;
			5'd3 : Butfly_raddr_b <= dpr_addr + 8;
			5'd4 : Butfly_raddr_b <= dpr_addr + 16;
			5'd5 : Butfly_raddr_b <= dpr_addr + 32;
			5'd6 : Butfly_raddr_b <= dpr_addr + 64;
			5'd7 : Butfly_raddr_b <= dpr_addr + 128;
			5'd8 : Butfly_raddr_b <= dpr_addr + 256;
			5'd9 : Butfly_raddr_b <= dpr_addr + 512;
			5'd10: Butfly_raddr_b <= dpr_addr + 1024;
			5'd11: Butfly_raddr_b <= dpr_addr + 2048;
			5'd12: Butfly_raddr_b <= dpr_addr + 4096;
			5'd13: Butfly_raddr_b <= dpr_addr + 8192;
			5'd14: Butfly_raddr_b <= dpr_addr + 16384;
			5'd15: Butfly_raddr_b <= dpr_addr + 32768;
			5'd16: Butfly_raddr_b <= dpr_addr + 65536;
			5'd17: Butfly_raddr_b <= dpr_addr + 131072;
			default:Butfly_raddr_b <= 'd0;
		endcase
	else if((Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH) && Stage_Cnt > 20 && Stage_Cnt <= DPRAM_LEN_DIV2+23)
		Butfly_raddr_b <= dpr_addr + 1;
	else
		Butfly_raddr_b <= Butfly_raddr_b;
end

endmodule

