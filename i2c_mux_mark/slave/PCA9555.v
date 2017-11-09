//***************************************************************************
//* 	Date:		2017/04/13
//*	Description:	PCA9555
//*	Clock:		25Mhz
//*	Author:		Galaxy_Mark
//* 	Status:		IN/ OUT function 
//***************************************************************************
//          Register Map   
//  Descriptions:
//            |Reg  0 | Reg 1 | Reg 2    | Reg 3    | Reg 4   | Reg 5    | Reg 6    | Reg 7   
//            |In 0    | In 1    | Out 0   | Out 1    | Pol 0    | Pol 1      | Conf0   | Conf1   
//            |Rd       | Rd      | Rd/Wr | Rd/Wr | Rd/Wr | Rd/Wr | Rd/Wr | Rd/Wr 
//Statu    |good   |good   |good       |good     |poor      |poor       |poor       |poor     
//***************************************************************************
module PCA9555 
(
	input           iClk,                
	input           iRstn,                    
	input           iSCL,
	input           iSDA,
	output          onSDAOE,
	input   [6:0]   iModule_Address, 
	input   [7:0]   ivIO0,
	output  [7:0]   ovIO0,                   
	output  [7:0]   onvOE0,                    
	input   [7:0]   ivIO1,     			
	output  [7:0]   ovIO1,  			
	output  [7:0]   onvOE1,
	output          onIntOE   
     
);
	
	wire  [7:0]	rx_data;
	reg   [7:0]	tx_data;
	wire  [6:0]	rx_address;
	wire  [7:0]	rx_offset;
	wire        owrite_en;
	wire        oread_en;
	wire  [1:0] r_data_cnt;   // for port0 and port1 read
	wire  [1:0] w_data_cnt;	  // for port0 and port 1 write
	wire  [4:0] iSCL_count;
	reg         rINT;
	wire  [4:0] wstate;
	reg   [7:0]	rvSMBusReg00_a;
	reg   [7:0]	rvSMBusReg01_a;	
	reg   [7:0]	rvSMBusReg02_a;
	reg   [7:0]	rvSMBusReg03_a;
	reg   [7:0]	rvSMBusReg04_a;
	reg   [7:0]	rvSMBusReg05_a;
	reg   [7:0]	rvSMBusReg06_a;
	reg   [7:0]	rvSMBusReg07_a;
	 
	

//////////////////////////////////////////////////////////////////////
// IO Settings
//////////////////////////////////////////////////////////////////////
//reg [8:0] rvOutput0;
//reg [8:0] rvOutput1;
assign ovIO0 = rvSMBusReg02_a;
assign ovIO1 = rvSMBusReg03_a;

always @(posedge iClk)
	begin
		rvSMBusReg00_a <= ivIO0;
		rvSMBusReg01_a <= ivIO1;
	end
reg ronSDAOE1;
reg ronSDAOE2;
always@(posedge iClk)	
begin
	ronSDAOE1	<= onSDAOE;
	ronSDAOE2	<= ronSDAOE1;
end


	
	
//////////////////////////////////////////////////////////////////////
//Slave INT operation
//////////////////////////////////////////////////////////////////////
//Slave INT operation
assign onIntOE = 	rINT;
always @(posedge iClk or negedge iRstn)
	if(!iRstn)
		rINT	<=	1'b1;	
	else if ( ((|(rvSMBusReg00_a[7:0] ^ ivIO0[7:0])) || (|(rvSMBusReg01_a[7:0] ^ ivIO1[7:0]))) /*&& ( ) */)
		rINT	<=	1'b0;	
	else if( ~ronSDAOE2 &&(wstate[4:0] == 4'd10))//((iSCL_count == 5'd9)&&(rx_address == iModule_Address[6:0]))
		rINT	<=	1'b1;
	else
		rINT	<=	rINT;
//////////////////////////////////////////////////////////////////////
//Host Write operation
//////////////////////////////////////////////////////////////////////

