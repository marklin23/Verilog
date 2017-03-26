///////////////////////////////////////////////////////
// edit by Mark 2016/12/26
// Support Repeat START_W and single read
///////////////////////////////////////////////////////


module i2c_master #(
	parameter 	ADDRESS_DATA_NUM= 1,// unit byte
	parameter 	OFFSET_DATA_NUM	= 1,
	parameter 	WRITE_DATA_NUM	= 4,
	parameter 	READ_DATA_NUM	= 4
	
	)
	(
	input   RESETn, SYSTEM_CLK,
	// I2C_Interface

	//output	SCL,
	//inout   SDA,
	input	iSDA,
	output	oSDAOE,
	output  oSCLOE,	
	//i2c control sig
	input	[2:0]enable_buf,
	input	read,
	input	write,
	//tx signal
	input	[(ADDRESS_DATA_NUM*8-1)	:0]	address,
	input	[(OFFSET_DATA_NUM*8-1)	:0]	offset,
	input	[(WRITE_DATA_NUM*8-1)	:0]	w_data,
	output	reg	[7:0]	state_m
);

	reg	[4:0]	count;
	reg	[4:0]	r_cnt;
	reg	[4:0]	w_cnt;	
	reg	[1:0]	sda_pipe;
	reg	[1:0]	scl_pipe;
	reg	[1:0]	pipe_1mhz;
	reg	[6:0]	address_data;
	reg			RW_data		;
	reg	[7:0]	offset_data	;
	reg	[7:0]	write_data	;
	reg			tx_shift	;
	reg			master_ack	;
	reg			sda_o;
	reg			stop_sdaoe;
	reg	[7:0]	tx_data;
	reg	[(WRITE_DATA_NUM*8-1):0]	shift_reg;
	reg	[7:0]	shift_address;	
	reg	[7:0]	shift_offset;	
	reg	[7:0]	shift_w_data;	
	wire		clk_100khz;
	wire		clk_400khz;
	wire		clk_1mhz;
	reg		load;
	reg			clk_oe;
	reg	[7:0]	state;
	//reg	[7:0]	state_m;
	reg			nack;
	reg			clk_nack;
	reg			sr_sig;
	wire [31:0]	wcnt_1;
	wire [31:0]	wcnt_2;
	wire [31:0]	wcnt_3;
	//reg			done	=	1'b0;
	//reg			read	=	1'b0;
	//reg			write	=	1'b0;
	//reg			enable;
	assign	sclk_in	=	clk_400khz;
//////////////////////////////////////////////////////////////////////
//creat SCLK
//////////////////////////////////////////////////////////////////////	


divider	#( // for slow counter
			.Clock_IN_Frequency(25000000), //Mhz
			.Clock_OUT1_Frequency(1000000), //Mhz
			.Clock_OUT2_Frequency(400000), //400khz
			.Clock_OUT3_Frequency(100000),  //100khz
			.CNT1_WIDTH(32),
			.CNT2_WIDTH(32),
			.CNT3_WIDTH(32)
			)	divider_clk(
						.CLK_IN(SYSTEM_CLK),
						.RST_N(RESETn),
						.CLKOUT_1(clk_1mhz),//5mhz
						.CLKOUT_2(),//4hz
						.CLKOUT_3(),
						.cnt_1(),
						.cnt_2(),
						.cnt_3()
						
					);	
	
divider	#(  //for sclk
			.Clock_IN_Frequency(25000000), //Mhz
			.Clock_OUT1_Frequency(1000000), //Mhz
			.Clock_OUT2_Frequency(400000), //400khz
			.Clock_OUT3_Frequency(100000),  //100khz
			.CNT1_WIDTH(32),
			.CNT2_WIDTH(32),
			.CNT3_WIDTH(32)
			)	divider_SCLK(
						.CLK_IN(SYSTEM_CLK),
						.RST_N(clk_oe),
						.CLKOUT_1(),//5mhz
						.CLKOUT_2(clk_100khz),//4hz
						.CLKOUT_3(clk_400khz),
						.cnt_1(wcnt_1),
						.cnt_2(wcnt_2),	
						.cnt_3(wcnt_3)
						
					);		
	
	
	
