//////////////////////////////////////////////////////////////////////
//state machine decode_data tx_shift
//////////////////////////////////////////////////////////////////////
	// parameter	IDLE			=	8'd1;
	// parameter	IDLE_W			=	8'd2;
	// parameter	IDLE_R			=	8'd3;
	// parameter	WAIT_START		=	8'd4;
	// parameter	START_W			=	8'd5;
	// parameter	START_R			=	8'd24;
	// parameter	WAIT_STOP		=	8'd22;
	// parameter	STOP			=	8'd23;

	// parameter	TX_ADDRESS		=	8'd6;
	// parameter	ADDRESS_ACK		=	8'd7;	
	// parameter	TX_OFFSET		=	8'd8;
	// parameter	OFFSET_ACK		=	8'd9;	
	// parameter	TX_DATA			=	8'd10;
	// parameter	TX_DATA_ACK		=	8'd11;
	// parameter	NACK_WAIT_STOP	=	8'd12;
	// parameter	WAIT_LAST_ACK	=	8'd13;
	
	// parameter	R_TX_ADDRESS	=	8'd14;
	// parameter	R_ADDRESS_ACK	=	8'd15;	
	// parameter	R_TX_OFFSET		=	8'd16;
	// parameter	R_OFFSET_ACK	=	8'd17;	
	// parameter	RX_DATA			=	8'd18;
	// parameter	RX_DATA_ACK		=	8'd19;	
	// parameter	R_NACK_WAIT_STOP=	8'd20;
	// parameter	R_WAIT_LAST_ACK	=	8'd21;
//redriver  0x01 - 0x32   32byte 
module i2c_master_ctrl#(
	parameter	ADDRESS_NUM			= 6,
	parameter	OFFSET_NUM			= 32,			// means how much rvI2c_Offset will sent 0x00~0x06  means OFFSET_NUM is 7
	parameter	OFFSET_DATA_BYTE	= 1,			// means how much rvI2c_Offset data byte 8'hA5 means 1 byte  OFFSET_DATA_BYTE = 1
	parameter	WRITE_DATA_BYTE		= 1,			// means how much write data byte 8'hA5 means 1 byte  WRITE_DATA_BYTE = 1
	//parameter	WRITE_DATA			={8'hA1} ,		// write data MSB to  LSB   means  WRITE_DATA	=	{8'h01,  8'h02,  8'h04,  8'h08}
	parameter	READ_DATA_BYTE		= 1				// means how much read data byte want to read means 1 byte  READ_DATA_BYTE = 1	
)(
	input   iRstn, iClk,
	// I2C_Interface for test bench
	//output  SCL,
	//inout   SDA
	
	
	// I2C_Interface for redriver
	input	iSDA,
	output	oSDAOE,
	output	oSCLOE
);



reg	[WRITE_DATA_BYTE*8-1:0]	rvI2c_WriteData;

reg	[7:0]	rv_I2c_Address;
reg	[7:0]	rvI2c_Offset;
reg [2:0]   rvEnable_buf;

reg			rEn;
reg			rRW; //High Read  Low Write

reg			rNext_Device	=	'd0;
reg			rNext_Byte;
reg 		rDone;
reg	[1:0]	rvSda_pipe;
reg	[1:0]	rvScl_pipe;
wire[7:0]	state_m;

wire wRead  = rRW;
wire wWrite = ~rRW;
//----------------------------------------------------------------
//  read  i2cwData whhich save in ram
//----------------------------------------------------------------

parameter DATA_WIDTH=64;
parameter ADDR_WIDTH=4;

reg		[DATA_WIDTH-1:0]	rvWriteDataa='d0;
reg		[ADDR_WIDTH-1:0]	rvWriteAddra='d0;
reg		[DATA_WIDTH-1:0]	rvWriteDatab='d0;
reg		[ADDR_WIDTH-1:0]	rvWriteAddrb='d0;
reg		[ADDR_WIDTH-1:0]	rvReadAddra='d0;
reg		[ADDR_WIDTH-1:0]	rvReadAddrb='d0;
reg							rWriteEn='d0;
reg							rReadEn='d0;
reg		[9:0]				rvOffsetCnt='d0;
reg		[9:0]				rvAddressCnt='d0;

reg		[DATA_WIDTH-1:0]	rvI2CWriteRamDatab;
wire	[DATA_WIDTH-1:0]	wvReadDatab;	//=	64'h1122334455667788;
wire 	[DATA_WIDTH-1:0]	wvReadDataa;
//----------------------------------------------------------------
//----------------------------------------------------------------


