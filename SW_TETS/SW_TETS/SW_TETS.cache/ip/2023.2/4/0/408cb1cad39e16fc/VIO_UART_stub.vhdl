-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
-- Date        : Wed Jun 18 15:13:34 2025
-- Host        : xie running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ VIO_UART_stub.vhdl
-- Design      : VIO_UART
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a200tfbv484-3
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    clk : in STD_LOGIC;
    probe_in0 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_in1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in2 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_in3 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_in4 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe_in5 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in6 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    probe_in7 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in8 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in9 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe_in10 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_in11 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in12 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe_out0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out2 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out3 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out4 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out5 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out6 : out STD_LOGIC_VECTOR ( 31 downto 0 );
    probe_out7 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out8 : out STD_LOGIC_VECTOR ( 1 downto 0 );
    probe_out9 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out10 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    probe_out11 : out STD_LOGIC_VECTOR ( 0 to 0 )
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_in0[7:0],probe_in1[0:0],probe_in2[7:0],probe_in3[7:0],probe_in4[31:0],probe_in5[0:0],probe_in6[1:0],probe_in7[0:0],probe_in8[0:0],probe_in9[31:0],probe_in10[7:0],probe_in11[0:0],probe_in12[31:0],probe_out0[7:0],probe_out1[0:0],probe_out2[7:0],probe_out3[7:0],probe_out4[0:0],probe_out5[0:0],probe_out6[31:0],probe_out7[7:0],probe_out8[1:0],probe_out9[0:0],probe_out10[7:0],probe_out11[0:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2023.2";
begin
end;
