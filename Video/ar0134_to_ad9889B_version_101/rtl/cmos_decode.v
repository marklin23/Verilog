//----------------------------------------------------------------------------------------------------------
//*   Date:            
//*   Project:         
//*   Filename:        
//*   Device           
//*   Clock:          74.25Mhz
//*   Author:         Galaxy_Mark
//*   Description:    
//*   Version:        1.0.0 
//----------------------------------------------------------------------------------------------------------
//*   Change History:
//*
//----------------------------------------------------------------------------------------------------------
module cmos_decode#(
   parameter X_LEN       = 722 , 
   parameter Y_LEN       = 1282,
   parameter ColumnValid = 1280, //720P 欄
   parameter RowValid    = 720 , //720P 列
   parameter BUF_NUM     = 10  

)(

   input  wire  [9 : 0] PIX_DATA       ,
   input  wire          PIX_CLK        ,
   input  wire          MTL_CLK        ,
   input  wire          PIX_LV         ,
   input  wire          PIX_FV         ,
   input  wire          iRstn          ,
   input  wire          iFifoReadEn    ,
   output wire  [9 : 0] ovDataBayerOut ,
   output wire  [29: 0] ovDataRGBOut   ,
   output wire  [15: 0] ovClockCounter ,
   output wire  [15: 0] ovLineCounter  ,
   output wire          oGo            

);

//----------------------------------------------------------------------------------------------------------
// Parameter Settings
//----------------------------------------------------------------------------------------------------------

   localparam ST_IDLE     = 0;
   localparam ST_PORT_SEL = 1;
   localparam ST_FIRST    = 2;
   localparam ST_1        = 3; 
   localparam ST_2        = 4;
   localparam ST_3        = 5;
   localparam ST_4        = 6;
   localparam ST_LAST     = 7;
   
   // scfifo parameter     
   parameter DATA_WIDTH                           = 30;
   parameter BE_WIDTH                             = 12;
   parameter BUFFER_SIZE                          = 1650*32; 
   parameter ALMOST_FULL_VALUE                    = 100; // must big than 4
   
   defparam ram_to_cvo_fifo.DEVICE_FAMILY      = "CYCLONE V GX";
   defparam ram_to_cvo_fifo.FIFO_WIDTH         = DATA_WIDTH; 
   defparam ram_to_cvo_fifo.FIFO_SIZE          = BUFFER_SIZE;
   defparam ram_to_cvo_fifo.SHOW_AHEAD         = "ON";
   defparam ram_to_cvo_fifo.ALMOST_FULL_VALUE  = ALMOST_FULL_VALUE;
   
//----------------------------------------------------------------------------------------------------------
// wire reg declaration
//----------------------------------------------------------------------------------------------------------

   //state machine sig
   reg [7:0]      rvBayer2RGBState;
   reg [10*3-1:0] rvDataBuffer0;
   reg [10*3-1:0] rvDataBuffer1;
   reg [10*3-1:0] rvDataBuffer2;
   reg [10*3-1:0] rvDataBuffer3;
   reg            rPIX_LV;
   reg            rPIX_FV; 
   reg [9 : 0]    rvR;
   reg [9 : 0]    rvG;
   reg [9 : 0]    rvB;
   reg            rvOddEvenCnt; // 1: Even, 0: Odd 
   reg            rGo;
   //fifo sig
   reg            rFifoWriteEn;
   wire           wFifo_full;
   wire           wFifo_empty;
   
   //ram sig 
   wire[9 : 0] wvQ [3:0];
   wire[29: 0] wvFifo_out;
   reg [9 : 0] rvBayerData;
   reg [15: 0] rvClockCounter;
   reg [15: 0] rvLineCounter;
   reg [15: 0] rvReadCounter;
   
   //fifo read write sig
   reg [01:0] rvDataBuf ;
   reg [31:0] rvFifoReadCounter ;
   reg [31:0] rvFifoWriteCounter ;
   reg [31:0] rvFifoWriteRisingCounter ;
   reg [31:0] rvFifoReadRisingCounter ;
   reg [31:0] rvPixClkCount ;
   reg [31:0] rvFrameCount ;
   
   
