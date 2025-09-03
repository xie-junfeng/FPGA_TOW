`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/29 13:00:41
// Design Name: 
// Module Name: ADDA
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
module ADDA(
	input                       clk               ,
    input                       rst_n             ,
    //
	input                        ad_read_ready    ,   
	output          reg          ad_read_valid    ,
    output       reg    [7:0]    ad_read_data     ,		
     //AD0
     output     reg              ad0_write_clk    , 
     input      [9:0]            ad0_write_data   ,   
     output                      ad0_write_oe     ,   
     //AD1
     output     reg               ad1_write_clk   ,  
     input     [9:0]              ad1_write_data  ,   
     output                       ad1_write_oe          
	
);
//localparam
localparam  FREE           =     3'b001       ; 
localparam  DELY           =     3'b010       ; 
localparam  AD_SAMPLE      =     3'b100       ; 

reg    [2:0]         cur_state;
reg    [2:0]         next_state;
reg                  st_done;
reg    [7:0]         cnt;
reg                  cnt1;
reg    [9:0]          cnt3;
assign ad0_write_oe = 1'b0;
assign ad1_write_oe = 1'b0;

 


 always@(posedge clk or negedge rst_n)begin
     if(rst_n == 1'b0)begin
     ad0_write_clk<=1'd0;
     ad1_write_clk<=1'd1; 
    end
    else begin
            ad0_write_clk<=~ad0_write_clk;
            ad1_write_clk<=~ad1_write_clk;
     end
 end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cur_state <= FREE;
    else
        cur_state <= next_state;
end

always @(*) begin
    next_state = FREE;
    case(cur_state)
        FREE: begin                          
                if(ad_read_ready) begin  //如果检测到FIFO将被读空
                    next_state = DELY;        //就进入延时状态
                end 
                else
                    next_state = FREE;
                    end
        DELY: begin
            if(st_done) 
                   next_state = AD_SAMPLE ;
              else
                   next_state = DELY ;          
        end
        AD_SAMPLE: begin
            if(st_done) 
                   next_state = FREE; 
                else 
                   next_state = AD_SAMPLE ;
                   end
        default: next_state= FREE;
    endcase
end

always @(posedge ~clk or negedge rst_n ) begin
    if(!rst_n) begin
        cnt  <= 11'b0;
        cnt1  <= 1'b0;
        st_done<=1'd0;
        ad_read_valid<=1'd0;
        ad_read_data <=  8'b0;
        cnt3<=10'd0;
    end
    else begin
        ad_read_valid<=1'd0;
        ad_read_data <=  8'b0; 
        st_done<=1'd0;
        case(next_state)
            FREE: begin 

            end 
			DELY: begin
                if(cnt == 5'd1) begin  //延时10拍                 
                    cnt    <= 8'd0;
                    st_done<=1'd1 ;
				end
				else
					cnt <= cnt + 4'd1;
                end 
			AD_SAMPLE: begin
			            if(cnt3<10'd960)begin
			               cnt3<=cnt3+1'd1;
			               ad_read_valid<=1'd1;
			               if(cnt1==1'd0)begin
			                     ad_read_data <=ad0_write_data[9:2];
			                     cnt1<= cnt1+1'd1;
			                end
			                else begin
			                     ad_read_data <=ad1_write_data[9:2];
			                     cnt1<= cnt1+1'd1;
			                end
			                end
			             else begin
			                    cnt3<=10'd0;
                                st_done<=1'd1;
                         end
                     end
			default :;
        endcase
    end
end    


endmodule

