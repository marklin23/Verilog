///////////////////////////////////////////////////////
// edit by Mark 2016/12/26
// Support Repeat Start and single read
///////////////////////////////////////////////////////

module i2c_slave_t#(
	parameter slave_addr = 7'b010_0011,
   parameter TX_DATA_BYTE = 1

)   
(
	input   RESETn, SYSTEM_CLK,
	// I2C_Interface
	input   iSCL,
	input   iSDA,
   output  oSDA,
   
	input	   [TX_DATA_BYTE*8-1:0]tx_data,
	output	[6:0]rx_address,	
	output	[7:0]rx_data,
	output	[7:0]rx_offset,
	output	owrite_en,
	output	oread_en
);
	reg	[4:0]	state;
	reg	[10:0]	decode_data = 10'b0;
	reg	[4:0]	count = 5'b0;
	reg	[1:0]	sda_pipe = 2'b11;
	reg	[1:0]	scl_pipe = 2'b11;
	reg	[6:0]	address_data = 7'b0;
	reg			RW_data		;
	reg	[7:0]	offset_data	 = 8'b0;
	reg	[7:0]	write_data	= 8'b0;
	reg			tx_shift	;
	reg			sda_o;
	reg	[TX_DATA_BYTE*8-1:0]	shift_reg;
   reg         rNACK;
	assign	load	=	oread_en;
	assign	read	=	(RW_data==1'b1)?1'b1:1'b0;
	assign	write	=	(RW_data==1'b0)?1'b1:1'b0;
//////////////////////////////////////////////////////////////////////
//creat pipe
//////////////////////////////////////////////////////////////////////

	
always @(posedge SYSTEM_CLK or negedge RESETn)
	begin
		sda_pipe	<=	!RESETn	?	1'b0	:	{sda_pipe[0],iSDA};
		scl_pipe	<=	!RESETn	?	1'b0	:	{scl_pipe[0],iSCL};
	end

//////////////////////////////////////////////////////////////////////
//bit-counter
//////////////////////////////////////////////////////////////////////

always @(posedge SYSTEM_CLK or negedge RESETn)
	if(!RESETn)
		count	<=	5'b0;
	else if(((scl_pipe== 2'b11)&&(sda_pipe==2'b10))||((scl_pipe== 2'b11)&&(sda_pipe==2'b01)))
		count	<=	5'b0;
	else if (scl_pipe==2'b10)
		count	<=	((count==5'd9))	?	5'b1	:	count	+	1'b1;
		


//////////////////////////////////////////////////////////////////////
//	 TX  SHIFT
//////////////////////////////////////////////////////////////////////
always @(posedge SYSTEM_CLK or negedge RESETn)
 	if(!RESETn)
		shift_reg[TX_DATA_BYTE*8-1:0]	<=	8'b0;
	else 
		begin
			if(load)
					shift_reg	<=	tx_data[TX_DATA_BYTE*8-1:0];
			else if((tx_shift==1'b1) && (scl_pipe== 2'b10))
					shift_reg	<=	{shift_reg[TX_DATA_BYTE*8-2:0],1'b0};
		end		
		


//////////////////////////////////////////////////////////////////////
//state machine decode_data tx_shift
//////////////////////////////////////////////////////////////////////
	parameter	IDLE		=	4'd1;
	parameter	ADDRESS		=	4'd2;
	parameter	RW			=	4'd3;
	parameter	ADDRESS_ACK	=	4'd4;
	parameter	OFFSET		=	4'd5;
	parameter	OFFSET_ACK	=	4'd6;
	parameter	W_DATA		=	4'd7;
	parameter	R_DATA		=	4'd8;
	parameter	ACK_WR		=	4'd9;
	parameter	ACK_RD		=	4'd10;
	parameter	WAIT_STOP	=	4'd11;
	parameter	STOP		=	4'd12;

always @(posedge SYSTEM_CLK or negedge RESETn)
	if(!RESETn)
		begin
			state			<=	IDLE;
			decode_data <=	11'b0;
			tx_shift		<=	1'b0;
         rNACK       <= 1'b0;
		end
	else if ((scl_pipe== 2'b11)&&(sda_pipe==2'b10))
		begin
			state			<=	/* (state!=IDLE)	?	OFFSET	:	 */IDLE;
			tx_shift		<=	1'b0;
		end
	else if	((scl_pipe== 2'b11)&&(sda_pipe==2'b01))
		begin
			state			<=	STOP;
			tx_shift		<=	1'b0;
		end
	else
		begin
		case(state)
			
			IDLE:	begin
						state       <=	ADDRESS;
						decode_data <=	decode_data;
						tx_shift    <=	1'b0;
                  rNACK       <= 1'b0;
					end
			ADDRESS:begin
						state       <=	(count==5'd9)		?	ADDRESS_ACK		:	ADDRESS;
						decode_data <=	(scl_pipe== 2'b01)	?	{decode_data[9:0],iSDA}	:	decode_data;
						tx_shift    <=	1'b0;
					end					
			ADDRESS_ACK:	begin
						state       <=	((address_data[6:0] == slave_addr)&&(scl_pipe== 2'b10))?	((RW_data==1'b0)?OFFSET:R_DATA)
																															:	ADDRESS_ACK;
						tx_shift    <=	1'b0;
					end		
			
			OFFSET:	begin
						state       <=	(count==5'd9)			?	OFFSET_ACK		:	OFFSET;
						decode_data <=	(scl_pipe== 2'b01)	?	{decode_data[9:0],iSDA}	:	decode_data;
						tx_shift    <=	1'b0;
					end	
			OFFSET_ACK:	begin
						state       <=	(scl_pipe!= 2'b10)	?	OFFSET_ACK	:	W_DATA;
						tx_shift    <=	(read)?	1'b1	:	1'b0;			
					end
			W_DATA:	begin
						decode_data <=	(scl_pipe== 2'b01)	?	{decode_data[9:0],iSDA}	:	decode_data;
						state       <=	(count==5'd9)			?	ACK_WR		:	W_DATA;
						tx_shift    <=	1'b0;
					end
					
			R_DATA:	begin

						state       <=	(scl_pipe== 2'b10)&&(count==5'd8)	?	ACK_RD		:	R_DATA;
                  //decode_data	<=	decode_data;
						tx_shift    <=	1'b1;
					end
					
			ACK_WR:	begin
						decode_data <= decode_data;
						tx_shift    <=	1'b0;
						state       <=	(count==5'd1)		?	WAIT_STOP		:	ACK_WR;
					end
			ACK_RD:begin
						decode_data <= decode_data;
						tx_shift    <=	1'b0; 
                  rNACK       <= ((scl_pipe== 2'b01)&&(iSDA==1'b1))  ?  1'b1           : rNACK;
						state       <=	(scl_pipe== 2'b01)&&(iSDA==1'b1)    ?	WAIT_STOP      : 
                                 (scl_pipe== 2'b10)                  ?  R_DATA         : ACK_RD;
					end
			WAIT_STOP:
						state       <=	state;
                  
			STOP:
						state       <=	state;
			default:begin
						state       <=	IDLE;
                  rNACK       <= rNACK;
						tx_shift    <=	1'b0;	
					end
					
		
		endcase
		end
//////////////////////////////////////////////////////////////////////
//data-capture
//////////////////////////////////////////////////////////////////////
always @(posedge SYSTEM_CLK or negedge RESETn)
	if(!RESETn)
		begin
			address_data	<=	7'b0;
			RW_data			<=	1'b0;
			offset_data		<=	8'b0;
			write_data		<=	8'b0;
		end
	else	
		begin 
			case(state)
			 	IDLE	:
					begin
						address_data	<=	address_data;
						RW_data			<=	1'b0;
						offset_data		<=	offset_data;
						write_data		<=	8'b0;
					end 
				ADDRESS_ACK		:
					begin
						address_data	<=	decode_data[7:1];
						RW_data			<=	decode_data[0];
					end				
			
				OFFSET_ACK	:
					begin
						offset_data		<=	decode_data;
					end				
			
				ACK_WR	:
					begin
						write_data		<=	decode_data;
						offset_data		<=	offset_data;
					end	
				STOP	:
					begin
						address_data	<=	address_data;
						RW_data			<=	RW_data;
						offset_data		<=	offset_data;
						write_data		<=	write_data;
					end	
				default:
					begin
						address_data	<=	address_data;
						RW_data			<=	RW_data;
						offset_data		<=	offset_data;
						write_data		<=	write_data;
					end
			endcase
		end




//////////////////////////////////////////////////////////////////////
//	 TX  SDA_o
//////////////////////////////////////////////////////////////////////
always @(posedge SYSTEM_CLK or negedge RESETn)
	if(!RESETn)
		sda_o	<=	1'b1;
	else if ((scl_pipe== 2'b11)&&(sda_pipe==2'b10))
		sda_o	<=	1'b1;
	else if	((scl_pipe== 2'b11)&&(sda_pipe==2'b01))
		sda_o	<=	1'b1;
	else	
		begin 
			if (state[4:0] == ADDRESS_ACK)
				sda_o	<=	(address_data[6:0] == slave_addr)	?	1'b0	:	1'b1;
			else if (state[4:0] == OFFSET_ACK)
				sda_o	<=	((count==5'd9)) ? 1'b0 : 1'b1;
			else if	(state[4:0] == ACK_WR)
				sda_o	<=	(count==5'd9) ? 1'b0 : 1'b1;
			else if	(state[4:0] == ACK_RD)
				sda_o	<=	1'b1;
 			else if	(tx_shift)	 
				sda_o	<=	shift_reg[TX_DATA_BYTE*8-1]; 
			else
				sda_o	<=	1'b1;
		end	
//////////////////////////////////////////////////////////////////////
//	Decode Data and Register W/R enable
//////////////////////////////////////////////////////////////////////
	assign	rx_address	=	address_data[6:0];
	assign	rx_data		=	write_data	[7:0];
	assign	rx_offset	=	offset_data	[7:0];
	assign	owrite_en	=	((state[4:0] == ACK_WR/* WAIT_STOP */	)	&&	write	)?	1'b1:1'b0;
	assign	oread_en	=	((state[4:0] == ADDRESS_ACK	)	&&	read	)?	1'b1:1'b0;
	assign	oSDA		=	sda_o;

endmodule