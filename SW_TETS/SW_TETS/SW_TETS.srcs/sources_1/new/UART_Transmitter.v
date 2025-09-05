/*===================================================================================================
	Name	:
	Function:
	Author	:
	Date	:
====================================================================================================*/
module	UART_Transmitter
(
	input			  Clk_100MHz,
	input			  Reset_n,
	input			  Feed_back,
	
	input [31:0]	  ALT_Value,
	input [7:0]	      Work_mode,   
	input [7:0]	      ALT_TRF_Gain1,
	input [7:0]	      ALT_TRF_Gain2,
	input [7:0]	      ALT_TRF_Gain3,
	input [7:0]	      ALT_RRF_Gain,
	input [7:0]	      ALT_PA,
    input [15:0]      Tempe_data,
	input 	          ALT_State,    

	output			  UART_Tx,
    output reg[6:0]   Current_State,
    output reg		  rs232_flag,
    output reg [7:0]  data_rs232_tx
);

parameter	IDLE		= 7'b0000001;
parameter	COMMANDx02	= 7'b0000010;
parameter	CHECK		= 7'b0000100;
parameter	WAIT_TIME	= 7'b0001000;

reg			Feed_back1;
reg			Feed_back2;
wire		tx_done;
reg			tx_done1;
reg			tx_done2;
//reg			rs232_flag;
//reg		Cnt1;
//reg [4:0]	Cnt;
//reg [4:0]	Cnt0;
//reg [4:0]	Cnt2;
//reg [4:0]	Cnt3;
reg [4:0]	Wait_cnt;
reg [4:0]	Check_cnt;
reg [4:0]	Tx_cntx02;
//reg [6:0]	Current_State;
reg [6:0]	Next_State;
//reg [6:0]	State;
//reg [7:0]	Cmmd5_Cnt;
//reg [7:0]	data_rs232_tx;
reg [7:0]	Check_sum;
reg [7:0]	mem_data[19:0];

wire[15:0]	ZD2101_Version;
assign      ZD2101_Version = {2'd3,14'h0001};


// ----------------------------------------------------------- 
//*UART Tx parallel to Serial
Uart_tx_Init1  Uart_tx_Init1
(
	.clk			( Clk_100MHz ),
	.reset			( Reset_n ),
	.Rs232_tx		( data_rs232_tx ),
	.Tx_en			( rs232_flag ),	
					  
	.Tx_flag		( tx_done ),
	.Rs232_out		( UART_Tx )
);

