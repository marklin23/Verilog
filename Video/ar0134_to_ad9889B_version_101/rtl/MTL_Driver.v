//-----------------------
// MTL2 800x480 LCD panel


//----------------------------------------------------------------------//----------------------------------------------------------------------//
//LCD Horizontal Timing Specifications                                  //LCD Vertical Timing Specifications                                    //
//----------------------------------------------------------------------//----------------------------------------------------------------------//
//    Item                | Symbol      | Typical Value       |  Unit   //    Item                 |  Symbol   |  Typical Value       |  Unit   //
//----------------------------------------------------------------------//----------------------------------------------------------------------//
//                        |             | min  | typ  | max   |         //                         |           |  min  | typ  | max   |         //
//----------------------------------------------------------------------//----------------------------------------------------------------------//
//Horizontal Display Area |  thd        | -    | 800  | -     |  DCLK   // Vertical Display Area   |  tvd      |  -    | 480  | -     |  TH     //
//----------------------------------------------------------------------//----------------------------------------------------------------------//
//DCLK Frequency          |  fclk       | 26.4 | 33.3 | 46.8  |  MHz    // VS period time          |  tv       |  510  | 525  | 650   |  TH     //
//----------------------------------------------------------------------//----------------------------------------------------------------------//
//One Horizontal Line     |  th         | 862  | 1056 | 1200  |  DCLK   // VS pulse width          |  tvpw     |  1    | -    | 20    |  TH     //
//----------------------------------------------------------------------//----------------------------------------------------------------------//
//HS pulse width          |  thpw       | 1    |      | 40    |  DCLK   // VS Blanking             |  tvb      |  23   | 23   | 23    |  TH     //
//----------------------------------------------------------------------//----------------------------------------------------------------------//
//HS Blanking             |  thb        | 46   | 46   | 46    |  DCLK   // HS Front Porch          |  tvfp     |  7    | 22   | 147   |  TH     //
//----------------------------------------------------------------------//----------------------------------------------------------------------//
//HS Front Porch          |  thfp       | 16   | 210  | 354   |  DCLK   //
//----------------------------------------------------------------------//


//-------------------------
//Name         1280x720p60
//EDID Name           720p
//Aspect Ratio        16:9
//Pixel Clock        74.25 MHz
//Pixel Time        13.468 ns
//Active Pixels    921,600 total
//8-bit Memory       7,200 Kbits
//32-bit Memory     28,800 Kbits
//Data Rate           1.78 Gbps
//
//Horizontal Timings
//Active Pixels       1280
//Front Porch           72
//Sync Width            80
//Back Porch           216
//Blanking Total       368
//Total Pixels        1648
//Sync Polarity        pos
//
//Vertical Timings
//Active Pixels        720
//Front Porch            3
//Sync Width             5
//Back Porch            22
//Blanking Total        30
//Total Pixels         750
//Sync Polarity        pos

//-------------------------------------------------------------------------------------------------------//
//  Horizontal  Timing
//       H pulse width(thpw)
// HS   _____ <----> _____________________________....._________________________         _______________                
//           |______|          |                                   |            |_______|
//                             |                                   |            |
//             fclk            |                                   |            |
//            <---->           |                                   |            |
// DCLK _____    __    __    __|   __    __    __          __    __|   __    __ |  __    __                 
//           |__|  |__|  |__|  |__|  |__|  |__|  |......__|  |__|  |__|  |__|  ||_|  |__|  |
//                             |                                   |            |
// R0~R7      _____ _____ _____|_____ _____ _____ _____ _____ _____|_____ _____ |     _____ _____ 
//           |_____|_____|_____|__R__|__R__|__R__|__R__|__R__|__R__|_____|_____||....|_____|_____|
// G0~G7      _____ _____ _____|_____ _____ _____ _____ _____ _____|_____ _____ |     _____ _____ 
//           |_____|_____|_____|__G__|__G__|__G__|__G__|__G__|__G__|_____|_____||....|_____|_____|
// B0~B7      _____ _____ _____|_____ _____ _____ _____ _____ _____|_____ _____ |     _____ _____ 
//           |_____|_____|_____|__B__|__B__|__B__|__B__|__B__|__B__|_____|_____||....|_____|_____|
//             H Blanking (thb)|   Horizontal Display Area (thd)   | H FrontPorch(thfp)
//           <---------------->|<--------------------------------->|<---------->|
//                                Total Area ( th )  
//           <-----------------------------------------------------------------> 
//-------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------//
//  Vertical  Timing
//       VS pulse width(tvpw)
// VS   _____ <----> _____________________________.....________________________         _______________                
//           |______|          |                                   |           |_______|
//                             |                                   |           |
//             th              |                                   |           |
//            <---->           |                                   |           |
// HS   _____    __    __    __|   __    __    __          __    __|   __    __|  __    __                 
//           |__|  |__|  |__|  |__|  |__|  |__|  |......__|  |__|  |__|  |__|  |_|  |__|  |
//                             |                                   |           |
//                             |                                   |           |
//             V Blanking (tvb)|   Vertical Display Area (tvd)     | V FrontPorch(tvfp)
//             V Blanking (tvb)|   Vertical Display Area (tvd)     | V FrontPorch(tvfp)
//           <---------------->|<--------------------------------->|<--------->|
//                                Total Area ( tv )  
//           <-----------------------------------------------------------------> 
//-------------------------------------------------------------------------------------------------------//


