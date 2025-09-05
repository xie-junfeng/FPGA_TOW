`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/27 14:53:59
// Design Name: 
// Module Name: TB_PID_CTL
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

module TB_PID_CTL( );
    
    //Ports
    reg                         clk     ;
    reg                         rstn    ;
    reg   signed  [31:0]        sig_in  ;
    reg   signed  [31:0]        target  ;
    reg   signed  [7:0]         kp      ;
    reg   signed  [7:0]         ki      ;
    reg   signed  [7:0]         kd      ;
    wire  signed  [63:0]        ctrl_out;
 
    integer i;
    reg [31:0]  txt_in       [0:500-1]  ;
    reg [31:0]  txt_target   [0:500-1]  ;
    reg [7:0]   count                   ;
    reg [15:0]  file                    ;
    initial begin
        $readmemh("C:/Users/xie/Desktop/SW_TETS/DATA/TB_PID/sig_in.txt", txt_in);      // ��ȡ�����ź�sig_in
        $readmemh("C:/Users/xie/Desktop/SW_TETS/DATA/TB_PID/target.txt", txt_target);  // ��ȡ�����ź�target
        file = $fopen("C:/Users/xie/Desktop/SW_TETS/DATA/TB_PID/ctrl_out.txt","w");    // �������ļ����ڱ������ctrl_out
    end
    initial begin   
        // ����PIDϵ������ֵ�����治ͬ��ԭ����� 3.3
        kp      =   8'd10   ;
        ki      =   8'd10  ;
        kd      =   8'd3    ;
        //����ʱ�Ӽ���λ
        clk     =   1'b0    ;
        rstn    =   1'b1    ;
        # 5;
        rstn    =   1'b0    ;
        # 5;
        rstn    =   1'b1    ;
        // ���ζ�ȡ��������
        for (i = 0;i <= 500; i = i + 1) begin
            sig_in = txt_in[i]      ;
            target = txt_target[i]  ;
            #10;
        end
    end
    pid_controller pid_controller_inst (
                       .clk         (clk)       ,
                       .rstn        (rstn)      ,
                       .sig_in      (sig_in)    ,
                       .target      (target)    ,
                       .kp          (kp)        ,
                       .ki          (ki)        ,
                       .kd          (kd)        ,
                       .ctrl_out    (ctrl_out)
                   );
    always #5  clk = ~clk ;
    // ��ctrl_out���浽txt�ļ�
    always @(posedge clk) begin
        if (count < 10'd500) begin
            $fwrite(file,"%d\n", ctrl_out);
            count <= count + 1;
        end
        else begin
            count <= 8'd0;
            $fclose(file);   // �ر��ļ���д
        end
    end
   
    
endmodule
