`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/25 17:06:54
// Design Name: 
// Module Name: sine_gen
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

module DDS(
    input wire clk,
    input wire[15:0]  delta_phase,
    output reg[43:0] dout,
	input wire rstn
    );

    reg[15:0] pinc;
    reg[15:0] poff [3:0];
    wire[10:0] dout_dds [3:0];
    reg rstn_reg;
//     wire[15:0]  delta_phase;
//      wire[15:0]  rstn;    
     
//    vio_DDS your_instance_name (
//  .clk(clk),                // input wire clk
//  .probe_out0(delta_phase)
//);
    
    
    genvar ll;
    generate
        for (ll=0; ll<4; ll=ll+1) begin
            always @ (posedge clk)
                poff[ll] <= delta_phase*ll;
        end
    endgenerate
     
    always @ (posedge clk)
        begin
            rstn_reg <= rstn;
            pinc 	<= delta_phase*4;
        end

    genvar kk;
     generate
        for (kk=0; kk<4; kk=kk+1) begin
	 	    dds_compiler_0  inst_dds_compiler_0 (
                .aclk(clk), // input aclk
                .aresetn(rstn_reg), // input aresetn
                .s_axis_config_tvalid(1'b1),                  // input wire s_axis_config_tvalid      
                .s_axis_config_tdata({poff[kk],pinc}),        // input wire [31 : 0] s_axis_config_tdaa
                .m_axis_data_tvalid(),                        // output wire m_axis_data_tvalid       
                .m_axis_data_tdata(dout_dds[kk])// output wire [15 : 0] m_axis_data_tdata
            );
          end 
    endgenerate  

    genvar ii;
    generate
        for (ii=0; ii<4; ii=ii+1) begin
            always @ (posedge clk) begin
                dout[11*ii+10:11*ii]={~dout_dds[ii][10],dout_dds[ii][9:0]}; 
            end
            end
    endgenerate
           
endmodule	

