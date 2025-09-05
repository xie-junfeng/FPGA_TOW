`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:51:08
// Design Name: 
// Module Name: Pruning_Wn_Ctrl
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


module  Pruning_Wn_Ctrl
#(
	parameter TWIDDLE_PRECISION		= 11,
	parameter LOG2_FFT_NORZEROS_LEN	= 11,
	parameter LOG2_FFT_LEN			= 11,
	parameter SHIFT_BITS_LEN		= 11
)
(
	input	wire							clk,
	input	wire							reset_n,
	input	wire							pruning_sop,
	input	wire [3:0]						Current_state,
	input	wire [4:0]						FFT_stage,
	input	wire [31:0]						Stage_Cnt,
	input	wire [LOG2_FFT_NORZEROS_LEN-1:0]peak_location,
	input	wire [LOG2_FFT_NORZEROS_LEN:0]	Repeat_Cnt,
	
	output	reg								First_Wn_ready,
	output	reg [LOG2_FFT_LEN-1:0]			Freq_Shift_Nums,
	output	wire[2*TWIDDLE_PRECISION-1:0]	Twiddle_factor0,
	output	wire[2*TWIDDLE_PRECISION-1:0]	Twiddle_factor1
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

// localparam	SHIFT_BITS_NUMS		= 2**(SHIFT_BITS_LEN-1)+1;
localparam	SHIFT_BITS_NUMS		= 2**(SHIFT_BITS_LEN-1);
localparam	DPRAM_LEN_DIV2		= 2**(LOG2_FFT_LEN-4)-1;
localparam	DPRAM_LEN			= 2**(LOG2_FFT_LEN-3);
localparam	DPRAM_LEN_DOUBLE	= 2**(LOG2_FFT_LEN-3)*2;
localparam	DPRAM_LEN_TRE		= 2**(LOG2_FFT_LEN-3)*3;
localparam	PI_DOUBLE			= 32'd2147483647;//pi*2=(2^31-1)
localparam	REPEAT_DIV2			= 2**(SHIFT_BITS_LEN-2)-1;
localparam	PEAK_ZERO_LAST		= 2**(LOG2_FFT_LEN)-2**(SHIFT_BITS_LEN-1);

// -----------------------------------------------------------------
//* REG
reg								Peak_Zero_flag;
reg  [3:0]						Current_state_reg;
reg  [7:0]						Buf_Cnt;
reg  [15:0]						Cnt;
reg  [31:0]						Shift_Len;
reg  [4:0]						FFT_stage_reg;
reg								Twiddle_Wr[LOG2_FFT_NORZEROS_LEN-2:0];
reg  [2*TWIDDLE_PRECISION-1:0]	Twiddle_r0[LOG2_FFT_NORZEROS_LEN-2:0];
reg  [2*TWIDDLE_PRECISION-1:0]	Twiddle_r1[LOG2_FFT_NORZEROS_LEN-2:0];
reg  [2*TWIDDLE_PRECISION-1:0]	Twiddle_fr0;
reg  [2*TWIDDLE_PRECISION-1:0]	Twiddle_fr1;
reg  [2*LOG2_FFT_LEN-LOG2_FFT_NORZEROS_LEN-1:0]			Addr_Wn_complex;
reg  [2*LOG2_FFT_LEN-LOG2_FFT_NORZEROS_LEN-1:0]			Addr_Wn_complex0;
reg  [2*LOG2_FFT_LEN-LOG2_FFT_NORZEROS_LEN-1:0]			Addr_Wn_complex1;
reg  [LOG2_FFT_LEN-1:0]			Wn_complex_data0;
reg  [LOG2_FFT_LEN-1:0]			Wn_complex_data1;
reg  [LOG2_FFT_LEN+TWIDDLE_PRECISION-1:0]		Addr_Wn_Phase0;
reg  [LOG2_FFT_LEN+TWIDDLE_PRECISION-1:0]		Addr_Wn_Phase1;

// -----------------------------------------------------------------
//* WIRE
wire	   [2*TWIDDLE_PRECISION-1:0]	Twiddle_fw0;
wire	   [2*TWIDDLE_PRECISION-1:0]	Twiddle_fw1;
wire signed[TWIDDLE_PRECISION-1:0]		Twiddle_Phase0;
wire signed[TWIDDLE_PRECISION-1:0]		Twiddle_Phase1;
wire signed[TWIDDLE_PRECISION-1:0]		Wn_Sin_out0,Wn_Cos_out0;
wire signed[TWIDDLE_PRECISION-1:0]		Wn_Sin_out1,Wn_Cos_out1;


// ------------------------------------------------------------------
//* FFT Wn Control
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Peak_Zero_flag <= 1'd0;
	else if(pruning_sop == 1 && peak_location == 0)
		Peak_Zero_flag <= 1'd1;
	else if(pruning_sop == 1 && peak_location != 0)
		Peak_Zero_flag <= 1'd0;
	else
		Peak_Zero_flag <= Peak_Zero_flag;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Freq_Shift_Nums <= 0;
	else
		Freq_Shift_Nums <= ({{(LOG2_FFT_LEN-LOG2_FFT_NORZEROS_LEN){1'b0}},peak_location} <<< SHIFT_BITS_LEN) - SHIFT_BITS_NUMS;
end

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
		FFT_stage_reg <= 5'd0;
	else
		FFT_stage_reg <= FFT_stage;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_complex <= 'd0;
	else if(FFT_stage == LOG2_FFT_LEN-4 && FFT_stage_reg == LOG2_FFT_LEN-5)
		begin
			if(Peak_Zero_flag == 1 && Repeat_Cnt == REPEAT_DIV2 )
				Addr_Wn_complex <= PEAK_ZERO_LAST;
			else
				Addr_Wn_complex <= Addr_Wn_complex + 'd2;
		end
	else if(pruning_sop == 1 && peak_location != 0)
		Addr_Wn_complex <= ({{(2*LOG2_FFT_LEN-2*LOG2_FFT_NORZEROS_LEN){1'b0}},peak_location} <<< SHIFT_BITS_LEN) - SHIFT_BITS_NUMS;
	else if(pruning_sop == 1 && peak_location == 0)
		Addr_Wn_complex <= ({{(2*LOG2_FFT_LEN-2*LOG2_FFT_NORZEROS_LEN){1'b0}},peak_location} <<< SHIFT_BITS_LEN);
	else if(Current_state == FFT_STATE_RESET)
		Addr_Wn_complex <= 'd0;
	else
		Addr_Wn_complex <= Addr_Wn_complex;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Buf_Cnt <= 8'd0;
	else if(Current_state == FFT_STATE_FIRST)
		begin
			if(Buf_Cnt < 8'hFF)
				Buf_Cnt <= Buf_Cnt + 8'd1;
			else
				Buf_Cnt <= Buf_Cnt;
		end
	else
		Buf_Cnt <= 8'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Shift_Len <= LOG2_FFT_NORZEROS_LEN-1;
	else if(Current_state == FFT_STATE_FIRST)
		begin
			if(Shift_Len > 0)
				Shift_Len <= Shift_Len - 1;
			else
				Shift_Len <= Shift_Len;
		end
	else
		Shift_Len <= LOG2_FFT_NORZEROS_LEN-1;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_complex0 <= 'd0;
	else if(Current_state == FFT_STATE_WN_PRE || FFT_stage == LOG2_FFT_LEN-4)
		Addr_Wn_complex0 <= Addr_Wn_complex << (LOG2_FFT_NORZEROS_LEN-1);
	else if(Current_state == FFT_STATE_FIRST)
		Addr_Wn_complex0 <= Addr_Wn_complex << Shift_Len;
	else if(Current_state == FFT_STATE_RESET)
		Addr_Wn_complex0 <= 'd0;
	else
		Addr_Wn_complex0 <= Addr_Wn_complex0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_complex1 <= 'd0;
	else if(Current_state == FFT_STATE_WN_PRE || FFT_stage == LOG2_FFT_LEN-4)
		Addr_Wn_complex1 <= (Addr_Wn_complex + 1) << (LOG2_FFT_NORZEROS_LEN-1);
	else if(Current_state == FFT_STATE_FIRST)
		Addr_Wn_complex1 <= (Addr_Wn_complex + 1) << Shift_Len;
	else if(Current_state == FFT_STATE_RESET)
		Addr_Wn_complex1 <= 'd0;
	else
		Addr_Wn_complex1 <= Addr_Wn_complex1;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Wn_complex_data0 <= 'd0;
	else
		Wn_complex_data0 <= Addr_Wn_complex0[LOG2_FFT_LEN-1:0];
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Wn_complex_data1 <= 'd0;
	else
		Wn_complex_data1 <= Addr_Wn_complex1[LOG2_FFT_LEN-1:0];
end

// ------------------------------------------------------------------
//* FFT Twiddle Phase Calculate 0
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_Phase0 <= 'd0;
	else
		Addr_Wn_Phase0 <= Wn_complex_data0 * PI_DOUBLE;
end
assign Twiddle_Phase0 = Addr_Wn_Phase0[LOG2_FFT_LEN+TWIDDLE_PRECISION-1:LOG2_FFT_LEN];

Pruning_Cordic_Sin_Cos  Wn_complex0
(
	.clk			( clk ),
	.reset			( ~reset_n ),
	.Phase_in		( ~Twiddle_Phase0+1 ),//-2*pi~2*pi = -524288~524287
	
	.Sin			( Wn_Sin_out0 ),
	.Cos			( Wn_Cos_out0 )
);
assign Twiddle_fw0 = {Wn_Cos_out0,Wn_Sin_out0};

// ------------------------------------------------------------------
//* FFT Twiddle Phase Calculate 1
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_Phase1 <= 'd0;
	else
		Addr_Wn_Phase1 <= Wn_complex_data1 * PI_DOUBLE;
end
assign Twiddle_Phase1 = Addr_Wn_Phase1[LOG2_FFT_LEN+TWIDDLE_PRECISION-1:LOG2_FFT_LEN];

Pruning_Cordic_Sin_Cos  Wn_complex1
(
	.clk			( clk ),
	.reset			( ~reset_n ),
	.Phase_in		( ~Twiddle_Phase1+1 ),//-2*pi~2*pi = -524288~524287
	
	.Sin			( Wn_Sin_out1 ),
	.Cos			( Wn_Cos_out1 )
);
assign Twiddle_fw1 = {Wn_Cos_out1,Wn_Sin_out1};

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Cnt <= 16'd0;
	else if(Cnt >= 16'd1 && Cnt <= 16'd40)
		Cnt <= Cnt + 16'd1;
	else if(pruning_sop == 1 || FFT_stage == LOG2_FFT_LEN-4)
		Cnt <= 16'd1;
	else
		Cnt <= 16'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		First_Wn_ready <= 1'd0;
	else if(Current_state == FFT_STATE_WN_PRE && Cnt == 16'd34)
		First_Wn_ready <= 1'd1;
	else
		First_Wn_ready <= 1'd0;
end

genvar i;
generate
	for(i=0;i<LOG2_FFT_NORZEROS_LEN-1;i=i+1)
		begin : Wn_Ctrl
			always@(posedge clk or negedge reset_n)
			begin
				if(!reset_n)
					Twiddle_Wr[i] <= 1'd0;
				else if(Current_state == FFT_STATE_FIRST && Buf_Cnt == 8'd37+i)
					Twiddle_Wr[i] <= 1'd1;
				else
					Twiddle_Wr[i] <= 1'd0;
			end
		
			always@(posedge clk or negedge reset_n)
			begin
				if(!reset_n)
					begin
						Twiddle_r0[i] <= 'd0;
						Twiddle_r1[i] <= 'd0;
					end
				else if(Current_state == FFT_STATE_FIRST && Twiddle_Wr[i] == 1'd1)
					begin
						Twiddle_r0[i] <= Twiddle_fw0;
						Twiddle_r1[i] <= Twiddle_fw1;
					end
				else if(Current_state == FFT_STATE_RESET)
					begin
						Twiddle_r0[i] <= 'd0;
						Twiddle_r1[i] <= 'd0;
					end
				else
					begin
						Twiddle_r0[i] <= Twiddle_r0[i];
						Twiddle_r1[i] <= Twiddle_r1[i];
					end
			end
		end
endgenerate

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			Twiddle_fr0 <= 'd0;
			Twiddle_fr1 <= 'd0;
		end
	else if(Current_state == FFT_STATE_FIRST && Cnt == 16'd38)
		begin
			Twiddle_fr0 <= Twiddle_fw0;
			Twiddle_fr1 <= Twiddle_fw1;
		end
	else if(Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH || Current_state == FFT_STATE_FIFTH)
		begin
			Twiddle_fr0 <= Twiddle_r0[FFT_stage-SHIFT_BITS_LEN-1];
			Twiddle_fr1 <= Twiddle_r1[FFT_stage-SHIFT_BITS_LEN-1];
		end
	else if(Current_state == FFT_STATE_RESET)
		begin
			Twiddle_fr0 <= 'd0;
			Twiddle_fr1 <= 'd0;
		end
	else
		begin
			Twiddle_fr0 <= Twiddle_fr0;
			Twiddle_fr1 <= Twiddle_fr1;
		end
end
assign Twiddle_factor0 = Twiddle_fr0;
assign Twiddle_factor1 = Twiddle_fr1;

endmodule

