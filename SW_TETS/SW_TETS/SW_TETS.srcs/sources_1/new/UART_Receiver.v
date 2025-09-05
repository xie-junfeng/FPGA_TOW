/*===================================================================================================
	Name	:
	Function:
	Author	:
	Date	:
====================================================================================================*/
module	UART_Receiver
(
	input					Clk_100MHz,
	input					Reset_n,
	input					Uart_rx1,
    
	input        			ALT_State,
	output reg [31:0]	    ALT_Value,
	output reg [7:0]   	    Work_mode,
    output reg [7:0]   	    ALT_TRF_Gain1,
	output reg [7:0]	    ALT_TRF_Gain2,
	output reg [7:0]   	    ALT_TRF_Gain3,
	output reg [7:0]  	    ALT_RRF_Gain,
	output reg [7:0]	    ALT_PA,
    output reg              Frame_End,
    output wire             Clk_16xBps,
    
	output reg [8:0]	    State,
    output wire [7:0]       UART_Pout

    
);

// ----------------------------------------------------------------
//* FSM PARAMETER
parameter	IDLE			= 9'b000000001;
parameter	FRAME_HEAD		= 9'b000000010;
parameter	COMMAND			= 9'b000000100;
parameter	COMMAND_RES		= 9'b000001000;
parameter	CONTROL			= 9'b000010000;
parameter	FLASH_WR		= 9'b000100000;
parameter	CHECK			= 9'b001000000;
parameter	WAIT_TIME		= 9'b010000000;
parameter	PARAMETER_INIT	= 9'b100000000;

// ----------------------------------------------------------------
//* REG
reg [7:0]	Data[19:0];
reg [7:0]	Frame_Cnt;
reg [7:0]	Checkout;
reg [7:0]	Check_reg;
reg [7:0]	Commd;
//reg [8:0]	State/* synthesis preserve */;
reg [15:0]	Frm_Head;
reg [16:0]	Beyond_time;
reg			Beyond_time_flag;

// ----------------------------------------------------------------
//* WIRE
wire		Rx_flag;
//wire[7:0]	UART_Pout;

// --------------------------------------------------------------------
RS422_rx1  RS422_rx1
(
	.clk					( Clk_100MHz ),
	.reset				    ( Reset_n ),
	.UART_in				( Uart_rx1 ),
	
	.Rx_flag				( Rx_flag ),
	.UART_PDout			    ( UART_Pout ),
	.Bps_cnt				(  ),
	.Clk_16xBps			    ( Clk_16xBps )
);