//----------------------------------------------------------------------------------------------------------
// Decode AR0134 data 
//----------------------------------------------------------------------------------------------------------
   always@( posedge PIX_CLK or negedge iRstn ) begin
      if(iRstn == 0) begin
         rvClockCounter    <= 0;
         rvBayerData       <= 0;
      end
      else if(PIX_LV) begin
         rvClockCounter    <= rvClockCounter + 1;
         rvBayerData       <= PIX_DATA;
      end else begin
         rvClockCounter    <= 0;
         rvBayerData       <= 0;
      end
   end

   always@( posedge PIX_CLK ) begin
      rPIX_LV <= PIX_LV;
      rPIX_FV <= PIX_FV;
   end
   
   always@( posedge PIX_CLK or negedge iRstn) begin
      if(iRstn == 0)
         rvLineCounter <= 0;
      else if ( ~rPIX_FV & PIX_FV ) // frame valid risign clear line counter
         rvLineCounter <= 0;
      else if (rPIX_LV & ~PIX_LV)
         rvLineCounter <= rvLineCounter + 1;
   end
//----------------------------------------------------------------------------------------------------------
// Ram Data buffer
//----------------------------------------------------------------------------------------------------------
   true_dual_port_ram_single_clock #(
      .DATA_WIDTH   ( 10                       ),
      .ADDR_WIDTH   ( 12                       ) 
   )ram_inst_dual1  (      
      .data_a       ( PIX_DATA                 ), 
      .data_b       (                          ),
      .addr_a       ( rvClockCounter           ), 
      .addr_b       ( rvReadCounter            ),
      .we_a         ((rvLineCounter%4==0)& rGo ), 
      .we_b         ( 1'b0                     ), 
      .clk          ( PIX_CLK                  ),
      .q_a          (                          ), 
      .q_b          ( wvQ[0]                   ) 
   );
   
   true_dual_port_ram_single_clock #(
      .DATA_WIDTH   ( 10                       ),
      .ADDR_WIDTH   ( 12                       ) 
   )ram_inst_dual2  (      
      .data_a       ( PIX_DATA                 ), 
      .data_b       (                          ),
      .addr_a       ( rvClockCounter           ), 
      .addr_b       ( rvReadCounter            ),
      .we_a         ((rvLineCounter%4==1)& rGo ), 
      .we_b         ( 1'b0                     ), 
      .clk          ( PIX_CLK                  ),
      .q_a          (                          ), 
      .q_b          ( wvQ[1]                   ) 
   );

   true_dual_port_ram_single_clock #(
      .DATA_WIDTH   ( 10                       ),
      .ADDR_WIDTH   ( 12                       ) 
   )ram_inst_dual3  (      
      .data_a       ( PIX_DATA                 ), 
      .data_b       (                          ),
      .addr_a       ( rvClockCounter           ), 
      .addr_b       ( rvReadCounter            ),
      .we_a         ((rvLineCounter%4==2)& rGo ), 
      .we_b         ( 1'b0                     ), 
      .clk          ( PIX_CLK                  ),
      .q_a          (                          ), 
      .q_b          ( wvQ[2]                   ) 
   );

   true_dual_port_ram_single_clock #(
      .DATA_WIDTH   ( 10                       ),
      .ADDR_WIDTH   ( 12                       ) 
   )ram_inst_dual4  (      
      .data_a       ( PIX_DATA                 ), 
      .data_b       (                          ),
      .addr_a       ( rvClockCounter           ), 
      .addr_b       ( rvReadCounter            ),
      .we_a         ((rvLineCounter%4==3)& rGo ), 
      .we_b         ( 1'b0                     ), 
      .clk          ( PIX_CLK                  ),
      .q_a          (                          ), 
      .q_b          ( wvQ[3]                   ) 
   );

//----------------------------------------------------------------------------------------------------------
// Real Time BAYER to RGB Convert
//----------------------------------------------------------------------------------------------------------
   
   
//----------------------------------------------------------------------------------------------------------
// R and B channels interpolation
//----------------------------------------------------------------------------------------------------------
// G R G  G B G  R G R  B G B 
// B G B  R G R  G B G  G R G 
// G R G  G B G  R G R  B G B 
//  (A)    (B)    (C)    (D)  
//----------------------------------------------------------------------------------------------------------
// AR0134: Pixel Color Pattern Detail (Top Right Corner)
//----------------------------------------------------------------------------------------------------------
// rOddEvenCnt -1-0-1-0-1-0- 計算odd 或是 even
//MODE 1 :     -C-A-C-A-C-A- 輸出的 奇列
//MODE 2 :     -B-D-B-D-B-D- 輸出的 偶列
//MODE 1 :     -C-A-C-A-C-A- 輸出的 奇列
//MODE 2 :     -B-D-B-D-B-D- 輸出的 偶列
//----------------------------------------------------------------------------------------------------------
//                         |--> start pattern First Adressable Pixel (0,0)
//   .... R G R G R G R G -|          Physical Location (112, 44)
//   .... G B G B G B G B  
//   .... R G R G R G R G 
//   .... G B G B G B G B
//   .... R G R G R G R G 
//----------------------------------------------------------------------------------------------------------
// ram buffer 
//----------------------------------------------------------------------------------------------------------
//(rvDataBuffer1[19:10]+rvDataBuffer3[19:10]                                        )/2; // 加上下   
//(rvDataBuffer2[29:20]+rvDataBuffer2[9:0]                                          )/2; // 加左右
//(rvDataBuffer2[29:20]+rvDataBuffer2[9:0]+rvDataBuffer1[19:10]+rvDataBuffer3[19:10])/4; // 加上下左右
//(rvDataBuffer3[29:20]+rvDataBuffer3[9:0]+rvDataBuffer1[29:20]+rvDataBuffer1[9:0]  )/4; // 加四個角角
//----------------------------------------------------------------------------------------------------------

   scfifo_wrapper ram_to_cvo_fifo (
      .clk         ( PIX_CLK                              ),
      .reset_n     ( iRstn                                ),
      .write_req   ( rFifoWriteEn & rGo                   ),
      .read_req    ( iFifoReadEn  & rGo                   ),
      .data_in     ({
                     rvR[9:0],    
                     rvG[9:0],  
                     rvB[9:0] 
                                                         }),
      .data_out    ( wvFifo_out                           ),
      .full        ( wFifo_full                           ), // almost full value
      .empty       ( wFifo_empty                          )
   ); 

   always@(posedge PIX_CLK) begin
      if(iRstn == 0) begin
         rvDataBuf[0]  <= 0;
         rvDataBuf[1]  <= 0;
         rvPixClkCount <= 0;
         rvFrameCount  <= 0;
      end else begin
         rvDataBuf[0]  <= iFifoReadEn ;
         rvDataBuf[1]  <= rFifoWriteEn;
         rvPixClkCount <= ( ~rPIX_FV & PIX_FV ) ? 0                : rvPixClkCount +1 ;
         rvFrameCount  <= ( ~rPIX_FV & PIX_FV ) ? rvFrameCount + 1 : rvFrameCount     ;
      end
   end
 
   always@(posedge PIX_CLK)
   
      if(iRstn == 0) begin
      
         rvFifoReadCounter        <= 32'd0;
                                     
         rvFifoWriteCounter       <= 32'd0;
                                     
         rvFifoWriteRisingCounter <= 32'd0;
                                     
         rvFifoReadRisingCounter  <= 32'd0;

      end else if( ~rPIX_FV & PIX_FV )  begin
      
         rvFifoReadCounter        <= 32'd0;
                                     
         rvFifoWriteCounter       <= 32'd0;
                                     
         rvFifoWriteRisingCounter <= 32'd0;
                                     
         rvFifoReadRisingCounter  <= 32'd0;

      end else begin
      
         rvFifoReadCounter        <= (rvFifoReadCounter == ColumnValid*RowValid ) ? 32'b0                        : 
                                     iFifoReadEn                                  ? rvFifoReadCounter        + 1 : rvFifoReadCounter; 
         rvFifoWriteCounter       <= (rvFifoWriteCounter == ColumnValid*RowValid) ? 32'b0                        :
                                     rFifoWriteEn                                 ? rvFifoWriteCounter       + 1 : rvFifoWriteCounter;   
         rvFifoWriteRisingCounter <= (rvFifoWriteRisingCounter == RowValid      ) ? 32'b0                        :
                                     (~rvDataBuf[1] & rFifoWriteEn              ) ? rvFifoWriteRisingCounter + 1 : rvFifoWriteRisingCounter;   
         rvFifoReadRisingCounter  <= (rvFifoReadRisingCounter == RowValid       ) ? 32'b0                        :
                                     (~rvDataBuf[0] & iFifoReadEn               ) ? rvFifoReadRisingCounter  + 1 : rvFifoReadRisingCounter; 
      end

   always@(posedge PIX_CLK or negedge iRstn) begin
      if(iRstn == 0)
         rGo <= 0;
      else
         rGo <= ( ~rPIX_FV & PIX_FV ) ? 1'b1 : rGo;
   end

   always@(posedge PIX_CLK) begin
      if(iRstn == 0) begin
         rvBayer2RGBState <= 0;
         rFifoWriteEn     <= 0;
         rvOddEvenCnt     <= 0;
         rvReadCounter    <= 0;
         rvDataBuffer0    <= 0;
         rvDataBuffer1    <= 0;
         rvDataBuffer2    <= 0;
         rvDataBuffer3    <= 0;
         rvR              <= 0;
         rvG              <= 0;
         rvB              <= 0;
      end 
      else begin
         case(rvBayer2RGBState)
         
            ST_IDLE:  begin
                        rvBayer2RGBState <=  (PIX_FV==0)                                    ? ST_IDLE  :
                                             (rGo==0   )                                    ? ST_IDLE  :
                                             ((rvLineCounter>=3)&&(rvClockCounter>BUF_NUM)) ? ST_FIRST : ST_IDLE;
                        rFifoWriteEn     <= 0;
                        rvOddEvenCnt     <= 0;
                        rvReadCounter    <= 0;
                        rvR              <= 0;
                        rvG              <= 0;
                        rvB              <= 0;
                        rvDataBuffer0    <= 0;
                        rvDataBuffer1    <= 0;
                        rvDataBuffer2    <= 0; 
                        rvDataBuffer3    <= 0;
                      end 
                   
                
                
            ST_FIRST: begin // MODE 1 奇列
                     // Read ram  buffer 3 data bus
                        rvReadCounter <= (rvReadCounter>Y_LEN+1) ? 0 : rvReadCounter + 1;
                        rvDataBuffer0 <= { rvDataBuffer0 [19:0] ,wvQ[0]};
                        rvDataBuffer1 <= { rvDataBuffer1 [19:0] ,wvQ[1]};
                        rvDataBuffer2 <= { rvDataBuffer2 [19:0] ,wvQ[2]};
                        
                     // read 3 data address in ram ready pipeline calculate RGB value by each Mode 
                        if((rvReadCounter>3) &&(rvReadCounter <= 1283) ) begin //total 1280 
                     // Count data is odd or even
                           rvOddEvenCnt   <= rvOddEvenCnt + 1;
                           case(rvOddEvenCnt)
                              0: begin       // CASE A
                                    rvR          <= (rvDataBuffer0[19:10]+rvDataBuffer2[19:10])/2; // 加上下
                                    rvG          <= (rvDataBuffer1[19:10]                     )  ; // 自己中心點
                                    rvB          <= (rvDataBuffer1[29:20]+rvDataBuffer1[9:0]  )/2; // 加左右
                                    rFifoWriteEn <= 1;
                                 end
                              default: begin // CASE C
                                    rvR          <= (rvDataBuffer2[29:20]+rvDataBuffer2[9:0]+rvDataBuffer0[29:20]+rvDataBuffer0[9:0]  )/4;// 加四個角角
                                    rvG          <= (rvDataBuffer1[29:20]+rvDataBuffer1[9:0]+rvDataBuffer0[19:10]+rvDataBuffer2[19:10])/4;// 加上下左右
                                    rvB          <= (rvDataBuffer1[19:10]                                                             )  ;// 自己中心點
                                    rFifoWriteEn <= 1;
                                 end
                           endcase
                        end 
                        else begin
                           rvR          <= rvR;
                           rvG          <= rvG;
                           rvB          <= rvB;
                           rFifoWriteEn <= 0;
                        end 
                     //Jump State
                        rvBayer2RGBState <=(rvReadCounter>Y_LEN+1) ? ST_PORT_SEL: rvBayer2RGBState;
                     
                  end
            ST_PORT_SEL:begin
                         rvReadCounter    <= 0;
                         rFifoWriteEn     <= 0;
                         rvOddEvenCnt     <= 0; 
                         rvDataBuffer0    <= 0;
                         rvDataBuffer1    <= 0;
                         rvDataBuffer2    <= 0;
                         rvDataBuffer3    <= 0;
                         rvR              <= rvR;
                         rvG              <= rvG;
                         rvB              <= rvB;
                         rvBayer2RGBState <= //(PIX_FV == 0                              ) ? ST_IDLE    :
                                             (rvFifoWriteRisingCounter == RowValid-1        ) ? ST_LAST    :  // last lane in one frame
                                             (rvLineCounter<3                               ) ? ST_PORT_SEL: 
                                             ((rvLineCounter%4==0)&&(rvClockCounter>BUF_NUM)) ? ST_1       :             // MODE 2 , RAM 123 , 偶列
                                             ((rvLineCounter%4==1)&&(rvClockCounter>BUF_NUM)) ? ST_2       :             // MODE 1 , RAM 230 , 奇列
                                             ((rvLineCounter%4==2)&&(rvClockCounter>BUF_NUM)) ? ST_3       :             // MODE 2 , RAM 301 , 偶列
                                             ((rvLineCounter%4==3)&&(rvClockCounter>BUF_NUM)) ? ST_4       : ST_PORT_SEL;// MODE 1 , RAM 012 , 奇列
                      end
            ST_1: begin  // MODE 2 , RAM 123 , 偶列
                     // Read ram  buffer 3 data bus
                        rvReadCounter <= (rvReadCounter>Y_LEN+1) ? 0 : rvReadCounter + 1;
                        rvDataBuffer1 <= { rvDataBuffer1 [19:0] ,wvQ[1]};
                        rvDataBuffer2 <= { rvDataBuffer2 [19:0] ,wvQ[2]};
                        rvDataBuffer3 <= { rvDataBuffer3 [19:0] ,wvQ[3]};
                        if((rvReadCounter>2+1) &&(rvReadCounter <= Y_LEN+1) ) begin  //(rvReadCounter+1)%3 ==>  read 3 data address in ram
                     // Count data is odd or even
                           rvOddEvenCnt   <= rvOddEvenCnt + 1;
                           case(rvOddEvenCnt)
                              0: begin       // CASE D
                                    rvR          <= (rvDataBuffer2[19:10]                                                             )  ; // 自己中心點
                                    rvG          <= (rvDataBuffer2[29:20]+rvDataBuffer2[9:0]+rvDataBuffer1[19:10]+rvDataBuffer3[19:10])/4; // 加上下左右
                                    rvB          <= (rvDataBuffer3[29:20]+rvDataBuffer3[9:0]+rvDataBuffer1[29:20]+rvDataBuffer1[9:0]  )/4; // 加四個角角
                                    rFifoWriteEn <= 1;
                                 end
                              default: begin // CASE B
                                    rvR          <= (rvDataBuffer2[29:20]+rvDataBuffer2[9:0]                                          )/2; // 加左右 
                                    rvG          <= (rvDataBuffer2[19:10]                                                             )  ; // 自己中心點
                                    rvB          <= (rvDataBuffer1[19:10]+rvDataBuffer3[19:10]                                        )/2; // 加上下
                                    rFifoWriteEn <= 1;
                                 end
                           endcase
                        end 
                        else begin
                           rvR          <= rvR;
                           rvG          <= rvG;
                           rvB          <= rvB;
                           rFifoWriteEn <= 0;
                        end 
                     //Jump State
                        rvBayer2RGBState <=(rvReadCounter>Y_LEN+1) ? ST_PORT_SEL: rvBayer2RGBState;
                     
                  end
            ST_2: begin // MODE 1 , RAM 230 , 奇列
                     // Read ram  buffer 3 data bus
                        rvReadCounter <= (rvReadCounter>Y_LEN+1) ? 0 : rvReadCounter + 1;
                        rvDataBuffer2 <= { rvDataBuffer2 [19:0] ,wvQ[2]};
                        rvDataBuffer3 <= { rvDataBuffer3 [19:0] ,wvQ[3]};
                        rvDataBuffer0 <= { rvDataBuffer0 [19:0] ,wvQ[0]};
                     // After 3 data bus ready pipeline calculate RGB value by each Mode 
                        if((rvReadCounter>2+1) &&(rvReadCounter <= Y_LEN+1) ) begin //(rvReadCounter+1)%3 ==>  read 3 data address in ram
                     // Count data is odd or even
                           rvOddEvenCnt   <= rvOddEvenCnt + 1;
                           case(rvOddEvenCnt)
                              0: begin       // CASE A
                                    rvR          <= (rvDataBuffer2[19:10]+rvDataBuffer0[19:10])/2; // 加上下
                                    rvG          <= (rvDataBuffer3[19:10]                     )  ; // 自己中心點
                                    rvB          <= (rvDataBuffer3[29:20]+rvDataBuffer3[9:0]  )/2; // 加左右
                                    rFifoWriteEn <= 1;
                                 end
                              default: begin // CASE C
                                    rvR          <= (rvDataBuffer2[29:20]+rvDataBuffer2[9:0]+rvDataBuffer0[29:20]+rvDataBuffer0[9:0]  )/4;// 加四個角角
                                    rvG          <= (rvDataBuffer3[29:20]+rvDataBuffer3[9:0]+rvDataBuffer2[19:10]+rvDataBuffer0[19:10])/4;// 加上下左右
                                    rvB          <= (rvDataBuffer3[19:10]                                                             )  ;// 自己中心點
                                    rFifoWriteEn <= 1;
                                 end
                           endcase
                        end 
                        else begin
                           rvR          <= rvR;
                           rvG          <= rvG;
                           rvB          <= rvB;
                           rFifoWriteEn <= 0;
                        end 
                     //Jump State
                        rvBayer2RGBState <=(rvReadCounter>Y_LEN+1) ? ST_PORT_SEL: rvBayer2RGBState;
                  end
            ST_3:  begin  // MODE 2 , RAM 301 , 偶列
                     // Read ram  buffer 3 data bus
                        rvReadCounter <= (rvReadCounter>Y_LEN+1) ? 0 : rvReadCounter + 1;
                        rvDataBuffer3 <= { rvDataBuffer3 [19:0] ,wvQ[3]};
                        rvDataBuffer0 <= { rvDataBuffer0 [19:0] ,wvQ[0]};
                        rvDataBuffer1 <= { rvDataBuffer1 [19:0] ,wvQ[1]};
                        if((rvReadCounter>2+1) &&(rvReadCounter <= Y_LEN+1) ) begin  //(rvReadCounter+1)%3 ==>  read 3 data address in ram
                     // Count data is odd or even
                           rvOddEvenCnt   <= rvOddEvenCnt + 1;
                           case(rvOddEvenCnt)
                              0: begin       // CASE D
                                    rvR          <= (rvDataBuffer0[19:10]                                                             )  ; // 自己中心點
                                    rvG          <= (rvDataBuffer0[29:20]+rvDataBuffer0[9:0]+rvDataBuffer3[19:10]+rvDataBuffer1[19:10])/4; // 加上下左右
                                    rvB          <= (rvDataBuffer1[29:20]+rvDataBuffer1[9:0]+rvDataBuffer3[29:20]+rvDataBuffer3[9:0]  )/4; // 加四個角角
                                    rFifoWriteEn <= 1;
                                 end
                              default: begin // CASE B
                                    rvR          <= (rvDataBuffer0[29:20]+rvDataBuffer0[9:0]                                          )/2; // 加左右 
                                    rvG          <= (rvDataBuffer0[19:10]                                                             )  ; // 自己中心點
                                    rvB          <= (rvDataBuffer3[19:10]+rvDataBuffer1[19:10]                                        )/2; // 加上下
                                    rFifoWriteEn <= 1;
                                 end
                           endcase
                        end 
                        else begin
                           rvR          <= rvR;
                           rvG          <= rvG;
                           rvB          <= rvB;
                           rFifoWriteEn <= 0;
                        end 
                     //Jump State
                        rvBayer2RGBState <=(rvReadCounter>Y_LEN+1) ? ST_PORT_SEL: rvBayer2RGBState;
                     
                  end
            ST_4: begin // MODE 1 , RAM 012 , 奇列
                     // Read ram  buffer 3 data bus
                        rvReadCounter <= (rvReadCounter>Y_LEN+1) ? 0 : rvReadCounter + 1;
                        rvDataBuffer0 <= { rvDataBuffer0 [19:0] ,wvQ[0]};
                        rvDataBuffer1 <= { rvDataBuffer1 [19:0] ,wvQ[1]};
                        rvDataBuffer2 <= { rvDataBuffer2 [19:0] ,wvQ[2]};
            
                     // After 3 data bus ready pipeline calculate RGB value by each Mode 
                        if((rvReadCounter>2+1) &&(rvReadCounter <= Y_LEN+1) ) begin //(rvReadCounter+1)%3 ==>  read 3 data address in ram
                     // Count data is odd or even
                           rvOddEvenCnt   <= rvOddEvenCnt + 1;
                           case(rvOddEvenCnt)
                              0: begin       // CASE A
                                    rvR          <= (rvDataBuffer0[19:10]+rvDataBuffer2[19:10])/2; // 加上下
                                    rvG          <= (rvDataBuffer1[19:10]                     )  ; // 自己中心點
                                    rvB          <= (rvDataBuffer1[29:20]+rvDataBuffer1[9:0]  )/2; // 加左右
                                    rFifoWriteEn <= 1;
                                 end
                              default: begin // CASE C
                                    rvR          <= (rvDataBuffer2[29:20]+rvDataBuffer2[9:0]+rvDataBuffer0[29:20]+rvDataBuffer0[9:0]  )/4;// 加四個角角
                                    rvG          <= (rvDataBuffer1[29:20]+rvDataBuffer1[9:0]+rvDataBuffer0[19:10]+rvDataBuffer2[19:10])/4;// 加上下左右
                                    rvB          <= (rvDataBuffer1[19:10]                                                             )  ;// 自己中心點
                                    rFifoWriteEn <= 1;
                                 end
                           endcase
                        end 
                        else begin
                           rvR          <= rvR;
                           rvG          <= rvG;
                           rvB          <= rvB;
                           rFifoWriteEn <= 0;
                        end 
                     //Jump State
                        rvBayer2RGBState <= (rvReadCounter>Y_LEN+1) ? ST_PORT_SEL: rvBayer2RGBState;
                  end
                  
            ST_LAST: begin  // MODE 2 , RAM 301 , 偶列
                     // Read ram  buffer 3 data bus
                        rvReadCounter <= (rvReadCounter>Y_LEN+1) ? 0 : rvReadCounter + 1;
                        rvDataBuffer3 <= { rvDataBuffer3 [19:0] ,wvQ[3]};
                        rvDataBuffer0 <= { rvDataBuffer0 [19:0] ,wvQ[0]};
                        rvDataBuffer1 <= { rvDataBuffer1 [19:0] ,wvQ[1]};
                        if((rvReadCounter>2+1) &&(rvReadCounter <= Y_LEN+1) ) begin  //(rvReadCounter+1)%3 ==>  read 3 data address in ram
                     // Count data is odd or even
                           rvOddEvenCnt   <= rvOddEvenCnt + 1;
                           case(rvOddEvenCnt)
                              0: begin       // CASE D
                                    rvR          <= (rvDataBuffer0[19:10]                                                             )  ; // 自己中心點
                                    rvG          <= (rvDataBuffer0[29:20]+rvDataBuffer0[9:0]+rvDataBuffer3[19:10]+rvDataBuffer1[19:10])/4; // 加上下左右
                                    rvB          <= (rvDataBuffer1[29:20]+rvDataBuffer1[9:0]+rvDataBuffer3[29:20]+rvDataBuffer3[9:0]  )/4; // 加四個角角
                                    rFifoWriteEn <= 1;
                                 end
                              default: begin // CASE B
                                    rvR          <= (rvDataBuffer0[29:20]+rvDataBuffer0[9:0]                                          )/2; // 加左右 
                                    rvG          <= (rvDataBuffer0[19:10]                                                             )  ; // 自己中心點
                                    rvB          <= (rvDataBuffer3[19:10]+rvDataBuffer1[19:10]                                        )/2; // 加上下
                                    rFifoWriteEn <= 1;
                                 end
                           endcase
                        end 
                        else begin
                           rvR          <= rvR;
                           rvG          <= rvG;
                           rvB          <= rvB;
                           rFifoWriteEn <= 0;
                        end 
                     //Jump State
                        rvBayer2RGBState <= (rvReadCounter>Y_LEN+1) ? ST_IDLE: rvBayer2RGBState;
                  end
            default: rvBayer2RGBState <= ST_IDLE;
         endcase
      end
   end

   assign ovDataBayerOut = rvBayerData & (&rvFifoReadCounter)  & (&rvFifoWriteCounter)  & (&rvFifoWriteRisingCounter) & (&rvFifoReadRisingCounter) & (&rvPixClkCount) & (&rvFrameCount);
   assign ovClockCounter = rvClockCounter;
   assign ovLineCounter  = rvLineCounter;
   assign ovDataRGBOut   = wvFifo_out;
   assign oGo            = rGo;
   
   
   
endmodule



module true_dual_port_ram_single_clock
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
   input [(DATA_WIDTH-1):0] data_a, data_b,
   input [(ADDR_WIDTH-1):0] addr_a, addr_b,
   input we_a, we_b, clk,
   output reg [(DATA_WIDTH-1):0] q_a, q_b
);

   // Declare the RAM variable
   reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

   // Port A 
   always @ (posedge clk)
   begin
      if (we_a) 
      begin
         ram[addr_a] <= data_a;
         q_a <= data_a;
      end
      else 
      begin
         q_a <= ram[addr_a];
      end 
   end 

   // Port B 
   always @ (posedge clk)
   begin
      if (we_b) 
      begin
         ram[addr_b] <= data_b;
         q_b <= data_b;
      end
      else 
      begin
         q_b <= ram[addr_b];
      end 
   end

endmodule
