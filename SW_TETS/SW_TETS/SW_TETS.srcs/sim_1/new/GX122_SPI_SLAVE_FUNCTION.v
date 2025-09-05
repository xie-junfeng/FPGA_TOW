`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/12 15:36:03
// Design Name: 
// Module Name: GX122_SPI_SLAVE_FUNCTION
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


module GX122_SPI_SLAVE_FUNCTION
#(
parameter DATA_WITH = 32
)
(
    input  wire                           fpga_sys_clk_i                  ,
    input  wire                           fpga_sys_rst_i                  ,
    
    output reg    [(DATA_WITH-1):0]       data_tx_o                         ,
    input  wire   [(DATA_WITH-1):0]       data_rx_i                         ,    
   
    output reg                             tx_en_o=1'd0                           ,
    input  wire                            rx_en_i                           
    );
    
    reg tx_en_o_reg0;
    reg tx_en_o_reg1;
    reg tx_en_o_reg2;
    reg [12:0] Arm_addr;
    reg        RW_ind=1'd0;	   
   
    
always@(posedge fpga_sys_clk_i or negedge fpga_sys_rst_i)begin
	if(!fpga_sys_rst_i)	begin
			tx_en_o_reg0 <= 1'd0;
			tx_en_o_reg1 <= 1'd0;
			tx_en_o_reg2 <= 1'd0;
	end
	else	begin
        tx_en_o_reg0 <= rx_en_i;
        tx_en_o_reg1 <= tx_en_o_reg0 ;//& ~RW_ind
        tx_en_o_reg2 <= tx_en_o_reg1;
        tx_en_o      <= tx_en_o_reg2;
	end
end

reg [(DATA_WITH-1):0] data_down0;
reg [(DATA_WITH-1):0] data_down1;
reg [(DATA_WITH-1):0] data_down2;
reg [(DATA_WITH-1):0] data_down3;
reg [(DATA_WITH-1):0] data_down4;
reg [(DATA_WITH-1):0] data_down5;
reg [(DATA_WITH-1):0] data_down6;
reg [(DATA_WITH-1):0] data_down7;
reg [(DATA_WITH-1):0] data_down8;
reg [(DATA_WITH-1):0] data_down9;
reg [(DATA_WITH-1):0] data_down10;

always @ ( posedge fpga_sys_clk_i )
begin
    if( rx_en_i )
        begin
                Arm_addr <= data_rx_i[2:0];
                RW_ind   <= data_rx_i[(DATA_WITH-1)];            		
        end
    else
        ;
end

 always@(posedge fpga_sys_clk_i or posedge fpga_sys_rst_i )
    begin
    
	if ( !fpga_sys_rst_i ) begin
		  data_tx_o <= 32'd0;
		  Arm_addr<= 3'd0;
		  
          data_down0 <= 32'd0; 
          data_down1 <= 32'd0; 
          data_down2 <= 32'd0;	
          data_down3 <= 32'd0;	
          data_down4 <= 32'd0; 
          data_down5 <= 32'd0; 
          data_down6 <= 32'd0; 
		  
		end

	else begin
//	data_tx_o <= 32'd2;
	
	   if(1'd1 ) begin
		case (1'd0 )
			3'd0 : data_tx_o <= 32'd16384;                     
			3'd1 : data_tx_o <= 32'd2;  
			3'd2 : data_tx_o <= 32'd3; 		
			3'd3 : data_tx_o <= 32'd4;		
			3'd4 : data_tx_o <= 32'd5;
			3'd5 : data_tx_o <= 32'd6;
			3'd6 : data_tx_o <= 32'd7;
			default: data_tx_o <= 32'd0;
		endcase
		end
		  else if(RW_ind ) begin
		   case ( Arm_addr)
			3'd0 : data_down0 <= data_rx_i;                    
			3'd1 : data_down1 <= data_rx_i; 
			3'd2 : data_down2 <= data_rx_i;		
			3'd3 : data_down3 <= data_rx_i;	
			3'd4 : data_down4 <= data_rx_i;
			3'd5 : data_down5 <= data_rx_i;
			3'd6 : data_down6 <= data_rx_i;
			default: ;
		endcase    
		  end
		  
		end
end

endmodule
