`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/01 13:50:05
// Design Name: 
// Module Name: PARAMETER_PASS
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

module PARAMETER_PASS(
input                sys_clk_100mhz            ,
input                sys_rst                   ,


input                data_AD_B_clk            ,
input                data_DA_clk              ,
input                PLL_Locked               ,

//ÑÓÊ±¿Ø
input                DA_Work_Flag,
output  reg          DA_Work_Flag_reg1,

//input                FFT_En,
//output  reg          FFT_En_reg1,

input    [31:0]      ALT_Value,

output reg [1:0]	ALT_Value_tmp_o,
output reg [13:0]	Dpram1_rd_base_addr,
output reg [13:0]	Dpram2_rd_base_addr,
output reg [13:0]	Dpram3_rd_base_addr,
output reg [13:0]	Dpram4_rd_base_addr,
output reg          ALT_Value_Change

    );
localparam	DPRAM_WR_BASE_ADDR = 14'h7FFF;
reg [31:0]	ALT_Value_tmp;
reg [31:0]	ALT_Value_tmp1;

reg			ALT_Value_Change_tmp;

//reg [13:0]	Dpram1_rd_base_addr;
//reg [13:0]	Dpram2_rd_base_addr;
//reg [13:0]	Dpram3_rd_base_addr;
//reg [13:0]	Dpram4_rd_base_addr;


reg [13:0]	Dpram1_rd_base_addr_reg0;
reg [13:0]	Dpram2_rd_base_addr_reg0;
reg [13:0]	Dpram3_rd_base_addr_reg0;
reg [13:0]	Dpram4_rd_base_addr_reg0;
 

reg [13:0]	Dpram1_rd_base_addr_reg1;
reg [13:0]	Dpram2_rd_base_addr_reg1;
reg [13:0]	Dpram3_rd_base_addr_reg1;
reg [13:0]	Dpram4_rd_base_addr_reg1;
 
reg			ALT_Value_Change_reg0;
reg			ALT_Value_Change_reg1;
always@( posedge sys_clk_100mhz or negedge sys_rst )
begin
	if(!sys_rst)
		ALT_Value_tmp <= 32'd0;
	else if(ALT_Value < 32'd8)
		ALT_Value_tmp <= 32'd8;
	else if(ALT_Value > 32'd131068)//32767*8
		ALT_Value_tmp <= 32'd131068;
	else
		ALT_Value_tmp <= ALT_Value;
end

 always@( posedge sys_clk_100mhz or negedge sys_rst )
begin
	if(!sys_rst)
		begin
			ALT_Value_tmp1 <= 32'd0;
			ALT_Value_Change_reg0 <= 1'b0;
		end
	else
		begin
			ALT_Value_tmp1 <= ALT_Value_tmp;
			ALT_Value_Change_reg0 <= ALT_Value_Change_tmp;
		end
end   

always@( posedge sys_clk_100mhz or negedge sys_rst )
begin
	if(!sys_rst)
		ALT_Value_Change_tmp <= 1'd0;
	else if(ALT_Value_tmp == ALT_Value_tmp1)
		ALT_Value_Change_tmp <= 1'b0;
//	else if(ALT_Value_tmp[31:1] != ALT_Value_tmp1[31:1])
//		ALT_Value_Change_tmp <= 1'b1;
	else
		ALT_Value_Change_tmp <= 1'd1;
end    


always@( posedge sys_clk_100mhz or negedge sys_rst )
begin
	if(!sys_rst)
		begin
			Dpram1_rd_base_addr_reg0 <= 15'd0;
			Dpram2_rd_base_addr_reg0 <= 15'd0;
			Dpram3_rd_base_addr_reg0 <= 15'd0;
			Dpram4_rd_base_addr_reg0 <= 15'd0;
		end
	else
		case(ALT_Value_tmp[1:0])
			2'd0: begin
					Dpram1_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram2_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram3_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram4_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
				end
			2'd1: begin
					Dpram1_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram2_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram3_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram4_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2] - 15'd1;
				end
			2'd2: begin
					Dpram1_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram2_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram3_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2] - 15'd1;
					Dpram4_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2] - 15'd1;
				end
			2'd3: begin
					Dpram1_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram2_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2] - 15'd1;
					Dpram3_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2] - 15'd1;
					Dpram4_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2] - 15'd1;
				end
			default: begin
					Dpram1_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram2_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram3_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
					Dpram4_rd_base_addr_reg0 <= DPRAM_WR_BASE_ADDR - ALT_Value_tmp[16:2];
				end
		endcase
end
   
 reg DA_Work_Flag_reg0;
// reg DA_Work_Flag_reg1;  
  
  always@( posedge data_DA_clk or negedge PLL_Locked )
begin
	if(!PLL_Locked)
		begin
			ALT_Value_Change       <= 1'd0;
			ALT_Value_Change_reg1     <= 1'd0;	
		end
	else
		begin
			ALT_Value_Change_reg1     <= ALT_Value_Change_reg0;			
			ALT_Value_Change      <= ALT_Value_Change_reg1;
			
		end
end 



  always@( posedge data_DA_clk or negedge PLL_Locked )
begin
	if(!PLL_Locked)
		begin
			DA_Work_Flag_reg0      <= 1'd0;
			DA_Work_Flag_reg1     <= 1'd0;	
		end
	else
		begin
			DA_Work_Flag_reg0     <= DA_Work_Flag;			
			DA_Work_Flag_reg1      <= DA_Work_Flag_reg0;
			
		end
end 


//reg FFT_En_reg0;
//  always@( posedge data_DA_clk or negedge PLL_Locked )
//begin
//	if(!PLL_Locked)
//		begin
//			FFT_En_reg0      <= 1'd0;
//			FFT_En_reg1     <= 1'd0;	
//		end
//	else
//		begin
//			FFT_En_reg0     <= FFT_En;			
//			FFT_En_reg1     <= FFT_En_reg0;
			
//		end
//end 




 always@( posedge data_DA_clk or negedge PLL_Locked )
begin
	if(!PLL_Locked)
		begin
			Dpram1_rd_base_addr      <= 15'd0;
			Dpram2_rd_base_addr      <= 15'd0;
			Dpram3_rd_base_addr      <= 15'd0;
			Dpram4_rd_base_addr      <= 15'd0;

			Dpram1_rd_base_addr_reg1 <= 15'd0;
			Dpram2_rd_base_addr_reg1 <= 15'd0;
			Dpram3_rd_base_addr_reg1 <= 15'd0;
			Dpram4_rd_base_addr_reg1 <= 15'd0;			
			
		end
	else
		begin
		
			Dpram1_rd_base_addr_reg1 <= Dpram1_rd_base_addr_reg0;
			Dpram2_rd_base_addr_reg1 <= Dpram2_rd_base_addr_reg0;
			Dpram3_rd_base_addr_reg1 <= Dpram3_rd_base_addr_reg0;
			Dpram4_rd_base_addr_reg1 <= Dpram4_rd_base_addr_reg0;	
					
            Dpram1_rd_base_addr      <= Dpram1_rd_base_addr_reg1; 
            Dpram2_rd_base_addr      <= Dpram2_rd_base_addr_reg1; 			
            Dpram3_rd_base_addr      <= Dpram3_rd_base_addr_reg1; 
            Dpram4_rd_base_addr      <= Dpram4_rd_base_addr_reg1; 			
			
		end
end  
 
reg [1:0] ALT_Value_tmp_reg0;

 always@( posedge data_AD_B_clk or negedge PLL_Locked )
begin
	if(!PLL_Locked)
		begin
			ALT_Value_tmp_o      <= 1'd0;
			ALT_Value_tmp_reg0      <= 1'd0;
			
		end
	else
		begin
			ALT_Value_tmp_reg0      <= ALT_Value_tmp[1:0];
			ALT_Value_tmp_o      <= ALT_Value_tmp_reg0;
		end
end  
   

endmodule
