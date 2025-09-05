`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/01 09:04:07
// Design Name: 
// Module Name: ADS5400_CONF
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

module MWD1000L_CONFIG_INIT(

input         clk,
input         rst_n,

output reg    SPI_CSB,
output reg    SPI_SCLK,
output reg    SPI_SDIO,
input         SPI_SDO,
////////////////

input               Work_Flag_DA,
output reg [3:0]	Current_State,
output reg [7:0]	Chip_Gain_SPI,
output reg [7:0]	Chip_ID,
output reg [7:0]	Chip_Revision,
input               Power_State,
output reg          Work_Flag

///////////////////
);

localparam   [3:0]    Judge_Power_State = 3'd0;
localparam   [3:0]    Idle              = 4'd1;
localparam   [3:0]    Wr_Reg            = 4'd2;
localparam   [3:0]    Wr_Reg_Loop       = 4'd3;
localparam   [3:0]    Rd_Reg            = 4'd4;
localparam   [3:0]    Rd_Reg_Loop       = 4'd5;
localparam   [3:0]    Work              = 4'd6;

//localparam [23:0]   delay_Time        = 24'd120;     
localparam [23:0]   delay_Time        = 24'd450750;  //       d16000000

//wire               Work_Flag_DA;
reg [1:0]   cou;
reg         cou_3;
reg [23:0]  delay_cou;
reg         delay_end_up;
//reg [2:0]	Current_State;
reg [3:0]	Next_State;
reg         new_state;
reg [5:0]   index_1; 
reg [5:0]   index_2;
reg [4:0]   da_bit_cou;
reg         wt_word_end_up;
//////////////////////////////////VIO²âÊÔÇø/////////////////////////////////////
wire VIO_SW;
wire         Work_Flag_AD_VIO;
wire         Power_State_VIO;
wire [7:0]   output_mode_VIO;


reg         Work_Flag_DA_src;
reg         Power_State_src;
reg [7:0]   output_mode_src;

wire [4:0]  Coarse_Clock_VIO;
wire [5:0]  Fine_Clock_VIO;

VIO_AD VIO_AD (
  .clk(clk),                        // input wire clk
  .probe_in0(Current_State),        // input wire [3 : 0] probe_in0
  .probe_in1(Chip_Gain_SPI),        // input wire [7 : 0] probe_in1
  .probe_in2(Chip_ID),              // input wire [7 : 0] probe_in2
  .probe_in3(Chip_Revision),        // input wire [7 : 0] probe_in3
  .probe_in4(Work_Flag),            // input wire [0 : 0] probe_in4
  
  .probe_out0(VIO_SW),              // output wire [0 : 0] probe_out0
  .probe_out1(Work_Flag_AD_VIO),                    // output wire [0 : 0] probe_out1
  .probe_out2(Power_State_VIO),                    // output wire [0 : 0] probe_out2
  .probe_out3(output_mode_VIO),                     // output wire [7 : 0] probe_out3
  .probe_out4(Coarse_Clock_VIO) ,                    // output wire [7 : 0] probe_out3
  .probe_out5(Fine_Clock_VIO)                     // output wire [7 : 0] probe_out3  
);

always@( posedge clk or negedge rst_n )
begin
	if(!rst_n)   begin
	   Work_Flag_DA_src<=1'd1;
	   Power_State_src<=1'd1;
	   output_mode_src<=8'b0010_0000;
	end
	else if(VIO_SW)begin
	   Work_Flag_DA_src<=Work_Flag_AD_VIO;
	   Power_State_src<=Power_State_VIO;
	   output_mode_src<=output_mode_VIO;
    end
	else begin
	   Work_Flag_DA_src<=Work_Flag_DA;
	   Power_State_src<=Power_State;
	   output_mode_src<=8'b0010_0000;
		end
end

///////////////////////////////////////////////////////////////////////////////



always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
	   cou <= 0;
	else
	   cou <= cou +1 ; 
end


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cou_3	<=	0;
	else if(cou==2)
		cou_3	<=	1;
	else
		cou_3	<=	0;
end


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
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


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		delay_end_up	<=	0;
	else if(cou_3 &&(delay_cou== delay_Time-5))
		delay_end_up	<=	1;
	else
		delay_end_up	<=	0;
end


// -------fsm
always @ (posedge clk or negedge rst_n)
begin
	if(!rst_n)
		Current_State <= Judge_Power_State;
	else
		Current_State <= Next_State;
end


always @ (posedge clk or negedge rst_n)
begin
	if(!rst_n)
		new_state <= 0;
	else
		new_state <= (Current_State != Next_State);
end


always @ (*)   
begin 
	if(!rst_n)
       Next_State = Judge_Power_State;
    else
       begin       
          case(Current_State) 
               Judge_Power_State:
                   if ( Power_State_src== 1 && Work_Flag_DA_src )
                       Next_State = Idle;
                   else   			 
                       Next_State = Judge_Power_State;  
               Idle:
                   if (delay_end_up) 
                       Next_State = Wr_Reg;
                   else   			 
                       Next_State = Idle;         
               Wr_Reg:
                   if (wt_word_end_up)
                       begin
                         if(index_1>=6'd6)			    
                             Next_State = Rd_Reg;
                          else
                             Next_State = Wr_Reg_Loop;
                       end
                    else 
                       Next_State = Wr_Reg;              
               Wr_Reg_Loop:
                   Next_State = Wr_Reg;
               Rd_Reg:
                   if (wt_word_end_up)
                       begin
                         if(index_2>=6'd7)			    
                             Next_State = Work;
                          else
                             Next_State = Rd_Reg_Loop;
                       end
                    else 
                       Next_State = Rd_Reg;        
               Rd_Reg_Loop: 
                  Next_State = Rd_Reg;       
               Work:
                  if ( Power_State_src== 0 ) 
                     Next_State = Judge_Power_State;
                  else   			 
                     Next_State = Work;    						
               default:
                    Next_State = Idle;		
            endcase
       end
end

reg [15:0]  Reg_Data;
always @ (posedge clk)
begin
   if(!rst_n)
	   Reg_Data <= {3'b000,5'h01,8'hF8};
	else if (( Current_State == Wr_Reg )||( Current_State == Wr_Reg_Loop ))
      begin	
			case(index_1)	            
				0:  Reg_Data <= {3'b000,5'h01,8'hF8};    
				1:  Reg_Data <= {3'b000,5'h00,8'hFF};   
				2:  Reg_Data <= {3'b000,5'h02,Coarse_Clock_VIO,3'D0};  	
				3:  Reg_Data <= {3'b000,5'h03,Fine_Clock_VIO,2'D0};	 				
                4:  Reg_Data <= {3'b000,5'h04,8'h00};					
                5:  Reg_Data <= {3'b000,5'h05,8'hB8};    // Enable data synchronization mode  ¡¢Output bus A and B aligned{6'b001000,1'b1,1'b0}};
				6:  Reg_Data <= {3'b000,5'h06,output_mode_src};	 	
               default:
					Reg_Data <= {3'b000,5'h01,8'hF8};  		 
			endcase
		end
	else if ( Current_State == Rd_Reg || Current_State == Rd_Reg_Loop )
      begin	
			case(index_2)	
     			0:  Reg_Data <= {3'b100,5'h01,8'h00};       			                       
                1:  Reg_Data <= {3'b100,5'h00,8'h00};    
                2:  Reg_Data <= {3'b100,5'h02,8'h00};   
                3:  Reg_Data <= {3'b100,5'h05,8'h00};   
                4:  Reg_Data <= {3'b100,5'h06,8'h00};   
                5:  Reg_Data <= {3'b100,5'h08,8'h00};  
                6:  Reg_Data <= {3'b100,5'h1E,8'h00};   
                7:  Reg_Data <= {3'b100,5'h1F,8'h00};   
				default:
					Reg_Data <= {3'b100,5'h01,8'h00};  		 
			endcase
		end 
	else	
	   Reg_Data <= Reg_Data;
end


always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         SPI_CSB<=1'b1;
         SPI_SDIO<=1'b0;
      end
   else  if( cou_3 &&( Current_State == Wr_Reg || Current_State == Rd_Reg ))
      begin
			case( da_bit_cou )  
			  8'd0: begin SPI_CSB <= 1'b1; SPI_SDIO <= 1'b0;             end 
			  8'd1: begin SPI_CSB <= 1'b1; SPI_SDIO <= 1'b0;             end                                                                                  
			  8'd2: begin SPI_CSB <= 1'b1; SPI_SDIO <= 1'b0;             end 
			  8'd3: begin SPI_CSB <= 1'b1; SPI_SDIO <= 1'b0;             end 
			  
  
			  8'd4: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[15];     end   
			  8'd5: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[14];     end  
			  8'd6: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[13];     end  
			  8'd7: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[12];     end 			  			  
			  8'd8: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[11];     end 
			  8'd9: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[10];     end 
			  8'd10: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[9];      end 
			  8'd11: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[8];      end 
			  8'd12: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[7];      end 
			  8'd13: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[6];      end                                          
			  8'd14: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[5];      end 
			  8'd15: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[4];      end 
			  8'd16: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[3];      end 
			  8'd17: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[2];      end 
			  8'd18: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[1];      end 
			  8'd19: begin SPI_CSB <= 1'b0; SPI_SDIO <= Reg_Data[0];      end 
			  8'd20: begin SPI_CSB <= 1'b1; SPI_SDIO <= 0;                end
			  8'd21: begin SPI_CSB <= 1'b1; SPI_SDIO <= 0;                end
			  8'd22: begin SPI_CSB <= 1'b1; SPI_SDIO <= 0;                end
			  8'd23: begin SPI_CSB <= 1'b1; SPI_SDIO <= 0;                end  
			  default: begin SPI_CSB <= 1'b1; SPI_SDIO <= 0;                end 
		   endcase
      end
   else
	   begin
		   SPI_CSB <=SPI_CSB;
		   SPI_SDIO<=SPI_SDIO;
	   end
end

reg [7:0]  RD_reg_Value;  
always @(posedge clk or negedge rst_n)  
begin
   if(!rst_n)
      RD_reg_Value <= 8'hFF;
   else if ( Current_State == Idle )
      RD_reg_Value <= 8'hFF;              
   else if ( cou==1 && ( Current_State == Rd_Reg ))
      begin
	     case( da_bit_cou )  
			  8'd13: RD_reg_Value[7] <= SPI_SDO; 
			  8'd14: RD_reg_Value[6] <= SPI_SDO;                                            
			  8'd15: RD_reg_Value[5] <= SPI_SDO; 
			  8'd16: RD_reg_Value[4] <= SPI_SDO; 
			  8'd17: RD_reg_Value[3] <= SPI_SDO; 
			  8'd18: RD_reg_Value[2] <= SPI_SDO; 
			  8'd19: RD_reg_Value[1] <= SPI_SDO; 
			  8'd20: RD_reg_Value[0] <= SPI_SDO; 
			  default:  RD_reg_Value <= RD_reg_Value; 
		   endcase
      end
   else
      RD_reg_Value <= RD_reg_Value; 
end

//------------  increased rd reg 
always @(posedge clk or negedge rst_n)   
begin
   if(!rst_n)
      Chip_Gain_SPI <= 8'hFF;
   else if ( Current_State == Idle )
      Chip_Gain_SPI <= 8'hFF;     
   else if ( Current_State == Rd_Reg && cou == 2 && da_bit_cou== 8'd21 && index_2 == 0 )
      Chip_Gain_SPI <= RD_reg_Value;
   else
      Chip_Gain_SPI <= Chip_Gain_SPI;  
end


always @(posedge clk or negedge rst_n)   
begin
   if(!rst_n)
      Chip_ID <= 8'hFF;
   else if ( Current_State == Idle )
      Chip_ID <= 8'hFF;     
   else if ( Current_State == Rd_Reg && cou == 2 && da_bit_cou== 8'd21 && index_2 == 6 )
      Chip_ID <= RD_reg_Value;
   else
      Chip_ID <= Chip_ID; 
end

always @(posedge clk or negedge rst_n)  
begin
   if(!rst_n)
      Chip_Revision <= 8'hFF;
   else if ( Current_State == Idle )
      Chip_Revision <= 8'hFF; 	  
   else if ( Current_State == Rd_Reg && cou == 2 && da_bit_cou== 8'd21 && index_2 == 7 )
      Chip_Revision <= RD_reg_Value; 
   else
      Chip_Revision <= Chip_Revision; 
end


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		SPI_SCLK <=	0;			
	else if (SPI_CSB==0)
		begin
			if(cou==0)
				SPI_SCLK <=	1;
			else  if(cou==2)
				SPI_SCLK <=	0;
			else
				SPI_SCLK <=	SPI_SCLK;
		end
	else 
		SPI_SCLK <=	0;					
end


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
       index_1 <= 6'd0;
    else
        case (Current_State)
            Idle:
                index_1 <= 6'd0;
            Wr_Reg_Loop:
                index_1 <= index_1 + 1;
            default: 
                index_1 <= index_1;	
        endcase
end


always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
       index_2 <= 6'd0;
    else
        case (Current_State)
            Idle:
                index_2 <= 6'd0;
            Rd_Reg_Loop:
                index_2 <= index_2 + 1;
            default: 
                index_2 <= index_2;	
        endcase
end


always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
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


always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      wt_word_end_up<=0;
   else if(cou_3 && da_bit_cou==22)
      wt_word_end_up<=1;
   else  
      wt_word_end_up<=0;
end

always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      Work_Flag <= 0;
   else if( Current_State == Work )
      Work_Flag <= 1;
   else  
      Work_Flag <= Work_Flag;
end


endmodule

