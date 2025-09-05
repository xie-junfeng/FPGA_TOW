`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/01 10:03:35
// Design Name: 
// Module Name: LTC2000_CONFIG_INIT1
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


module LTC2000_CONFIG_INIT1(
input                sys_clk_100mhz          ,
input                sys_rst                 ,

input                AD_Locked               ,

output reg          DA_SPI_CSB,
output reg          DA_SPI_SCLK,
output reg          DA_SPI_SDIO,
input               DA_SPI_SDO,

output reg  [3:0]	Current_State_DA,
output reg          DA_Work_Flag,
output              DA_PD      


    );
    
 reg [3:0]	Current_State;
 reg [7:0]	Reg_1_Val;
 reg [7:0]	Reg_3_Val;
 reg [7:0]	Reg_4_Val;
 reg [7:0]	Reg_5_Val;
 reg [7:0]	Reg_6_Val;
 reg [7:0]	Reg_1E_Val;
 reg [7:0]	Reg_1F_Val;    
    
    
    
//////////////////////////VIO≤‚ ‘«¯”Ú///////////////////////////////

wire Work_Flag_HMC7044_VIO;
wire [6:0]DELAY_VIO;
wire AD_SW_Work_VIO;
wire AD_SW_test_VIO;
wire AD_SW_view_VIO;
wire VIO_SW;
wire  [4:0]REG_LMX_ADR_VIO;

VIO_DA VIO_DA (
  .clk(sys_clk_100mhz),      // input wire clk
  .probe_in0(Current_State), // input wire [3 : 0] probe_in0
  .probe_in1(Reg_1_Val),    // input wire [7 : 0] probe_in1
  .probe_in2(Reg_3_Val),    // input wire [7 : 0] probe_in2
  .probe_in3(Reg_4_Val),    // input wire [7 : 0] probe_in3
  .probe_in4(Reg_5_Val),    // input wire [7 : 0] probe_in4
  .probe_in5(Reg_6_Val),    // input wire [7 : 0] probe_in5
  .probe_in6(Reg_1E_Val),    // input wire [7 : 0] probe_in6
  .probe_in7(Reg_1F_Val),    // input wire [7 : 0] probe_in7
  .probe_in8(DA_Work_Flag),    // input wire [7 : 0] probe_in7
  
  .probe_out0(VIO_SW),  // output wire [0 : 0] probe_out0
  .probe_out1(AD_SW_Work_VIO),  // output wire [0 : 0] probe_out1
  .probe_out2(AD_SW_test_VIO),  // output wire [0 : 0] probe_out2
  .probe_out3(AD_SW_view_VIO),  // output wire [0 : 0] probe_out3
  .probe_out4(REG_LMX_ADR_VIO),  // output wire [4 : 0] probe_out4
  .probe_out5(Work_Flag_HMC7044_VIO) , // output wire [4 : 0] probe_out4
  .probe_out6(DELAY_VIO)  // output wire [4 : 0] probe_out4
  
);



///////////////////////////////////////////////////////////
 
 
localparam   [3:0]    Judge_Power_State = 3'd0;
localparam   [3:0]    Idle              = 4'd1;
localparam   [3:0]    PD                = 4'd2;

localparam   [3:0]    Wr_Reg            = 4'd3;
localparam   [3:0]    Wr_Reg_Loop       = 4'd4;
localparam   [3:0]    Wait_5ms          = 4'd5;

localparam   [3:0]    Wr_Reg_View       = 4'd6;       
localparam   [3:0]    Wr_Reg_View_Loop  = 4'd7;
localparam   [3:0]    Wr_TEST_Reg       = 4'd8;
localparam   [3:0]    Wr_TEST_Reg_Loop  = 4'd9;
	
localparam   [3:0]    Rd_Reg            = 4'd10;
localparam   [3:0]    Rd_Reg_Loop       = 4'd11;
localparam   [3:0]    Work              = 4'd12;
    
localparam   [23:0]   delay_Time        = 24'd450750;  //       d16000000
localparam   [23:0]   T_5ms             = 16'd25000;   
localparam   [6:0]    PD_Time           = 7'd100;   


reg [1:0]   cou;
reg         cou_3;
reg [23:0]  delay_cou;
reg         delay_end_up;
reg [3:0]	Next_State;
reg         new_state;
reg [5:0]   index_1; 
reg [5:0]   index_2;
reg [7:0]   index_3;
reg [5:0]   index_4;
reg [4:0]   da_bit_cou;
reg         wt_word_end_up;
reg [15:0]  cnt_5ms;
wire        T_5ms_flag;
reg [6:0]   PD_cou;
reg [21:0]	din_A;
reg [21:0]	din_B;


reg   AD_SW_Work_d1;
reg   AD_SW_Work_d2;
wire  AD_SW_Work_Pulse;
always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
   if(!sys_rst)
      begin
         AD_SW_Work_d1 <= 1'b0;
         AD_SW_Work_d2 <= 1'b0;
      end
	else
      begin
         AD_SW_Work_d1 <= AD_SW_Work_VIO;
         AD_SW_Work_d2 <= AD_SW_Work_d1;
      end
end

assign  AD_SW_Work_Pulse  = ( AD_SW_Work_d1 && ~AD_SW_Work_d2 ) ? 1'b1 : 1'b0;


reg   AD_SW_test_d1;
reg   AD_SW_test_d2;
wire  AD_SW_test_Pulse;
always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
   if(!sys_rst)
      begin
         AD_SW_test_d1 <= 1'b0;
         AD_SW_test_d2 <= 1'b0;
      end
	else
      begin
         AD_SW_test_d1 <= AD_SW_test_VIO;
         AD_SW_test_d2 <= AD_SW_test_d1;
      end
end

assign  AD_SW_test_Pulse  = ( AD_SW_test_d1 && ~AD_SW_test_d2 ) ? 1'b1 : 1'b0;


reg   AD_SW_view_d1;
reg   AD_SW_view_d2;
wire  AD_SW_view_Pulse;
always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
   if(!sys_rst)
      begin
         AD_SW_view_d1 <= 1'b0;
         AD_SW_view_d2 <= 1'b0;
      end
	else
      begin
         AD_SW_view_d1 <= AD_SW_view_VIO;
         AD_SW_view_d2 <= AD_SW_view_d1;
      end
end

assign  AD_SW_view_Pulse  = ( AD_SW_view_d1 && ~AD_SW_view_d2 ) ? 1'b1 : 1'b0;


always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
   if(!sys_rst)
	   cou <= 0;
	else
	   cou <= cou +1 ; 
end


always @(posedge sys_clk_100mhz or negedge sys_rst)   // 5M
begin
	if(!sys_rst)
		cou_3	<=	0;
	else if(cou==2)
		cou_3	<=	1;
	else
		cou_3	<=	0;
end


always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
	if(!sys_rst)
	   delay_cou <= 0;      
	else if ( Current_State == Idle )
	   begin
          if (cou_3)
             begin
		        if (delay_cou >= delay_Time)  // delay 500ms
			       delay_cou <= delay_cou;
		        else
		           delay_cou <= delay_cou+1;
	          end
	      else
		     delay_cou <= delay_cou;
       end
    else
	   delay_cou <= 0;         
end


always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
	if(!sys_rst)
		delay_end_up	<=	0;
	else if(cou_3 &&(delay_cou== delay_Time-5))
		delay_end_up	<=	1;
	else
		delay_end_up	<=	0;
end


always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
	if(!sys_rst)
	   PD_cou <= 0;      
	else if ( Current_State == PD )
	   begin
         if ( cou_3 )
             begin
		        if ( PD_cou >= PD_Time )  // delay 500ms
			        PD_cou <= PD_cou;
		        else
		           PD_cou <= PD_cou+1;
	          end
	      else
		       PD_cou <= PD_cou;
      end
   else
	   PD_cou <= 0;         
end
  
assign  DA_PD = ( PD_cou >= 7'd10 && PD_cou <= 7'd40 ) ? 1'b0 : 1'b1;

// -------fsm
always @ (posedge sys_clk_100mhz or negedge sys_rst)
begin
	if(!sys_rst)
		Current_State <= Judge_Power_State;
	else
		Current_State <= Next_State;
end


always @ (posedge sys_clk_100mhz or negedge sys_rst)
begin
	if(!sys_rst)
		new_state <= 0;
	else
		new_state <= (Current_State != Next_State);
end


always @ (posedge sys_clk_100mhz or negedge sys_rst)
begin
	if(!sys_rst)
		cnt_5ms <= 16'd0;
	else if ( Current_State == Wait_5ms )
	   begin
         if (cou_3)
            begin
		         if (cnt_5ms >= T_5ms)  // delay 500ms
			         cnt_5ms <= cnt_5ms;
		         else
		            cnt_5ms <= cnt_5ms+1;
	         end
	      else
		      cnt_5ms <= cnt_5ms;
       end
    else
	    cnt_5ms <= 0;
end


assign  T_5ms_flag = ( cou_3 && cnt_5ms== T_5ms-5 ) ? 1'b1 : 1'b0;

always @ (*)   
begin 
	if(!sys_rst)
       Next_State = Judge_Power_State;
   else
       begin       
          case(Current_State) 
               Judge_Power_State:   // 0
                   if ( AD_Locked== 1 && Work_Flag_HMC7044_VIO )
                       Next_State = Idle;
                   else   			 
                       Next_State = Judge_Power_State;  
               Idle:                // 1
                   if (delay_end_up) 
                       Next_State = PD;
                   else   			 
                       Next_State = Idle;   
			      PD:                  // 2                     
                   if ( PD_cou == PD_Time-5 ) 
                       Next_State = Wr_Reg;
                   else   			 
                       Next_State = PD; 					
               Wr_Reg:              // 3
                   if (wt_word_end_up)
                       begin
                          if(index_1>=6'd4)		    
                             Next_State = Rd_Reg;
								  else if (index_1 == 6'd3)
								     Next_State = Wait_5ms;
                          else
                             Next_State = Wr_Reg_Loop;
                       end
                    else 
                       Next_State = Wr_Reg;              
               Wr_Reg_Loop:         // 4
                   Next_State = Wr_Reg;
					Wait_5ms:           // 5
			          if ( T_5ms_flag && index_1 == 6'd3 )
						    Next_State = Wr_Reg_Loop;
						 else if ( T_5ms_flag && index_4 == 8'd5 )
						    Next_State = Wr_Reg_View_Loop;
						 else if ( T_5ms_flag && index_3 == 8'd132 )
						    Next_State = Wr_TEST_Reg_Loop;
					    else
						    Next_State = Wait_5ms;
//--------------------							 
					Wr_Reg_View	:       // 6
                   if (wt_word_end_up)
                       begin
                          if(index_4>=8'd6)			    
                             Next_State = Rd_Reg;
								  else if (index_4 == 8'd5)
								     Next_State = Wait_5ms;
                          else
                             Next_State = Wr_Reg_View_Loop;
                       end
                    else 
                       Next_State = Wr_Reg_View; 					   
					Wr_Reg_View_Loop:   // 7
					   Next_State = Wr_Reg_View;								 
//--------------------							 
					Wr_TEST_Reg	:       // 8
                   if (wt_word_end_up)
                       begin
                          if(index_3>=8'd133)			    
                             Next_State = Rd_Reg;
								  else if (index_3 == 8'd132)
								     Next_State = Wait_5ms;
                          else
                             Next_State = Wr_TEST_Reg_Loop;
                       end
                    else 
                       Next_State = Wr_TEST_Reg; 					   
					Wr_TEST_Reg_Loop:   // 9
					   Next_State = Wr_TEST_Reg;							 
               Rd_Reg:             // 10
                   if (  wt_word_end_up   )
                       begin
                         if(index_2>=6'd6)			    
                             Next_State = Work;
                          else
                             Next_State = Rd_Reg_Loop;
                       end
                    else 
                       Next_State = Rd_Reg;        
               Rd_Reg_Loop:        // 11
                  Next_State = Rd_Reg;       
               Work:               // 12
//                  if ( Power_State== 0 ) 
//                     Next_State = Judge_Power_State;
                  if ( AD_SW_Work_Pulse == 1'b1 )
                     Next_State = Wr_Reg; 
						else if ( AD_SW_view_Pulse == 1'b1 )
                     Next_State = Wr_Reg_View; 	
					   else if ( AD_SW_test_Pulse == 1'b1 )
                     Next_State = Wr_TEST_Reg;  
                  else   			 
                     Next_State = Work;    						
               default:
                    Next_State = Idle;		
            endcase
       end
end

reg [15:0]  Reg_Data;
always @ (posedge sys_clk_100mhz or negedge sys_rst)
begin
   if(!sys_rst)
	   Reg_Data <= {1'b0,7'h01,8'h00}; 
	else if (( Current_State == Wr_Reg )||( Current_State == Wr_Reg_Loop ))
      begin	
			case(index_1)	            
				0:  Reg_Data <=  {1'b0,7'h01,8'B0011_0001};  
				1:  Reg_Data <= {1'b0,7'h03,DELAY_VIO,1'B1} ;  //{1'b0,7'h03,8'h05};
				2:  Reg_Data <= {1'b0,7'h04,8'h03};
				3:  Reg_Data <= {1'b0,7'h1E,8'h00}; 			
//-----Wait 5ms								
				4:  Reg_Data <= {1'b0,7'h04,8'h0B};	 				
            default:
					 Reg_Data <= {1'b0,7'h01,8'h00};   		 
			endcase
		end		
	else if (( Current_State == Wr_Reg_View )||( Current_State == Wr_Reg_View_Loop ))
      begin	
			case(index_4)	            
				0:  Reg_Data <= {1'b0,7'h01,8'B0011_0001}; 
				1:  Reg_Data <= {1'b0,7'h03,8'h05};   
				2:  Reg_Data <= {1'b0,7'h04,8'h03};
				3:  Reg_Data <= {1'b0,7'h1E,8'h00}; 
				
				4:  Reg_Data <= {1'b0,7'h18,{2'b01,REG_LMX_ADR_VIO,1'b0}};     // DA15P/N  DCKIN/P
				5:  Reg_Data <= {1'b0,7'h18,{2'b01,REG_LMX_ADR_VIO,1'b1}};				
//-----Wait 5ms								
				6:  Reg_Data <= {1'b0,7'h04,8'h0B};	 				
            default:
					 Reg_Data <= {1'b0,7'h01,8'h00};   		 
			endcase
		end
	else if (( Current_State == Wr_TEST_Reg )||( Current_State == Wr_TEST_Reg_Loop ))
      begin	
			case(index_3)	            
				0:  Reg_Data <= {1'b0,7'h01,8'B0011_0001};     // {1'b0,7'h01,8'h01};
				1:  Reg_Data <= {1'b0,7'h03,8'h00}; // NOT NEED REALLY  05----->03
				2:  Reg_Data <= {1'b0,7'h04,8'h00};  	
				3:  Reg_Data <= {1'b0,7'h1E,8'h00};
//   data----				
            4:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            5:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            6:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            7:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            8:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			9:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            10:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			11:  Reg_Data <= {1'b0,7'h1F,8'hAA};				
		
            12:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            13:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            14:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            15:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            16:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			17:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            18:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			19:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			
            20:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            21:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            22:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            23:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            24:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			25:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            26:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			27:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
	
            28:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            29:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            30:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            31:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            32:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			   33:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            34:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			   35:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			
            36:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            37:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            38:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            39:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            40:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			   41:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            42:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			   43:  Reg_Data <= {1'b0,7'h1F,8'hAA};			
				
				44:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            45:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            46:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            47:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            48:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			   49:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            50:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			   51:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
				
				52:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            53:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            54:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            55:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            56:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			   57:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            58:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			   59:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
				
            60:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            61:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            62:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            63:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            64:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			   65:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            66:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			   67:  Reg_Data <= {1'b0,7'h1F,8'hAA};	

            68:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            69:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            70:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            71:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            72:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			   73:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            74:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			   75:  Reg_Data <= {1'b0,7'h1F,8'hAA};				
		
            76:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            77:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            78:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            79:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            80:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			   81:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            82:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			   83:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			
            84:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            85:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            86:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            87:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            88:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			   89:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            90:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			   91:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
	
            92:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            93:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            94:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            95:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            96:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			   97:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            98:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			   99:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			
            100:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            101:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            102:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            103:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            104:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			   105:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            106:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			   107:  Reg_Data <= {1'b0,7'h1F,8'hAA};			
				
				108:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            109:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            110:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            111:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            112:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			   113:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            114:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			   115:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
				
				116:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            117:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            118:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            119:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            120:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			   121:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            122:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			   123:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
				
            124:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            125:  Reg_Data <= {1'b0,7'h1F,8'hAA};	 
            126:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            127:  Reg_Data <= {1'b0,7'h1F,8'h55};	 
            128:  Reg_Data <= {1'b0,7'h1F,8'h55};	
			   129:  Reg_Data <= {1'b0,7'h1F,8'h55};	
            130:  Reg_Data <= {1'b0,7'h1F,8'hAA};	
			   131:  Reg_Data <= {1'b0,7'h1F,8'hAA};						
//   data----					
            132:  Reg_Data <= {1'b0,7'h1E,8'h01};	 				
//-----Wait 5ms				
            133: Reg_Data <= {1'b0,7'h04,8'h08};	 
            default:
					 Reg_Data <= {1'b0,7'h01,8'h00};   		 
			endcase
		end		
	else if ( Current_State == Rd_Reg || Current_State == Rd_Reg_Loop )
      begin	
			case(index_2)	
     		0:  Reg_Data <= {1'b1,7'h01,8'h00};       			                       
            1:  Reg_Data <= {1'b1,7'h03,8'h00};    
            2:  Reg_Data <= {1'b1,7'h04,8'h00}; 
	        3:  Reg_Data <= {1'b1,7'h05,8'h00};   
            4:  Reg_Data <= {1'b1,7'h06,8'h00};			
            5:  Reg_Data <= {1'b1,7'h1E,8'h00};   
            6:  Reg_Data <= {1'b1,7'h1F,8'h00};
				default:
					 Reg_Data <= {1'b1,7'h01,8'h00};  		 
			endcase
		end 
	else	
	   Reg_Data <= Reg_Data;
end


always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
   if(!sys_rst)
      begin
         DA_SPI_CSB<=1'b1;
         DA_SPI_SDIO<=1'b0;
      end
   else  if( cou_3 &&( Current_State == Wr_Reg || Current_State == Wr_TEST_Reg || Current_State == Wr_Reg_View || Current_State == Rd_Reg ))
      begin
			case( da_bit_cou )  
			  8'd0: begin DA_SPI_CSB <= 1'b1; DA_SPI_SDIO <= 1'b0;             end 
			  8'd1: begin DA_SPI_CSB <= 1'b1; DA_SPI_SDIO <= 1'b0;             end                                                                                  
			  8'd2: begin DA_SPI_CSB <= 1'b1; DA_SPI_SDIO <= 1'b0;             end 
			  8'd3: begin DA_SPI_CSB <= 1'b1; DA_SPI_SDIO <= 1'b0;             end 
			  
  
			  8'd4:  begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[15];     end   
			  8'd5:  begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[14];     end  
			  8'd6:  begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[13];     end  
			  8'd7:  begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[12];     end 			  			  
			  8'd8:  begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[11];     end 
			  8'd9:  begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[10];     end 
			  8'd10: begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[9];      end 
			  8'd11: begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[8];      end 
			  8'd12: begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[7];      end 
			  8'd13: begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[6];      end                                          
			  8'd14: begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[5];      end 
			  8'd15: begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[4];      end 
			  8'd16: begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[3];      end 
			  8'd17: begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[2];      end 
			  8'd18: begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[1];      end 
			  8'd19: begin DA_SPI_CSB <= 1'b0; DA_SPI_SDIO <= Reg_Data[0];      end 
			  8'd20: begin DA_SPI_CSB <= 1'b1; DA_SPI_SDIO <= 0;                end
			  8'd21: begin DA_SPI_CSB <= 1'b1; DA_SPI_SDIO <= 0;                end
			  8'd22: begin DA_SPI_CSB <= 1'b1; DA_SPI_SDIO <= 0;                end
			  8'd23: begin DA_SPI_CSB <= 1'b1; DA_SPI_SDIO <= 0;                end  
			  default: begin DA_SPI_CSB <= 1'b1; DA_SPI_SDIO <= 0;              end 
		   endcase
      end
   else
	   begin
		   DA_SPI_CSB <=DA_SPI_CSB;
		   DA_SPI_SDIO<=DA_SPI_SDIO;
	   end
end

reg [7:0]  RD_reg_Value;  
always @(posedge sys_clk_100mhz or negedge sys_rst)  
begin
   if(!sys_rst)
      RD_reg_Value <= 8'hFF;
   else if ( Current_State == Idle )
      RD_reg_Value <= 8'hFF;              
   else if ( cou==1 && ( Current_State == Rd_Reg ))
      begin
	     case( da_bit_cou )  
			  8'd13: RD_reg_Value[7] <= DA_SPI_SDO; 
			  8'd14: RD_reg_Value[6] <= DA_SPI_SDO;                                            
			  8'd15: RD_reg_Value[5] <= DA_SPI_SDO; 
			  8'd16: RD_reg_Value[4] <= DA_SPI_SDO; 
			  8'd17: RD_reg_Value[3] <= DA_SPI_SDO; 
			  8'd18: RD_reg_Value[2] <= DA_SPI_SDO; 
			  8'd19: RD_reg_Value[1] <= DA_SPI_SDO; 
			  8'd20: RD_reg_Value[0] <= DA_SPI_SDO; 
			  default:  RD_reg_Value <= RD_reg_Value; 
		   endcase
      end
   else
      RD_reg_Value <= RD_reg_Value; 
end

//------------  increased rd reg 
always @(posedge sys_clk_100mhz or negedge sys_rst)   
begin
   if(!sys_rst)
      Reg_1_Val <= 8'hFF;
   else if ( Current_State == Idle )
      Reg_1_Val <= 8'hFF;     
   else if ( Current_State == Rd_Reg && cou == 2 && da_bit_cou== 8'd21 && index_2 == 0 )
      Reg_1_Val <= RD_reg_Value;
   else
      Reg_1_Val <= Reg_1_Val; 
end


always @(posedge sys_clk_100mhz or negedge sys_rst)   
begin
   if(!sys_rst)
      Reg_3_Val <= 8'hFF;
   else if ( Current_State == Idle )
      Reg_3_Val <= 8'hFF;     
   else if ( Current_State == Rd_Reg && cou == 2 && da_bit_cou== 8'd21 && index_2 == 1 )
      Reg_3_Val <= RD_reg_Value;
   else
      Reg_3_Val <= Reg_3_Val; 
end

always @(posedge sys_clk_100mhz or negedge sys_rst)  
begin
   if(!sys_rst)
      Reg_4_Val <= 8'hFF;
   else if ( Current_State == Idle )
      Reg_4_Val <= 8'hFF; 	  
   else if ( Current_State == Rd_Reg && cou == 2 && da_bit_cou== 8'd21 && index_2 == 2 )
      Reg_4_Val <= RD_reg_Value; 
   else
      Reg_4_Val <= Reg_4_Val; 
end


always @(posedge sys_clk_100mhz or negedge sys_rst)  
begin
   if(!sys_rst)
      Reg_5_Val <= 8'hFF;
   else if ( Current_State == Idle )
      Reg_5_Val <= 8'hFF; 	  
   else if ( Current_State == Rd_Reg && cou == 2 && da_bit_cou== 8'd21 && index_2 == 3 )
      Reg_5_Val <= RD_reg_Value; 
   else
      Reg_5_Val <= Reg_5_Val; 
end


always @(posedge sys_clk_100mhz or negedge sys_rst)  
begin
   if(!sys_rst)
      Reg_6_Val <= 8'hFF;
   else if ( Current_State == Idle )
      Reg_6_Val <= 8'hFF; 	  
   else if ( Current_State == Rd_Reg && cou == 2 && da_bit_cou== 8'd21 && index_2 == 4 )
      Reg_6_Val <= RD_reg_Value; 
   else
      Reg_6_Val <= Reg_6_Val; 
end


always @(posedge sys_clk_100mhz or negedge sys_rst)  
begin
   if(!sys_rst)
      Reg_1E_Val <= 8'hFF;
   else if ( Current_State == Idle )
      Reg_1E_Val <= 8'hFF; 	  
   else if ( Current_State == Rd_Reg && cou == 2 && da_bit_cou== 8'd21 && index_2 == 5 )
      Reg_1E_Val <= RD_reg_Value; 
   else
      Reg_1E_Val <= Reg_1E_Val; 
end

always @(posedge sys_clk_100mhz or negedge sys_rst)  
begin
   if(!sys_rst)
      Reg_1F_Val <= 8'hFF;
   else if ( Current_State == Idle )
      Reg_1F_Val <= 8'hFF; 	  
   else if ( Current_State == Rd_Reg && cou == 2 && da_bit_cou== 8'd21 && index_2 == 6 )
      Reg_1F_Val <= RD_reg_Value; 
   else
      Reg_1F_Val <= Reg_1F_Val; 
end


always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
	if(!sys_rst)
		DA_SPI_SCLK <=	0;			
	else if (DA_SPI_CSB==0)
		begin
			if(cou==0)
				DA_SPI_SCLK <=	1;
			else  if(cou==2)
				DA_SPI_SCLK <=	0;
			else
				DA_SPI_SCLK <=	DA_SPI_SCLK;
		end
	else 
		DA_SPI_SCLK <=	0;					
end


always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
	if(!sys_rst)
       index_1 <= 6'd0;
    else
        case (Current_State)
            Idle:
                index_1 <= 6'd0;
				Rd_Reg:
				    index_1 <= 6'd0;					 
            Wr_Reg_Loop:
                index_1 <= index_1 + 1;
            default: 
                index_1 <= index_1;	
        endcase
end


always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
	if(!sys_rst)
       index_2 <= 6'd0;
    else
        case (Current_State)
            Idle:
                index_2 <= 6'd0;
				Work:
				    index_2 <= 6'd0;
            Rd_Reg_Loop:
                index_2 <= index_2 + 1;
            default: 
                index_2 <= index_2;	
        endcase
end


always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
	if(!sys_rst)
       index_3 <= 8'd0;
    else
        case (Current_State)
            Idle:
                index_3 <= 8'd0;
				Rd_Reg:
				    index_3 <= 8'd0;
            Wr_TEST_Reg_Loop:
                index_3 <= index_3 + 1;
            default: 
                index_3 <= index_3;	
        endcase
end

always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
	if(!sys_rst)
       index_4 <= 6'd0;
    else
        case (Current_State)
            Idle:
                index_4 <= 6'd0;
				Rd_Reg:
				    index_4 <= 6'd0;
            Wr_Reg_View_Loop:
                index_4 <= index_4 + 1;
            default: 
                index_4 <= index_4;	
        endcase
end

always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
   if(!sys_rst)
      da_bit_cou<=23;
   else  if(new_state)
      da_bit_cou<=0;
   else  if(cou_3)
      begin
         if(da_bit_cou==23)
            da_bit_cou<= da_bit_cou;
         else
            da_bit_cou<=da_bit_cou +1;
      end 
   else
      da_bit_cou<=da_bit_cou;
end


always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
   if(!sys_rst)
      wt_word_end_up<=0;
   else if(cou_3 && da_bit_cou==22)
      wt_word_end_up<=1;
   else  
      wt_word_end_up<=0;
end

always @(posedge sys_clk_100mhz or negedge sys_rst)
begin
   if(!sys_rst)
      DA_Work_Flag <= 0;
   else if( Current_State == Work )
      DA_Work_Flag <= 1;
   else  
      DA_Work_Flag <= DA_Work_Flag;
end

    
endmodule