// ------------------------ Beyond Time 1ms -------------------------
always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)
		Beyond_time <= 17'd0;
	else if( State != IDLE && State != WAIT_TIME && State != PARAMETER_INIT )
		begin
			if( Rx_flag == 1'b1 )
				Beyond_time <= 17'd0;
			else if( Beyond_time <= 17'd100000 )
				Beyond_time <= Beyond_time + 17'd1;
			else
				Beyond_time <= Beyond_time;
		end
	else
		Beyond_time <= 17'd0;
end

always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)
		Beyond_time_flag <= 1'd0;
	else if( Beyond_time >= 17'd100000 )
		Beyond_time_flag <= 1'd1;
	else
		Beyond_time_flag <= 1'd0;
end
			
// ----------- Frame Of Recv --------------
always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)
		begin
			State <= IDLE;
			Frame_Cnt <= 8'd0;
			Frm_Head <= 16'd0;
			Checkout <= 8'd0;
			Commd <= 8'd0;
			Check_reg <= 8'd0;
			Data[0] <= 8'd0;
			Data[1] <= 8'd0;
			Data[2] <= 8'd0;
			Data[3] <= 8'd0;
			Data[4] <= 8'd74;
			Data[5] <= 8'd0;	
			Data[6] <= 8'd0;	
			Data[7] <= 8'd0;
            Data[8] <= 8'b0010_1000;		
			Data[9] <= 8'd0;	 
		end
	else 
		begin
			case(State)
				IDLE :
					begin
						if(Rx_flag == 1'b1)
							begin
								State <= FRAME_HEAD;
								Frame_Cnt <= Frame_Cnt + 8'd1;   // Frame_Cnt <= 1
								Frm_Head[15:8] <= UART_Pout;
							end
						else
							begin
								State     <= IDLE;
								Frame_Cnt <= Frame_Cnt;
								Frm_Head  <= Frm_Head;
							end
					end
				
				FRAME_HEAD:
					begin
						if( Beyond_time_flag == 1 || (Frame_Cnt >= 8'd2 && Frm_Head != 16'hAA55))
							State <= PARAMETER_INIT;
						else if( Frame_Cnt >= 8'd2 && Frm_Head == 16'hAA55 )
							State <= COMMAND;
						else
							State <= FRAME_HEAD;
						
						if(Rx_flag == 1'b1)
							begin
								Frame_Cnt <= Frame_Cnt + 8'd1;   // Frame_Cnt <= 2
								Frm_Head[7:0] <= UART_Pout;
							end
						else
							begin
								Frame_Cnt <= Frame_Cnt;
								Frm_Head <= Frm_Head;
							end
					end
				
				COMMAND:
					begin
						if( Beyond_time_flag == 1 )
							State <= PARAMETER_INIT;
						else if(Rx_flag == 1'b1)
							State <= COMMAND_RES;
						else
							State <= COMMAND;
							
						if(Rx_flag == 1'b1)
							begin
								Frame_Cnt <= Frame_Cnt + 8'd1;    // Frame_Cnt <= 3
								Commd <= UART_Pout;
								Checkout <= Checkout + UART_Pout;
							end
						else
							begin
								Frame_Cnt <= Frame_Cnt;
								Commd <= Commd;
								Checkout <= Checkout;
							end
					end
					
				COMMAND_RES: //Command Resolve
					begin
						if(Commd == 8'h02 || Commd == 8'h82)
							State <= CONTROL;		
						else
							State <= PARAMETER_INIT;
					end
					
				CONTROL:
					begin
						if( Beyond_time_flag == 1 )
							State <= PARAMETER_INIT;
						else if( Frame_Cnt >= 8'd13 )
							State <= CHECK;
						else
							State <= CONTROL;
						
						if( Rx_flag == 1'b1 )
							Data[Frame_Cnt-3] <= UART_Pout;
						else
							;
						
						if( Rx_flag == 1'b1 )
							begin
								Frame_Cnt <= Frame_Cnt + 8'd1;    // Frame_Cnt <= 3
								Checkout <= Checkout + UART_Pout;
							end
						else
							begin
								Frame_Cnt <= Frame_Cnt;
								Checkout <= Checkout;
							end
					end
/*					
				FLASH_WR:
					begin
						if( Beyond_time_flag == 1 )
							State <= PARAMETER_INIT;
						else if( Frame_Cnt >= 8'd148 )
							State <= CHECK;
						else
							State <= FLASH_WR;
						
						if( Rx_flag == 1'b1 || Frame_Cnt >= 8'd148 )
							Data[Frame_Cnt-3] <= UART_Pout;
						else
							;
						
						if( Rx_flag == 1'b1 )
							begin
								Frame_Cnt <= Frame_Cnt + 8'd1;
								Checkout <= Checkout + UART_Pout;
							end
						else
							begin
								Frame_Cnt <= Frame_Cnt;
								Checkout <= Checkout;
							end
					end
*/					
				CHECK:
					begin
						if( Beyond_time_flag == 1 )
							State <= PARAMETER_INIT;
						else if(Rx_flag == 1'b1)
							State <= WAIT_TIME;
						else
							State <= CHECK;
							
						if(Rx_flag == 1'b1)
							begin
								Check_reg <= UART_Pout;
								Checkout <= Checkout + 8'hFF;   
							end
						else
							begin
								Check_reg <= Check_reg;
								Checkout <= Checkout;
							end
					end
				
				WAIT_TIME: State <= PARAMETER_INIT;
					
				PARAMETER_INIT:
					begin
						Data[0] <= 8'd0;	
						Data[1] <= 8'd0;	
						Data[2] <= 8'd0;	
						Data[3] <= 8'd0;	
						Data[4] <= 8'd74;
						Data[5] <= 8'd0;
						Data[6] <= 8'd0;
						Data[7] <= 8'd0;
                        Data[8] <= 8'b0010_1000;	
						Data[9] <= 8'd0;

						Checkout <= 8'd0;
						Frame_Cnt <= 8'd0;
						Commd <= 8'd0;
						Check_reg <= 8'd0;
						Frm_Head <= 16'h0000;
						State <= IDLE;
					end
					
				default: State <= PARAMETER_INIT;
			endcase
		end
end

always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)
		begin
			ALT_Value		<= 32'd0;
            Work_mode	    <= 8'd74;
			ALT_TRF_Gain1	<= 8'd0;
			ALT_TRF_Gain2	<= 8'd0;
			ALT_TRF_Gain3	<= 8'd0;
			ALT_RRF_Gain	<= 8'b1010_0000;
			ALT_PA			<= 8'd0;
		end
	else if( State == WAIT_TIME && Checkout == Check_reg && ALT_State )
		case(Commd)
            8'h02:begin // Control SW
                    ALT_Value		<= {Data[0],Data[1],Data[2],Data[3]};
                    Work_mode       <= Data[4];
                    ALT_TRF_Gain1	<= Data[5];
                    ALT_TRF_Gain2	<= Data[6];
                    ALT_TRF_Gain3	<= Data[7];
                    ALT_RRF_Gain	<= Data[8];
                    ALT_PA			<= Data[9];
                end
            default : begin
                    ALT_Value		<= ALT_Value;
                    Work_mode       <= Work_mode;
                    ALT_TRF_Gain1	<= ALT_TRF_Gain1;
                    ALT_TRF_Gain2	<= ALT_TRF_Gain2;
                    ALT_TRF_Gain3	<= ALT_TRF_Gain3;
                    ALT_RRF_Gain	<= ALT_RRF_Gain;
                    ALT_PA			<= ALT_PA;
                end
		endcase
    else 
       begin
          ALT_Value		<= ALT_Value;
          Work_mode     <= Work_mode;
          ALT_TRF_Gain1	<= ALT_TRF_Gain1;
          ALT_TRF_Gain2	<= ALT_TRF_Gain2;
          ALT_TRF_Gain3	<= ALT_TRF_Gain3;
          ALT_RRF_Gain	<= ALT_RRF_Gain;
          ALT_PA		<= ALT_PA;
      end   
 end

always@(posedge Clk_100MHz or negedge Reset_n)
begin
	if(!Reset_n)
       Frame_End <= 1'b0;
    else if ( State == WAIT_TIME && Checkout == Check_reg )
       Frame_End <= 1'b1;
    else
       Frame_End <= 1'b0;
end
       

endmodule