reg		[DATA_WIDTH-1:0]	rvTempData;   // data from RAM
reg		[ADDRESS_NUM*7-1:0]	rvTempAddress	=	{7'h58,7'h59,7'h5A,7'h5B,7'h5C,7'h5D};
reg		[OFFSET_NUM*8*ADDRESS_NUM-1:0]	rvTempOffset	=	
	{
	8'h0E,8'h0F,8'h10,8'h11,8'h15,8'h16,8'h17,8'h18,8'h1C,8'h1D,8'h1E,8'h1F,8'h23,8'h24,8'h25,8'h26,8'h2B,8'h2C,8'h2D,8'h2E,8'h32,8'h33,8'h34,8'h35,8'h39,8'h3A,8'h3B,8'h3C,8'h40,8'h41,8'h42,8'h43,	//Address58
	8'h0E,8'h0F,8'h10,8'h11,8'h15,8'h16,8'h17,8'h18,8'h1C,8'h1D,8'h1E,8'h1F,8'h23,8'h24,8'h25,8'h26,8'h2B,8'h2C,8'h2D,8'h2E,8'h32,8'h33,8'h34,8'h35,8'h39,8'h3A,8'h3B,8'h3C,8'h40,8'h41,8'h42,8'h43,	//Address59
	8'h0E,8'h0F,8'h10,8'h11,8'h15,8'h16,8'h17,8'h18,8'h1C,8'h1D,8'h1E,8'h1F,8'h23,8'h24,8'h25,8'h26,8'h2B,8'h2C,8'h2D,8'h2E,8'h32,8'h33,8'h34,8'h35,8'h39,8'h3A,8'h3B,8'h3C,8'h40,8'h41,8'h42,8'h43,	//Address5A
	8'h0E,8'h0F,8'h10,8'h11,8'h15,8'h16,8'h17,8'h18,8'h1C,8'h1D,8'h1E,8'h1F,8'h23,8'h24,8'h25,8'h26,8'h2B,8'h2C,8'h2D,8'h2E,8'h32,8'h33,8'h34,8'h35,8'h39,8'h3A,8'h3B,8'h3C,8'h40,8'h41,8'h42,8'h43,	//Address5B
	8'h0E,8'h0F,8'h10,8'h11,8'h15,8'h16,8'h17,8'h18,8'h1C,8'h1D,8'h1E,8'h1F,8'h23,8'h24,8'h25,8'h26,8'h2B,8'h2C,8'h2D,8'h2E,8'h32,8'h33,8'h34,8'h35,8'h39,8'h3A,8'h3B,8'h3C,8'h40,8'h41,8'h42,8'h43,	//Address5C
	8'h0E,8'h0F,8'h10,8'h11,8'h15,8'h16,8'h17,8'h18,8'h1C,8'h1D,8'h1E,8'h1F,8'h23,8'h24,8'h25,8'h26,8'h2B,8'h2C,8'h2D,8'h2E,8'h32,8'h33,8'h34,8'h35,8'h39,8'h3A,8'h3B,8'h3C,8'h40,8'h41,8'h42,8'h43		//Address5D
	};
reg	[OFFSET_NUM*8*ADDRESS_NUM-1:0]	rvwriteData			=
	{
	8'h04,8'h2D,8'hAE,8'h00,8'h04,8'h2D,8'hAE,8'h00,8'h04,8'h2D,8'hAE,8'h00,8'h04,8'h2D,8'hAE,8'h00,8'h04,8'h2D,8'hAE,8'h00,8'h04,8'h2D,8'hAE,8'h00,8'h04,8'h2D,8'hAE,8'h00,8'h04,8'h2D,8'hAE,8'h00,
	8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,
	8'h04,8'h2F,8'hAE,8'h00,8'h04,8'h2F,8'hAE,8'h00,8'h04,8'h2F,8'hAE,8'h00,8'h04,8'h2F,8'hAE,8'h00,8'h04,8'h2F,8'hAE,8'h00,8'h04,8'h2F,8'hAE,8'h00,8'h04,8'h2F,8'hAE,8'h00,8'h04,8'h2F,8'hAE,8'h00,
	8'h04,8'h2F,8'hAE,8'h00,8'h04,8'h2F,8'hAE,8'h00,8'h04,8'h2F,8'hAE,8'h00,8'h04,8'h2F,8'hAE,8'h00,8'h04,8'h2F,8'hAE,8'h00,8'h04,8'h2F,8'hAE,8'h00,8'h04,8'h2F,8'hAE,8'h00,8'h04,8'h2F,8'hAE,8'h00,
	8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,
	8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00,8'h04,8'h2C,8'hAE,8'h00
	};

