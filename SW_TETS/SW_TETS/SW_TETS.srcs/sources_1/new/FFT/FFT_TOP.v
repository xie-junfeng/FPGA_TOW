`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/19 14:33:49
// Design Name: 
// Module Name: FFT_TOP
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


module FFT_TOP
#(
	parameter	FFT_DATA_WITDH	= 32'd12,
	parameter	LOG2_FFT_LEN	= 32'd11,
	parameter	AD_WIDTH		= 32'd16,
	parameter	PEAK_NUM		= 2,
	parameter	SAMPLE_FREQ		= 32'd500_000_000//Unit:Hz
)
(
	input								Clk,
	input								Clk_100M,
	input								Reset,
	input								FFT_valid,
	input								measure_RX_En,
	input								Trigger_flag,
	input								Work_mode,//1-Continuous Wave or 0-Pulse flag
	input signed[FFT_DATA_WITDH-1:0]	sink_rel,
	input signed[FFT_DATA_WITDH-1:0]	sink_img,
	input			[AD_WIDTH-1:0]	    FFT_Data1,
	input			[AD_WIDTH-1:0]	    FFT_Data2,
	input			[AD_WIDTH-1:0]	    FFT_Data3,
	input			[AD_WIDTH-1:0]	    FFT_Data4,
	input [AD_WIDTH-1:0]			    MAX_Square_data,
	input	[29:0]					    Probe_o,

	output reg						    Freq_update,
	output reg [31:0]				    Freq_out
);

// -----------------------------------------------------------------
//* FSM
localparam	FFT_NUM		= 2**LOG2_FFT_LEN;//2^11
localparam	FFT_NUM_DIV2= 2**LOG2_FFT_LEN-3*1024;//2^11
localparam	PRUNING_NUM = 1024*1024;
localparam	PRUNING_NUM_DIV2 = 1024*512;
localparam	IDEL 		= 2'b00;
localparam	PRE_SOP		= 2'b01;
localparam	PRE_READY	= 2'b10;
localparam	START		= 2'b11;

reg [2:0]	Sync_Cnt = 0;
// -----------------------------------------------------------------
//* REG
reg			FFT_Finish_flag;
reg			sink_valid;
reg			sink_start;
reg			pre_sop;
reg			sink_sop;
reg			sink_eop;
reg			FFT_source_val;
reg			Pruning_source_val;
reg	[1:0]	state;
reg	[1:0]	state_reg;
reg [3:0]	SOP_Cnt;
reg [31:0]	FFT_Cnt;
reg [FFT_DATA_WITDH-1:0]Freq_rel;
reg [FFT_DATA_WITDH-1:0]Freq_img;

// -----------------------------------------------------------------
//* WIRE
wire						Pruning_finish;
wire						FFT_sink_ready;
wire						FFT_source_valid;
wire						FFT_source_sop;
wire						FFT_source_eop;
wire [4:0]					FFT_source_exp;
wire						Pruning_sink_ready;
wire						Pruning_source_valid;
wire						Pruning_source_sop;
wire						Pruning_source_eop;
wire [4:0]					Pruning_source_exp;
wire						pruning_sop;
wire [LOG2_FFT_LEN-1:0]		peak_location;
wire [FFT_DATA_WITDH-1:0]	sink_real;
wire [FFT_DATA_WITDH-1:0]	FFT_rel_o;
wire [FFT_DATA_WITDH-1:0]	FFT_img_o;
wire signed[FFT_DATA_WITDH-1:0]	Pruning_rel_o;
wire signed[FFT_DATA_WITDH-1:0]	Pruning_img_o;
wire [2*FFT_DATA_WITDH-1:0]Sink_data;

wire		Freq_out_en;
wire		Freq_avail;
wire		FFT_Start;
wire		FFT_busy;
wire[31:0]	peak_place;
wire		peak_place_en;
wire [31:0]	Freq_Acc_out;
wire [31:0]	FMCW_Freq_Max;
wire [31:0]	FMCW_Freq_Min;
wire [31:0]	FMCW_Period_Num;
wire [31:0]	Freq_out_w;



//---------------------------------------------------
//FFT_Ready
//#(
//	.FFT_DATA_WITDH		( FFT_DATA_WITDH ),
//	.LOG2_FFT_LEN			( LOG2_FFT_LEN ),
//	.AD_WIDTH				( AD_WIDTH )
//)
//FFT_Ready_Init
//(
//	.Clk_250MHz				( Clk ),
//	.Clk_100MHz				( Clk_100M ),
//	.Reset					( Reset ),
//	.FFT_valid				( FFT_valid ),
//	.Trigger_flag			( Trigger_flag ),
//	.FFT_sink_ready		( FFT_sink_ready ),
//	.Pruning_sink_ready	( Pruning_sink_ready ),
//	.sink_rel				( sink_rel ),
//	.sink_img				( sink_img ),
//	.MAX_Square_data		( MAX_Square_data ),
//
//	.FFT_Start				( FFT_Start ),
//	.Sink_data				( Sink_data )
//);

wire [AD_WIDTH-1:0]	Data_out1;
wire [AD_WIDTH-1:0]	Data_out2;
wire [AD_WIDTH-1:0]	Data_out3;
wire [AD_WIDTH-1:0]	Data_out4;
wire [AD_WIDTH-1:0]	Data_in_Avg;
pre_mean
#(
	.AD_WIDTH	(AD_WIDTH),
    .LOG2_FFT_LEN	(LOG2_FFT_LEN)
)
pre_mean_Init
(
	.Clk(Clk),
	.Clk_100M(Clk_100M),
	.Reset(Reset),

	.Data_in1(FFT_Data1),
	.Data_in2(FFT_Data2),
	.Data_in3(FFT_Data3),
	.Data_in4(FFT_Data4),
	
	.Data_out1(Data_out1),
	.Data_out2(Data_out2),
	.Data_out3(Data_out3),
    .Data_out4(Data_out4),

    .Data_in_Avg(Data_in_Avg)
);



Single_mean
#(
	.FFT_DATA_WITDH			( FFT_DATA_WITDH ),
	.LOG2_FFT_LEN			( LOG2_FFT_LEN ),
	.AD_WIDTH				( AD_WIDTH )
)
Single_mean_Init
(
	.Clk					( Clk ),
	.Clk_100M				( Clk_100M ),
	.Reset					( Reset ),
	.measure_RX_En       ( measure_RX_En ),
	.P_C_flag				( 1'd1 ),//1-Continuous Wave or 0-Pulse flag
	.sink_eop				( Pruning_source_sop ),
	.sink_sop				( sink_sop ),
	.Data_in1				( Data_out1 ),
	.Data_in2				( Data_out2 ),
	.Data_in3				( Data_out3 ),
	.Data_in4				( Data_out4 ),
	.Data_in_Avg			( Data_in_Avg ),
								
	.FFT_Start				( FFT_Start ),
	.Sngle_test				(  ),
	.FFT_Data_Out			( Sink_data )
);
// ---------------------------------------------------------------------
//*FFT Time Ctrl
always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		begin
			state_reg <= IDEL;
			Pruning_source_val <= 1'd0;
		end
	else 
		begin
			state_reg <= state;
			Pruning_source_val <= Pruning_source_valid;
		end
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		FFT_Finish_flag <= 1'b1;
	else if(state == PRE_READY && state_reg == IDEL)
		FFT_Finish_flag <= 1'b0;
	else if(Pruning_source_valid == 1 && Pruning_source_val == 0)
		FFT_Finish_flag <= 1'b1;
	else
		FFT_Finish_flag <= FFT_Finish_flag;
end
						 
always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		begin
			pre_sop <= 1'b0;
			sink_sop <= 1'b0;
			sink_eop <= 1'b0;
			sink_valid <= 1'b0;
			sink_start <= 1'b0;
			SOP_Cnt <= 4'd0;
			FFT_Cnt <= 32'd0;
			state <= IDEL;
		end
	else
		case(state)
			IDEL:
				begin
					pre_sop <= 1'b0;
					sink_sop <= 1'b0;
					sink_eop <= 1'b0;
					sink_valid <= 1'b0;
					sink_start <= 1'b0;
					SOP_Cnt <= 4'd0;
					FFT_Cnt <= 32'd0;
					if(FFT_Start == 1 && Pruning_sink_ready == 1 && FFT_Finish_flag == 1)
//					if(FFT_Start_t == 1 && Pruning_sink_ready == 1 && FFT_Finish_flag == 1)
						state <= PRE_SOP;
					else
						state <= state;
				end
			PRE_SOP:
				begin
					sink_start <= 1'b0;
					sink_valid <= 1'b0;
					pre_sop <= 1'b1;
					sink_sop <= 1'b0;
					sink_eop <= 1'b0;
					FFT_Cnt <= 32'd0;
					SOP_Cnt <= SOP_Cnt + 4'd1;
					if(SOP_Cnt >= 1)
						state <= PRE_READY;
					else
						state <= PRE_SOP; 
				end
			PRE_READY:
				begin
					SOP_Cnt <= 4'd0;
					pre_sop <= 1'b0;
					sink_start <= 1'b0;
					sink_valid <= 1'b1;
					FFT_Cnt <= FFT_Cnt + 32'd1;
					if(FFT_Cnt == 0)
						begin
							sink_sop <= 1'b1;
							sink_eop <= 1'b0;
							state <= PRE_READY; 
						end 
					else if(FFT_Cnt > 0 && FFT_Cnt < FFT_NUM-1)
						begin
							sink_sop <= 1'b0;
							sink_eop <= 1'b0;
							state <= PRE_READY; 
						end
					else if(FFT_Cnt == FFT_NUM-1)
						begin
							sink_sop <= 1'b0;
							sink_eop <= 1'b1;
							state <= START; 
						end
				end
			START:
				begin
					SOP_Cnt <= 4'd0;
					pre_sop <= 1'b0;
					sink_sop <= 1'b0;
					sink_eop <= 1'b0;
					sink_valid <= 1'b0;
					FFT_Cnt <= FFT_Cnt + 32'd1;
					if(FFT_Cnt >= FFT_NUM+1)
						begin
							sink_start <= 1'b1;
							state <= IDEL; 
						end 
					else
						begin
							sink_start <= 1'b0;
							state <= START; 
						end
				end
			default: state <= IDEL; 
		endcase
end

// -------------------------------------------------------
FFT_Base2_DIT  
#(
	.DATA_INPUT_WITDH		( FFT_DATA_WITDH ),
	.LOG2_FFT_LEN			( LOG2_FFT_LEN )
)
FFT_Base2_Init
(
	.clk					( Clk_100M ),
	.reset_n				( Reset ),
	.inverse				( 1'b0 ),
	.sink_valid				( sink_valid ),
	.sink_sop				( sink_sop ),
	.sink_eop				( sink_eop ),
	.sink_real				( Sink_data[2*FFT_DATA_WITDH-1:FFT_DATA_WITDH]),
	.sink_imag				( Sink_data[FFT_DATA_WITDH-1:0] ),
		
	.sink_ready				( FFT_sink_ready ),
	.source_valid			( FFT_source_valid ),
	.source_sop				( FFT_source_sop ),
	.source_eop				( FFT_source_eop ),
	.source_error			(  ),
	.source_exp				( FFT_source_exp ),
	.source_real			( FFT_rel_o ),
	.source_imag			( FFT_img_o )
);

// ------------------ Acc Frequency ------------------	 
always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		begin
			FFT_source_val <= 1'd0;
			Freq_rel   <= 'd0;
			Freq_img   <= 'd0;
		end
	else 
		begin
			FFT_source_val <= FFT_source_valid;
			if(FFT_source_valid == 1)
				begin
					Freq_rel <= FFT_rel_o;
					Freq_img <= FFT_img_o;
				end
			else
				begin
					Freq_rel <= 'd0;
					Freq_img <= 'd0;
				end
		end
end

FFT_FREQ_CAL
#(
	.FFT_DATA_WITDH		( FFT_DATA_WITDH ),
	.LOG2_FFT_LEN		( LOG2_FFT_LEN )
)
FFT_FREQ_CAL_Init
(
	.Clk				( Clk_100M ),
	.Reset				( Reset ),
	.Pruning_finish		( Pruning_source_eop ),//Pruning_finish
	.Pruning_sink_ready	( Pruning_sink_ready ),
	.source_valid		( FFT_source_val ),
	.rel				( Freq_rel ),
	.img				( Freq_img ),
	
	.pruning_sop		( pruning_sop ),
	.peak_location		( peak_location )
);

// ---------------------------------------------------------------
wire[13:0]	peak_location_w;
FFT_Pruning  
#(
	.DATA_INPUT_WITDH		( FFT_DATA_WITDH ),
	.LOG2_FFT_NORZEROS_LEN	( LOG2_FFT_LEN ),//range=[4,14]
	.PEAK_NUM				( PEAK_NUM )
)
FFT_Pruning_Init
(
	.clk					( Clk_100M ),
	.reset_n				( Reset ),
	.inverse				( 1'b0 ),
	.sink_valid				( sink_valid ),
	.sink_sop				( sink_sop ),
	.sink_eop				( sink_eop ),
	.sink_real				( Sink_data[2*FFT_DATA_WITDH-1:FFT_DATA_WITDH]),
	.sink_imag				( Sink_data[FFT_DATA_WITDH-1:0] ),
	.pruning_sop			( pruning_sop ),
	.peak_location			( peak_location_w ),//peak_location
		
	.FFT_finish				( Pruning_finish ),
	.sink_ready				( Pruning_sink_ready ),
	.source_valid			( Pruning_source_valid ),
	.source_sop				( Pruning_source_sop ),
	.source_eop				( Pruning_source_eop ),
	.source_error			(  ),
	.source_exp				( Pruning_source_exp ),
	.source_real			( Pruning_rel_o ),
	.source_imag			( Pruning_img_o ),
	.peak_place_en			( peak_place_en ),
	.peak_place				( Freq_out_w )
);

assign peak_location_w = Probe_o[29]==1 ? Probe_o[28:15] : peak_location;

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		Freq_out <= 32'd0;
	else if(peak_place_en == 1'd1 && Freq_out_w >= PRUNING_NUM_DIV2)
		Freq_out <= PRUNING_NUM - Freq_out_w;
	else if(peak_place_en == 1'd1)
		Freq_out <= Freq_out_w;
	else
		Freq_out <= Freq_out;
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		Sync_Cnt <= 3'd0;
	else if(peak_place_en == 1'd1)
		Sync_Cnt <= 3'd1;
	else if(Sync_Cnt >= 3'd1)
		Sync_Cnt <= Sync_Cnt + 3'd1;
	else
		Sync_Cnt <= 3'd0;
end

always@(posedge Clk_100M or negedge Reset)
begin
	if(!Reset)
		Freq_update <= 1'd0;
	else if(Sync_Cnt >= 3'd1)
		Freq_update <= 1'd1;
	else
		Freq_update <= 1'd0;
end
// -----------------------------------------------------------------
reg	signed[2*FFT_DATA_WITDH-1:0]	rel_saquar;
reg	signed[2*FFT_DATA_WITDH-1:0]	img_saquar;
reg	signed[2*FFT_DATA_WITDH-1:0]	result_add;
always@(posedge Clk_100M)
begin
	rel_saquar <= Pruning_rel_o * Pruning_rel_o;
	img_saquar <= Pruning_img_o * Pruning_img_o;
	result_add <= rel_saquar + img_saquar;
end

wire [FFT_DATA_WITDH-1:0]	Dem_Sig;
//sqrt24 sqrt24_I2Q2(
//		.clk				(Clk_100M),
//		.radical			(result_add),
//		.q					(Dem_Sig),
//		.remainder			()
//		);
sqrt24 sqrt24_I2Q2 (
  .aclk(Clk_100M),                                        // input wire aclk
  .s_axis_cartesian_tvalid(1'd1),  // input wire s_axis_cartesian_tvalid
  .s_axis_cartesian_tdata(result_add),    // input wire [47 : 0] s_axis_cartesian_tdata
  .m_axis_dout_tvalid(),            // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(Dem_Sig)              // output wire [23 : 0] m_axis_dout_tdata
);

endmodule

