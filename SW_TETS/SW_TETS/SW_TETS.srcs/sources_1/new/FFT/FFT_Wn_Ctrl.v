`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:02:17
// Design Name: 
// Module Name: FFT_Wn_Ctrl
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

module  FFT_Wn_Ctrl
#(
	parameter LOG2_FFT_LEN		= 11
)
(
	input	wire							clk,
	input	wire							reset_n,
	input	wire [2:0]						Current_state,
	input	wire [4:0]						FFT_stage,
	input	wire [19:0]						Stage_Cnt,
	input	wire [19:0]						FFT_Cnt,
	
	output	wire[31:0]						Twiddle_factor0,
	output	wire[31:0]						Twiddle_factor1,
	output	wire[31:0]						Twiddle_factor2,
	output	wire[31:0]						Twiddle_factor3,
	output	wire[31:0]						Twiddle_factor4,
	output	wire[31:0]						Twiddle_factor5,
	output	wire[31:0]						Twiddle_factor6,
	output	wire[31:0]						Twiddle_factor7
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
localparam	DPRAM_LEN			= 2**(LOG2_FFT_LEN-3);
localparam	DPRAM_LEN_DOUBLE	= 2**(LOG2_FFT_LEN-3)*2;
localparam	DPRAM_LEN_TRE		= 2**(LOG2_FFT_LEN-3)*3;
localparam	PI_DOUBLE			= 20'd524287;//pi*2=(2^19-1)

// -----------------------------------------------------------------
//* REG
reg								complex_valid;
reg  [LOG2_FFT_LEN-1:0]			Addr_Wn_complex;
reg  [LOG2_FFT_LEN-1:0]			Addr_Wn_complex0;
reg  [LOG2_FFT_LEN-1:0]			Addr_Wn_complex1;
reg  [LOG2_FFT_LEN-1:0]			Addr_Wn_complex2;
reg  [LOG2_FFT_LEN-1:0]			Addr_Wn_complex3;
reg  [LOG2_FFT_LEN-1:0]			Addr_Wn_complex4;
reg  [LOG2_FFT_LEN-1:0]			Addr_Wn_complex5;
reg  [LOG2_FFT_LEN-1:0]			Addr_Wn_complex6;
reg  [LOG2_FFT_LEN-1:0]			Addr_Wn_complex7;
reg  signed[LOG2_FFT_LEN+19:0]	Addr_Wn_Phase0;
reg  signed[LOG2_FFT_LEN+19:0]	Addr_Wn_Phase1;
reg  signed[LOG2_FFT_LEN+19:0]	Addr_Wn_Phase2;
reg  signed[LOG2_FFT_LEN+19:0]	Addr_Wn_Phase3;
reg  signed[LOG2_FFT_LEN+19:0]	Addr_Wn_Phase4;
reg  signed[LOG2_FFT_LEN+19:0]	Addr_Wn_Phase5;
reg  signed[LOG2_FFT_LEN+19:0]	Addr_Wn_Phase6;
reg  signed[LOG2_FFT_LEN+19:0]	Addr_Wn_Phase7;

// -----------------------------------------------------------------
//* WIRE
wire signed[19:0]				Twiddle_Phase0;
wire signed[19:0]				Twiddle_Phase1;
wire signed[19:0]				Twiddle_Phase2;
wire signed[19:0]				Twiddle_Phase3;
wire signed[19:0]				Twiddle_Phase4;
wire signed[19:0]				Twiddle_Phase5;
wire signed[19:0]				Twiddle_Phase6;
wire signed[19:0]				Twiddle_Phase7;
wire signed[15:0]				Wn_Sin_out0,Wn_Cos_out0;
wire signed[15:0]				Wn_Sin_out1,Wn_Cos_out1;
wire signed[15:0]				Wn_Sin_out2,Wn_Cos_out2;
wire signed[15:0]				Wn_Sin_out3,Wn_Cos_out3;
wire signed[15:0]				Wn_Sin_out4,Wn_Cos_out4;
wire signed[15:0]				Wn_Sin_out5,Wn_Cos_out5;
wire signed[15:0]				Wn_Sin_out6,Wn_Cos_out6;
wire signed[15:0]				Wn_Sin_out7,Wn_Cos_out7;

// ------------------------------------------------------------------
//* FFT Wn Control
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_complex <= 'd0;
	else if(Current_state == FFT_STATE_FIRST)
		begin
			if(Stage_Cnt <= DPRAM_LEN_DIV2)
				case(FFT_stage)
					5'd0 :	Addr_Wn_complex <= 'd0;
					5'd1 :	if(FFT_Cnt[1:0] == 2'b00 || FFT_Cnt[1:0] == 2'b10)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd2 :	if(FFT_Cnt[2:0] == 3'b000 || FFT_Cnt[2:0] == 3'b100)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd3 :	if(FFT_Cnt[3:0] == 4'b0000 || FFT_Cnt[3:0] == 4'b1000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd4 :	if(FFT_Cnt[4:0] == 5'b0000 || FFT_Cnt[4:0] == 5'b1_0000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd5 :	if(FFT_Cnt[5:0] == 6'b00000 || FFT_Cnt[5:0] == 6'b10_0000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd6 :	if(FFT_Cnt[6:0] == 7'd0 || FFT_Cnt[6:0] == 7'b100_0000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd7 :	if(FFT_Cnt[7:0] == 8'd0 || FFT_Cnt[7:0] == 8'b1000_0000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd8 :	if(FFT_Cnt[8:0] == 9'd0 || FFT_Cnt[8:0] == 9'b1_0000_0000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd9 :	if(FFT_Cnt[9:0] == 10'd0 || FFT_Cnt[9:0] == 10'b10_0000_0000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd10:	if(FFT_Cnt[10:0] == 11'd0 || FFT_Cnt[10:0] == 11'b100_0000_0000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd11:	if(FFT_Cnt[11:0] == 12'd0 || FFT_Cnt[11:0] == 12'b1000_0000_0000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd12:	if(FFT_Cnt[12:0] == 13'd0 || FFT_Cnt[12:0] == 13'b1_0000_0000_0000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd13:	if(FFT_Cnt[13:0] == 14'd0 || FFT_Cnt[13:0] == 14'b10_0000_0000_0000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd14:	if(FFT_Cnt[14:0] == 15'd0 || FFT_Cnt[14:0] == 15'b100_0000_0000_0000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd15:	if(FFT_Cnt[15:0] == 16'd0 || FFT_Cnt[15:0] == 16'b1000_0000_0000_0000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd16:	if(FFT_Cnt[16:0] == 17'd0 || FFT_Cnt[16:0] == 17'b1_0000_0000_0000_0000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					5'd17:	if(FFT_Cnt[17:0] == 18'd0 || FFT_Cnt[17:0] == 18'b10_0000_0000_0000_0000)
								Addr_Wn_complex <= 'd0;
							else
								Addr_Wn_complex <= Addr_Wn_complex + 1;
					default:Addr_Wn_complex <= 'd0;
				endcase
			else if(Stage_Cnt >= DPRAM_LEN_DIV2+10)
				Addr_Wn_complex <= 'd0;
			else
				Addr_Wn_complex <= Addr_Wn_complex;
		end
	else if(Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
		begin
			if(Stage_Cnt > 0 && Stage_Cnt <= DPRAM_LEN_DIV2)
				Addr_Wn_complex <= Addr_Wn_complex + 2;
			else if(Stage_Cnt >= DPRAM_LEN_DIV2+10)
				Addr_Wn_complex <= 'd0;
			else
				Addr_Wn_complex <= Addr_Wn_complex;
		end
	else
		Addr_Wn_complex <= 'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_complex0 <= 'd0;
	else if(Current_state == FFT_STATE_FIRST || Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
		Addr_Wn_complex0 <= Addr_Wn_complex<<<(LOG2_FFT_LEN-FFT_stage-1);
	else
		Addr_Wn_complex0 <= 'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_complex1 <= 'd0;
	else if(Current_state == FFT_STATE_FIRST)
		Addr_Wn_complex1 <= (Addr_Wn_complex)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else if(Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
		Addr_Wn_complex1 <= (Addr_Wn_complex+1)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else
		Addr_Wn_complex1 <= 'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_complex2 <= 'd0;
	else if(Current_state == FFT_STATE_FIRST || Current_state == FFT_STATE_SECOND)
		Addr_Wn_complex2 <= Addr_Wn_complex<<<(LOG2_FFT_LEN-FFT_stage-1);
	else if(Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
		Addr_Wn_complex2 <= (Addr_Wn_complex+DPRAM_LEN)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else
		Addr_Wn_complex2 <= 'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_complex3 <= 'd0;
	else if(Current_state == FFT_STATE_FIRST)
		Addr_Wn_complex3 <= (Addr_Wn_complex)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else if(Current_state == FFT_STATE_SECOND)
		Addr_Wn_complex3 <= (Addr_Wn_complex+1)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else if(Current_state == FFT_STATE_THIRD || Current_state == FFT_STATE_FOURTH)
		Addr_Wn_complex3 <= (Addr_Wn_complex+DPRAM_LEN+1)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else
		Addr_Wn_complex3 <= 'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_complex4 <= 'd0;
	else if(Current_state == FFT_STATE_FIRST || Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD)
		Addr_Wn_complex4 <= Addr_Wn_complex<<<(LOG2_FFT_LEN-FFT_stage-1);
	else if(Current_state == FFT_STATE_FOURTH)
		Addr_Wn_complex4 <= (Addr_Wn_complex+DPRAM_LEN_DOUBLE)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else
		Addr_Wn_complex4 <= 'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_complex5 <= 'd0;
	else if(Current_state == FFT_STATE_FIRST)
		Addr_Wn_complex5 <= (Addr_Wn_complex)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else if(Current_state == FFT_STATE_SECOND || Current_state == FFT_STATE_THIRD)
		Addr_Wn_complex5 <= (Addr_Wn_complex+1)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else if(Current_state == FFT_STATE_FOURTH)
		Addr_Wn_complex5 <= (Addr_Wn_complex+DPRAM_LEN_DOUBLE+1)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else
		Addr_Wn_complex5 <= 'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_complex6 <= 'd0;
	else if(Current_state == FFT_STATE_FIRST || Current_state == FFT_STATE_SECOND)
		Addr_Wn_complex6 <= Addr_Wn_complex<<<(LOG2_FFT_LEN-FFT_stage-1);
	else if(Current_state == FFT_STATE_THIRD)
		Addr_Wn_complex6 <= (Addr_Wn_complex+DPRAM_LEN)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else if(Current_state == FFT_STATE_FOURTH)
		Addr_Wn_complex6 <= (Addr_Wn_complex+DPRAM_LEN_TRE)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else
		Addr_Wn_complex6 <= 'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_complex7 <= 'd0;
	else if(Current_state == FFT_STATE_FIRST)
		Addr_Wn_complex7 <= (Addr_Wn_complex)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else if(Current_state == FFT_STATE_SECOND)
		Addr_Wn_complex7 <= (Addr_Wn_complex+1)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else if(Current_state == FFT_STATE_THIRD)
		Addr_Wn_complex7 <= (Addr_Wn_complex+DPRAM_LEN+1)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else if(Current_state == FFT_STATE_FOURTH)
		Addr_Wn_complex7 <= (Addr_Wn_complex+DPRAM_LEN_TRE+1)<<<(LOG2_FFT_LEN-FFT_stage-1);
	else
		Addr_Wn_complex7 <= 'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		complex_valid <= 1'd0;
	else if(Current_state == FFT_STATE_FIRST && Stage_Cnt > 0 && Stage_Cnt <= DPRAM_LEN_DIV2+1)
		complex_valid <= 1'd1;
	else if(Current_state == FFT_STATE_SECOND && Stage_Cnt > 0 && Stage_Cnt <= DPRAM_LEN_DIV2+1)
		complex_valid <= 1'd1;
	else if(Current_state == FFT_STATE_THIRD && Stage_Cnt > 0 && Stage_Cnt <= DPRAM_LEN_DIV2+1)
		complex_valid <= 1'd1;
	else if(Current_state == FFT_STATE_FOURTH && Stage_Cnt > 0 && Stage_Cnt <= DPRAM_LEN_DIV2+1)
		complex_valid <= 1'd1;
	else
		complex_valid <= 1'd0;
end

// ------------------------------------------------------------------
//* FFT Twiddle Phase Calculate 0
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_Phase0 <= 'd0;
	else
		Addr_Wn_Phase0 <= Addr_Wn_complex0 * PI_DOUBLE;
end
assign Twiddle_Phase0 = Addr_Wn_Phase0[LOG2_FFT_LEN+19:LOG2_FFT_LEN];

Cordic_Sin_Cos  Wn_complex0
(
	.clk			( clk ),
	.reset			( ~reset_n ),
	.Phase_in		( ~Twiddle_Phase0+1 ),//-2*pi~2*pi = -524288~524287
	
	.Sin			( Wn_Sin_out0 ),
	.Cos			( Wn_Cos_out0 )
);
assign Twiddle_factor0 = {Wn_Cos_out0,Wn_Sin_out0};

// ------------------------------------------------------------------
//* FFT Twiddle Phase Calculate 1
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_Phase1 <= 'd0;
	else if(complex_valid == 1)
		Addr_Wn_Phase1 <= Addr_Wn_complex1 * PI_DOUBLE;
	else
		Addr_Wn_Phase1 <= Addr_Wn_Phase1;
end
assign Twiddle_Phase1 = Addr_Wn_Phase1[LOG2_FFT_LEN+19:LOG2_FFT_LEN];

Cordic_Sin_Cos  Wn_complex1
(
	.clk			( clk ),
	.reset			( ~reset_n ),
	.Phase_in		( ~Twiddle_Phase1+1 ),//-2*pi~2*pi = -524288~524287
	
	.Sin			( Wn_Sin_out1 ),
	.Cos			( Wn_Cos_out1 )
);
assign Twiddle_factor1 = {Wn_Cos_out1,Wn_Sin_out1};

// ------------------------------------------------------------------
//* FFT Twiddle Phase Calculate 2
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_Phase2 <= 'd0;
	else
		Addr_Wn_Phase2 <= Addr_Wn_complex2 * PI_DOUBLE;
end
assign Twiddle_Phase2 = Addr_Wn_Phase2[LOG2_FFT_LEN+19:LOG2_FFT_LEN];

Cordic_Sin_Cos  Wn_complex2
(
	.clk			( clk ),
	.reset			( ~reset_n ),
	.Phase_in		( ~Twiddle_Phase2+1 ),//-2*pi~2*pi = -524288~524287
	
	.Sin			( Wn_Sin_out2 ),
	.Cos			( Wn_Cos_out2 )
);
assign Twiddle_factor2 = {Wn_Cos_out2,Wn_Sin_out2};

// ------------------------------------------------------------------
//* FFT Twiddle Phase Calculate 3
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_Phase3 <= 'd0;
	else
		Addr_Wn_Phase3 <= Addr_Wn_complex3 * PI_DOUBLE;
end
assign Twiddle_Phase3 = Addr_Wn_Phase3[LOG2_FFT_LEN+19:LOG2_FFT_LEN];

Cordic_Sin_Cos  Wn_complex3
(
	.clk			( clk ),
	.reset			( ~reset_n ),
	.Phase_in		( ~Twiddle_Phase3+1 ),//-2*pi~2*pi = -524288~524287
	
	.Sin			( Wn_Sin_out3 ),
	.Cos			( Wn_Cos_out3 )
);
assign Twiddle_factor3 = {Wn_Cos_out3,Wn_Sin_out3};

// ------------------------------------------------------------------
//* FFT Twiddle Phase Calculate 4
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_Phase4 <= 'd0;
	else
		Addr_Wn_Phase4 <= Addr_Wn_complex4 * PI_DOUBLE;
end
assign Twiddle_Phase4 = Addr_Wn_Phase4[LOG2_FFT_LEN+19:LOG2_FFT_LEN];

Cordic_Sin_Cos  Wn_complex4
(
	.clk			( clk ),
	.reset			( ~reset_n ),
	.Phase_in		( ~Twiddle_Phase4+1 ),//-2*pi~2*pi = -524288~524287
	
	.Sin			( Wn_Sin_out4 ),
	.Cos			( Wn_Cos_out4 )
);
assign Twiddle_factor4 = {Wn_Cos_out4,Wn_Sin_out4};

// ------------------------------------------------------------------
//* FFT Twiddle Phase Calculate 5
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_Phase5 <= 'd0;
	else
		Addr_Wn_Phase5 <= Addr_Wn_complex5 * PI_DOUBLE;
end
assign Twiddle_Phase5 = Addr_Wn_Phase5[LOG2_FFT_LEN+19:LOG2_FFT_LEN];

Cordic_Sin_Cos  Wn_complex5
(
	.clk			( clk ),
	.reset			( ~reset_n ),
	.Phase_in		( ~Twiddle_Phase5+1 ),//-2*pi~2*pi = -524288~524287
	
	.Sin			( Wn_Sin_out5 ),
	.Cos			( Wn_Cos_out5 )
);
assign Twiddle_factor5 = {Wn_Cos_out5,Wn_Sin_out5};

// ------------------------------------------------------------------
//* FFT Twiddle Phase Calculate 6
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_Phase6 <= 'd0;
	else
		Addr_Wn_Phase6 <= Addr_Wn_complex6 * PI_DOUBLE;
end
assign Twiddle_Phase6 = Addr_Wn_Phase6[LOG2_FFT_LEN+19:LOG2_FFT_LEN];

Cordic_Sin_Cos  Wn_complex6
(
	.clk			( clk ),
	.reset			( ~reset_n ),
	.Phase_in		( ~Twiddle_Phase6+1 ),//-2*pi~2*pi = -524288~524287
	
	.Sin			( Wn_Sin_out6 ),
	.Cos			( Wn_Cos_out6 )
);
assign Twiddle_factor6 = {Wn_Cos_out6,Wn_Sin_out6};

// ------------------------------------------------------------------
//* FFT Twiddle Phase Calculate 7
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_Wn_Phase7 <= 'd0;
	else
		Addr_Wn_Phase7 <= Addr_Wn_complex7 * PI_DOUBLE;
end
assign Twiddle_Phase7 = Addr_Wn_Phase7[LOG2_FFT_LEN+19:LOG2_FFT_LEN];

Cordic_Sin_Cos  Wn_complex7
(
	.clk			( clk ),
	.reset			( ~reset_n ),
	.Phase_in		( ~Twiddle_Phase7+1 ),//-2*pi~2*pi = -524288~524287
	
	.Sin			( Wn_Sin_out7 ),
	.Cos			( Wn_Cos_out7 )
);
assign Twiddle_factor7 = {Wn_Cos_out7,Wn_Sin_out7};

endmodule

