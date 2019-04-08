//`define SENSOR_J14

module claire_top(
  OSC_100M,
  OSC_148M5,
  //OSC_148M35,
  CLK_AB17,
  CLK_AA18,
  PLL_CLKOUT3_CMOS,
  //PLL_GXB_REF_CLKP1,
  
  LMK_C0,  
  LMK_C2,  
  LMK_C4,  
  LMK_CLK, 
  LMK_DATA,
  LMK_LE,  
  LMK_CIN, 
  
  SW0,
  SW1,
  SW2,
  SW3,
  
//`ifdef SENSOR_J14
  SENSOR_CLK,
  SENSOR_DATA, 
  SENSOR_LV,   
  SENSOR_FV,   
  SENSOR_SDA,  
  SENSOR_SCL,  
  SENSOR_RSTn, 
  SENSOR_ERR,
//`else
  APT_RSTn, 
  APT_SDA,
  APT_SCL,
  PIX_DATA,
  PIX_CLK,
  PIX_LV,
  PIX_FV,
//`endif

// ddr3 sig
 // DDR3_CLK_P
 // DDR3_CKE
 // DDR3_RESETn
 // DDR3_A
 // DDR3_DQ
 // DDR3_DQS_P
 //
 // DDR3_CSn
 // DDR3_WEn
 // DDR3_RASn
 // DDR3_CASn
 //
 // DDR3_BA0
 // DDR3_BA1
 // DDR3_BA2
 // DDR3_DM
 // DDR3_ODT

  
  
// AD9889B sig
  VIDEO_OUT_SDA,
  VIDEO_OUT_SCL,
  VIDEO_OUT_HDCP_EN,
  VIDEO_OUT_CLK,
  VIDEO_OUT_VS,
  VIDEO_OUT_HS,
  VIDEO_OUT_DE,
  VIDEO_OUT_R,
  VIDEO_OUT_G,
  VIDEO_OUT_B,
  
  LED
  
);
  // OSC
  input   wire         OSC_100M;              // AH4, Not Dedicated Clock Input
  input   wire         OSC_148M5;             // GXB {W8+,W7-}, LVDS?, 
  //input   wire         OSC_148M35;            // GXB {P8+,N7-}, LVDS?,
  input   wire         CLK_AB17;              // AB17 <-- AA18, 1.8
  output  wire         CLK_AA18;              // AA18, 1.8
  input   wire         PLL_CLKOUT3_CMOS;      // P22
  
  //PLL_GXB_REF_CLKN1  PIN_R7
  //input   wire         PLL_GXB_REF_CLKP1;  //PIN_R8
  
  
  // LMK04031
  input   wire         LMK_C0;                // {L15,K15}, LVDS
  input   wire         LMK_C2;                // Y15, LVCMOS3.3
  input   wire         LMK_C4;                // {U23,T24}, LVDS
  output  wire         LMK_CLK;               // AH7, LVCMOS3.3
  output  wire         LMK_DATA;              // T10, LVCMOS3.3
  output  wire         LMK_LE;                // AG7, LVCMOS3.3
  output  wire         LMK_CIN;               // {J7,H7}, LVPECL, PLL1 Refclk Port 0
  // Aptina Sensor                            
//`ifdef SENSOR_J14
  input  wire          SENSOR_CLK;            //  L10
  input  wire  [11:2]  SENSOR_DATA;           // {K12,K10,J12,J10,J9,H9,G8,G7,G6,F6}
  input  wire          SENSOR_LV;             //  K13
  input  wire          SENSOR_FV;             //  L9
  inout  wire          SENSOR_SDA;            //  N11
  inout  wire          SENSOR_SCL;            //  L11 
  output wire          SENSOR_RSTn;           //  N12
  output wire          SENSOR_ERR;            //  P12, Sch Error, Stuck at 0
//`else
  output  wire         APT_RSTn;              // A6, Sensor Reset
  inout   wire         APT_SDA;               // D6, I2C.SDA
  inout   wire         APT_SCL;               // C6, I2C.SCL
  input   wire  [11:2] PIX_DATA;              // {G14,J14,F15,J15,C16,F16,K16,C17,E12,H12}, Pixel Data, Low 2 Bit Truncation
  input   wire         PIX_CLK;               // L14, Pixel Clock //74.25 MHz;
  input   wire         PIX_LV;                // E11, Line Valid
  input   wire         PIX_FV;                // M9, Frame Valid 
