`timescale 1 ns/100 ps
module tb_i2c_master();
////////////////////////////////////////
reg		RESETn, SYSTEM_CLK;
wire	SCL;
wire	SDA;
reg		enable;
reg		read	= 1'b1;
reg		write	= 1'b0;
reg	[7:0]	address	=	{8'b0100_0110}	;
reg	[7:0]	offset	=	{8'h5A};
reg	[7:0]	w_data	=	{8'h5A};
reg	[2:0]	enable_buf;
wire[7:0]	state_m;


i2c_master_ctrl mi2c_master_ctrl(
	.RESETn 		(RESETn			),
	.SYSTEM_CLK     (SYSTEM_CLK		),
	.SCL            (SCL),
	.SDA            (SDA)
	
	//.iSDA			(iSDA			),
	//.oSDAOE			(oSDAOE			),
	//.oSCLOE			(oSCLOE			)
);

/*  i2c_master #(
	.ADDRESS_DATA_NUM	(1),
	.OFFSET_DATA_NUM	(1),
	.WRITE_DATA_NUM		(1),
	.READ_DATA_NUM		(1)
	
	) mi2c_master
	(
	.RESETn 		(RESETn 	),
	.SYSTEM_CLK     (SYSTEM_CLK ),
	.SCL            (SCL        ),
	.SDA            (SDA        ),
	.enable_buf     (enable_buf ),
	.read           (read       ),
	.write          (write      ),
	.address        (address    ),
	.offset         (offset     ),
	.w_data         (w_data     ),
	.state_m		(state_m	)
);
 */
//////////////////////////////////////////////////////////////////
//reg		RESETn, SYSTEM_CLK;
//wire	SCL, SDA;
wire	[7:0]rx_offset;
wire	[7:0]rx_data;
wire	[7:0]rx_address;
reg		[7:0]tx_data=8'hA0;
wire	owrite_en;
wire	oread_en;
 i2c_slave U01  ( 
				.RESETn     ( RESETn     ),
				.SYSTEM_CLK ( SYSTEM_CLK ),
				// I2C_Interface
				.SCL        ( SCL        ),
				.SDA        ( SDA        ),
				.tx_data	 ( tx_data    ),
				.rx_address ( rx_address ),
				.rx_data	 ( rx_data    ),
				.rx_offset	 ( rx_offset  ),
				.owrite_en  ( owrite_en  ),
				.oread_en   ( oread_en   )
			   );
//////////////////////////////////////////////////////////////////			   
//////////////////////////////////////////////////////////////////////////////////////////////////////
//parameter
//////////////////////////////////////////////////////////////////////////////////////////////////////
pullup(pull1) p00( SCL );
pullup(pull1) p01( SDA );

parameter time_unit      = 1;					//1ns
parameter clk_time       = 40 * time_unit;   	// 2.5MHz
parameter clk_time_div2  = ( clk_time /   2 );	//1.25Mhz
parameter clk_time_div10 = ( clk_time / 100 );	//4ns,250Mhz 
parameter wait_time      = clk_time * 1000; 	//400ns*1000
parameter wait_long_time = clk_time * 10000;	//1310us
//////////////////////////////////////////////////////////////////////////////////////////////////////
//SYSTEM_CLK
//////////////////////////////////////////////////////////////////////////////////////////////////////
initial
begin
					SYSTEM_CLK = 1'b1;
  forever
	#clk_time_div2	SYSTEM_CLK = ~SYSTEM_CLK;
end
//////////////////////////////////////////////////////////////////////////////////////////////////////
//RESETn
//////////////////////////////////////////////////////////////////////////////////////////////////////initial
initial
begin				
					enable_buf	=	3'b000;
					RESETn	=	1'b0;
					enable	=	1'b0;	
	# wait_time		RESETn	=	1'b1;
	# wait_time		enable_buf	=	3'b000;
	# wait_time		enable_buf	=	3'b001;
	# wait_time		enable_buf	=	3'b011;
	# wait_time		enable_buf	=	3'b111;
end
endmodule