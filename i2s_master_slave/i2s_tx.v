//================================================
// I2S TX Module
// Auther:Mark
// Date:2017/05/22
//================================================
module	i2s_tx#(
	parameter	DATA_WIDTH		=	32,
	parameter	LRCLK_SPEED		=	200,//unit khz
	parameter	CORECLK_SPEED	=	50,//unit Mhz	
	parameter	SCLK_SPEED		=	LRCLK_SPEED*DATA_WIDTH//unit khz	
	
	
)(

// Clock & Resetn
	input  iClk,
	input  iRstn,

// I2s_sig
	output oSCLK,
	output oLRCLK,  // 1: L-channel , 2: R-channel
	output oSDATA,	 
	
// Local Bus Signal
	input  [DATA_WIDTH-1:0] ivLEFT_DATA ,
	input  [DATA_WIDTH-1:0] ivRIGHT_DATA    
	
);
parameter SCLK_PRESCALE = (CORECLK_SPEED*1000)/SCLK_SPEED; //core clk(Mhz)*1000/i2s_clk(Khz)

reg [15:0] rvClkcnt;
reg [15:0] rvLRCLKcnt;
wire [DATA_WIDTH-1:0] wvTx_Data;
reg rSCLK;
reg rLRCLK;
reg rSDATA;
wire wSCLK_change = (rvClkcnt==0);
wire wSCLK_fall = (rvClkcnt==0)&(rvLRCLKcnt%2==0);
wire wLoad = (rvClkcnt==0)&(rvLRCLKcnt==1);
always@(posedge iClk)
begin
if(!iRstn)
	begin
		rvClkcnt	<= 0;
		rSCLK		<= 0;
		rLRCLK		<= 0;	
		rvLRCLKcnt	<= 0;
		rSDATA		<= 0;
	end
else
	begin
		rvClkcnt	<= (rvClkcnt == 0) ? (SCLK_PRESCALE/2)-1 : rvClkcnt - 16'b1;
		rvLRCLKcnt	<= (rvLRCLKcnt == 0)		?	DATA_WIDTH*2	:
							(rvClkcnt==0)	?	(rvLRCLKcnt - 1'b1) : rvLRCLKcnt;
							
		rSCLK		<= (rvClkcnt==0)	?	~rSCLK	:	rSCLK;
		rLRCLK		<= ((rvLRCLKcnt==2)&& wSCLK_change )	?	~rLRCLK	:	rLRCLK;
		
		rSDATA		<= wSCLK_fall	?	wvTx_Data[(rvLRCLKcnt/2-1)]	:	rSDATA;
	end
end	

//tx select

assign wvTx_Data =	(!wLoad)	?	wvTx_Data	:
					(rLRCLK)	?	ivLEFT_DATA : ivRIGHT_DATA;


assign oSCLK	=	rSCLK;
assign oLRCLK	=	rLRCLK;
assign oSDATA	=	rSDATA;

					
					
					
endmodule
