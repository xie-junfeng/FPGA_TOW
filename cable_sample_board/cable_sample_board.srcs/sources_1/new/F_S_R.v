`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/24 19:49:51
// Design Name: 
// Module Name: F_S_W
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


module F_S_R(
    input                      rst_n                    ,   
    input         [9:0]        wr_data_count            ,
    input         [7:0]        rd_data_count            , 
       
    input                      fifo_read_clk            , 
    input                      fifo_read_ready          , 
    output    reg              fifo_read_valid          ,
    output    reg              start         
    );
//localparam
localparam  FREE           =   3'b001; 
localparam  DELY           =   3'b010; 
localparam  FIFO_READ      =   3'b100; 
parameter   DATA_SEND_NUMBER_8    = 15'd976;  

reg      [2:0]       cur_state;
reg      [2:0]       next_state;
reg                  st_done;
reg    [10:0]        cnt;
//
always @(posedge fifo_read_clk or negedge rst_n) begin
    if(!rst_n)
        cur_state <= FREE;
    else
        cur_state <= next_state;
end


always @(*) begin
    next_state = FREE;
    case(cur_state)
        FREE: begin                          
                if(wr_data_count==DATA_SEND_NUMBER_8) begin  
                    next_state = DELY;        
                end 
                else
                    next_state = FREE;
                    end
        DELY: begin
            if(st_done) 
                   next_state = FIFO_READ ;
              else
                   next_state = DELY ;          
        end
        FIFO_READ: begin
            if(st_done) 
                   next_state = FREE;
                else 
                   next_state = FIFO_READ ;
                   end
        default: next_state= FREE;
    endcase
end

always @(posedge fifo_read_clk or negedge rst_n ) begin
    if(!rst_n) begin
        cnt  <= 11'b0;
        st_done<=1'd0;
        fifo_read_valid <= 1'd0 ;  
        start<=1'd0;
    end
    else begin
         start<=1'd0;
        st_done<=1'd0;
        fifo_read_valid <= 1'd0 ;  
        case(next_state)
            FREE: begin 
                    
            end 
			DELY: begin
                if(cnt == 5'd10) begin  // Delayed by 10 beats    
                    cnt    <= 4'd0;
                    st_done<=1'd1 ;
				end
				else if(cnt == 5'd9)begin
				    cnt <= cnt + 4'd1;
				end
				else
					cnt <= cnt + 4'd1;
                end 
			FIFO_READ: begin
			             start<=1'd1;
//			            if(fifo_read_ready) begin
//			                 fifo_read_valid<=1'd1 ;
                        if(rd_data_count==1'd0)begin
                             st_done<=1'd1           ;
                        end
//                        end
                        
                       end 
			default:;
        endcase
    end
end    
endmodule
