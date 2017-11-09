module i2c_slave_t_top(
	input   iRstn, iClk,
	// I2C_Interface for test bench
	input  SCL,
	inout   SDA

);
// I2C_Interface for test bench
wire	oSCLOE , oSDAOE;
assign	SDA				=	(!oSDAOE)	?	1'b0	:	1'bz;
//assign	SCL				=	(!oSCLOE)	?	1'b0	:	1'bz;
assign	iSDA			=	SDA;

i2c_slave_t#(
  .slave_addr   ( 7'h23 ),
  .TX_DATA_BYTE ( 1     )

)   i2c_slave_t_inst
(
	.RESETn      ( iRstn    ),
   .SYSTEM_CLK  ( iClk     ),
	.iSCL        ( SCL      ),
	.iSDA        ( iSDA     ),
   .oSDA        ( oSDAOE   ),
	.tx_data     ( 8'hA5    ),
	.rx_address	 (  ),
	.rx_data     (  ),
	.rx_offset   (  ),
	.owrite_en   (  ),
	.oread_en    (  )
);

endmodule