//`endif
  // Push Botton
  input   wire         SW0;                   // S3
  input   wire         SW1;                   // S4
  input   wire         SW2;                   // S5
  input   wire         SW3;                   // S6
  // Video In
/* 
  output  wire         VIDEO_IN_CLK;          // H19, ?
  output  wire         VIDEO_IN_HDCP_EN;      // H19, ?
  inout   wire         VIDEO_IN_SDA;          // J29
  inout   wire         VIDEO_IN_SCL;          // J30
  input   wire         VIDEO_IN_FIELD;        // L28
  input   wire         VIDEO_IN_SOG;          // L59
  input   wire         VIDEO_IN_VS;           // H24
  input   wire         VIDEO_IN_HS;           // H25
  input   wire         VIDEO_IN_DE;           // H26
  output  wire  [7:0]  VIDEO_IN_R;            //
  output  wire  [7:0]  VIDEO_IN_G;            //
  output  wire  [7:0]  VIDEO_IN_B;            // 
*/



  // DDR3 signal
  //inout         DDR3_CLK_P  
  //inout         DDR3_CLK_N 
  //output        DDR3_CKE    
  //output        DDR3_RESETn 
  //output [14:0] DDR3_A      
  //inout  [31:0] DDR3_DQ     
  //inout  [3 :0] DDR3_DQS_P  
  //inout  [3 :0] DDR3_DQS_N  
  //output        DDR3_CSn    
  //output        DDR3_WEn    
  //output        DDR3_RASn   
  //output        DDR3_CASn   
  //
  //output [2 :0] DDR3_BA     
  //output [3 :0] DDR3_DM     
  //output        DDR3_ODT    



  // Video Out (HDMI Tx) AD9889B
  
  inout   wire         VIDEO_OUT_SDA;
  inout   wire         VIDEO_OUT_SCL;
  output  wire         VIDEO_OUT_HDCP_EN;
  output  wire         VIDEO_OUT_CLK; 
  output  wire         VIDEO_OUT_VS;
  output  wire         VIDEO_OUT_HS;
  output  wire         VIDEO_OUT_DE;
  output  wire  [7:0]  VIDEO_OUT_R;
  output  wire  [7:0]  VIDEO_OUT_G;
  output  wire  [7:0]  VIDEO_OUT_B;
  output  wire  [7:0]  LED;
  
  
   reg  [3 : 0] rvBuffer = 0     ;
   wire [31: 0] wvQsysPioOut     ;
   wire         wPll_148M5       ;
   wire         wPll_100M        ;
   wire         wPll_74M25       ;
   wire         wPll_2M          ;
   wire         wPll_Rstn        ;
   wire         wGlobleRstn      ;
   
   wire         wHdmi_tx_sda_in  ;
   wire         wHdmi_tx_scl_in  ;
   wire         wHdmi_tx_sda_oe  ;
   wire         wHdmi_tx_scl_oe  ;
           
   wire         wCamera_sda_in   ; 
   wire         wCamera_scl_in   ;
   wire         wCamera_sda_oe   ; 
   wire         wCamera_scl_oe   ;
   
   wire [7 : 0] wvVIDEO_OUT_R    ;
   wire [7 : 0] wvVIDEO_OUT_G    ;
   wire [7 : 0] wvVIDEO_OUT_B    ;

   wire [7 : 0] wvVIDEO_OUT_R_cvo;
   wire [7 : 0] wvVIDEO_OUT_G_cvo;
   wire [7 : 0] wvVIDEO_OUT_B_cvo;
   
   wire         wVIDEO_OUT_VS_cvo;
   wire         wVIDEO_OUT_HS_cvo;
   wire         wVIDEO_OUT_DE_cvo;
   
   wire         wVIDEO_OUT_VS;
   wire         wVIDEO_OUT_HS;
   wire         wVIDEO_OUT_DE;
   
   wire [29: 0] wvDataRGBOut     ;
   wire [15: 0] wvClockCounter   ;
   wire [15: 0] wvLineCounter    ;
   wire         wGo              ;
   reg  [31: 0] rvDebugFVCounter ;
   reg  [3 : 0] rvRstBuf         ;
   wire [9 : 0] wvDataBayerOut   ;
   
   always@( wPll_74M25 )
      rvBuffer[3:0] <={ rvBuffer[2:0] , SW0 }; 
  
  
   pll pll_inst  (
      .refclk                                         ( OSC_148M5                     ), //  refclk.clk
      .rst                                            ( 1'b0                          ), //   reset.reset
      .outclk_0                                       ( wPll_148M5                    ), // outclk0.clk
      .outclk_1                                       ( wPll_100M                     ), // outclk1.clk
      .outclk_2                                       ( wPll_74M25                    ), // outclk2.clk
      .outclk_3                                       ( wPll_2M                       ), // outclk3.clk
      .locked                                         ( wPll_Rstn                     )  //  locked.export
   );                   
                     
   nios jtag_master2IIc (                   
      .clk_clk                                        ( wPll_74M25                    ), //                       clk.clk
      .i2c_camera_i2c_serial_sda_in                   ( wCamera_sda_in                ), //     i2c_camera_i2c_serial.sda_in
      .i2c_camera_i2c_serial_scl_in                   ( wCamera_scl_in                ), //                          .scl_in
      .i2c_camera_i2c_serial_sda_oe                   ( wCamera_sda_oe                ), //                          .sda_oe
      .i2c_camera_i2c_serial_scl_oe                   ( wCamera_scl_oe                ), //                          .scl_oe
      .i2c_hdmi_tx_i2c_serial_sda_in                  ( wHdmi_tx_sda_in               ), //    i2c_hdmi_tx_i2c_serial.sda_in
      .i2c_hdmi_tx_i2c_serial_scl_in                  ( wHdmi_tx_scl_in               ), //                          .scl_in
      .i2c_hdmi_tx_i2c_serial_sda_oe                  ( wHdmi_tx_sda_oe               ), //                          .sda_oe
      .i2c_hdmi_tx_i2c_serial_scl_oe                  ( wHdmi_tx_scl_oe               ), //                          .scl_oe
      .pio_0_external_connection_export               ( wvQsysPioOut                  ), // pio_0_external_connection.export
      .reset_reset_n                                  ( wGlobleRstn                   ), //                     reset.reset_n
   );
   
//   pattern_gen pattern_gen_inst (
//      .clk_clk                                        (   wPll_148M5                  ), //                            clk.clk
//      .reset_reset_n                                  (   wGlobleRstn                 ), //                          reset.reset_n
//      .alt_vip_cl_cvo_0_clocked_video_vid_data        ({         
//                                                          wvVIDEO_OUT_R[7:0] ,       
//                                                          wvVIDEO_OUT_G[7:0] ,       
//                                                          wvVIDEO_OUT_B[7:0]        
//                                                                                     }), // alt_vip_cl_cvo_0_clocked_video.vid_data
//      .alt_vip_cl_cvo_0_clocked_video_underflow       (                               ), //                               .underflow
//      .alt_vip_cl_cvo_0_clocked_video_vid_mode_change (                               ), //                               .vid_mode_change
//      .alt_vip_cl_cvo_0_clocked_video_vid_std         (                               ), //                               .vid_std
//      .alt_vip_cl_cvo_0_clocked_video_vid_datavalid   (   wVIDEO_OUT_DE               ), //                               .vid_datavalid
//      .alt_vip_cl_cvo_0_clocked_video_vid_v_sync      (   wVIDEO_OUT_VS               ), //                               .vid_v_sync
//      .alt_vip_cl_cvo_0_clocked_video_vid_h_sync      (   wVIDEO_OUT_HS               ), //                               .vid_h_sync
//      .alt_vip_cl_cvo_0_clocked_video_vid_f           (                               ), //                               .vid_f
//      .alt_vip_cl_cvo_0_clocked_video_vid_h           (                               ), //                               .vid_h
//      .alt_vip_cl_cvo_0_clocked_video_vid_v           (                               ), //                               .vid_v
//   );

   //----------------------------------------------------------------------------------------------------------
   // AR0134 Frame Line Decode
   //----------------------------------------------------------------------------------------------------------
   
   cmos_decode cmos_decoder_inst(
      .PIX_DATA       ( PIX_DATA              ),
      .MTL_CLK        ( wPll_74M25            ), 
      .PIX_CLK        ( PIX_CLK               ),
      .PIX_LV         ( PIX_LV                ),
      .PIX_FV         ( PIX_FV                ),
      .iFifoReadEn    ( VIDEO_OUT_DE          ),
      .iRstn          ( wGlobleRstn &  ~wvQsysPioOut[9]),
      .ovDataBayerOut ( wvDataBayerOut        ),
      .ovDataRGBOut   ( wvDataRGBOut          ),
      .ovClockCounter ( wvClockCounter        ),
      .ovLineCounter  ( wvLineCounter         ),
      .oGo            ( wGo                   )

   );
   
   //----------------------------------------------------------------------------------------------------------
   // LCD Sync Gen
   //----------------------------------------------------------------------------------------------------------
   MTL_Driver MTL_Driver_inst (
   
      .iClk         ( PIX_CLK                        ) ,
      .iRstn        ( wGlobleRstn & ~wvQsysPioOut[8] ) ,
      .iGo          ( wGo                            ) ,
      .ivControl    ( wvQsysPioOut[7:0]              ) ,
      .ivRGB_Ram    ({
                     wvDataRGBOut[29:22],
                     wvDataRGBOut[19:12],
                     wvDataRGBOut[09:02]           }) ,
                     
      .ovHcounter   ( wvHcounter                     ) ,
      .ovVcounter   ( wvVcounter                     ) ,
      .MTL2_INT     ( MTL2_INT                       ) ,
      .MTL2_I2C_SCL ( MTL2_I2C_SCL                   ) ,
      .MTL2_I2C_SDA ( MTL2_I2C_SDA                   ) ,
      .MTL2_BL_ON_n (                                ) ,
      .MTL2_DCLK    ( MTL2_DCLK                      ) ,
      .MTL2_R       ( wvVIDEO_OUT_R[7:0]             ) ,
      .MTL2_G       ( wvVIDEO_OUT_G[7:0]             ) ,
      .MTL2_B       ( wvVIDEO_OUT_B[7:0]             ) ,
      .MTL2_HSD     ( wVIDEO_OUT_HS                  ) ,
      .MTL2_VSD     ( wVIDEO_OUT_VS                  ) ,
      .MTL2_DISP_EN ( wVIDEO_OUT_DE                  ) 
   
   );

    
   assign wGlobleRstn = wPll_Rstn & (rvBuffer[3:0] == 4'b1111);
   
   assign LED [7:0]        = wvQsysPioOut[7:0] | (&wvDataBayerOut); //| (&wvDataBuffer) | (&wvClockCounter) | (&wvLineCounter) ;
 
   assign wHdmi_tx_scl_in  = VIDEO_OUT_SCL ;
   assign wHdmi_tx_sda_in  = VIDEO_OUT_SDA ;
   assign VIDEO_OUT_SCL    = wHdmi_tx_scl_oe ? 1'b0 : 1'bz ;
   assign VIDEO_OUT_SDA    = wHdmi_tx_sda_oe ? 1'b0 : 1'bz ;
 
   assign wCamera_scl_in   = APT_SCL ;
   assign wCamera_sda_in   = APT_SDA ;
    
    
   assign APT_SCL          = wCamera_scl_oe  ? 1'b0 : 1'bz ;
   assign APT_SDA          = wCamera_sda_oe  ? 1'b0 : 1'bz ;
   assign APT_RSTn         = (!wvQsysPioOut[10]) & wGlobleRstn ;
   
   assign VIDEO_OUT_CLK    = wPll_148M5;//PIX_CLK;
   assign VIDEO_OUT_R[7:0] = wvVIDEO_OUT_R;
   assign VIDEO_OUT_G[7:0] = wvVIDEO_OUT_G;
   assign VIDEO_OUT_B[7:0] = wvVIDEO_OUT_B;
   
   assign VIDEO_OUT_HS     = wVIDEO_OUT_HS;
   assign VIDEO_OUT_VS     = wVIDEO_OUT_VS;
   assign VIDEO_OUT_DE     = wVIDEO_OUT_DE;
   
   
   
endmodule