// I2C_Interface for test bench
//wire	oSCLOE , oSDAOE;
//assign	SDA				=	(!oSDAOE)	?	1'b0	:	1'bz;
//assign	SCL				=	(!oSCLOE)	?	1'b0	:	1'bz;
//assign	iSDA			=	SDA;


 i2c_master #(
	.ADDRESS_DATA_NUM	(1				),
	.OFFSET_DATA_NUM	(OFFSET_DATA_BYTE),
	.WRITE_DATA_NUM		(WRITE_DATA_BYTE),
	.READ_DATA_NUM		(READ_DATA_BYTE	)
	
	) mi2c_master
	(
	.RESETn 			(iRstn			),
	.SYSTEM_CLK     	(iClk			),
	.iSDA				(iSDA			),
	.oSDAOE				(oSDAOE			),
	.oSCLOE				(oSCLOE			),
	.enable_buf			(rvEnable_buf	),
	.read           	(wRead			),
	.write          	(wWrite			),
	.address        	(rv_I2c_Address	),
	.offset         	(rvI2c_Offset	),
	.w_data         	(rvI2c_WriteData),
	.state_m			(state_m		)
);



//////////////////////////////////////////////////////////////////////
//creat pipe
//////////////////////////////////////////////////////////////////////

always @(posedge iClk or negedge iRstn)
	begin
		rvSda_pipe	<=	!iRstn	?	1'b0	:	{rvSda_pipe[ 0],iSDA};
		rvScl_pipe	<=	!iRstn	?	1'b0	:	{rvScl_pipe[ 0],oSCLOE};
	end
