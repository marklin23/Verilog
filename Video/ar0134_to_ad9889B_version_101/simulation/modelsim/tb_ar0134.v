`timescale 1ns/10ps

//`timescale   Unit/Precision    Delay    Time delay
//  __________________________________________________
//
//  `timescale 10ns/1ns          #5       50ns
//
//  `timescale 10ns/1ns          #5.738   57ns
//
//  `timescale 10ns/10ns         #5.5     60ns
//
//  `timescale 10ns/100ps        #5.738   57.4ns


//========================================================
//tb_mac_led_decoder  tb_mac_led_decoder_inst(
//
//   .iRstn    () ,
//   .LED_CLK0 () ,
//   .LED_DATA0()    
//
//   
//);                         
// 20181112 add custom led stream function "LED_WDATA_CUSTOM_BIT"
//========================================================
module tb_ar0134(

   input            iRstn     ,
   output reg       oPixelClk , 
   output reg       oFV       ,
   output reg       oLV       ,
   output reg[11:2] oData
);


    parameter time_unit            = 1;
    parameter clk_time             = 13.46 * time_unit;   // 74.25MHz 
    parameter clk_time_div2    = ( clk_time / 2 );
    parameter wait_time            = clk_time * 1000;
    parameter wait_long_time       = clk_time * 10000;
    parameter NumOfStream          = 10;
    parameter NumOfBit             = 80;
	
	parameter NumOf_H_Blank        = 368;
	parameter NumOf_V_Blank        = 100;
	parameter Frame_unit           = clk_time*NumOf_V_Blank*NumOfBit ;
	parameter FV_T0                = clk_time*5;
	parameter FV_T1                = clk_time*46558;
	parameter FV_T2                = clk_time*5;	
	
	
    wire [3:0] wvRj45_4b = 4'b0110;// lsb shift first 
	wire [3:0] wvSFP_4b  = 4'b1111;// lsb shift first 

    wire [NumOfBit-1 :0 ] BitOfValue = {//total 256 bit shift from LSB
                                        //8'b0,
										wvSFP_4b[3:1],
										2'b0,
										wvSFP_4b[0],
										14'b0,
										wvSFP_4b[3:1],
										2'b0,
									    wvSFP_4b[0],
										4'b0,
										2'b00,                  // mode sel
										{12{ wvRj45_4b[3:0] }}  // rj45 mode 
										//168'b0                  // unused 
									                     
                                                                 };

   
   
	initial begin
		AR0134_TX(1282,722,1000,NumOf_H_Blank,NumOf_V_Blank);
		  
	end
    
	initial begin
		oPixelClk  = 1'b0; 
		forever 
		# clk_time_div2  oPixelClk  = ~oPixelClk; 
		  
	end	
	reg rLv =0;
	reg rCnt=0;
	reg rLineCnt=0;
   //test green
	always@(negedge oPixelClk) begin
		rLv <= oLV;
		rCnt <= (~oFV) ? 0 : rCnt + 1;
		rLineCnt <= (~oFV    ) ? 0            :
					(rLv&~oLV) ? rLineCnt + 1 : rLineCnt;

		oData <= ~oLV     ? oData                      :
				 rLineCnt ? (rCnt ? 10'h044 : 10'h000) : (rCnt ? 10'h040 : 10'h000); 
		
	end



	
	task AR0134_TX; //rising edge send data
	   input integer NumOfBit;      // 1282 
	   input integer NumOfLine;     // 722 
	   input integer NumOfFrame;    // 10    
	   input integer NumOf_H_Blank; // 
	   input integer NumOf_V_Blank; // 
	   integer bit_num, stream_num, Frame_num;      
	   begin
			oFV   = 0;
			oLV   = 0;
			oData = 10'b0;
			
			for (Frame_num = 0; Frame_num <NumOfFrame; Frame_num = Frame_num + 1) begin
				#FV_T1 oFV = 1;
				#FV_T2
				for (stream_num = 0; stream_num <NumOfLine; stream_num = stream_num + 1) begin
					for (bit_num = 0; bit_num <NumOfBit; bit_num = bit_num + 1) begin
						#clk_time oLV = 1;
					end 
					for (bit_num = 0; bit_num <NumOf_H_Blank; bit_num = bit_num + 1) begin
						#clk_time oLV = 0;
					end
				end
					#FV_T0 oFV = 0; 
			end
	   end   
	endtask 
   
   
   
   
endmodule
