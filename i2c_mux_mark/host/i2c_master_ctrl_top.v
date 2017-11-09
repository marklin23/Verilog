module i2c_master_ctrl_top(
	input   iRstn, iClk,
	// I2C_Interface for test bench
	output  SCL,
	inout   SDA

);
// I2C_Interface for test bench
wire	oSCLOE , oSDAOE;
assign	SDA				=	(!oSDAOE)	?	1'b0	:	1'bz;
assign	SCL				=	(!oSCLOE)	?	1'b0	:	1'bz;
assign	iSDA			=	SDA;




i2c_master_ctrl mi2c_master_ctrl(

	.iRstn          ( iRstn         ),
	.iClk           ( iClk          ),                
	.iSDA           ( iSDA          ),
	.oSDAOE         ( oSDAOE        ),
	.oSCLOE         ( oSCLOE        )
	
);

endmodule