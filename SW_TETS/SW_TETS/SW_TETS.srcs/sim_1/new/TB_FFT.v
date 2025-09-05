`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/29 20:05:11
// Design Name: 
// Module Name: TB_FFT
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


module TB_FFT();
parameter                       N    = 16384    ;
//IP核接口信号


reg signed[15:0] Data_I[N-1:0];
reg [16:0] cnt;



parameter  Data_PATH_I= "E:/MATLAB_Project/common_tool/genert_singal/I1.txt";
integer          i ,MMTT                                                  ;

  initial begin
    MMTT=$fopen(Data_PATH_I,"r");
    for(i=0;i<N;i=i+1)
    $fscanf(MMTT,"%d",Data_I[i]);
    $fclose(MMTT);
    end 

reg signed [15:0] Data_Q[N-1:0];
parameter  Data_PATH_Q="E:/MATLAB_Project/common_tool/genert_singal/Q1.txt";

integer          Q ,MMTT_Q;

  initial begin
    MMTT_Q=$fopen(Data_PATH_Q,"r");
    for(Q=0;Q<N;Q=Q+1)
    $fscanf(MMTT_Q,"%d",Data_Q[Q]);
    $fclose(MMTT_Q);
    end 


reg CLK_25MHz=0;
reg RESET;
  //数据时钟
  initial begin
  CLK_25MHz = 1'b1      ;
    forever begin
    #20 CLK_25MHz = ~CLK_25MHz;
    end
  end

  //数据时钟
  reg CLK_100MHz=0;
  initial begin
  CLK_100MHz = 1'b1      ;
  forever begin
   #5 CLK_100MHz = ~CLK_100MHz;
  end
  end

   //复位初始化 
    initial begin
        RESET <= 1'b1   ;
        #30
        RESET <= 1'b0   ;
        #10000
        RESET <= 1'b1   ;
    end
reg START;
   initial begin
        START <= 1'b0   ;
        #100000
        START <= 1'b1   ;
    end



reg signed [15:0]read_q;
reg signed [15:0]read_i;



reg data_tvalid;

reg  [31:0]s_axis_data_tdata_Q=0;
reg  [31:0]s_axis_data_tdata_I=0;

//送入数据，每1024个数据产生一个last
always@(posedge CLK_100MHz or negedge RESET)begin
    if(!RESET)begin
        cnt<=16'b0;
        data_tvalid<=1'b0;
        s_axis_data_tdata_Q<=32'b0;
        s_axis_data_tdata_I<=32'b0;
        read_q<=16'b0;
        read_i<=16'b0;
    end
    else if(START)begin
        if(cnt<(N-4))begin
            s_axis_data_tdata_Q<={Data_Q[cnt],Data_Q[cnt+1'd1]};
            s_axis_data_tdata_I<={Data_I[cnt],Data_I[cnt+1'd1]};
           data_tvalid<=1'b1;
            read_q<=Data_Q[cnt];
            read_i<=Data_I[cnt];
            cnt<=cnt+1'b1;
        end
        else  begin
           cnt<=0; 
           data_tvalid<=1'b1;
           s_axis_data_tdata_Q<=32'd0;
            s_axis_data_tdata_I<=32'b0;
        end
end
end

wire [31:0] Freq_out;

//
 FFT_TOP  #(
	.FFT_DATA_WITDH( 32'd24 ),
	.LOG2_FFT_LEN	( 32'd12 ),
	.AD_WIDTH		( 32'd12 ),
	.PEAK_NUM		( 32'd3 ),
	.SAMPLE_FREQ	( 32'd1_000_000_000 )
)
U_FFT_TOP(
	.Clk				( CLK_25MHz ),//CLK250MHz
	.Clk_100M			( CLK_25MHz ),
	.Reset				( RESET ),
	.FFT_valid			( 1'd1 ),
	.measure_RX_En      ( START ),
	.Trigger_flag		( 1'd1 ),
//	.Trigger_flag		( Probe_o[31] == 1 ? FFT_trigger : Trigger_upload ),
	.Work_mode			( 1'd1 ),//unused
	.sink_rel			( 24'd0 ),
	.sink_img			( 24'd0 ),
	.FFT_Data1			( s_axis_data_tdata_Q[31:16] ),
	.FFT_Data2			( s_axis_data_tdata_Q[15:0]  ),
	.FFT_Data3			( s_axis_data_tdata_I[31:16] ),
	.FFT_Data4			( s_axis_data_tdata_I[15:0] ),
	.MAX_Square_data	( 1'd0 ),
	.Probe_o			( 30'd0 ),//Probe_o[29:0]

	.Freq_update		(  ),
	.Freq_out			( Freq_out )
 );  
endmodule
