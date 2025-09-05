`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 14:53:40
// Design Name: 
// Module Name: FFT_Base2_DIT
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


module FFT_Base2_DIT  
#(
	parameter	DATA_INPUT_WITDH	= 12,
	parameter	LOG2_FFT_LEN		= 11
)
(
	input	wire						clk,
	input	wire						reset_n,
	input	wire						inverse,
	input	wire						sink_valid,
	input	wire						sink_sop,
	input	wire						sink_eop,
	input	signed[DATA_INPUT_WITDH-1:0]sink_real,
	input	signed[DATA_INPUT_WITDH-1:0]sink_imag,
	
	output	reg							sink_ready,
	output	wire       					source_valid,
	output	wire       					source_sop,
	output	wire       					source_eop,
	output	wire [1:0]					source_error,
	output	wire [4:0]					source_exp,
	output	signed[DATA_INPUT_WITDH-1:0]source_real,
	output	signed[DATA_INPUT_WITDH-1:0]source_imag
);

localparam	FFT_NUM			= 2**LOG2_FFT_LEN;//2^11
// localparam	DPRAM_LEN_DIV2	= 2**(LOG2_FFT_LEN-4)-1;
// localparam	DPRAM_LEN		= 2**(LOG2_FFT_LEN-3);
// localparam	DPRAM_LEN_DOUBLE= 2**(LOG2_FFT_LEN-3)*2;
// localparam	DPRAM_LEN_TRE	= 2**(LOG2_FFT_LEN-3)*3;
// localparam	FFT_LEN_DIV2	= 2**(LOG2_FFT_LEN-4)-1;
// localparam	ADDR_DPRAM0		= 2**(LOG2_FFT_LEN-3);
// localparam	ADDR_DPRAM1		= 2**(LOG2_FFT_LEN-3)*2;
// localparam	ADDR_DPRAM2		= 2**(LOG2_FFT_LEN-3)*3;
// localparam	ADDR_DPRAM3		= 2**(LOG2_FFT_LEN-3)*4;
// localparam	ADDR_DPRAM4		= 2**(LOG2_FFT_LEN-3)*5;
// localparam	ADDR_DPRAM5		= 2**(LOG2_FFT_LEN-3)*6;
// localparam	ADDR_DPRAM6		= 2**(LOG2_FFT_LEN-3)*7;
// localparam	ADDR_DPRAM7		= 2**(LOG2_FFT_LEN-3)*8;
localparam	TWIDDLE_PRECISION	= 16;//旋转因子固定16位
localparam	FFT_STATE_RESET		= 3'b000;
localparam	FFT_STATE_READ		= 3'b001;
localparam	FFT_STATE_FIRST		= 3'b010;
localparam	FFT_STATE_SECOND	= 3'b011;
localparam	FFT_STATE_THIRD		= 3'b100;
localparam	FFT_STATE_FOURTH	= 3'b101;
localparam	FFT_STATE_TWIDDLE	= 3'b110;
localparam	FFT_STATE_END		= 3'b111;

reg	[2:0]						Next_state;
reg	[2:0]						Current_state;
reg	[2:0]						Current_state_reg;

reg								sink_valid1,sink_valid2,sink_valid3;
reg								sink_sop1,sink_sop2,sink_sop3;
reg								sink_eop1,sink_eop2,sink_eop3;
reg signed[DATA_INPUT_WITDH-1:0]sink_real1,sink_real2,sink_real3;
reg signed[DATA_INPUT_WITDH-1:0]sink_imag1,sink_imag2,sink_imag3;
reg								source_v;
reg								source_s;
reg								source_e;

reg								Flip_Wr_dpram0;
reg								Flip_Wr_dpram1;
reg								Flip_Wr_dpram2;
reg								Flip_Wr_dpram3;
reg								Flip_Wr_dpram4;
reg								Flip_Wr_dpram5;
reg								Flip_Wr_dpram6;
reg								Flip_Wr_dpram7;
reg [LOG2_FFT_LEN-1:0]			Addr_din;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram0;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram1;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram2;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram3;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram4;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram5;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram6;
reg [LOG2_FFT_LEN-4:0]			Flip_Addr_dpram7;

reg								Butfly_vaild;
reg								Butfly_Wr;
	
wire[LOG2_FFT_LEN-1:0]			Addr_xout;
wire[31:0]						Addr_xout_32b;
wire[2*DATA_INPUT_WITDH+3:0]	dpr0_q_a;
wire[2*DATA_INPUT_WITDH+3:0]	dpr1_q_a;
wire[LOG2_FFT_LEN-1:0]			source_addr;
wire							Carry_MH_flag;
wire							Carry_ML_flag;
// wire							Carry_bit_flag;
wire							source_exp_flag;
wire							mem_switch;
wire[4:0]						FFT_stage;
wire[19:0]						FFT_Cnt;
wire[19:0]						Stage_Cnt;
wire[LOG2_FFT_LEN-4:0]			Butfly_raddr_a;
wire[LOG2_FFT_LEN-4:0]			Butfly_raddr_b;
wire[LOG2_FFT_LEN-4:0]			Butfly_waddr_a;
wire[LOG2_FFT_LEN-4:0]			Butfly_waddr_b;
wire[31:0]						Twiddle_factor0;
wire[31:0]						Twiddle_factor1;
wire[31:0]						Twiddle_factor2;
wire[31:0]						Twiddle_factor3;
wire[31:0]						Twiddle_factor4;
wire[31:0]						Twiddle_factor5;
wire[31:0]						Twiddle_factor6;
wire[31:0]						Twiddle_factor7;

// ------------------------------------------------------------
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		sink_ready <= 1'd0;
	else if(Current_state == FFT_STATE_RESET)
		sink_ready <= 1'd1;
	else
		sink_ready <= 1'd0;
end

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
			else
				Next_state = FFT_STATE_RESET;
				
		FFT_STATE_READ:
			if ( sink_eop3 == 1 ) 
				Next_state = FFT_STATE_FIRST;	
			else
				Next_state = FFT_STATE_READ; 
				
		FFT_STATE_FIRST:
			if ( FFT_stage >= LOG2_FFT_LEN-3 ) 
				Next_state = FFT_STATE_SECOND;	
			else
				Next_state = FFT_STATE_FIRST; 		

		FFT_STATE_SECOND:
			if ( FFT_stage >= LOG2_FFT_LEN-2 ) 
				Next_state = FFT_STATE_THIRD;	
			else
				Next_state = FFT_STATE_SECOND; 		
					
		FFT_STATE_THIRD:
			if ( FFT_stage >= LOG2_FFT_LEN-1 ) 
				Next_state = FFT_STATE_FOURTH;	
			else
				Next_state = FFT_STATE_THIRD; 		
				
		FFT_STATE_FOURTH:
			if ( FFT_stage >= LOG2_FFT_LEN ) 
				Next_state = FFT_STATE_RESET;	
			else
				Next_state = FFT_STATE_FOURTH; 		
				
		// FFT_STATE_END:
			// Next_state = FFT_STATE_RESET;
		
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
	.LOG2_FFT_LEN	( LOG2_FFT_LEN )
)
FFT_Addr_Flip_Init
(
	.Clk			( clk ),
	.Reset			( reset_n ),
	.Addr_xin		( Addr_din ),
	
	.Addr_xout		( Addr_xout )
);
assign Addr_xout_32b = {{32-LOG2_FFT_LEN{1'b0}},Addr_xout};

// -----------------------------------------------------------------
//* FFT Butterfly Calculate
FFT_Butfly_Process
#(
	.DATA_INPUT_WITDH		( DATA_INPUT_WITDH ),
	.TWIDDLE_PRECISION		( TWIDDLE_PRECISION ),
	.LOG2_FFT_LEN			( LOG2_FFT_LEN )
)
FFT_Butfly_Process_Init
(
	.clk					( clk ),
	.reset_n				( reset_n ),
	.mem_switch				( mem_switch ),
	.source_eop				( source_eop ),
	.sink_real				( sink_real3 ),
	.sink_imag				( sink_imag3 ),
	.Current_state			( Current_state ),
	.FFT_stage				( FFT_stage ),
	.FFT_Cnt				( FFT_Cnt ),
	.Stage_Cnt				( Stage_Cnt ),
	.Addr_xout_32b			( Addr_xout_32b ),
	.Addr_xout				( Addr_xout ),
	.source_addr			( source_addr ),
	.Twiddle_factor0		( Twiddle_factor0 ),
	.Twiddle_factor1		( Twiddle_factor1 ),
	.Twiddle_factor2		( Twiddle_factor2 ),
	.Twiddle_factor3		( Twiddle_factor3 ),
	.Twiddle_factor4		( Twiddle_factor4 ),
	.Twiddle_factor5		( Twiddle_factor5 ),
	.Twiddle_factor6		( Twiddle_factor6 ),
	.Twiddle_factor7		( Twiddle_factor7 ),
	
	.Butfly_waddr_a			( Butfly_waddr_a ),
	.Butfly_waddr_b			( Butfly_waddr_b ),
	.Butfly_raddr_a			( Butfly_raddr_a ),
	.Butfly_raddr_b			( Butfly_raddr_b ),
	.Carry_MH_flag			( Carry_MH_flag ),
	.Carry_ML_flag			( Carry_ML_flag ),
	// .Carry_bit_flag			( Carry_bit_flag ),
	.dpr0_q_a				( dpr0_q_a ),
	.dpr1_q_a				( dpr1_q_a )
);

// -----------------------------------------------------------------
//* FFT_PROCESS
FFT_Process_Ctrl
#(
	.LOG2_FFT_LEN			( LOG2_FFT_LEN )
)	
FFT_Process_Ctrl_Init	
(	
	.clk					( clk ),
	.reset_n				( reset_n ),
	.sink_eop				( sink_eop3 ),
	.Current_state			( Current_state ),
	
	.source_exp_flag		( source_exp_flag ),
	.mem_switch				( mem_switch ),
	.FFT_stage				( FFT_stage ),
	.FFT_Wn_Cnt				( FFT_Cnt ),
	.Stage_Cnt				( Stage_Cnt ),
	.Butfly_raddr_a			( Butfly_raddr_a ),
	.Butfly_raddr_b			( Butfly_raddr_b ),
	.Butfly_waddr_a			( Butfly_waddr_a ),
	.Butfly_waddr_b			( Butfly_waddr_b )
);

// -----------------------------------------------------------------
//* FFT_Twiddle_PROCESS
FFT_Wn_Ctrl
#(
	.LOG2_FFT_LEN			( LOG2_FFT_LEN )
)
FFT_Wn_Ctrl_Init
(
	.clk					( clk ),
	.reset_n				( reset_n ),
	.Current_state			( Current_state ),
	.FFT_stage				( FFT_stage ),
	.FFT_Cnt				( FFT_Cnt ),
	.Stage_Cnt				( Stage_Cnt ),
	
	.Twiddle_factor0		( Twiddle_factor0 ),
	.Twiddle_factor1		( Twiddle_factor1 ),
	.Twiddle_factor2		( Twiddle_factor2 ),
	.Twiddle_factor3		( Twiddle_factor3 ),
	.Twiddle_factor4		( Twiddle_factor4 ),
	.Twiddle_factor5		( Twiddle_factor5 ),
	.Twiddle_factor6		( Twiddle_factor6 ),
	.Twiddle_factor7		( Twiddle_factor7 )
);

// --------------------------------------------------------------------------------------------------------------------------
//*FFT Output Control & Data Process
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_v <= 1'd0;
	else if(source_addr >= FFT_NUM-1)
		source_v <= 1'd0;
	else if(Current_state == FFT_STATE_RESET && Current_state_reg == FFT_STATE_FOURTH)
		source_v <= 1'd1;
	else
		source_v <= source_v;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_s <= 1'd0;
	else if(Current_state == FFT_STATE_RESET && Current_state_reg == FFT_STATE_FOURTH)
		source_s <= 1'd1;
	else
		source_s <= 1'd0;
end

always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		source_e <= 1'd0;
	else if(source_addr == FFT_NUM-2)
		source_e <= 1'd1;
	else
		source_e <= 1'd0;
end

FFT_OUT_PROCESS  
#(
	.DATA_INPUT_WITDH	( DATA_INPUT_WITDH ),
	.LOG2_FFT_LEN		( LOG2_FFT_LEN )
)
FFT_OUT_PROCESS_Init
(
	.clk				( clk ),
	.reset_n			( reset_n ),
	.mem_switch			( mem_switch ),
	.Carry_MH_flag		( Carry_MH_flag ),
	.Carry_ML_flag		( Carry_ML_flag ),
	.sink_sop			( sink_sop ),
	.source_exp_flag	( source_exp_flag ),
	.source_v			( source_v ),
	.source_s			( source_s ),
	.source_e			( source_e ),
	.dpr0_q_a			( dpr0_q_a ),
	.dpr1_q_a			( dpr1_q_a ),
	
	.source_addr		( source_addr ),
	.source_valid		( source_valid ),
	.source_sop			( source_sop ),
	.source_eop			( source_eop ),
	.source_error		( source_error ),
	.source_exp			( source_exp ),
	.source_real		( source_real ),
	.source_imag		( source_imag )
);

endmodule
// ----------------------------------------------------------
