`timescale 1 ns/10 ps
module tb_spi_slave;
parameter DATA_WIDTH =32;
reg	rCLK;
reg	reset; 
reg rSys_clk;
reg	rLRCLK;
reg rSDATA;
reg[DATA_WIDTH-1:0] rand;
wire oSDATA;
wire oSCLK;
wire oLRCLK;
i2s_tx #(	.DATA_WIDTH		(DATA_WIDTH),
			.LRCLK_SPEED	(200),//unit khz
			.CORECLK_SPEED	(50)//unit Mhz		
)i2s_tx_inst(
	.iRstn			(	!reset			),
	.iClk			(	rSys_clk		),
	.oSCLK			(	oSCLK			),
	.oLRCLK			(	oLRCLK			), 
	.oSDATA			(	oSDATA			),	 
	.ivLEFT_DATA	(	rand  			),
	.ivRIGHT_DATA	(	rand			)      
);


i2s_rx#(.DATA_WIDTH(DATA_WIDTH)
)i2s_rx_inst(
	.iRstn			(	!reset			),
	.iSCLK			(	oSCLK           ),
	.iLRCLK			(	oLRCLK			), 
	.iSDATA			(	oSDATA			),	 
	.ovLEFT_DATA	(					),
	.ovRIGHT_DATA	(					)      
);

i2s_rx_opencore#(.AUDIO_DW(DATA_WIDTH)
)i2s_rx_opencore_inst(

	.rst			(	1'b0			),
	.sclk			(	rCLK            ),
	.lrclk			(	rLRCLK			), 
	.sdata			(	rSDATA			),	 
	.left_chan		(					),
	.right_chan		(					)      
);

//i2s_tx_opencore #(.AUDIO_DW(32)
//)i2s_tx_opencore_inst(
//	.rst			(	1'b0			),
//	.sclk			(	rCLK            ),
//	.lrclk			(	rLRCLK			),
//	.sdata			(	rSDATA			),
//	.left_chan		(	rand            ),
//	.right_chan		(	rand			), 
//	.prescaler		(					)
//);


		 
	parameter time_unit = 1;
    parameter clk_time  = 10 * time_unit;   
	parameter pclk_8Mhz  = 60 * time_unit;   // 8MHZ
	parameter pclk_8MhzX2= 60 * 2;   // 8MHZ	
    parameter pLRCLK = (pclk_8Mhz*DATA_WIDTH*2); //5000ns
	
initial
begin
    reset = 1;
    while(1)
        #100 reset = 0;

end

initial
begin
    rSys_clk = 0;
    forever
		#clk_time rSys_clk = ~rSys_clk;  

end



//rCLK  
initial
	begin
	  rCLK = 1'b0;
	  forever
		#pclk_8Mhz rCLK = ~rCLK;  
	end
//rLRCLK
initial
	begin
	  rLRCLK = 1'b1;
	  //#pclk_8Mhz
	  forever
		#pLRCLK rLRCLK = ~rLRCLK;  
	end	

initial
	begin
		#pclk_8MhzX2
		forever
		begin
			rand={$random};
			//I2S_WRITE(rand);
			I2S_WRITE(32'ha5a5a5a5);
			
		end
	end		
		
integer i;
task I2S_WRITE;
input[DATA_WIDTH-1:0]rvData_32;
begin	
	//rSDATA 
	//rSDATA = 0;
	for ( i=DATA_WIDTH-1; i>=0; i=i-1 )
		begin
			#pclk_8MhzX2  rSDATA = rvData_32[i];
		end


end
endtask





endmodule