always @(posedge iClk or negedge iRstn)
	if(!iRstn)
		begin
			rvSMBusReg02_a	<=	8'hff;
			rvSMBusReg03_a	<=	8'hff;
			rvSMBusReg04_a	<=	8'h00;
			rvSMBusReg05_a	<=	8'h00;
			rvSMBusReg06_a	<=	8'hff;
			rvSMBusReg07_a	<=	8'hff;
			
		end
	else if (rx_offset==8'h02 && owrite_en)
		begin
			rvSMBusReg02_a	<=	(w_data_cnt==2'd1)	?	rx_data[7:0]	:	rvSMBusReg02_a;
			rvSMBusReg03_a	<=	(w_data_cnt==2'd2)	?	rx_data[7:0]	:	rvSMBusReg03_a;		
		end
	else if (rx_offset==8'h03 && owrite_en)
		begin
			rvSMBusReg03_a	<=	(w_data_cnt==2'd1)	?	rx_data[7:0]	:	rvSMBusReg03_a;
			rvSMBusReg02_a	<=	(w_data_cnt==2'd2)	?	rx_data[7:0]	:	rvSMBusReg02_a;			
		end
	else if (rx_offset==8'h04 && owrite_en)
		begin
			rvSMBusReg04_a	<=	(w_data_cnt==2'd1)	?	rx_data[7:0]	:	rvSMBusReg04_a;
			rvSMBusReg05_a	<=	(w_data_cnt==2'd2)	?	rx_data[7:0]	:	rvSMBusReg05_a;		
		end
	else if (rx_offset==8'h05 && owrite_en)
		begin
			rvSMBusReg05_a	<=	(w_data_cnt==2'd1)	?	rx_data[7:0]	:	rvSMBusReg05_a;
			rvSMBusReg04_a	<=	(w_data_cnt==2'd2)	?	rx_data[7:0]	:	rvSMBusReg04_a;		
		end
	else if (rx_offset==8'h06 && owrite_en)
		begin
			rvSMBusReg06_a	<=	(w_data_cnt==2'd1)	?	rx_data[7:0]	:	rvSMBusReg06_a;
			rvSMBusReg07_a	<=	(w_data_cnt==2'd2)	?	rx_data[7:0]	:	rvSMBusReg07_a;		
		end
	else if (rx_offset==8'h07 && owrite_en)
		begin
			rvSMBusReg07_a	<=	(w_data_cnt==2'd1)	?	rx_data[7:0]	:	rvSMBusReg07_a;
			rvSMBusReg06_a	<=	(w_data_cnt==2'd2)	?	rx_data[7:0]	:	rvSMBusReg06_a;		
		end	
	else	
		begin
			rvSMBusReg02_a	<=	rvSMBusReg02_a[7:0];
			rvSMBusReg03_a	<=	rvSMBusReg03_a[7:0];
			rvSMBusReg04_a	<=	rvSMBusReg04_a[7:0];
			rvSMBusReg05_a	<=	rvSMBusReg05_a[7:0];	
			rvSMBusReg06_a	<=	rvSMBusReg06_a[7:0];	
			rvSMBusReg07_a	<=	rvSMBusReg07_a[7:0];
		end  
//////////////////////////////////////////////////////////////////////
//Host Read operation
//////////////////////////////////////////////////////////////////////

	always @(posedge iClk or negedge iRstn)
	if(!iRstn)
			tx_data	<=	7'b0;
	else if (oread_en)
		begin
			case(rx_offset)
					8'h00:
					begin
						tx_data		<=	(r_data_cnt==2'b00)	?	rvSMBusReg00_a[7:0]	:	rvSMBusReg01_a[7:0];
					end	
							
					8'h01:	
					begin	
						tx_data		<=	(r_data_cnt==2'b00)	?	rvSMBusReg01_a[7:0]	:	rvSMBusReg00_a[7:0];
					end	
					8'h02:	
					begin	
						tx_data		<=	(r_data_cnt==2'b00)	?	rvSMBusReg02_a[7:0]	:	rvSMBusReg03_a[7:0]	;
					end				
					8'h03:	
					begin	
						tx_data		<=	(r_data_cnt==2'b00)	?	rvSMBusReg02_a[7:0]	:	rvSMBusReg03_a[7:0]	;
					end		
					8'h04:	
					begin	
						tx_data		<=	(r_data_cnt==2'b00)	?	rvSMBusReg04_a[7:0]	:	rvSMBusReg05_a[7:0]	;
					end		
					8'h05:	
					begin	
						tx_data		<=	(r_data_cnt==2'b00)	?	rvSMBusReg04_a[7:0]	:	rvSMBusReg05_a[7:0]	;
					end		
					8'h06:	
					begin	
						tx_data		<=	(r_data_cnt==2'b00)	?	rvSMBusReg06_a[7:0]	:	rvSMBusReg07_a[7:0]	;
					end		
					8'h07:	
					begin	
						tx_data		<=	(r_data_cnt==2'b00)	?	rvSMBusReg06_a[7:0]	:	rvSMBusReg07_a[7:0]	;
					end				
					default:
						tx_data	<=	rvSMBusReg00_a[7:0];
				
			endcase
		end

//////////////////////////////////////////////////////////////////////
//I2C SLAVE
//////////////////////////////////////////////////////////////////////
	
i2c_slave
	mi2c_rw( 
				.RESETn         ( iRstn           ),
				.SYSTEM_CLK     ( iClk            ),
				.iSCL           ( iSCL            ),
				.iSDA           ( iSDA            ),
				.oSDA_oe        ( onSDAOE         ),
				.slave_addr     ( iModule_Address ),
				.tx_data        ( tx_data         ),
				.rx_address     ( rx_address      ),
				.rx_data        ( rx_data         ),
				.rx_offset      ( rx_offset       ),
				.owrite_en      ( owrite_en       ),
				.oread_en       ( oread_en        ),
				.r_data_cnt     ( r_data_cnt      ),
				.w_data_cnt     ( w_data_cnt      ),
				.iSCL_count     ( iSCL_count      ),
				.ostate         ( wstate          )
			   );
			   
endmodule