//////////////////////////////////////////////////////////////////////	
// 4ms clock flag
//////////////////////////////////////////////////////////////////////
reg  [16:0]   clk4ms_count = 17'd0;  // 98304 x 40ns ~= 3.932ms
reg    clk4ms_flag = 1'b0;
wire v_clk4ms_flag = (clk4ms_count[6:5] == 2'b11);
wire [16:0] v_clk4ms_count = /* (clk4ms_count[16:15] == 2'b11) */(clk4ms_count[6:5] == 2'b11) ? 17'd0 : clk4ms_count + 17'd1;
always @(posedge iClk, negedge iRstn)
	if (~iRstn)
		clk4ms_count <= 17'd0;
	else
		clk4ms_count <= v_clk4ms_count;


always @(posedge iClk, negedge iRstn)
	if (~iRstn)
		clk4ms_flag <= 1'b0;
	else
		clk4ms_flag <= v_clk4ms_flag;
		
//////////////////////////////////////////////////////////////////////
//  debonce
//////////////////////////////////////////////////////////////////////
  //wire [2:0] v_enable = clk4ms_flag ? {rvEnable_buf[1:0], rEn} : rvEnable_buf;
  
always @(posedge iClk, negedge iRstn)
	if (~iRstn)
		rvEnable_buf <= 3'd0;
	else
		rvEnable_buf <= clk4ms_flag ? {rvEnable_buf[1:0], rEn} : rvEnable_buf;
//////////////////////////////////////////////////////////////////////
//i2c W ctrl for Redriver
//////////////////////////////////////////////////////////////////////


always @(posedge iClk or negedge iRstn)
	if(!iRstn)
		begin
			rRW						<=	1'b1;	
			rv_I2c_Address			<=	{8'h00};
			rvI2c_Offset			<=	{8'h00};
			rvI2c_WriteData		<=	'd0;
			rEn						<=	1'b0;
			rvTempData				<=	rvI2CWriteRamDatab;
			rvOffsetCnt				<=	'd0;
		end
	else if(state_m[7:0]==8'd2) // IDLE_W
		begin
			rvTempData				<=	(rEn)&&(rvOffsetCnt=='d0)	?	rvI2CWriteRamDatab	:	rvTempData;
			rRW						<=	1'b0;
			rv_I2c_Address			<=	{rvTempAddress[ADDRESS_NUM*7-1:ADDRESS_NUM*7-7], 1'b0}	;
			rvI2c_Offset			<=	rvTempOffset[OFFSET_NUM*8*ADDRESS_NUM-1:OFFSET_NUM*8*ADDRESS_NUM-8];
			rvI2c_WriteData		<=	rvwriteData[OFFSET_NUM*8*ADDRESS_NUM-1:OFFSET_NUM*8*ADDRESS_NUM-8];	
			
			rvOffsetCnt				<=	rvOffsetCnt;
			rEn						<=	(clk4ms_count==17'd10)?1'b1:rEn;
			
		end	
// burst write
	else if(state_m[7:0]==8'd9)  // rvI2c_Offset ack
		begin
			//rvI2c_Offset			<=	(rvI2c_Offset < OFFSET_NUM-1)&& (rvScl_pipe== 2'b01)	?	rvI2c_Offset+1'b1	:	rvI2c_Offset;
			rvOffsetCnt				<=	(rvScl_pipe	== 2'b01)	?	
										(rvOffsetCnt<OFFSET_NUM-1)?	rvOffsetCnt	+1'b1	:	1'b0
																						:	rvOffsetCnt;	
		
			//rvAddressCnt			<=	(rvScl_pipe	== 2'b01)									?	rvOffsetCnt	+1'b1	:	rvOffsetCnt;
			rvTempOffset			<=	(rvScl_pipe	== 2'b01)									?	(rvTempOffset <<8)	:	rvTempOffset;
			
			//rvTempData				<=	(rvScl_pipe	== 2'b01)									?	(rvTempData <<8)	:	rvTempData;
			//rvTempAddress			<=	(rvOffsetCnt==OFFSET_NUM-1)&&(rvScl_pipe== 2'b01)		?	(rvTempAddress <<7)	:	rvTempAddress;	//write N device
	
		end	
	else if(state_m[7:0]==8'd22)  // Stop
		begin
			//rvOffsetCnt				<=	(rvScl_pipe	== 2'b01)	?:	rvOffsetCnt;
			rvAddressCnt			<=	(rvScl_pipe	== 2'b01)&&(rvOffsetCnt=='d0)	?	rvAddressCnt+1'b1	:	rvAddressCnt;
			rvTempData				<=	(rvScl_pipe	== 2'b01)									?	(rvTempData <<8)	:	rvTempData;
			rvTempAddress			<=	(rvOffsetCnt=='d0)&&(rvScl_pipe== 2'b01)			?	(rvTempAddress <<7)	:	rvTempAddress;	//write N device
			rEn						<=	(rvOffsetCnt !='d0)|(rvAddressCnt<ADDRESS_NUM)	?	1'b0				:	1'b1;	
			rvwriteData				<=	(rvScl_pipe	== 2'b01)									?	(rvwriteData <<8)	:	rvwriteData;
			
		end

	else	
		begin
			rRW						<=	rRW;
			rv_I2c_Address			<=	rv_I2c_Address;
			rvI2c_Offset			<=	rvI2c_Offset;
			rvI2c_WriteData			<=	rvI2c_WriteData;
			rEn						<=	rEn;
			rvTempData				<=	rvTempData;
			rvwriteData				<=	rvwriteData;
		end		  
//----------------------------------------------------------------
//  read  i2cwData whhich save in ram
//----------------------------------------------------------------
//-------------------------------
// wirte counter 
//-------------------------------
/* always@(posedge iClk)
	if(!iRstn)
		rvCnt	<=	'd0;
	else	
		rvCnt	<=	rvCnt +	'd1; */
		
//-------------------------------
// read data state control
//-------------------------------		
always@(negedge iClk)
	if(!iRstn)
		begin
			rvReadAddrb			<=	'b0;
			rReadEn				<=	'b0;
			rvI2CWriteRamDatab	<=	wvReadDatab;
		end
	else if (rNext_Device)
		begin
			rvReadAddrb			<=	rvReadAddrb	+	1'b1;
			rReadEn				<=	'b1;
			rvI2CWriteRamDatab	<=	rvI2CWriteRamDatab;
		end
	else
		begin
			rvReadAddrb			<=	rvReadAddrb;
			rReadEn				<=	'b1;
			rvI2CWriteRamDatab	<= 	wvReadDatab;
		end
/* always@(negedge iClk)
	if(!iRstn)
		begin
			rWriteEn		<=	'd0;
			rvWriteDataa	<=	'd0;
			rvWriteAddra	<=	'd0;
			rvReadAddrb		<=	'd0;
			rReadEn			<=	'd0;
		end
	else if 	((rvCnt>0'd0) && (rvCnt<'d33))
		begin
			rWriteEn		<=	'd0;
			rvWriteDataa	<=	'd0;
			rvWriteAddra	<=	'd0;
			rvReadAddrb		<=	rvReadAddrb	+	'd1;
			rReadEn			<=	'd1;
		end
	else if		((rvCnt>'d100) && (rvCnt<'d133))
		begin
			rWriteEn		<=	'd0;
			rReadEn			<=	'd1;
			rvWriteDataa	<=	'd0;
			rvWriteAddra	<=	'd0;
			rvReadAddrb		<=	rvReadAddrb	+	'd1;	
		end
	else
		begin
			rWriteEn		<=	'd0;
			rReadEn			<=	'd0;
			rvWriteDataa	<=	'd0;
			rvWriteAddra	<=	'd0;
			rvReadAddrb		<=	'd0;
		end
	 */
	 
	 
// ram2port	ram2port_inst (
//	// output q delay 1 clock can set by IP parameter
//	.clock			( iClk ),
//	//port A	
//	.address_a		(rvWriteAddra	),
//	.wren_a			(rWriteEn		),
//	.rden_a			(1'b0 			),
//	.data_a			(rvWriteDataa	),
//	.q_a			(wvReadDataa	),	
//	//port B	
//	.address_b		(rvAddressCnt),//rvReadAddrb),
//	.rden_b			(rReadEn		),
//	.wren_b			(1'b0			),
//	.data_b			(64'd0			),
//	.q_b			(wvReadDatab	)  
//); 
	
	
endmodule
