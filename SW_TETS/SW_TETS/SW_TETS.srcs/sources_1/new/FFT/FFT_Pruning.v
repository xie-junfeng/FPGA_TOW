`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 15:47:19
// Design Name: 
// Module Name: FFT_Pruning
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


module FFT_Pruning  
#(
	parameter	DATA_INPUT_WITDH		= 12,
	parameter	LOG2_FFT_NORZEROS_LEN	= 11,
	parameter	PEAK_NUM				= 2
)
(
	input	wire								clk,
	input	wire								reset_n,
	input	wire								inverse,
	input	wire								sink_valid,
	input	wire								sink_sop,
	input	wire								sink_eop,
	input	signed[DATA_INPUT_WITDH-1:0]		sink_real,
	input	signed[DATA_INPUT_WITDH-1:0]		sink_imag,
	input	wire								pruning_sop,
	input	wire [LOG2_FFT_NORZEROS_LEN-1:0]	peak_location,
	
	output	wire       							FFT_finish,
	output	reg									sink_ready,
	output	wire       							source_valid,
	output	wire       							source_sop,
	output	wire       							source_eop,
	output	wire [1:0]							source_error,
	output	wire [4:0]							source_exp,
	output	signed[DATA_INPUT_WITDH-1:0]		source_real,
	output	signed[DATA_INPUT_WITDH-1:0]		source_imag,
	output		[31:0]							peak_place,
	output										peak_place_en
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

localparam	LOG2_FFT_LEN		= 32'd20;
localparam	DPRAM_LEN			= 2**(LOG2_FFT_NORZEROS_LEN-3)-1;
localparam	REPEAT_LEN			= 2**(LOG2_FFT_LEN-LOG2_FFT_NORZEROS_LEN-1)-1;
localparam	TWIDDLE_PRECISION	= 32;//旋转因子固定16位

// -----------------------------------------------------------------
//* REG
reg	[3:0]						Next_state;
reg	[3:0]						Current_state;
reg	[3:0]						Current_state_reg;
reg								Repeat_Peak_en;
reg [31:0]						Repeat_Peak_Cnt;
reg [LOG2_FFT_NORZEROS_LEN:0]	Repeat_Cnt;
reg [LOG2_FFT_NORZEROS_LEN-1:0]	Addr_din;

reg								sink_valid1,sink_valid2,sink_valid3;
reg								sink_sop1,sink_sop2,sink_sop3;
reg								sink_eop1,sink_eop2,sink_eop3;
reg signed[DATA_INPUT_WITDH-1:0]sink_real1,sink_real2,sink_real3;
reg signed[DATA_INPUT_WITDH-1:0]sink_imag1,sink_imag2,sink_imag3;

// -----------------------------------------------------------------
//* WIRE
wire[LOG2_FFT_NORZEROS_LEN-1:0]	Addr_xout;
wire[31:0]						Addr_xout_32b;
wire							Result_Cache_Wr;
wire[2*DATA_INPUT_WITDH+3:0]	dpr0_q_a;
wire[2*DATA_INPUT_WITDH+3:0]	dpr1_q_a;
wire							source_exp_ml;
wire							source_exp_mh;
wire							mem_switch;
wire							First_Wn_ready;
wire[4:0]						FFT_stage;
wire[4:0]						Middle_exp;
wire[31:0]						Stage_Cnt;
wire[LOG2_FFT_NORZEROS_LEN-4:0]	Butfly_raddr_a;
wire[LOG2_FFT_NORZEROS_LEN-4:0]	Butfly_raddr_b;
wire[LOG2_FFT_NORZEROS_LEN-4:0]	Butfly_waddr_a;
wire[LOG2_FFT_NORZEROS_LEN-4:0]	Butfly_waddr_b;
wire[31:0]						Stage_Cnt_Peak;
wire[2*TWIDDLE_PRECISION-1:0]	Twiddle_factor0;
wire[2*TWIDDLE_PRECISION-1:0]	Twiddle_factor1;
wire[LOG2_FFT_LEN-1:0]			Freq_Shift_Nums;

// ------------------------------------------------------------
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		begin
			sink_real1 <= 0;
			sink_real2 <= 0;
			sink_real3 <= 0;
			sink_imag1 <= 0;
			sink_imag2 <= 0;
			sink_imag3 <= 0;
			sink_valid1 <= 0;
			sink_valid2 <= 0;
			sink_valid3 <= 0;
			sink_sop1 <= 0;
			sink_sop2 <= 0;
			sink_sop3 <= 0;
			sink_eop1 <= 0;
			sink_eop2 <= 0;
			sink_eop3 <= 0;
		end
	else
		begin
			sink_real1 <= sink_real;
			sink_real2 <= sink_real1;
			sink_real3 <= sink_real2;
			sink_imag1 <= sink_imag;
			sink_imag2 <= sink_imag1;
			sink_imag3 <= sink_imag2;
			sink_valid1 <= sink_valid;
			sink_valid2 <= sink_valid1;
			sink_valid3 <= sink_valid2;
			sink_sop1 <= sink_sop;
			sink_sop2 <= sink_sop1;
			sink_sop3 <= sink_sop2;
			sink_eop1 <= sink_eop;
			sink_eop2 <= sink_eop1;
			sink_eop3 <= sink_eop2;
		end
end

// ------------------------- FSM --------------------------------
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
        Repeat_Cnt <= 0;
    else if(Current_state == FFT_STATE_REPEAT)
        Repeat_Cnt <= Repeat_Cnt + 1;
    else if(Current_state == FFT_STATE_RESET)
        Repeat_Cnt <= 0;
	else
		Repeat_Cnt <= Repeat_Cnt;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
        Repeat_Peak_Cnt <= 0;
	else if(Repeat_Peak_Cnt >= PEAK_NUM)
		Repeat_Peak_Cnt <= 0;
    else if(Current_state == FFT_STATE_RESET && Current_state_reg == FFT_STATE_REPEAT)
        Repeat_Peak_Cnt <= Repeat_Peak_Cnt + 1;
	else
		Repeat_Peak_Cnt <= Repeat_Peak_Cnt;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
        Repeat_Peak_en <= 1'd0;
	else if(Repeat_Peak_Cnt >= 1)
		Repeat_Peak_en <= 1'd1;
	else
        Repeat_Peak_en <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
        Current_state <= FFT_STATE_RESET;
    else
        Current_state <= Next_state;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
        Current_state_reg <= FFT_STATE_RESET;
    else
        Current_state_reg <= Current_state;
end

always @ ( * )
begin
	Next_state = FFT_STATE_RESET; 
	case ( Current_state )
		FFT_STATE_RESET:
			if ( sink_sop == 1 )  
				Next_state = FFT_STATE_READ;
			else if ( pruning_sop == 1 )  
				Next_state = FFT_STATE_WN_PRE;
			else
				Next_state = FFT_STATE_RESET;
				
		FFT_STATE_READ:
			if ( sink_eop3 == 1 ) 
				Next_state = FFT_STATE_WAIT;
				// Next_state = FFT_STATE_FIRST;	
			else
				Next_state = FFT_STATE_READ; 
				
		FFT_STATE_WAIT:
			if ( pruning_sop == 1 ) 
				Next_state = FFT_STATE_WN_PRE;	
			else
				Next_state = FFT_STATE_WAIT; 		

		FFT_STATE_WN_PRE:
			if ( First_Wn_ready == 1 ) 
				Next_state = FFT_STATE_FIRST;	
			else
				Next_state = FFT_STATE_WN_PRE; 
				
		FFT_STATE_FIRST:
			if ( Stage_Cnt > DPRAM_LEN+8 ) 
				Next_state = FFT_STATE_SECOND;	
			else
				Next_state = FFT_STATE_FIRST; 		
					
		FFT_STATE_SECOND:
			if ( FFT_stage >= LOG2_FFT_LEN-3 ) 
				Next_state = FFT_STATE_THIRD;	
			else
				Next_state = FFT_STATE_SECOND; 		
					
		FFT_STATE_THIRD:
			if ( FFT_stage >= LOG2_FFT_LEN-2 ) 
				Next_state = FFT_STATE_FOURTH;	
			else
				Next_state = FFT_STATE_THIRD; 		
				
		FFT_STATE_FOURTH:
			if ( FFT_stage >= LOG2_FFT_LEN-1 ) 
				Next_state = FFT_STATE_FIFTH;	
			else
				Next_state = FFT_STATE_FOURTH; 		
			
		FFT_STATE_FIFTH:
			if ( Stage_Cnt > 5 ) 
				Next_state = FFT_STATE_REPEAT;	
			else
				Next_state = FFT_STATE_FIFTH;

		FFT_STATE_REPEAT:
			if(Repeat_Cnt >= REPEAT_LEN)
				Next_state = FFT_STATE_RESET;
			else
				Next_state = FFT_STATE_FIRST;
		
		default : Next_state = FFT_STATE_RESET;
	endcase
end

// -------------------------------------------------------------------
//* Address Flipped
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		Addr_din <= 'd0;
	else if(Current_state == FFT_STATE_READ && sink_valid1 == 1)
		Addr_din <= Addr_din + 'd1;
	else
		Addr_din <= 'd0;
end

FFT_Addr_Flip  
#(
	.LOG2_FFT_LEN	( LOG2_FFT_NORZEROS_LEN )
)
FFT_Addr_Flip_Init
(
	.Clk			( clk ),
	.Reset			( reset_n ),
	.Addr_xin		( Addr_din ),
	
	.Addr_xout		( Addr_xout )
);
assign Addr_xout_32b = {{32-LOG2_FFT_NORZEROS_LEN{1'b0}},Addr_xout};

// -----------------------------------------------------------------
//* FFT Butterfly Calculate
Pruning_Butfly_Process
#(
	.DATA_INPUT_WITDH		( DATA_INPUT_WITDH ),
	.TWIDDLE_PRECISION		( TWIDDLE_PRECISION ),
	.LOG2_FFT_LEN			( LOG2_FFT_NORZEROS_LEN ),
	.PEAK_NUM				( PEAK_NUM )
)
Pruning_Butfly_Process_Init
(
	.clk					( clk ),
	.reset_n				( reset_n ),
	.Repeat_Peak_en			( Repeat_Peak_en ),
	.mem_switch				( mem_switch ),
	.source_eop				( source_eop ),
	.sink_real				( sink_real3 ),
	.sink_imag				( sink_imag3 ),
	.Current_state			( Current_state ),
	.Repeat_Cnt				( Repeat_Cnt ),
	.FFT_stage				( FFT_stage ),
	.Stage_Cnt				( Stage_Cnt ),
	.Addr_xout_32b			( Addr_xout_32b ),
	.Addr_xout				( Addr_xout ),
	.Stage_Cnt_Peak			( Stage_Cnt_Peak ),
	.Twiddle_factor0		( Twiddle_factor0 ),
	.Twiddle_factor1		( Twiddle_factor1 ),
	
	.Butfly_waddr_a			( Butfly_waddr_a ),
	.Butfly_waddr_b			( Butfly_waddr_b ),
	.Butfly_raddr_a			( Butfly_raddr_a ),
	.Butfly_raddr_b			( Butfly_raddr_b ),
	.source_exp_ml			( source_exp_ml ),
	.source_exp_mh			( source_exp_mh ),
	.Result_Cache_Wr		( Result_Cache_Wr ),
	.source_exp				( Middle_exp ),
	.dpr0_q_a				( dpr0_q_a ),
	.dpr1_q_a				( dpr1_q_a )
);

// -----------------------------------------------------------------
//* FFT_PROCESS
Pruning_Process_Ctrl
#(
	.LOG2_FFT_NORZEROS_LEN	( LOG2_FFT_NORZEROS_LEN ),
	.LOG2_FFT_LEN			( LOG2_FFT_LEN )
)	
Pruning_Process_Ctrl_Init	
(	
	.clk					( clk ),
	.reset_n				( reset_n ),
	.sink_eop				( sink_eop3 ),
	.Current_state			( Current_state ),
	
	.mem_switch				( mem_switch ),
	.FFT_stage				( FFT_stage ),
	.Stage_Cnt				( Stage_Cnt ),
	.Stage_Cnt_Peak			( Stage_Cnt_Peak ),
	.Butfly_raddr_a			( Butfly_raddr_a ),
	.Butfly_raddr_b			( Butfly_raddr_b ),
	.Butfly_waddr_a			( Butfly_waddr_a ),
	.Butfly_waddr_b			( Butfly_waddr_b )
);
// -----------------------------------------------------------------
//* FFT_Twiddle_PROCESS
Pruning_Wn_Ctrl
#(
	.TWIDDLE_PRECISION		( TWIDDLE_PRECISION ),
	.LOG2_FFT_NORZEROS_LEN	( LOG2_FFT_NORZEROS_LEN ),
	.LOG2_FFT_LEN			( LOG2_FFT_LEN ),
	.SHIFT_BITS_LEN			( LOG2_FFT_LEN-LOG2_FFT_NORZEROS_LEN )
)
Pruning_Wn_Ctrl_Init
(
	.clk					( clk ),
	.reset_n				( reset_n ),
	.pruning_sop			( pruning_sop ),
	.Current_state			( Current_state ),
	.FFT_stage				( FFT_stage ),
	.Stage_Cnt				( Stage_Cnt ),
	.peak_location			( peak_location ),
	.Repeat_Cnt				( Repeat_Cnt ),
	
	.First_Wn_ready			( First_Wn_ready ),
	.Freq_Shift_Nums		( Freq_Shift_Nums ),
	.Twiddle_factor0		( Twiddle_factor0 ),
	.Twiddle_factor1		( Twiddle_factor1 )
);

// -----------------------------------------------------------------
//*FFT Output Control & Data Process
Pruning_Out_Process  
#(
	.DATA_INPUT_WITDH		( DATA_INPUT_WITDH ),
	.LOG2_FFT_NORZEROS_LEN	( LOG2_FFT_NORZEROS_LEN ),
	.LOG2_FFT_LEN			( LOG2_FFT_LEN ),
	.CACHE_ADDR_LEN			( LOG2_FFT_LEN-LOG2_FFT_NORZEROS_LEN ),
	.PEAK_NUM				( PEAK_NUM )
)
Pruning_Out_Process_Init
(
	.clk					( clk ),
	.reset_n				( reset_n ),
	.source_exp_ml			( source_exp_ml ),
	.source_exp_mh			( source_exp_mh ),
	.Result_Cache_Wr		( Result_Cache_Wr ),
	.Middle_exp				( Middle_exp ),
	.Freq_Shift_Nums		( Freq_Shift_Nums ),
	.Current_state			( Current_state ),
	.dpr0_q_a				( dpr0_q_a ),
	.dpr1_q_a				( dpr1_q_a ),
	.peak_location			( peak_location ),

	.FFT_finish				( FFT_finish ),
	.source_valid			( source_valid ),
	.source_sop				( source_sop ),
	.source_eop				( source_eop ),
	.source_error			( source_error ),
	.source_exp				( source_exp ),
	.source_real			( source_real ),
	.source_imag			( source_imag ),
	.peak_place_en			( peak_place_en ),
	.peak_place				( peak_place )
);

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		sink_ready <= 1'd1;
	// else if(Current_state == FFT_STATE_RESET)
	else if(Repeat_Peak_Cnt >= PEAK_NUM)
		sink_ready <= 1'd1;
	else if(Current_state == FFT_STATE_RESET)
		sink_ready <= sink_ready;
	else
		sink_ready <= 1'd0;
end

endmodule
// ----------------------------------------------------------
