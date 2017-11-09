`timescale 1ns / 1ps
//***************************************************************************
//* 	Date:		2017/09/22
//*	Description:	I2C_Buffer
//*	Clock:		25Mhz
//*	Author:		Galaxy_Mark
//* 	Status:		
//*               Support Burst Read, Repeat Start, Single Write, and Test Finish
//*               Support bir control on Sda 
//*               Support 7bit Address, 8bit offset 8bit data
//***************************************************************************
module i2c_mux (
input  iClk     ,
input  iRstn    ,

input  iSCL_m   ,
output oSCLoe_m ,
input  iSDA_m   ,
output oSDAoe_m ,
                
input  iSCL_s   , 
output oSCLoe_s ,
input  iSDA_s   ,
output oSDAoe_s 

);

	reg   [4:0] rvState;
	reg   [4:0]	rvSclcount;
	reg   [1:0]	rvSDA_pipe;
	reg   [1:0]	rvSCL_pipe;
   reg   [1:0]	rvSDA_pipe_s;
	reg         rSda_s_o;
   reg         rSda_m_o;

	reg	[10:0]rvDecode_data;
	reg	[6:0]	rvAddress_data;
	reg			rRW_data		;
	reg	[7:0]	rvOffset_data	;
	reg	[7:0]	rvWrite_data	;
	reg			rTx_shift	;
	reg	[7:0]	rvShift_reg;
   wire        oread_en;
   
   assign	   wLoad	 =	oread_en;
	assign	   wRead	 =	(rRW_data==1'b1)?1'b1:1'b0;
	assign	   wWrite =	(rRW_data==1'b0)?1'b1:1'b0;
//**********************************************
//creat pipe
//**********************************************

	
always @(posedge iClk or negedge iRstn)
	begin
		rvSDA_pipe	<=	!iRstn	?	1'b0	:	{rvSDA_pipe[0],iSDA_m};
		rvSCL_pipe	<=	!iRstn	?	1'b0	:	{rvSCL_pipe[0],iSCL_m};
      rvSDA_pipe_s<= !iRstn	?	1'b0	:	{rvSDA_pipe_s[0],iSDA_s};
	end

//**********************************************
//Bit-counter
//**********************************************

always @(posedge iClk or negedge iRstn)
	if(!iRstn)
		rvSclcount	<=	5'b0;
	else if(((rvSCL_pipe== 2'b11)&&(rvSDA_pipe==2'b10))||((rvSCL_pipe== 2'b11)&&(rvSDA_pipe==2'b01)))
		rvSclcount	<=	5'b0;
	else if (rvSCL_pipe==2'b10)
		rvSclcount	<=	((rvSclcount==5'd9))	?	5'b1	:	rvSclcount	+	1'b1;
		


//**********************************************
//	 TX  SHIFT
//**********************************************
//always @(posedge iClk or negedge iRstn)
// 	if(!iRstn)
//		rvShift_reg[7:0]	<=	8'b0;
//	else 
//		begin
//			if(wLoad)
//					rvShift_reg	<=	tx_data[7:0];
//			else if((rTx_shift==1'b1) && (rvSCL_pipe== 2'b10))
//					rvShift_reg	<=	{rvShift_reg[6:0],1'b0};
//		end		
//		


//**********************************************
// IIC State machine
//**********************************************
	parameter	IDLE        =	4'd1;
	parameter	ADDRESS     =	4'd2;
	parameter	RW          =	4'd3;
	parameter	ADDRESS_ACK =	4'd4;
	parameter	OFFSET      =	4'd5;
	parameter	OFFSET_ACK  =	4'd6;
	parameter	W_DATA      =	4'd7;
	parameter	R_DATA      =	4'd8;
	parameter	ACK_WR      =	4'd9;
	parameter	ACK_RD      =	4'd10;
	parameter	WAIT_STOP   =	4'd11;
	parameter	STOP        =	4'd12;

always @(posedge iClk or negedge iRstn)
	if(!iRstn)
		begin
			rvState			<=	IDLE;
			rvDecode_data		<=	11'b0;
			rTx_shift		<=	1'b0;
		end
	else if ((rvSCL_pipe== 2'b11)&&(rvSDA_pipe==2'b10))
		begin
			rvState			<=	/* (rvState!=IDLE)	?	OFFSET	:	 */IDLE;
			rTx_shift		<=	1'b0;
		end
	else if	((rvSCL_pipe== 2'b11)&&(rvSDA_pipe==2'b01))
		begin
			rvState			<=	STOP;
			rTx_shift		<=	1'b0;
		end
	else
		begin
		case(rvState)
			
			IDLE:	begin
						rvState		<=	ADDRESS;
						rvDecode_data	<=	rvDecode_data;
						rTx_shift	<=	1'b0;
					end
			ADDRESS:begin
						rvState		<=	(rvSclcount==5'd9)		?	ADDRESS_ACK		:	ADDRESS;
						rvDecode_data	<=	(rvSCL_pipe== 2'b01)	?	{rvDecode_data[9:0],iSDA_m}	:	rvDecode_data;
						rTx_shift	<=	1'b0;
					end					
			ADDRESS_ACK:	begin
						rvState		<=	(/*(rvAddress_data[6:0] == slave_addr)&&*/(rvSCL_pipe== 2'b10))?	((rRW_data==1'b0)?OFFSET:R_DATA)
																															:	ADDRESS_ACK;
						rTx_shift	<=	1'b0;
					end		
			
			OFFSET:	begin
						rvState		<=	(rvSclcount==5'd9)			?	OFFSET_ACK		:	OFFSET;
						rvDecode_data	<=	(rvSCL_pipe== 2'b01)	?	{rvDecode_data[9:0],iSDA_m}	:	rvDecode_data;
						rTx_shift	<=	1'b0;
					end	
			OFFSET_ACK:	begin
						rvState		<=	(rvSCL_pipe!= 2'b10)	?	OFFSET_ACK	:	W_DATA;
						rTx_shift	<=	(wRead)?	1'b1	:	1'b0;			
					end
			W_DATA:	begin
						rvDecode_data	<=	(rvSCL_pipe== 2'b01)	?	{rvDecode_data[9:0],iSDA_m}	:	rvDecode_data;
						rvState		<=	(rvSclcount==5'd9)			?	ACK_WR		:	W_DATA;
						rTx_shift	<=	1'b0;
					end
					
			R_DATA:	begin
						rvState		<=	(rvSCL_pipe== 2'b10)&&(rvSclcount==5'd8) ?	ACK_RD		:	R_DATA;
						rTx_shift	<=	1'b1;
					end
					
			ACK_WR:	begin
						rvDecode_data	<= rvDecode_data;
						rTx_shift	<=	1'b0;
						rvState		<=	(rvSclcount==5'd1)		?	WAIT_STOP		:	ACK_WR;
					end
			ACK_RD:begin
						rvDecode_data	<= rvDecode_data;
						rTx_shift	<=	1'b0;
						rvState		<=	(rvSCL_pipe== 2'b01)&&(iSDA_m==1'b1)   ?	WAIT_STOP      : 
                                 (rvSCL_pipe== 2'b10)                   ?  R_DATA         :  ACK_RD;               
					end
			WAIT_STOP:
						rvState		<=	rvState;
                  
			STOP:
						rvState		<=	rvState;
			default:begin
						rvState		<=	IDLE;
                  //rvDecode_data	<= rvDecode_data;
						rTx_shift	<=	1'b0;	
					end
					
		
		endcase
		end
//**********************************************
//data-capture
//**********************************************
always @(posedge iClk or negedge iRstn)
	if(!iRstn)
		begin
			rvAddress_data	<=	7'b0;
			rRW_data			<=	1'b0;
			rvOffset_data		<=	8'b0;
			rvWrite_data		<=	8'b0;
		end
	else	
		begin 
			case(rvState)
			 	IDLE	:
					begin
						rvAddress_data	<=	rvAddress_data;
						rRW_data			<=	1'b0;
						rvOffset_data		<=	rvOffset_data;
						rvWrite_data		<=	8'b0;
					end 
				ADDRESS_ACK		:
					begin
						rvAddress_data	<=	rvDecode_data[7:1];
						rRW_data			<=	rvDecode_data[0];
					end				
			
				OFFSET_ACK	:
					begin
						rvOffset_data		<=	rvDecode_data;
					end				
			
				ACK_WR	:
					begin
						rvWrite_data		<=	rvDecode_data;
						rvOffset_data		<=	rvOffset_data;
					end	
				STOP	:
					begin
						rvAddress_data	<=	rvAddress_data;
						rRW_data			<=	rRW_data;
						rvOffset_data		<=	rvOffset_data;
						rvWrite_data		<=	rvWrite_data;
					end	
				default:
					begin
						rvAddress_data	<=	rvAddress_data;
						rRW_data			<=	rRW_data;
						rvOffset_data		<=	rvOffset_data;
						rvWrite_data		<=	rvWrite_data;
					end
			endcase
		end
//**********************************************
//	Decode Data and Register W/R enable
//**********************************************
	assign	rx_address	=	rvAddress_data[6:0];
	assign	rx_data		=	rvWrite_data	[7:0];
	assign	rx_offset	=	rvOffset_data	[7:0];
	assign	owrite_en	=	((rvState[4:0] == ACK_WR/* WAIT_STOP */	)	&&	wWrite	)?	1'b1:1'b0;
	assign	oread_en	   =	((rvState[4:0] == ADDRESS_ACK	)	&&	wRead	)?	1'b1:1'b0;
	assign	oSDA		   =	rSda_s_o;

//**********************************************
//	 i2c_mux slave sda out
//**********************************************
always @(*)
	if(!iRstn)
		rSda_s_o	<=	1'b1;
	else if ((rvSCL_pipe== 2'b11)&&(rvSDA_pipe==2'b10))
		rSda_s_o	<=	iSDA_m;
	else if	((rvSCL_pipe== 2'b11)&&(rvSDA_pipe==2'b01))
		rSda_s_o	<=	iSDA_m;
	else	
		begin 
			if ((rvState[4:0] == ADDRESS_ACK)||(rvState[4:0] == OFFSET_ACK)||(rvState[4:0] == ACK_WR))
				rSda_s_o	<=	1'b1;
			else if	(rvState[4:0] == ACK_RD)
				rSda_s_o	<=	1'b1;
 			else if	(rTx_shift)	 
				rSda_s_o	<=	1'b1;//rvShift_reg[7]; 
			else
				rSda_s_o	<=	iSDA_m;
		end	
      
//**********************************************
//	 i2c_mux master sda out
//**********************************************
always @(*)
	if(!iRstn)
		rSda_m_o	<=	1'b1;
	else if ((rvSCL_pipe== 2'b11)&&(rvSDA_pipe==2'b10))
		rSda_m_o	<=	1'b1;
	else if	((rvSCL_pipe== 2'b11)&&(rvSDA_pipe==2'b01))
		rSda_m_o	<=	1'b1;
	else	
		begin 
			if ((rvState[4:0] == ADDRESS_ACK)||(rvState[4:0] == OFFSET_ACK)||(rvState[4:0] == ACK_WR))
				rSda_m_o	<=	iSDA_s;//(rvSclcount==5'd9)&&(rvSDA_pipe_s==2'b00)   ?  iSDA_s  : 1'b1;
			else if	(rvState[4:0] == ACK_RD)
				rSda_m_o	<=	1'b1;
 			else if	(rTx_shift)	 
				rSda_m_o	<=	iSDA_s;//rvShift_reg[7]; 
			else
				rSda_m_o	<=	1'b1;
		end	


   assign   oSCLoe_s = iSCL_m;
   assign   oSDAoe_s = rSda_s_o;// ? iSDA_m : 1'b1;
   assign   oSDAoe_m = rSda_m_o;
	
endmodule
