`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/18 09:43:42
// Design Name: 
// Module Name: SW_DSA_TOP
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

module SW_TOP(
	input			         Clk,
	input		             Reset,
    input [7:0]              Work_mode,
    
//    output reg [31:0]     Freq_set,
    output reg   [7:0]      Freq_set,

// 增益控制
    output reg [1:0]        PA_U38,
    output reg	[1:0]        PA_U44,
    output reg	[1:0]        PA_U55,    
    output reg	[1:0]        PA_U67,    
    output reg	[1:0]        PA_U82, 
    output reg	[1:0]        PA_U89, 

// 衰减控制
	output reg [7:0]		 ALT_RRF_Gain_U37,
	output reg [7:0]		 ALT_TIF_Gain_U81,
	output reg [7:0]		 ALT_RIF_Gain_U43,
	
//延时控制
    output reg [2:0]        ARW3433_SW_U77,
    output reg              ARW3271_SW_U76,
    
    output reg              ARW3271_SW_U74,  
    output reg              ARW3271_SW_U73,
    
    output reg              ARW3271_SW_U71, 
    output reg              ARW3271_SW_U70,
    
    output reg              ARW3271_SW_U66, 
    output reg              ARW3271_SW_U65,
    
    output reg              ARW3271_SW_U60,
    output reg              ARW3271_SW_U59,
    
    output reg               ARW3271_SW_U54,
    output reg               ARW3271_SW_U53,
    
    output reg               ARW3271_SW_U48,
    output reg [2:0]         ARW3433_SW_U47,
    
    output reg [2:0]         ARW3433_SW_U39,
    output reg               ARW3271_SW_U46,
    
    output reg [2:0]         ARW3433_SW_U90,
    output reg               ARW3271_SW_U86,
    
    output reg               ARW3271_SW_U40,
    output reg               ARW3271_SW_U85
    
//    output reg               X122A_SW_U35,
//    output reg                X122A_SW_U34  
    );

reg    [31:0]  DlyBlock_SW;

reg    [31:0]  DlyBlock_SW_src;

reg    [7:0]   ALT_RRF_Gain_U37_src ;
reg    [7:0]   ALT_TIF_Gain_U81_src ;
reg    [7:0]   ALT_RIF_Gain_U43_src ;

reg        PA_U38_src;
reg        PA_U44_src;
reg        PA_U55_src;
reg        PA_U67_src;
reg        PA_U82_src;
reg        PA_U89_src;



//////////////测试控制////////////

wire            SW_SW_VIO;
wire            SW_PA_DSA_VIO;
wire [31:0]     DlyBlock_SW_VIO;
//wire [20:0]     ARW_VIO;
//wire [11:0]     DSA_VIO;
//PA
wire            PA_U38_VIO;
wire            PA_U44_VIO;
wire            PA_U55_VIO;
wire            PA_U67_VIO;
wire            PA_U82_VIO;
wire            PA_U89_VIO;
//DSA
wire [7:0]      DSA_U37_VIO;
wire [7:0]      DSA_U81_VIO;
wire [7:0]      DSA_U43_VIO;

//vio_0 VIO_SW_DSA (
//  .clk(Clk),                // input wire clk
//  .probe_in0(DlyBlock_SW),    // input wire [31 : 0] probe_in0
//  .probe_out0(SW_VIO),  // output wire [0 : 0] probe_out0
//  .probe_out1(DlyBlock_SW_VIO),  // output wire [31 : 0] probe_out1
//  .probe_out2(ARW_VIO),  // output wire [20 : 0] probe_out
//  .probe_out3(DSA_VIO),  // output wire [5 : 0] probe_out3
//  .probe_out4(),  // output wire [5 : 0] probe_out3 
//  .probe_out5(SW_VIO1)  // output wire [5 : 0] probe_out3 
//);

vio_0 VIO_SW_DSA (
  .clk(Clk),                  // input wire clk
  .probe_out0(DlyBlock_SW_VIO),    // output wire [31 : 0] probe_out0
  .probe_out1(DSA_U37_VIO),    // output wire [7 : 0] probe_out1
  .probe_out2(DSA_U81_VIO),    // output wire [7 : 0] probe_out2
  .probe_out3(DSA_U43_VIO),    // output wire [7 : 0] probe_out3
  .probe_out4(SW_SW_VIO),    // output wire [0 : 0] probe_out4
  .probe_out5(SW_PA_DSA_VIO),    // output wire [0 : 0] probe_out5
  .probe_out6(PA_U38_VIO),    // output wire [0 : 0] probe_out6
  .probe_out7(PA_U44_VIO),    // output wire [0 : 0] probe_out7
  .probe_out8(PA_U55_VIO),    // output wire [0 : 0] probe_out8
  .probe_out9(PA_U67_VIO),    // output wire [0 : 0] probe_out9
  .probe_out10(PA_U82_VIO),  // output wire [0 : 0] probe_out10
  .probe_out11(PA_U89_VIO),  // output wire [0 : 0] probe_out11
  .probe_out12()  // output wire [0 : 0] probe_out12
);






always@(posedge Clk or negedge Reset)   
begin 
    if(!Reset)begin
      ARW3433_SW_U77<=3'D0;
      ARW3271_SW_U76<=1'D0;
     
      ARW3271_SW_U74<=1'D0;
      ARW3271_SW_U73<=1'D0;
     
      ARW3271_SW_U71<=1'D0;
      ARW3271_SW_U70<=1'D0;
     
      ARW3271_SW_U66<=1'D0;
      ARW3271_SW_U65<=1'D0;
     
      ARW3271_SW_U60<=1'D0;
      ARW3271_SW_U59<=1'D0;
     
      ARW3271_SW_U54<=1'D0;
      ARW3271_SW_U53<=1'D0;
     
      ARW3271_SW_U48<=1'D0;
      ARW3433_SW_U47<=3'D1;
     
      ARW3433_SW_U39<=3'D0;
      ARW3271_SW_U46<=1'D0;
     
      ARW3433_SW_U90<=3'D0;
      ARW3271_SW_U86<=1'D0;
     
      ARW3271_SW_U40<=1'D0;
      ARW3271_SW_U85<=1'D0;

         
       end
    else if(SW_SW_VIO)
       begin
         ARW3433_SW_U77<=DlyBlock_SW_VIO[2:0];
         ARW3271_SW_U76<=DlyBlock_SW_VIO[3];

         ARW3271_SW_U74<=DlyBlock_SW_VIO[4];
         ARW3271_SW_U73<=DlyBlock_SW_VIO[5]; 

         ARW3271_SW_U71<=DlyBlock_SW_VIO[6]; 
         ARW3271_SW_U70<=DlyBlock_SW_VIO[7]; 

         ARW3271_SW_U66<=DlyBlock_SW_VIO[8]; 
         ARW3271_SW_U65<=DlyBlock_SW_VIO[9]; 

         ARW3271_SW_U60<=DlyBlock_SW_VIO[10]; 
         ARW3271_SW_U59<=DlyBlock_SW_VIO[11]; 

         ARW3271_SW_U54<=DlyBlock_SW_VIO[12]; 
         ARW3271_SW_U53<=DlyBlock_SW_VIO[13]; 

         ARW3271_SW_U48<=DlyBlock_SW_VIO[14]; 
         ARW3433_SW_U47<=DlyBlock_SW_VIO[17:15]; 

         ARW3433_SW_U39<=DlyBlock_SW_VIO[20:18]; 
         ARW3271_SW_U46<=DlyBlock_SW_VIO[21]; 
   
         ARW3433_SW_U90<=DlyBlock_SW_VIO[24:22]; 
         ARW3271_SW_U86<=DlyBlock_SW_VIO[25]; 

         ARW3271_SW_U40<=DlyBlock_SW_VIO[26]; 
         ARW3271_SW_U85<=DlyBlock_SW_VIO[27];
         
//         X122A_SW_U35<=DlyBlock_SW_VIO[28]; 
//         X122A_SW_U34<=DlyBlock_SW_VIO[29];   
                   

       end
    else begin

         ARW3433_SW_U77<=DlyBlock_SW[2:0];
         ARW3271_SW_U76<=DlyBlock_SW[3];

         ARW3271_SW_U74<=DlyBlock_SW[4];
         ARW3271_SW_U73<=DlyBlock_SW[5]; 

         ARW3271_SW_U71<=DlyBlock_SW[6]; 
         ARW3271_SW_U70<=DlyBlock_SW[7]; 

         ARW3271_SW_U66<=DlyBlock_SW[8]; 
         ARW3271_SW_U65<=DlyBlock_SW[9]; 

         ARW3271_SW_U60<=DlyBlock_SW[10]; 
         ARW3271_SW_U59<=DlyBlock_SW[11]; 

         ARW3271_SW_U54<=DlyBlock_SW[12]; 
         ARW3271_SW_U53<=DlyBlock_SW[13]; 

         ARW3271_SW_U48<=DlyBlock_SW[14]; 
         ARW3433_SW_U47<=DlyBlock_SW[17:15]; 

         ARW3433_SW_U39<=DlyBlock_SW[20:18]; 
         ARW3271_SW_U46<=DlyBlock_SW[21]; 
   
         ARW3433_SW_U90<=DlyBlock_SW[24:22]; 
         ARW3271_SW_U86<=DlyBlock_SW[25]; 

         ARW3271_SW_U40<=DlyBlock_SW[26]; 
         ARW3271_SW_U85<=DlyBlock_SW[27]; 
         
//         X122A_SW_U35<=X122A_SW_U35;
//         X122A_SW_U34<=X122A_SW_U34;
       end
end

always@(posedge Clk or negedge Reset)   
begin 
    if(!Reset)begin
      ALT_RRF_Gain_U37 <= 7'd0; 
      ALT_TIF_Gain_U81 <= 7'd0;    
      ALT_RIF_Gain_U43 <= 7'd0;    
                     
      PA_U38     <= 1'b0; 
      PA_U44     <= 1'b1;
      PA_U55     <= 1'b0;
      PA_U67     <= 1'b0;
      PA_U82     <= 1'b0;
      PA_U89     <= 1'b0;

       end
    else if(SW_PA_DSA_VIO)
       begin
      ALT_RRF_Gain_U37     <=      DSA_U37_VIO; 
      ALT_TIF_Gain_U81     <=      DSA_U81_VIO;    
      ALT_RIF_Gain_U43     <=      DSA_U43_VIO;  
                     
      PA_U38     <= {1'B0        ,~PA_U38_VIO}; //10
      PA_U44     <= {~PA_U44_VIO ,~PA_U44_VIO}; //11
      PA_U55     <= {~PA_U55_VIO ,~PA_U55_VIO };
      PA_U67     <= {~PA_U67_VIO ,~PA_U67_VIO }; 
      PA_U82     <= {~PA_U82_VIO ,~PA_U82_VIO }; 
      PA_U89     <= {~PA_U89_VIO ,~PA_U89_VIO };

       end
    else begin
      ALT_RRF_Gain_U37 <=ALT_RRF_Gain_U37_src; 
      ALT_TIF_Gain_U81 <= ALT_TIF_Gain_U81_src;    
      ALT_RIF_Gain_U43 <= ALT_RIF_Gain_U43_src;    
                     
      PA_U38     <= {1'B0        ,~PA_U38_src}; 
      PA_U44     <= {~PA_U44_src ,~PA_U44_src}; 
      PA_U55     <= {~PA_U55_src ,~PA_U55_src };
      PA_U67     <= {~PA_U67_src ,~PA_U67_src }; 
      PA_U82     <= {~PA_U82_src ,~PA_U82_src }; 
      PA_U89     <= {~PA_U89_src ,~PA_U89_src };      
      
       end
end


////////////////////////////////////

always@(posedge Clk or negedge Reset)   
begin 
    if(!Reset)begin
//       Freq_set <= 32'd3750000000;    //  默认  3.75GHz
       Freq_set<= 8'd0;
       end

    else if(Work_mode[6:0] >= 7'd74)
       begin
       Freq_set<= 8'd3;
       end
       
    else begin
       Freq_set<= 8'd2;
       end
       
end

always@(posedge Clk or negedge Reset)
begin
	if(!Reset)  
	   begin 
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
         
       end
    else begin
	   case ( Work_mode[6:0])
          0: //  0ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
            
		     end
          3: //  1ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
                 
		     end             
          6: //  2ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
                 	    
                  end                           
	      8:  //  3ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      11:  //  4ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end             
	      14:  //  5ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end              
	      15:  //  6ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      16:  //  7ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      17,18:  //  8ns，9ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      19:  //  10ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      20:  //  11ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      21:  //  12ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      22:  //  13ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      23:  //  14ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end             
	      24:  //  15ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end    
	      25:  //  16ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      26:  //  17ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end  
	      27:  //  18ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end  
	      28:  //  19ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end  
	      29:  //  20ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end  
	      30:  //  21ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      31:  // 22ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 
	      32:  //  23ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      33:  //  24ns延时通道
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      34:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      34:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      36:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      37: 
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      38:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      39:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      40:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      41:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end
	      33:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end             
 ///////////////////////////////////////            
	      42:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end              
	      43:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end               
	      44:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end           
	      45:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end        
 	      46:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end    
	      47: 
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end  
	      48: 
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 
	      49: 
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 
	      50:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 
	      51:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b1; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 
	      52:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 
	      53:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 
	      54:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 
	      55:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 
	      56:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 
	      57:  
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 
	      58: 
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 
	      59: 
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 
	      60: 
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
                
		     end             
	      61: 
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
                
                
		     end            
	      62: 
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end           
	      63: 
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end          
	      64: 
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end         
	      65: 
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end         
	      66:
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end  
	      67:
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end  
	      68: 
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end  
	      69:
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 
	      70:
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 		     

	      71:
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 	

	      72:
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 	
	      73:
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 	
	      74:
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 		
		     
	      75:
	         begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
		     end 			     
		     
		           
          default:                             //  默认 0ns延时通道
		     begin
           ALT_RRF_Gain_U37_src  <= 8'd0; 
           ALT_TIF_Gain_U81_src  <= 8'd0;    
           ALT_RIF_Gain_U43_src  <= 8'd0;    
                          
           PA_U38_src      <= 1'b0; 
           PA_U44_src      <= 1'b1;
           PA_U55_src      <= 1'b0;
           PA_U67_src      <= 1'b0;
           PA_U82_src      <= 1'b0;
           PA_U89_src      <= 1'b0;
                 
		     end
       endcase   
 end 
end

always@(posedge Clk or negedge Reset)
begin
	if(!Reset) begin
		DlyBlock_SW <= 32'b0010_0000_0000_0100_0000_0000_0000_0000;                // 延时块：延时 0ns
		end
	else begin
		case (Work_mode[6:0])
			 8'd0:  DlyBlock_SW <=  32'b0010_0000_0000_0100_0000_0000_0000_0000;     // 延时块：延时 0ns  
 			 8'd3:  DlyBlock_SW <=  32'b0010_1010_0100_1100_0000_0000_0000_0000;
 			 8'd6:  DlyBlock_SW <=  32'b0010_1000_1000_1100_0000_0000_0000_0000; 			 			 
 			 8'd8:  DlyBlock_SW <=  32'b00100010010000001000000000000000;     // 延时块：延时 1ns 
 			 8'd9:  DlyBlock_SW <=  32'b00100100101011011010010101010011;     // 延时块：延时 1ns 			     
 			 8'd11: DlyBlock_SW <=  32'b00100000100000001000000000000000;
 			 8'd14: DlyBlock_SW <=  32'b00100100101011001000000000000000;
			 8'd15: DlyBlock_SW <=  32'b00100100101011011010010101011010;     // 延时块：延时 2ns
			 8'd16: DlyBlock_SW <=  32'b00100100101011011010010101100011;
			 8'd17: DlyBlock_SW <=  32'b00100100101011011010010101101010;     // 延时块：延时 3ns 
			 8'd18: DlyBlock_SW <=  32'b00100100101011011010010110010011; 
			 8'd19: DlyBlock_SW <=  32'b00100100101011011010010110011010; 
			 8'd20: DlyBlock_SW <=  32'b00100100101011011010010110100011;     // 延时块：延时 4ns
			 8'd21: DlyBlock_SW <=  32'b00100100101011011010010110101010;
			 8'd22: DlyBlock_SW <=  32'b00100100101011011010011001010011;
			 8'd23: DlyBlock_SW <=  32'b00100100101011011010011001011010;     // 延时块：延时 5ns  
		     8'd24: DlyBlock_SW <=  32'b00100100101011011010011001100011;     // 延时块：延时 15ns               
			 8'd25: DlyBlock_SW <=  32'b00100100101011011010011001101010;     // 延时块：延时 16ns 
			 8'd26: DlyBlock_SW <=  32'b00100100101011011010011010010011;     // 延时块：延时 17ns
			 8'd27: DlyBlock_SW <=  32'b00100100101011011010011010011010;     // 延时块：延时 18ns 
		     8'd28: DlyBlock_SW <=  32'b00100100101011011010011010100011;     // 延时块：延时 19ns
			 8'd29: DlyBlock_SW <=  32'b00100100101011011010011010101010;     // 延时块：延时 20ns 
			 8'd30: DlyBlock_SW <=  32'b00100100101011011010100101010011;     // 延时块：延时 21ns      
		     8'd31: DlyBlock_SW <=  32'b00100100101011011010100101011010;     // 延时块：延时 22ns  
			 8'd32: DlyBlock_SW <=  32'b00100100101011011010100101100011;     // 延时块：延时 23ns   
			 8'd33: DlyBlock_SW <=  32'b00100100101011011010100101101010;     // 延时块：延时 24ns 
			 8'd34: DlyBlock_SW <=  32'b00100100101011011010100110010011;     // 延时块：延时 25ns
			 8'd35: DlyBlock_SW <=  32'b00100100101011011010100110011010;     // 延时块：延时 26ns 
			 8'd36: DlyBlock_SW <=  32'b00100100101011011010100110100011;     // 延时块：延时 27ns   
			 8'd37: DlyBlock_SW <=  32'b00100100101011011010100110101010;     // 延时块：延时 28ns  
			 8'd38: DlyBlock_SW <=  32'b00100100101011011010101001010011;     // 延时块：延时 29ns    
			 8'd39: DlyBlock_SW <=  32'b00100100101011011010101001011010;     // 延时块：延时 30ns  
			 8'd40: DlyBlock_SW <=  32'b00100100101011011010101001100011;     // 延时块：延时 31ns   
			 8'd41: DlyBlock_SW <=  32'b00100100101011011010101001101010;     // 延时块：延时 32ns
			 8'd42: DlyBlock_SW <=  32'b00100100101011011010101010010011;     // 延时块：延时 33ns 
			 8'd43: DlyBlock_SW <=  32'b00100100101011011010101010011010;     // 延时块：延时 34ns  
			 8'd44: DlyBlock_SW <=  32'b00100100101011011010101010100011;     // 延时块：延时 35ns               
			 8'd45: DlyBlock_SW <=  32'b00100100101011011010101010101010;     // 延时块：延时 36ns  
			 8'd46: DlyBlock_SW <=  32'b00100100101011010110100101010011;     // 延时块：延时 37ns 
			 8'd47: DlyBlock_SW <=  32'b00100100101011010110100101011010;     // 延时块：延时 38ns  
			 8'd48: DlyBlock_SW <=  32'b00100100101011010110100101100011;     // 延时块：延时 39ns 
			 8'd49: DlyBlock_SW <=  32'b00100100101011010110100101101010;     // 延时块：延时 40ns
			 8'd50: DlyBlock_SW <=  32'b00100100101011010110100110010011;     // 延时块：延时 41ns  
			 8'd51: DlyBlock_SW <=  32'b00100100101011010110100110011010;     // 延时块：延时 42ns
			 8'd52: DlyBlock_SW <=  32'b00100100101011010110100110100011;     // 延时块：延时 43ns 
			 8'd53: DlyBlock_SW <=  32'b00100100101011010110100110101010;     // 延时块：延时 44ns  
			 8'd54: DlyBlock_SW <=  32'b00100100101011010110101001010011;     // 延时块：延时 45ns  
			 8'd55: DlyBlock_SW <=  32'b00100100101011010110101001011010;     // 延时块：延时 46ns   
			 8'd56: DlyBlock_SW <=  32'b00100100101011010110101001100011;     // 延时块：延时 47ns   
			 8'd57: DlyBlock_SW <=  32'b00100100101011010110101001101010;     // 延时块：延时 48ns 
			 8'd58: DlyBlock_SW <=  32'b00100100101011010110101010010011;     // 延时块：延时 49ns
			 8'd59: DlyBlock_SW <=  32'b00100100101011010110101010011010;     // 延时块：延时 50ns
			 8'd60: DlyBlock_SW <=  32'b00100100101011010110101010100011;     // 延时块：延时 51ns   
			 8'd61: DlyBlock_SW <=  32'b00100100101011010110101010101010;     // 延时块：延时 52ns    
			 8'd62: DlyBlock_SW <=  32'b00100100101011010101100110010011;     // 延时块：延时 53ns  
			 8'd63: DlyBlock_SW <=  32'b00100100101011010101100110011010;     // 延时块：延时 54ns 
			 8'd64: DlyBlock_SW <=  32'b00100100101011010101100110100011;     // 延时块：延时 55ns
			 8'd65: DlyBlock_SW <=  32'b00100100101011010101100110101010;     // 延时块：延时 55ns
			 8'd66: DlyBlock_SW <=  32'b00100100101011010101101001010011;     // 延时块：延时 55ns 
			 8'd67: DlyBlock_SW <=  32'b00100100101011010101101001011010;     // 延时块：延时 55ns
			 8'd68: DlyBlock_SW <=  32'b00100100101011010101101001100011;     // 延时块：延时 55ns
			 8'd69: DlyBlock_SW <=  32'b00100100101011010101101001101010;     // 延时块：延时 55ns   
			 8'd70: DlyBlock_SW <=  32'b00100100101011010101101010010011;     // 延时块：延时 55ns 
			 8'd71: DlyBlock_SW <=  32'b00100100101011010101101010011010;     // 延时块：延时 55ns  
			 8'd72: DlyBlock_SW <=  32'b00100100101011010101101010100011;     // 延时块：延时 55ns  		
			 8'd73: DlyBlock_SW <=  32'b00100100101011010101101010101010;     // 延时块：延时 55ns  
			 8'd74: DlyBlock_SW <=  32'b00100010011000000010010101011001;     // 延时块：延时 55ns 
			 8'd75: DlyBlock_SW <=  32'b00100100101011000010010101011001;     // 延时块：延时 55ns  		 

		   default:DlyBlock_SW <=   32'b0010_0000_0000_0100_0000_0000_0000_0000;     // 延时块：延时 0ns 
		endcase 
    end  
end
    
endmodule