// -------------------------------- Commd 0x03 -------------------------------------
always@(posedge Clk_100MHz or negedge Reset_n)  //后发低8为  先高8位
begin
	if(!Reset_n)
		begin
			mem_data[0] <= 8'hAA;
			mem_data[1] <= 8'h55;
			mem_data[2] <= 8'h03;
			mem_data[3] <= 8'h00;
			mem_data[4] <= 8'h00;
			mem_data[5] <= 8'h00;
			mem_data[6] <= 8'h00;
			mem_data[7] <= 8'h00;
			mem_data[8] <= 8'h00;
			mem_data[9] <= 8'h00;
			mem_data[10]<= 8'h00;
            mem_data[11]<= 8'h00;
			mem_data[12]<= 8'h00;
            mem_data[13]<= 8'h00;
			mem_data[14]<= 8'h00;            
            mem_data[15]<= 8'h00;
			mem_data[16]<= 8'h00; 
 			mem_data[17]<= 8'h00;             
		end 
	else 
		begin
            if( Tx_cntx02 != 'd3 && Tx_cntx02 != 'd4 && Tx_cntx02 != 'd5 && Tx_cntx02 != 'd6 )//只有在不发该数据的时候才能对该数据赋值，否则会导致数据发送出错
				begin
					mem_data[3] <= ALT_Value[31:24];
					mem_data[4] <= ALT_Value[23:16];
                    mem_data[5] <= ALT_Value[15:8];
                    mem_data[6] <= ALT_Value[7:0];
				end
            else      // 如果此刻要发当前的值，必须保证当前值不变
				begin
					mem_data[3] <= mem_data[3];
					mem_data[4] <= mem_data[4];
                    mem_data[5] <= mem_data[5];
                    mem_data[6] <= mem_data[6]; 
				end

            if( Tx_cntx02 != 'd7 )
			   mem_data[7] <= Work_mode;
			else 
			   mem_data[7] <= mem_data[7];	
               
			if( Tx_cntx02 != 'd8 )
			   mem_data[8] <= ALT_TRF_Gain1;
			else
			   mem_data[8] <= mem_data[8];
			
			if( Tx_cntx02 != 'd9 )
			   mem_data[9] <= ALT_TRF_Gain2;
			else
			   mem_data[9] <= mem_data[9];
                
			if( Tx_cntx02 != 'd10 )
			   mem_data[10] <= ALT_TRF_Gain3;
			else
			   mem_data[10] <= mem_data[10];
                
			if( Tx_cntx02 != 'd11 )
			   mem_data[11] <= ALT_RRF_Gain;
			else
			   mem_data[11] <= mem_data[11];
               
            if( Tx_cntx02 != 'd12 )
			   mem_data[12] <= ALT_PA;
			else
			   mem_data[12] <= mem_data[12];
               
            if( Tx_cntx02 != 'd13 )
			   mem_data[13] <= Tempe_data[15:8];
			else
			   mem_data[13] <= mem_data[13];               
               
            if( Tx_cntx02 != 'd14 )
			   mem_data[14] <= Tempe_data[7:0];
			else
			   mem_data[14] <= mem_data[14];               
               
            if( Tx_cntx02 != 'd15 )
			   mem_data[15] <= ZD2101_Version[15:8];
			else
			   mem_data[15] <= mem_data[15];               
               
            if( Tx_cntx02 != 'd16 )
			   mem_data[16] <= ZD2101_Version[7:0];
			else
			   mem_data[16] <= mem_data[16]; 

            if( Tx_cntx02 != 'd17 )
			   mem_data[17] <= {7'd0,ALT_State};
			else
			   mem_data[17] <= mem_data[17];                
		end
end

always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)
		begin
			Feed_back1 <= 1'b0;
			Feed_back2 <= 1'b0;
			tx_done1   <= 1'b0;
			tx_done2   <= 1'b0;
		end
	else
		begin
			Feed_back1 <= Feed_back;
			Feed_back2 <= Feed_back1;
			tx_done1   <= tx_done;
			tx_done2   <= tx_done1;
		end
end

always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)
		Tx_cntx02 <= 5'd0;
	else if(Current_State == COMMANDx02 && tx_done == 1)
		Tx_cntx02 <= Tx_cntx02 + 5'd1;
	else if(Current_State != COMMANDx02)
		Tx_cntx02 <= 5'd0;
	else
		Tx_cntx02 <= Tx_cntx02;
end


always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)
		Wait_cnt <= 5'd0;
	else if(Current_State == WAIT_TIME)
		Wait_cnt <= Wait_cnt + 5'd1;
	else
		Wait_cnt <= 5'd0;
end


// --------------------------------------------------------------------------
always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)
		Check_cnt <= 5'd0;
	else if(Current_State == CHECK && Check_cnt < 5'd30)
		Check_cnt <= Check_cnt + 5'd1;
	else if(Current_State != CHECK)
		Check_cnt <= 5'd0;
	else
		Check_cnt <= Check_cnt;
end

always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)
		rs232_flag <= 1'b0;
//	else if(Current_State == COMMANDx02 && (Feed_back2 == 1 || tx_done2 == 1))
	else if(Current_State == COMMANDx02 && Feed_back2 == 1 )   //  AA  55  03  Message
		rs232_flag <= 1'b1;
//	else if(Current_State == CHECK && Check_cnt == 2)           
	else if(Current_State == CHECK && Feed_back2 == 1)         // CK
		rs232_flag <= 1'b1;
	else
		rs232_flag <= 1'b0;
end

always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)
		data_rs232_tx <= 8'd0;
	else if(Current_State == COMMANDx02)
		data_rs232_tx <= mem_data[Tx_cntx02];
	else if(Current_State == CHECK)
		data_rs232_tx <= Check_sum;
	else
		data_rs232_tx <= data_rs232_tx;
end

always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)
		Check_sum <= 8'd0;
	else if(Current_State == COMMANDx02 && tx_done == 1)  // cg
		Check_sum <= Check_sum + data_rs232_tx;
	else if(Current_State == IDLE)
		Check_sum <= 8'd0;
	else
		Check_sum <= Check_sum;
end

	
// --------------------------------------------------------------------------
always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)
		Current_State <= IDLE;
	else
		Current_State <= Next_State;
end

always@(*)
begin
	Next_State = IDLE;
	case(Current_State)
		IDLE: 
			begin
				if(Feed_back1 && !Feed_back2 )
					Next_State = COMMANDx02;
				else
					Next_State = Current_State;
			end
						
		COMMANDx02:
			begin
				if(Tx_cntx02 >= 17 && tx_done == 1)
					Next_State = CHECK;
				else
					Next_State = Current_State;
			end
					
		CHECK: 
			begin
				if(tx_done == 1)
					Next_State = WAIT_TIME;
				else
					Next_State = Current_State;
			end
			
		WAIT_TIME:
			begin
				if(Wait_cnt >= 10)
					Next_State = IDLE;
				else
					Next_State = Current_State;
			end
			
		default: Next_State = IDLE;
	endcase
end


endmodule
