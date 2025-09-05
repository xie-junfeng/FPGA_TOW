// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Wed Jun 18 15:13:41 2025
// Host        : xie running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/xie/Desktop/SW_TETS/SW_TETS/SW_TETS.gen/sources_1/ip/RAM_dual_8096/RAM_dual_8096_sim_netlist.v
// Design      : RAM_dual_8096
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a200tfbv484-3
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "RAM_dual_8096,blk_mem_gen_v8_4_7,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_7,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module RAM_dual_8096
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
  RAM_dual_8096_blk_mem_gen_v8_4_7 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 30352)
`pragma protect data_block
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
5vUjt3eIE9E0zIhdWfBNZSIfStN/Gd9iVz8Cvg==
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
