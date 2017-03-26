//================================================
//SPI MASTER TX RX MODULE
//Auther: Mark
//Data: 2017/03/07
//parameterize DATA_WIDTH
//TX sent iTx_Data MSB first
//RX store  oRx_Data shift from MSB to LSB
//================================================
module spi_master#(
	parameter	DATA_WIDTH	=	10
)(
	input	iClk,
	input	iRstn,
	// SPI Signal
	output	oSCLK,    // SPI clock
	output	oSSn,     // Slave select lines
	output	oMOSI,    // Master out slave in
	input	iMISO,    // Master in slave out
	// Data Send Receive
	input	[DATA_WIDTH-1:0]	iTx_Data,
	output reg	[DATA_WIDTH-1:0]oRx_Data

);

reg [DATA_WIDTH-1:0]	rRX_Data;
reg [32:0]				rvSPI_CNT;   
reg						rSPI_CLK;
reg						rSPI_CS;
reg						rMOSI;
reg						rreadvaild;
wire					wMISO;
reg [7:0]				rvDelay;

assign	wMISO	=	iMISO;
assign	oMOSI	=	rMOSI;
assign	oSSn	=	rSPI_CS;
assign	oSCLK	=	rSPI_CLK;


//SPI MASTER CTRL
always@(posedge iClk or negedge iRstn)
begin
    if (!iRstn) 
		begin
			rvDelay    <= 0;
			rvSPI_CNT  <= 7'd0;
			rSPI_CLK  <= 1'd0;
		end 
	else 
		begin
			if (!rvDelay[7]) 
				begin
					rvSPI_CNT		<= 7'd0;
					rvDelay			<= rvDelay + 8'd1;
				end 
			else 
				begin
					if (rvSPI_CNT<DATA_WIDTH*2+22) 
						begin
							rvSPI_CNT	<= rvSPI_CNT + 7'd1;
							rvDelay		<=	rvDelay;
						end 
					else 
						begin
							rvSPI_CNT	<=	rvSPI_CNT;
							rvDelay		<= 8'd0;
						end
				end
        
        
        if (rvSPI_CNT >= 12 && rvSPI_CNT < (DATA_WIDTH*2+12))
			begin
				rSPI_CLK <= rvSPI_CNT[0]; 
			end 
		else 
			begin
				rSPI_CLK <= 1'b0; 
			end  
    end
end
//--------------------------------------------------
//MOSI 
//--------------------------------------------------		
always@(posedge iClk or  negedge iRstn)
	if(!iRstn)
		begin
			rSPI_CS			<= 1'd1;
			rMOSI			<= 1'd0;
		end
	else 
		begin	
				rSPI_CS		<=	(rvSPI_CNT<4||rvSPI_CNT>(DATA_WIDTH*2+12+15))	?	1'b1	:	1'b0	;
				
				
				rMOSI 		<=	(rvSPI_CNT<=13||rvSPI_CNT>=DATA_WIDTH*2+12)	?	1'b0	:
											(rvSPI_CNT%2==0)	?	iTx_Data[DATA_WIDTH-(rvSPI_CNT-12)/2-1]	:	rMOSI;
										
		end
    
//--------------------------------------------------
//MISO
//--------------------------------------------------
integer i;
 
always@(negedge iClk or negedge iRstn)
	if(!iRstn)
		begin
			rRX_Data		<=	{DATA_WIDTH{1'b0}};
			rreadvaild		<=	rreadvaild;
		end
	else 
		begin		
			for(i=15;i<DATA_WIDTH*2+15;i=i+2)		
				begin
					case (rvSPI_CNT)
							i : 	rRX_Data[DATA_WIDTH-((i-15)/2)-1]	<=	wMISO;
						 // i : 	rRX_Data[DATA_WIDTH-(i/2)-15-1]	<=	wMISO;
					endcase
				end
			
			rreadvaild	<=	rvSPI_CNT==(DATA_WIDTH*2+22)	?	1'b1	:	1'b0;		
		end
    

always@(posedge iClk or negedge iRstn)
	if(!iRstn)
		oRx_Data	<=	{DATA_WIDTH{1'b0}};
	else
		oRx_Data <=	(rreadvaild)	?	 rRX_Data	:	oRx_Data;



endmodule