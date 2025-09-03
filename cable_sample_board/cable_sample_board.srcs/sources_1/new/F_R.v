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
module F_R(
    input                      rst_n                    ,   
    input         [4:0]        wr_data_count            ,
    input         [4:0]        rd_data_count            ,    
    input                      fifo_read_clk            , 
         
    input                      fifo_read_ready          ,       //
    output   reg               fifo_read_valid          ,   
    input     [31:0]            fifo_read_data          ,
    
    output   reg               fifo_read_valid_r          ,     
    output  reg    [31:0]      fifo_read_data_r        
    );
//localparam
localparam  FREE           =   3'b001; 
localparam  DELY           =   3'b010; 
localparam  FIFO_READ      =   3'b100; 
parameter  DATA_NUMBER_32= 8'd18;     
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
                if(wr_data_count==DATA_NUMBER_32 && fifo_read_ready) begin  
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
        fifo_read_valid <=  1'b0 ;
        fifo_read_valid_r <=  1'b0;   
        fifo_read_data_r  <=  32'b0;   
    end
    else begin
        st_done<=1'd0;
        fifo_read_valid   <=  1'b0 ;
        fifo_read_valid_r <=  1'b0;   
        fifo_read_data_r  <=  32'b0;   
        case(next_state)
            FREE: begin 
            
            end 
			DELY: begin
                if(cnt == 5'd10) begin  // Delayed by 10 beats      
                    cnt    <= 4'd0;
                    st_done<=1'd1 ;
                    fifo_read_valid  <=  1'b1 ;
				end
				else if(cnt == 5'd9)begin
				    cnt <= cnt + 4'd1;
				     fifo_read_valid  <=  1'b1 ;   // fifo_read_valid singnal adjustment for make the data have zhe same steap with it . if you want adjust zhe  valid and data for synchronous,please take it.
				end
				else
					cnt <= cnt + 4'd1;
                end 
			FIFO_READ: begin
                        fifo_read_valid  <=  1'b1 ;
                        fifo_read_valid_r<=  1'b1 ;
                        fifo_read_data_r <=  fifo_read_data;
                        if(rd_data_count==1'd1)begin
                           st_done<=1'd1           ;
                        end
                  end 
			default:;
        endcase
    end
end    
endmodule