//////////////////////////////////////////////////////////////////////
//creat pipe
//////////////////////////////////////////////////////////////////////

	
always @(posedge SYSTEM_CLK or negedge RESETn)
	begin
		sda_pipe	<=	!RESETn	?	1'b0	:	{sda_pipe[0],iSDA};
		scl_pipe	<=	!RESETn	?	1'b0	:	{scl_pipe[0],oSCLOE};
		pipe_1mhz	<=	!RESETn	?	1'b0	:	{pipe_1mhz[0],clk_1mhz};
	end

//////////////////////////////////////////////////////////////////////
//bit-counter
//////////////////////////////////////////////////////////////////////

always @(posedge SYSTEM_CLK or negedge RESETn)
	if(!RESETn)
		count	<=	5'b0;
	else if(((scl_pipe== 2'b11)&&(sda_pipe==2'b10))||((scl_pipe== 2'b11)&&(sda_pipe==2'b01)))
		count	<=	5'b0;
	else if (scl_pipe==2'b01)
		count	<=	((count==5'd8))	?	5'b0	:	count	+	1'b1;
		
//////////////////////////////////////////////////////////////////////
//state machine decode_data tx_shift
//////////////////////////////////////////////////////////////////////
	parameter	IDLE			=	8'd1;
	parameter	IDLE_W			=	8'd2;
	parameter	IDLE_R			=	8'd3;
	parameter	WAIT_START		=	8'd4;
	parameter	START_W			=	8'd5;
	parameter	START_R			=	8'd24;
	parameter	WAIT_STOP		=	8'd22;
	parameter	STOP			=	8'd23;

	parameter	TX_ADDRESS		=	8'd6;
	parameter	ADDRESS_ACK		=	8'd7;	
	parameter	TX_OFFSET		=	8'd8;
	parameter	OFFSET_ACK		=	8'd9;	
	parameter	TX_DATA			=	8'd10;
	parameter	TX_DATA_ACK		=	8'd11;
	parameter	NACK_WAIT_STOP	=	8'd12;
	parameter	WAIT_LAST_ACK	=	8'd13;
	
	parameter	R_TX_ADDRESS	=	8'd14;
	parameter	R_ADDRESS_ACK	=	8'd15;	
	parameter	R_TX_OFFSET		=	8'd16;
	parameter	R_OFFSET_ACK	=	8'd17;	
	parameter	RX_DATA			=	8'd18;
	parameter	RX_DATA_ACK		=	8'd19;	
	parameter	R_NACK_WAIT_STOP=	8'd20;
	parameter	R_WAIT_LAST_ACK	=	8'd21;

//////////////////////////////////////////////////////////////////////
//i2c_enable statemachine
//////////////////////////////////////////////////////////////////////	
	wire	SCL, SDA;
	reg	[31:0]	cnt;  // for start and stop cnt
	reg			sda_oe;
	assign	oSCLOE	=	SCL;
	assign	oSDAOE	=	SDA;
	
	
	assign	SCL	=	clk_nack	?	1'b0	:	((clk_oe&&!sclk_in)	?	1'b0	:	1'b1);
						
	assign	SDA	=	(!sda_o|sda_oe|stop_sdaoe)		?	1'b0	:	1'b1;

always @(posedge SYSTEM_CLK or negedge RESETn)	
	begin
		if(!RESETn)
			sda_o	<=	1'b1;
		
		else
			sda_o	<=	(wcnt_3==31'd63 &&(scl_pipe== 2'b00))?
						(master_ack	?	1'b0	: 
						!tx_shift	?	1'b1	:
						tx_shift /* (scl_pipe== 2'b10) */	?				
											shift_reg[(WRITE_DATA_NUM*8-1)]	:	sda_o):	sda_o;
	end					
	
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////	
always @(posedge SYSTEM_CLK or negedge RESETn)
	if(!RESETn)
		begin
		clk_oe		<=	1'b0;
		cnt			<=	'd0;
		tx_shift	<=	1'b0;
		nack		<=	1'b0;
		clk_nack	<=	1'b0;
		master_ack	<=	1'b0;
		sda_oe		<=	1'b0;
		w_cnt		<=	1'b0;
		r_cnt		<=	1'b0;	
		sr_sig		<=	1'b0;
		stop_sdaoe	<=	1'b0;
		state_m		<=	IDLE_W;
		end
//////////////////////////////////////////////////////////////////////
//write process
//////////////////////////////////////////////////////////////////////	
	else if(write)
		begin
			case(state_m)
			 	IDLE_W	:
					begin
						clk_oe		<=	1'b0;
						tx_shift	<=	1'b0;
						stop_sdaoe	<=	1'b0;
						/* cnt			<=	(cnt=='d10)			?			'd0	:
										(pipe_1mhz==2'b01)	?	cnt	+	'd1	:	cnt; */
						
						w_cnt		<=	'd0;
						sda_oe		<=	1'b0;
						state_m		<=	/* (cnt=='d10) */	(enable_buf==3'b011)?	WAIT_START	:IDLE_W;
					end 
				WAIT_START:
					begin
						tx_shift	<=	1'b1;
						sda_oe		<=	1'b1;
						cnt			<=	(cnt=='d10)			?			'd0	:
										(pipe_1mhz==2'b01)	?	cnt	+	'd1	:	cnt;
						
						state_m		<=	(cnt=='d10)	?	TX_ADDRESS	:	WAIT_START;
					end
				TX_ADDRESS	:
					begin
						clk_oe		<=	1'b1;
						clk_nack	<=	1'b0;
						sda_oe		<=	(wcnt_3==31'd63)?1'b0:sda_oe;
						state_m		<=	(count==5'd8)&&(scl_pipe== 2'b10)		?	ADDRESS_ACK		:	TX_ADDRESS;
						tx_shift		<=	1'b1;/* (scl_pipe== 2'b10)	?	1'b1	:	tx_shift; */
					end 
				ADDRESS_ACK:
					begin
						//nack		<=	(scl_pipe== 2'b01)&&(sda_pipe== 2'b11)	?	1'b1		:	nack;
						state_m		<=	(scl_pipe== 2'b01)						?	TX_OFFSET		:	ADDRESS_ACK;
						tx_shift	<=	1'b0;
					end
				TX_OFFSET:
					begin
						clk_oe		<=	1'b1;
						clk_nack	<=	1'b0;
						state_m		<=	(count==5'd8)&&(scl_pipe== 2'b10)		?	OFFSET_ACK		:	TX_OFFSET;
						tx_shift	<=	1'b1;
					end				
			
				OFFSET_ACK:
					begin
						//nack		<=	(scl_pipe== 2'b01)&&(sda_pipe== 2'b11)	?	1'b1		:	nack;
						state_m		<=	(scl_pipe== 2'b01)						?	TX_DATA		:	OFFSET_ACK;
						tx_shift	<=	1'b0;
					end				
			
				TX_DATA	:
					begin
						clk_oe		<=	1'b1;
						clk_nack	<=	1'b0;
						state_m		<=	(count==5'd8)&&(scl_pipe== 2'b10)		?	TX_DATA_ACK		:	TX_DATA;
						tx_shift		<=	1'b1;
					end
				TX_DATA_ACK:
					begin
						//nack		<=	(scl_pipe== 2'b01)&&(sda_pipe== 2'b11)	?	1'b1		:	nack;
						state_m		<=	(w_cnt==(WRITE_DATA_NUM-1'd1)&&scl_pipe== 2'b01)				?	WAIT_LAST_ACK:
												(scl_pipe== 2'b01				?	TX_DATA			:	TX_DATA_ACK);
						tx_shift	<=	1'b0;
						w_cnt		<=		(scl_pipe== 2'b01)?	w_cnt	+ 1'b1	:	w_cnt;
					end
				WAIT_LAST_ACK:
					begin
						nack		<=	(scl_pipe== 2'b01)&&(sda_pipe== 2'b11)	?	1'b1		:	nack;
						state_m		<=	(scl_pipe== 2'b10)						?	NACK_WAIT_STOP	:	WAIT_LAST_ACK;
						tx_shift	<=	1'b0;
					end		
				NACK_WAIT_STOP:
					begin
						clk_oe		<=	1'b0;
						//sda_o		<=	1'b0;
						stop_sdaoe	<=	(cnt=='d3)?1'b1	:stop_sdaoe;
						tx_shift	<=	1'b0;
						nack		<=	1'b0;
						clk_nack	<=	1'b1;
						cnt			<=		(cnt=='d10)	?	'd0			:
										((pipe_1mhz==2'b01)	?	cnt	+	'd1	:	cnt);
						state_m		<=	(cnt=='d10)		?	WAIT_STOP	:	NACK_WAIT_STOP;
					end	
				WAIT_STOP:
					begin
						clk_oe	<=	1'b0;
						//sda_o	<=	1'b0;
						stop_sdaoe	<=	1'b1;
						clk_nack<=	1'b0;
						cnt		<=	(cnt=='d10)	?	'd0	:
										(pipe_1mhz==2'b01)	?	cnt	+	'd1	:	cnt;
						
						state_m	<=	(cnt=='d10)	?	STOP	:	WAIT_STOP;
					end
			
				STOP	:
					begin
						clk_oe	<=	1'b0;
						//sda_o	<=	1'b1;
						stop_sdaoe	<=	1'b0;
						
						cnt		<=	(cnt=='d10)	?	'd0	:
										(pipe_1mhz==2'b01)	?	cnt	+	'd1	:	cnt;
						state_m	<=	(cnt=='d10)	?	IDLE_W	:	STOP;
					end					
				
			default:
					begin
						clk_oe		<=	1'b0;
						state_m		<=	IDLE_W;
						tx_shift	<=	1'b0;
						cnt			<=	'd0;	
						sda_oe		<=	1'b0;
						stop_sdaoe	<=	1'b0;
					end
			endcase
		end
//////////////////////////////////////////////////////////////////////
//read process
//////////////////////////////////////////////////////////////////////	
	else if (read)
		begin
			case(state_m)
				IDLE_W	:
					begin
						clk_oe		<=	1'b0;
						tx_shift	<=	1'b0;
						cnt			<=	(cnt=='d10)			?			'd0	:
										(pipe_1mhz==2'b01)	?	cnt	+	'd1	:	cnt;
						stop_sdaoe	<=	1'b0;
						master_ack	<=	1'b0;						
						sr_sig		<=	1'b0;
						sda_oe		<=	1'b0;
						r_cnt		<=	'd0;
						state_m		<=	/* (cnt=='d10)	 */(enable_buf==3'b011)?	WAIT_START	:IDLE_W;
					end
				IDLE_R	:
					begin
						clk_oe		<=	1'b0;
						tx_shift	<=	1'b0;
						stop_sdaoe	<=	1'b0;
						cnt			<=	(cnt=='d10)			?			'd0	:
										(pipe_1mhz==2'b01)	?	cnt	+	'd1	:	cnt;
						sr_sig		<=	1'b1;						
						state_m		<=	(cnt=='d10)			?	WAIT_START	:	IDLE_R;
					end   					
				WAIT_START:
					begin
						tx_shift	<=	1'b1;
						sda_oe		<=	1'b1;
						cnt			<=	(cnt=='d10)			?			'd0	:
										(pipe_1mhz==2'b01)	?	cnt	+	'd1	:	cnt;
						
						state_m		<=	(cnt=='d10)	?	TX_ADDRESS	:	WAIT_START;
					end
				TX_ADDRESS	:
					begin
						clk_oe		<=	1'b1;
						sda_oe		<=	(wcnt_3==31'd63)?1'b0:sda_oe;
						clk_nack	<=	1'b0;
						state_m		<=	(count==5'd8)&&(scl_pipe== 2'b10)		?	ADDRESS_ACK		:	TX_ADDRESS;
						tx_shift		<=	1'b1;/* (scl_pipe== 2'b10)	?	1'b1	:	tx_shift; */
					end 
				ADDRESS_ACK:
					begin
						//nack		<=	(scl_pipe== 2'b01)&&(sda_pipe== 2'b11)	?	1'b1		:	nack;
						state_m		<=	(scl_pipe== 2'b01)						?	(sr_sig?RX_DATA:TX_OFFSET)	:	ADDRESS_ACK;
						tx_shift	<=	1'b0;
						sr_sig		<=	((scl_pipe== 2'b01)&&sr_sig)			?	1'b0						:	sr_sig;
					end
				TX_OFFSET:
					begin
						clk_oe		<=	1'b1;
						clk_nack	<=	1'b0;
						state_m		<=	(count==5'd8)&&(scl_pipe== 2'b10)		?	OFFSET_ACK		:	TX_OFFSET;
						tx_shift		<=	1'b1;
					end				
			
				OFFSET_ACK:
					begin
						//nack		<=	(scl_pipe== 2'b01)&&(sda_pipe== 2'b11)	?	1'b1			:	nack;
						state_m		<=	(scl_pipe== 2'b10)						?	NACK_WAIT_STOP	:	OFFSET_ACK;
						tx_shift	<=	1'b0;
						sr_sig		<=	1'b1;
					end				
				RX_DATA	:
					begin
						clk_oe		<=	1'b1;
						master_ack	<=	1'b0;
						clk_nack	<=	1'b0;
						//sda_oe		<=	1'b0;
						state_m		<=	(count==5'd8)&&(scl_pipe== 2'b10)		?	RX_DATA_ACK		:	RX_DATA;
						tx_shift		<=	1'b0;
					end
				RX_DATA_ACK:
					begin

						state_m		<=	(r_cnt==(READ_DATA_NUM-1'd1)&&scl_pipe== 2'b01)				?	R_WAIT_LAST_ACK:
												(scl_pipe== 2'b10				?	RX_DATA			:	RX_DATA_ACK);
						master_ack	<=	(wcnt_3==31'd63)?1'b1:master_ack;
						sda_oe		<=	(wcnt_3==31'd63)?1'b1:sda_oe;
						r_cnt		<=		(scl_pipe== 2'b01)?	r_cnt	+ 1'b1	:	r_cnt;
					end
				R_WAIT_LAST_ACK:
					begin
						state_m		<=	(scl_pipe== 2'b10)						?	NACK_WAIT_STOP	:	R_WAIT_LAST_ACK;
						master_ack	<=	1'b1;
						//sda_oe		<=	(wcnt_3==31'd63)?1'b0:sda_oe;
						stop_sdaoe	<=	(cnt=='d3)?1'b1	:stop_sdaoe;
					end		
				NACK_WAIT_STOP:
					begin
						clk_oe		<=	1'b0;
						master_ack	<=	(cnt=='d3)?1'b0:master_ack;
						sda_oe		<=	(cnt=='d3)?1'b0:sda_oe;
						//sda_o		<=	1'b0;
						stop_sdaoe	<=	(cnt=='d3)?1'b1	:stop_sdaoe;
						tx_shift	<=	1'b0;
						nack		<=	1'b0;
						clk_nack	<=	1'b1;
						cnt			<=		(cnt=='d10)	?	'd0			:
										((pipe_1mhz==2'b01)	?	cnt	+	'd1	:	cnt);
						state_m		<=	(cnt=='d10)		?	WAIT_STOP	:	NACK_WAIT_STOP;
					end	
				WAIT_STOP:
					begin
						clk_oe	<=	1'b0;
						//sda_o	<=	1'b0;
						stop_sdaoe	<=	1'b1;
						clk_nack<=	1'b0;
						cnt		<=	(cnt=='d10)	?	'd0	:
										(pipe_1mhz==2'b01)	?	cnt	+	'd1	:	cnt;
						
						state_m	<=	(cnt=='d10)	?	STOP	:	WAIT_STOP;
					end
			
				STOP	:
					begin
						clk_oe	<=	1'b0;
						//sda_o	<=	1'b1;
						stop_sdaoe	<=	1'b0;
						cnt		<=	(cnt=='d10)	?	'd0	:
										(pipe_1mhz==2'b01)	?	cnt	+	'd1		:	cnt;
						state_m	<=	(cnt=='d10)	?	(sr_sig?IDLE_R:IDLE_W)		:	STOP;
						
					end	
			default:
					begin
						clk_oe		<=	1'b0;
						state_m		<=	IDLE_W;
						tx_shift	<=	1'b0;
						cnt			<=	'd0;
						r_cnt		<=	'd0;
						master_ack	<=	1'b0;
						sda_oe		<=	1'b0;
						sr_sig		<=	1'b0;
						stop_sdaoe	<=	1'b0;
					end
			endcase
		end
	else
		begin
			clk_oe		<=	1'b0;
			cnt			<=	'd0;
			tx_shift	<=	1'b0;
			nack		<=	1'b0;
			clk_nack	<=	1'b0;
			master_ack	<=	1'b0;
			sda_oe		<=	1'b0;
			w_cnt		<=	1'b0;
			stop_sdaoe	<=	1'b0;
			r_cnt		<=	1'b0;		
			state_m		<=	IDLE_W;
		end
//////////////////////////////////////////////////////////////////////
//	 TX  SHIFT
//////////////////////////////////////////////////////////////////////
	
always @(posedge SYSTEM_CLK or negedge RESETn)
 	if(!RESETn)
		begin
				shift_reg[(WRITE_DATA_NUM*8-1):0]			<=	32'd0;
		end		
	else if((tx_shift==1'b1) && (scl_pipe== 2'b01))
				shift_reg[(WRITE_DATA_NUM*8-1):0]		<=	{shift_reg[(WRITE_DATA_NUM*8-2):0]		,1'b0};	
	else 
		begin
			if(state_m[7:0]==IDLE_W)
				shift_reg[(WRITE_DATA_NUM*8-1):(WRITE_DATA_NUM*8-8)]		<=	{address[(ADDRESS_DATA_NUM*8-1)	:1],1'b0	};	
			else if(state_m[7:0]==IDLE_R)
				shift_reg[(WRITE_DATA_NUM*8-1):(WRITE_DATA_NUM*8-8)]		<=	{address[(ADDRESS_DATA_NUM*8-1)	:1],1'b1	};		
			else if(state_m[7:0]==ADDRESS_ACK)
				shift_reg[(WRITE_DATA_NUM*8-1):(WRITE_DATA_NUM*8-8)]		<=	offset[(OFFSET_DATA_NUM*8-1)	:0]	;		
			else if(state_m[7:0]==OFFSET_ACK)
				shift_reg[(WRITE_DATA_NUM*8-1):0]		<=	w_data[(WRITE_DATA_NUM*8-1)	:0]	;	
			else
				shift_reg[(WRITE_DATA_NUM*8-1):0]			<=	shift_reg;
		end	
endmodule