//MTL_Driver MTL_Driver_inst (
//
//   .iClk         ( wClk30             ) ,  // wClk30
//   .iRstn        ( KEY[0] & wPllRstn  ) ,
//   .ivControl    ( SW[7:0]            ) ,
//   .ivRGB_Ram    ( q[23:0]            ) ,
//   .ovHcounter   ( wvHcounter         ) ,
//   .ovVcounter   ( wvVcounter         ) ,
//   .MTL2_INT     ( MTL2_INT           ) ,
//   .MTL2_I2C_SCL ( MTL2_I2C_SCL       ) ,
//   .MTL2_I2C_SDA ( MTL2_I2C_SDA       ) ,   
//   .MTL2_BL_ON_n (                    ) ,
//   .MTL2_DCLK    ( MTL2_DCLK          ) ,
//   .MTL2_R       ( MTL2_R             ) ,
//   .MTL2_G       ( MTL2_G             ) ,
//   .MTL2_B       ( MTL2_B             ) ,
//   .MTL2_HSD     ( MTL2_HSD           ) ,
//   .MTL2_VSD     ( MTL2_VSD           ) ,
//
//);

module MTL_Driver(

// HD 1280x720 60Hz
   //parameter  thd  = 1280,
   //parameter  thpw = 40,   // H sync
   //parameter  thfp = 110,  // H front porch
   //parameter  thb  = 260,  // H sync + H back porch
   //parameter  th   = thb+thfp+thd, //1650
   //
   //parameter  tvd  = 720,
   //parameter  tvpw = 5,   // V sync
   //parameter  tvfp = 5,   // V front porch
   //parameter  tvb  = 25,  // V sync + V back porch
   //parameter  tv   = tvb+tvfp+tvd, //750



//   


   input                iClk,   
   input                iRstn,
   input                iGo,
   input       [7:0]    ivControl,
   input      [23:0]    ivRGB_Ram,
   output     [10:0]    ovHcounter,
   output     [10:0]    ovVcounter,
   
   input                MTL2_INT,
   output               MTL2_I2C_SCL,
   inout                MTL2_I2C_SDA,   
     
     
  
     
   inout                MTL2_BL_ON_n,
   output               MTL2_DCLK,
   output      [7:0]    MTL2_R,
   output      [7:0]    MTL2_G,
   output      [7:0]    MTL2_B,
   output               MTL2_HSD, // active low
   output               MTL2_VSD, // active low
   output               MTL2_DISP_EN

);

   function integer logb2 ( input integer size );
      integer size_buf;
      begin
         size_buf = size; 
         for(logb2=-1; size_buf>0; logb2=logb2+1) size_buf = size_buf >> 1;
      end
   endfunction

   reg [15:0] rvHcounter;
   reg [15:0] rvVcounter;
   reg rHSync, rVSync;


   
   wire [255:0] wvSource;
   wire [255:0] wvProbe;
   S_P u0 (
        .source ( wvSource ),  // sources.source
        .probe  ( wvProbe  )   // probes .probe
   );
   
   reg [15:00] thd  ;
   reg [15:00] thpw ;
   reg [15:00] thfp ;
   reg [15:00] thb  ;
   reg [15:00] tvd  ;
   reg [15:00] tvpw ;
   reg [15:00] tvfp ;
   reg [15:00] tvb  ;
   
   reg [15:00] th  ;
   reg [15:00] tv  ;
   reg         Sync_Polarity;
