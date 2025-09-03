`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/25 17:23:56
// Design Name: 
// Module Name: AC
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


module RAC(
     input                     rst_n                    ,     
     input                     clk                      ,

     //input signal    

     output    reg            count_write_ready        ,     
     input        [7:0]        wave_count_write_data    ,
     //
     input                     rom_read_adress_ready    , 
     output     reg            rom_read_adress_valid    , 
     output   reg [13:0]        rom_read_adress        
    );

 parameter  SOURCE_FREQUENCY0 = 8'd1;    
 parameter  SOURCE_FREQUENCY1 = 8'd3;    
 parameter  SOURCE_FREQUENCY2 = 8'd7;    
 parameter  SOURCE_FREQUENCY3 = 8'd15;  
 
 parameter  MOVE              = 8'd63;   
      
 reg    [7:0]         freq_adj    ; 
 reg    [7:0]         freq_cnt    ; 
 reg    [1:0]         freq_select ;
 reg                 start_en;
 wire                 flag;

always @(posedge clk or negedge rst_n) begin
     if(rst_n == 1'b0)begin
              freq_select <= 2'd0;
         end
     else if(wave_count_write_data%50 ==6'd49) begin 
            if(freq_select < 2'd3)
               freq_select <= freq_select+1'd1;
            else  
                freq_select <= 0;
           end
          else 
              freq_select <= freq_select;
 end

 always @(posedge clk or negedge rst_n) begin
     if(rst_n == 1'b0)
       freq_adj <= 8'd0;
     else case(freq_select)
              2'd0:freq_adj <= SOURCE_FREQUENCY0;
              2'd1:freq_adj <= SOURCE_FREQUENCY0;   
              2'd2:freq_adj <= SOURCE_FREQUENCY0;
              2'd3:freq_adj <= SOURCE_FREQUENCY0;
             default:freq_adj <= SOURCE_FREQUENCY0;
          endcase
 end
 
 //频率调节计数器
 always @(posedge clk or negedge rst_n) begin
     if(rst_n == 1'b0)
         freq_cnt <= 8'd0;
     else if(freq_cnt == freq_adj)    
         freq_cnt <= 8'd0;
     else         
         freq_cnt <= freq_cnt + 8'd1;
 end
                                                            
  SEDD U_SEDD (                                                      
     .clk             (clk),
     .rst_n           (rst_n),                                                                     
     .a               (rom_read_adress_ready),
     .flg             (flag)      
);                                                                        
    
  always @(posedge clk or negedge rst_n) begin
     if(rst_n == 1'b0)begin
        rom_read_adress_valid<= 1'd0;
        rom_read_adress <= 14'd0;
        start_en <= 1'd0;
        count_write_ready <= 1'd1;
        end
     else begin
      rom_read_adress_valid<= 1'd0;
      count_write_ready <= 1'd1;
      if( flag) 
         start_en <= 1'd1;
        else         
         start_en <= start_en;
     if( start_en) begin
            count_write_ready <= 1'd0;
        if(freq_cnt == freq_adj)begin
               if(rom_read_adress >= wave_count_write_data*63 && rom_read_adress <= wave_count_write_data*63+62)begin    
                   if(rom_read_adress == (wave_count_write_data*63+62))begin  
                      rom_read_adress_valid<= 1'd1;
                      rom_read_adress <= 14'd0;
                      start_en <= 1'd0;
                      end
                      
                     else 
                       rom_read_adress_valid<= 1'd1;
                       rom_read_adress <= rom_read_adress+9'd1; 
                       end
               else begin
                       rom_read_adress <= wave_count_write_data*63 ; 
              end                        
        end  
       else  
             rom_read_adress <= rom_read_adress;   
      end
      else
      rom_read_adress <= 14'd0;
 end
 end   
    
endmodule
