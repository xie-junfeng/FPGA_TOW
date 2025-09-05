`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:50:26
// Design Name: 
// Module Name: Pruning_Process_Ctrl
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


module  Pruning_Process_Ctrl
#(
	parameter LOG2_FFT_NORZEROS_LEN	= 11,
	parameter LOG2_FFT_LEN			= 11
)
(
	input	wire							clk,
	input	wire							reset_n,
	input	wire							sink_eop,
	input	wire [3:0]						Current_state,
	
	output	reg								mem_switch,
	output	reg	[4:0]						FFT_stage,
	output	reg [31:0]						Stage_Cnt,
	output	reg [31:0]						Stage_Cnt_Peak,
	output	reg	[LOG2_FFT_NORZEROS_LEN-4:0]	Butfly_raddr_a,
	output	reg	[LOG2_FFT_NORZEROS_LEN-4:0]	Butfly_raddr_b,
	output	wire[LOG2_FFT_NORZEROS_LEN-4:0]	Butfly_waddr_a,
	output	wire[LOG2_FFT_NORZEROS_LEN-4:0]	Butfly_waddr_b
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

localparam	DPRAM_LEN			= 2**(LOG2_FFT_NORZEROS_LEN-3)-1;
localparam	DPRAM_LEN_DIV2		= 2**(LOG2_FFT_NORZEROS_LEN-4)-1;
localparam	DPRAM_LEN_DIV4		= 2**(LOG2_FFT_NORZEROS_LEN-5)-1;

// -----------------------------------------------------------------
//* REG
reg [7:0]								Second_Cnt;
reg [19:0]								FFT_Cnt;
reg	[LOG2_FFT_NORZEROS_LEN-4:0]			dpr_addr;
reg [LOG2_FFT_NORZEROS_LEN-4:0]			Butfly_Wraddr_a;
reg [LOG2_FFT_NORZEROS_LEN-4:0]			Butfly_Wraddr_b;
reg	[LOG2_FFT_NORZEROS_LEN-4:0]			dpr_addr_a1,dpr_addr_b1;
reg	[LOG2_FFT_NORZEROS_LEN-4:0]			dpr_addr_a2,dpr_addr_b2;
reg	[LOG2_FFT_NORZEROS_LEN-4:0]			dpr_addr_a3,dpr_addr_b3;
reg	[LOG2_FFT_NORZEROS_LEN-4:0]			dpr_addr_a4,dpr_addr_b4;
reg	[LOG2_FFT_NORZEROS_LEN-4:0]			dpr_addr_a5,dpr_addr_b5;
reg	[LOG2_FFT_NORZEROS_LEN-4:0]			dpr_addr_a6,dpr_addr_b6;
reg	[LOG2_FFT_NORZEROS_LEN-4:0]			dpr_addr_a7,dpr_addr_b7;
reg	[LOG2_FFT_NORZEROS_LEN-4:0]			dpr_addr_a8,dpr_addr_b8;

// -----------------------------------------------------------------
//* FFT_PROCESS
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			Butfly_Wraddr_a <= 'd0;
			Butfly_Wraddr_b <= 'd0;
		end
	else if(Current_state == FFT_STATE_FIRST)
		begin
			Butfly_Wraddr_a <= Stage_Cnt;
			Butfly_Wraddr_b <= 0;
		end
	else if(Current_state == FFT_STATE_SECOND)
		begin
			Butfly_Wraddr_a <= Stage_Cnt;
			Butfly_Wraddr_b <= 0;
		end
	else
		begin
			Butfly_Wraddr_a <= Butfly_raddr_a;
			Butfly_Wraddr_b <= Butfly_raddr_b;
		end
end

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
			dpr_addr_a1 <= Butfly_Wraddr_a;
			dpr_addr_a2 <= dpr_addr_a1;
			dpr_addr_a3 <= dpr_addr_a2;
			dpr_addr_a4 <= dpr_addr_a3;
			dpr_addr_a5 <= dpr_addr_a4;
			dpr_addr_a6 <= dpr_addr_a5;
			dpr_addr_a7 <= dpr_addr_a6;
			dpr_addr_a8 <= dpr_addr_a7;
			dpr_addr_b1 <= Butfly_Wraddr_b;
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
		mem_switch <= 0;
	else if(Current_state == FFT_STATE_READ && sink_eop == 1)
		mem_switch <= ~mem_switch;
	else if(Current_state == FFT_STATE_FIRST && Stage_Cnt > DPRAM_LEN+8)
		mem_switch <= ~mem_switch;
	else if(Current_state == FFT_STATE_SECOND && Stage_Cnt > Stage_Cnt_Peak+8)
		mem_switch <= ~mem_switch;
	// else if(Current_state == FFT_STATE_THIRD && Stage_Cnt >= DPRAM_LEN_DIV2+31)
		// mem_switch <= ~mem_switch;
	else
		mem_switch <= mem_switch;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Second_Cnt <= 8'd0;
	else if(Current_state == FFT_STATE_SECOND)
		begin
			if(Stage_Cnt > Stage_Cnt_Peak+8)
				Second_Cnt <= Second_Cnt + 8'd1;
			else
				Second_Cnt <= Second_Cnt;
		end
	else
		Second_Cnt <= 8'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Stage_Cnt_Peak <= DPRAM_LEN_DIV2;
	else if(Current_state == FFT_STATE_SECOND)
		case(Second_Cnt)
			8'd0 : Stage_Cnt_Peak <= DPRAM_LEN_DIV2;
			8'd1 : Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>1;
			8'd2 : Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>2;
			8'd3 : Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>3;
			8'd4 : Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>4;
			8'd5 : Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>5;
			8'd6 : Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>6;
			8'd7 : Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>7;
			8'd8 : Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>8;
			8'd9 : Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>9;
			8'd10: Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>10;
			8'd11: Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>11;
			8'd12: Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>12;
			8'd13: Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>13;
			8'd14: Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>14;
			8'd15: Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>15;
			8'd16: Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>16;
			8'd17: Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>17;
			8'd18: Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>18;
			8'd19: Stage_Cnt_Peak <= DPRAM_LEN_DIV2>>19;
			default : Stage_Cnt_Peak <= DPRAM_LEN_DIV2;
		endcase
	else
		Stage_Cnt_Peak <= DPRAM_LEN_DIV2;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Stage_Cnt <= 'd0;
	else if(Current_state == FFT_STATE_FIRST)
		begin
			if(Stage_Cnt <= DPRAM_LEN+8)
				Stage_Cnt <= Stage_Cnt + 'd1;
			else
				Stage_Cnt <= 'd0;
		end
	else if(Current_state == FFT_STATE_SECOND)
		begin
			if(Stage_Cnt <= Stage_Cnt_Peak+8)
				Stage_Cnt <= Stage_Cnt + 'd1;
			else
				Stage_Cnt <= 'd0;
		end
	else if(Current_state == FFT_STATE_THIRD)
		begin
			if(Stage_Cnt < 9)
				Stage_Cnt <= Stage_Cnt + 'd1;
			else
				Stage_Cnt <= 'd0;
		end
	else if(Current_state == FFT_STATE_FOURTH || Current_state == FFT_STATE_FIFTH)
		begin
			if(Stage_Cnt < 6)
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
		FFT_stage <= LOG2_FFT_LEN - LOG2_FFT_NORZEROS_LEN;
	else if(Current_state == FFT_STATE_FIRST)
		begin
			if(Stage_Cnt == DPRAM_LEN+8)
				FFT_stage <= FFT_stage + 5'd1;
			else
				FFT_stage <= FFT_stage;
		end
	else if(Current_state == FFT_STATE_SECOND)
		begin
			if(Stage_Cnt == Stage_Cnt_Peak+8)
				FFT_stage <= FFT_stage + 5'd1;
			else
				FFT_stage <= FFT_stage;
		end
	else if(Current_state == FFT_STATE_THIRD)
		begin
			if(Stage_Cnt >= 9)
				FFT_stage <= FFT_stage + 5'd1;
			else
				FFT_stage <= FFT_stage;
		end
	else if(Current_state == FFT_STATE_FOURTH)
		begin
			if(Stage_Cnt > 5)
				FFT_stage <= FFT_stage + 5'd1;
			else
				FFT_stage <= FFT_stage;
		end
	else if(Current_state == FFT_STATE_FIFTH)
		FFT_stage <= FFT_stage;
	else
		FFT_stage <= LOG2_FFT_LEN - LOG2_FFT_NORZEROS_LEN;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		FFT_Cnt <= 'd0;
	else if(Current_state == FFT_STATE_FIRST)
		begin
			if(Stage_Cnt >= DPRAM_LEN+8)
				FFT_Cnt <= 'd0;
			else if(FFT_Cnt < DPRAM_LEN)
				FFT_Cnt <= FFT_Cnt + 'd1;
			else
				FFT_Cnt <= FFT_Cnt;
		end
	else if(Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
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
		dpr_addr <= 'd0;
	else if(Current_state == FFT_STATE_FIRST)
		begin
			if(Stage_Cnt < DPRAM_LEN && Stage_Cnt[0] == 1)
				dpr_addr <= dpr_addr + 2;
			else if(Stage_Cnt >= DPRAM_LEN+8)
				dpr_addr <= 'd0;
			else
				dpr_addr <= dpr_addr;
		end
	else if(Current_state == FFT_STATE_SECOND)
		begin
			if(Stage_Cnt < Stage_Cnt_Peak && Stage_Cnt[0] == 1'b1)
				dpr_addr <= dpr_addr + 3;
			else if(Stage_Cnt < Stage_Cnt_Peak)
				dpr_addr <= dpr_addr + 1;
			else if(Stage_Cnt >= Stage_Cnt_Peak+8)
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
	else if(Current_state == FFT_STATE_FIRST && Stage_Cnt <= DPRAM_LEN)
		Butfly_raddr_a <= dpr_addr;
	else if(Current_state == FFT_STATE_SECOND && Stage_Cnt <= Stage_Cnt_Peak)
		Butfly_raddr_a <= dpr_addr;
	else if(Current_state == FFT_STATE_THIRD && Stage_Cnt <= 1)
		Butfly_raddr_a <= dpr_addr;
	else
		Butfly_raddr_a <= Butfly_raddr_a;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Butfly_raddr_b <= 'd0;
	else if(Current_state == FFT_STATE_FIRST || Current_state == FFT_STATE_THIRD)
		Butfly_raddr_b <= dpr_addr + 1;
	else if(Current_state == FFT_STATE_SECOND)
		Butfly_raddr_b <= dpr_addr + 2;
	else
		Butfly_raddr_b <= Butfly_raddr_b;
end

endmodule