//
// Dynamic Sync Timing Ctrl
//
   always@(posedge iClk) begin
   
      if(iRstn == 0) begin
         thd  <= 1280;
         thpw <= 40  ;
         thfp <= 70;//110 ;
         thb  <= 300;//260 ;

         tvd  <= 720;
         tvpw <= 5  ;  
         tvfp <= 5  ;  
         tvb  <= 25 ; 
         th   <= thb+thfp+thd;
         tv   <= tvb+tvfp+tvd;
         Sync_Polarity <= 1;
      end else if(wvSource[129]) begin
      
         thd  <= wvSource[15 : 00] ;
         thpw <= wvSource[31 : 16] ;
         thfp <= wvSource[47 : 32] ;
         thb  <= wvSource[63 : 48] ;
         tvd  <= wvSource[79 : 64] ;
         tvpw <= wvSource[95 : 80] ;  
         tvfp <= wvSource[111: 96] ;  
         tvb  <= wvSource[127:112] ; 
         Sync_Polarity <= wvSource[128];
         th   <= thb+thfp+thd;
         tv   <= tvb+tvfp+tvd;
         
      end
      
      
   end

//
// Sync gen
//
   always@(posedge iClk)
      if(iRstn == 0) begin
         rvHcounter <= 0;
         rvVcounter <= 0;
         rHSync     <= 0;
         rVSync     <= 0;
      end
      else if(iGo) begin
         rvHcounter <= ( rvHcounter == th-1 ) ? 0 : rvHcounter + 1 ;
         rvVcounter <= ( rvHcounter == th-1 ) ? (( rvVcounter >=  tv-1 ) ? 0 : rvVcounter +1) : rvVcounter;                    
         rHSync     <= ( rvHcounter <  thpw ) ? 1'b1 : 1'b0;
         rVSync     <= ( rvVcounter <  tvpw ) ? 1'b1 : 1'b0;              
      end
      else begin
         rvHcounter <= 0;
         rvVcounter <= 0;
         rHSync     <= 0; 
         rVSync     <= 0;
      end
   

//
//data generater
//
   reg [7:0] rvR,rvG,rvB;



   always@(posedge iClk)
      if(iRstn == 0) begin
         rvB <= 0;
         rvG <= 0;
         rvR <= 0;
      end
      else if (rvHcounter == 0 ) begin   
         rvB <= 0;
         rvG <= 0;
         rvR <= 0;      
      end   
      else if ( (rvHcounter > thb) && ( rvHcounter <= (thd+thb) )/* && (rvVcounter > tvb ) && (rvVcounter < tvb+tvd) */) begin
         case(ivControl)
         0: begin      
               rvB <= rvB + 1;
               rvG <= rvG + 1;
               rvR <= rvR + 1;      
            end
         
         1: begin      
               rvB <= 8'hFF;
               rvG <= 0;
               rvR <= 0;      
            end

         2: begin      
               rvB <= 0;
               rvG <= 8'hFF;
               rvR <= 0;         
            end

         3: begin      
               rvB <= 0;
               rvG <= 0;
               rvR <= 8'hFF;          
            end

         4: begin      
               rvB <= 0;
               rvG <= 8'hFF;
               rvR <= 8'hFF;              
            end 
         5: begin      
               rvB <= ivRGB_Ram[ 7: 0];
               rvG <= ivRGB_Ram[15: 8];
               rvR <= ivRGB_Ram[23:16];              
            end         
         endcase

      end
   reg [3:0] rvPipeBuf;
   reg [7:0] rvR_buf,rvG_buf,rvB_buf;
   always@(posedge iClk) begin
      rvPipeBuf[0] <= (rvHcounter >= thb) && ( rvHcounter < (thd+thb) ) && (rvVcounter >= tvb ) && (rvVcounter < tvb+tvd);
      rvPipeBuf[1] <= Sync_Polarity ? rHSync : ~rHSync;
      rvPipeBuf[2] <= Sync_Polarity ? rVSync : ~rVSync;
      rvR_buf      <= rvR;
      rvG_buf      <= rvG;
      rvB_buf      <= rvB;
   end

//
//assignment block
//
   assign MTL2_R           = rvR_buf;      // rvR;
   assign MTL2_G           = rvG_buf;      // rvG;
   assign MTL2_B           = rvB_buf;      // rvB;      
   assign MTL2_HSD         = rvPipeBuf[1]; //Sync_Polarity ? rHSync : ~rHSync;
   assign MTL2_VSD         = rvPipeBuf[2]; //Sync_Polarity ? rVSync : ~rVSync;
   assign MTL2_DCLK        = iClk;
   assign ovHcounter[10:0] = rvHcounter[10:0];
   assign ovVcounter[10:0] = rvVcounter[10:0];
   assign MTL2_DISP_EN     = rvPipeBuf[0]; //(rvHcounter >= thb) && ( rvHcounter < (thd+thb) ) && (rvVcounter >= tvb ) && (rvVcounter < tvb+tvd);
   
endmodule
