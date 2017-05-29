//================================================
// I2S RX Module
// Auther:Mark
// Date:2017/05/22
//================================================
module	i2s_rx#(
	parameter	DATA_WIDTH	=	32
)(

// Clock & Resetn
	input  iRstn,

// I2s_sig
	input  iSCLK,
	input  iLRCLK,  // 1: L-channel , 2: R-channel
	input  iSDATA,	 
	
// Local Bus Signal
	output reg[DATA_WIDTH-1:0] ovLEFT_DATA ,
	output reg[DATA_WIDTH-1:0] ovRIGHT_DATA      
);

reg [DATA_WIDTH-1:0]  rRX_Data=0;
reg [1:0]             rLRCLK_Buf=0;

wire rLoad_L = (rLRCLK_Buf==2'b01)?1'b1:1'b0;
wire rLoad_R = (rLRCLK_Buf==2'b10)?1'b1:1'b0;

	
always@(posedge iSCLK)
begin
	rLRCLK_Buf		<=	(!iRstn)	?	2'b0				:	{rLRCLK_Buf[0],iLRCLK};
	rRX_Data		<=	(!iRstn)	?	{DATA_WIDTH{1'b0}}	:	{rRX_Data[DATA_WIDTH-2:0],iSDATA};
end	

always@(negedge iSCLK)
begin
	ovLEFT_DATA		<=	rLoad_L	? (rRX_Data) : ovLEFT_DATA;
	ovRIGHT_DATA	<=	rLoad_R ? (rRX_Data) : ovRIGHT_DATA;
end	

endmodule
