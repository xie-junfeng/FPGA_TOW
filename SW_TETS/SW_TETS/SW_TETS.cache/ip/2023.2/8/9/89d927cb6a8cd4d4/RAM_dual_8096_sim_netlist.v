// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Wed Jun 18 15:13:40 2025
// Host        : xie running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ RAM_dual_8096_sim_netlist.v
// Design      : RAM_dual_8096
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbv484-3
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "RAM_dual_8096,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    ena,
    wea,
    addra,
    dina,
    clkb,
    enb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [10:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [11:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [10:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [11:0]doutb;

  wire [10:0]addra;
  wire [10:0]addrb;
  wire clka;
  wire [11:0]dina;
  wire [11:0]doutb;
  wire ena;
  wire enb;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [11:0]NLW_U0_douta_UNCONNECTED;
  wire [10:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [10:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "11" *) 
  (* C_ADDRB_WIDTH = "11" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "1" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     4.7873 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "1" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "RAM_dual_8096.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "2048" *) 
  (* C_READ_DEPTH_B = "2048" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "12" *) 
  (* C_READ_WIDTH_B = "12" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "2048" *) 
  (* C_WRITE_DEPTH_B = "2048" *) 
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "READ_FIRST" *) 
  (* C_WRITE_WIDTH_A = "12" *) 
  (* C_WRITE_WIDTH_B = "12" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_7 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[11:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[10:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[10:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[11:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2023.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jLV29U0rrfMIZhYJzdoUrPoqB9eHQ5NXmWyCdqnN3Wgm+GU4C3zthrN1m4QGiaj0thPCIynZbX+0
7yjtkv+T5ByJ6NhiofAwWseGLvPXlYu6ERAPvi4SAYpF2VUqQHtPAbPmnPubGdDRgIEpeobF7hsz
rEcpEru1pyiScUriyuo=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
vsoizVrOONWw/DhjRLEYrtRmtji+Ok63CbpSg/l9VnoKAi8tAzqRbQ57atGB2N6IGGbKHkbK2Uzh
EHgWvYZeyt4hE+bpQX91vc9PNxfjQMGzPoFD3jCWk30EmEk+AND39eWx+DhJ8xhFuucoOQ2GwyAk
B+Mjs15naPE7DvlHel8hnD4dfSdYhGKp96oozu8JeBto8aHG6poOuYkxSwaut7NCI+mabCkMxtMp
RrydgmRuTvhRTbJMyx5CxFSZTRDrS5aU1vaRlnMiqKCI7g2KY9pemYaJsFeVodBuo6IyKGynyEhs
wr+VtUhQDtaVhMkwB95WwmMoDk9F2L5Au1I+TQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
W081dPMCWhKs5YlQD7n3zvf7+PTcnb8eFWxoVs8+zHLkxDMA1klITbsfztGYvJFce8Yao5XQLLqZ
oUE5Pq2arq+zwICFUcLjdMsmP1WmL82znHOPHm83zNwrxWMloHkySAqzFbgJeHa973uZqj0M8ydc
sYmzCYVlGVjt0QX0xqA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Zpc3MmdLWaVOv+S4z2POuoyslYoAbWc+Npxq2UyQRtDwf566IId3uwAetolMAgfLo/G3ezuSOXMn
8NznS37h9XvmVrxA50SAux68P87WgkLtiUYqM3CMBKkxNlZ/TR8WzTuQyFdvzkOE9lp8HC7LXnk5
RDsnOM+su46FW7ysY01COslo9Xc7rhs6WFqx29+Xcqk8+ZMLSzaJfuwZdNmJFS3Q1vhlq3ZeYqMl
wMieB731KsPxjxp7VKNHpTbgFryC2isqc4ohBDOt52M/Bz4B/rIpFeHfZ7X3jWSiKtSuBsDN2NXf
EMjfAT248dlK7NxJ+NBNPhS5sLxTiGyQhta57A==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rPMYqnkKhJKV1wltOfDrKos9ZbucaoX3WGTuqsdLkGpcKObzslHBwlGrKtWV7bZYmS2SM+QuEMfa
CE+tCUdsSiprp+n5BuSQlJa6BJ8mlqccjoo/JLw2QEmUhyMXQ3TLGomGGoZdeTmMPXhUBAOyLPea
Ddc8mgtTN8Kpy117GOTXDKP+IKJqW01fLrPJpgEhFiJCbyElLgtCRWmI94gX+y4XNVS0Cd1YwNw6
4nHgnEdC7fXARDKcYO3VsWC/pdzPQgursXloNLrVYa6i2xr+8E1V0+nSWwNYQZP7XUIVqXKMU8Ea
bT4acXrRCF/5tJJ5B9JparYI0zxXSbaakn1dIw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2022_10", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mfroTgL8g2pyIXQ/mGO9YHm19cd5mOlJ++qpusOYeVxGmkIhvF4aKx+AyIUz2yGGAeCtOzIasHty
pyqKgZhibSqxcpHgR0m6GOxXXOXJiHaK8NzxUzXeRJovcBI/WjtDhXeb1LRMI1J97jVBtJPJQH0Y
fGOD7jWvkvQwxnrZdyLp6kPWgSIcavHHDbO7iJv4gnyGp6W3/FCDo2RKWNLoW+SNjSdLZ6YRP8a+
ldaGU8TYvJ03KWlmik7repuN6AwxCjg2KeQ+x1sBAEXzROXomuSbvX3ZAo8UiIKAQY1SJumHLG3L
QI/S4Wbl1Hz6LDTsttMwP480gq6+tb6s1E4oWw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QJIabgm8dx/gVHbOQFwt8maOKVHFgkpZTPR6dzD8fqoGo9M9oGPTqBqchtPZWgv2UYFF2KEUSlV4
L3SDXBKrLs+NsAVTcICaEMiEi6j82zj/C1LsPkQfS8RLrg0ab8lbDMb5YqJ7lkHs3iM65x2iN1Mf
66cTgCbkAdl3rDpab75btpTQt5ZKiq5CSY3RZfyIW0uWbTGTELm6liuRKM9+K8BQwTU7A+FFFQBA
/9eJwQYzNNA/iwoYJ2WTPd6pBlzXriNLu9M+/2bYicNBSuH1PBR9v2ESrTB6k7EiV1zvBXV9NuG/
sFt4MumWMuSNwP2W38bQATxxW/l0IrmaXGOC/w==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
lhKf/Vgj6pHpme1ji4HVe36BU8pMkam/2I9lFeyOiBnIbzgdEGfLJBcEvkL33A7s0hxa6LFbHnkT
upgMpPjmIghBz3xUQ13vpiY152thFec6qvlcdg1r+GTmnBOSFl6g/OfZ3eFUhfsve6ZjQHpXnKFo
a55hN2+eP1EG9+VxGeM7XkHaeFhEIry52qtnmg072KEFIwRiGs2d/TJ4AqupuIdIiP1kTN9k+oqa
2ta1vdtqPY0dDHqrf+5YSd0CejkhQeCqg/bauLP3755SwdOPRgooG5ANT8hUpTiFMFXtU+GC9NSp
evJtMHUy1NbgMmhFHO+w3URLEdjSaBxZPD7YLdWkF65jY526tJzoek+BzEKoBaGfCaY7O1nHKXm+
89k3rPUy0Xo4/0nHpno+N/Db09heJPbnGsCwN/l+KnR6Lz8kvWziBjZe0ijOkKI+T12y3T1VeOtY
H/aqtNlQt1mhFwrbw6ezaAiDPVbCQXnly6b4tbb8+nFsxWOGIGAfLozB

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PNsQ8uEcQYrl+GaDuBaq1tQ5br5aAdaqHnyrc0NVu/JnQUk53jaiLx8Oz5fNACvWelUUk2/C+P5I
b2rbU1bb/dC6TqC5J1N0yoMYRYw58u4Lrl8Kgqgt9Rlph5Qgzzfxp+oblXF/pO4mRyAXpZhpNkFT
0Ar9BUtPOTOtJ9/g53SRnZ6GjxzfeD+25J4fcXBNo2gCTgUkwiLSsJRwTB/cJmn+dZPwPdIOHEP9
TkfDK+OrbLYO3T+DFBTCMRNH2NB1J9sc5s+nPU8iYnjgPTo6HoGW+LIlCz6yNJMZzJzoeW708utc
0fJXkT7vLDVh7olvy3V9AAY8Do0YR1kiZlhVhQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zAz8RnGHFebkJFAS+gjC+mXHW7m7We+JgSmIz15mS01u/4+9Ng0sJfkeXOClmVPTQ2Mp2Yuv6/6f
ehzUTcANilWsqLM6Q1FToCPNX/NTqodlcHirGM7b5R9yevouNT/aqH12nmbunBQmBHmehNutdCjG
r6Z7kZgeZ2ZE7MMOF0rTy1XHEPkqgMNTRoS8R/pPWPTW4/j+bn3aJj0Q/fTz4Gi3mbSUKWs2fREQ
UKiuolNJkN6DiDvhlVYHUyytXNJG44ikmBXehoQQRLapkYaxnQmMRT1ok9uY6pKoy71CtvJ3Mt2x
EQv1GU2i4qQyAOwa0mkEohWXduicU6tDz3zQwQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TK3eE9V+v1z2P1KjG4GrjhA1n3qDOpNzLGXdtjnjhF0QBFPSuhC+nmNqTPOb3p2a9r5KD0miY3Cd
+KpjH6Ao09E2/LD2Go4aLQh6vP+9BldlSKEwCGfx2NjBQrXWVH21lQR7IRjOvyTOclpd7SgtUJLw
dvebETyLiKr9C6RfnIBeptuCA3iJlXfwkh6I0JfzD5WBizQkotioZmmrXv5105pCXQ4Ta1WThFsA
2ll9dZeSjEDHUxxhfyfjryv9m4VL89ZDU/rGITsdptwB1BC1jLqmPDymY05lyECnjA6NIR5GGfI4
K2y2f4GfikKoN5r9IOvFzw963Wm82ZZPtXOKGg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 30368)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
