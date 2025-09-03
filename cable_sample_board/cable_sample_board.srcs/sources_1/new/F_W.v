`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/20 11:28:19
// Design Name: 
// Module Name: F_W
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
module F_W(
    input                 rst_n                    ,
    //
    input                 rd_rst_busy              ,
    input                 wr_rst_busy              ,
    input       [4:0]     rd_data_count            ,
    input       [4:0]     wr_data_count            ,
    // 

    input                 fifo_write_clk           ,       
    output  reg           fifo_write_ready         ,
    input                 fifo_write_valid         ,   
    input        [31:0]   fifo_write_data          ,
    //
    output   reg         fifo_write_valid_r        ,
    output   reg  [31:0] fifo_write_data_r  
    
    );
 
parameter   DATA_NUMBER_32    = 8'd18       ;    
//localparam
localparam  FREE           =     3'b001       ; 
localparam  DELY           =     3'b010       ; 
localparam  FIFO_WRITE     =     3'b100       ; 
reg    [2:0]         cur_state;
reg    [2:0]         next_state;
reg                  st_done;
reg    [10:0]        cnt;
//
always @(posedge fifo_write_clk or negedge rst_n) begin
    if(!rst_n)
        cur_state <= FREE;
    else
        cur_state <= next_state;
end

always @(*) begin
    next_state = FREE;
    case(cur_state)
        FREE: begin                          
                if(~rd_rst_busy & ~wr_rst_busy & rd_data_count==0) begin  //如果检测到FIFO将被读空
                    next_state = DELY;        //就进入延时状态
                end 
                else
                    next_state = FREE;
                    end
        DELY: begin
            if(st_done) 
                   next_state = FIFO_WRITE ;
              else
                   next_state = DELY ;          
        end
        FIFO_WRITE: begin
            if(st_done) 
                   next_state = FREE; 
                else 
                   next_state = FIFO_WRITE ;
                   end
        default: next_state= FREE;
    endcase
end

always @(posedge fifo_write_clk or negedge rst_n ) begin
    if(!rst_n) begin
        cnt  <= 11'b0;
        st_done<=1'd0;
        fifo_write_ready<=1'd0;
        fifo_write_valid_r <=  1'b0;
        fifo_write_data_r  <=  32'b0; 
    end
    else begin
        
        fifo_write_valid_r <=  1'b0;
        fifo_write_data_r  <=  32'b0;  
        st_done<=1'd0;

        case(next_state)
            FREE: begin 
            fifo_write_ready<=1'd0;
            end 
			DELY: begin
                if(cnt == 5'd10) begin  //延时10拍                 
                    cnt    <= 4'd0;
                    st_done<=1'd1 ;
                    fifo_write_ready<=1'd1;
				end
				else
					cnt <= cnt + 4'd1;
                end 
			FIFO_WRITE: begin
			         fifo_write_ready<=1'd1;
                    if (fifo_write_valid==1'b1)begin
                            fifo_write_valid_r<=  1'b1;
                            fifo_write_data_r <=  fifo_write_data;
                        end
                    if(wr_data_count==DATA_NUMBER_32)begin
                           st_done<=1'd1;
                        end
                    end
                    
			default :;
        endcase
    end
end    

endmodule
