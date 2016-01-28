///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	$Id: i2c_master_wishbone_ctrl 
//  $Date: 2016/01/27 10:55
//  $Revision: 1.0
//  $Author: Mark Lin $
// 	Change History:
//	2016/01/27: creat WISHBONE Read Write function use verilog
// 	2016/01/28: change state transfer way use bitcnt detail discription as below:
//	//**if write address is "0x04"  use // NS <=(wb_adr_i==3'b100&&wb_dat_o[1]==1'b0&&bitcnt==13'd1000)?TXR:CR;//
//	// 	else						use // NS <=(bitcnt==13'd1000)?CR:CTR;//
//	//**use bitcnt when bitcnt is 1000 change state 
//	//**use bitcnt1 to gernerate " wb_we_i, wb_stb_i, wb_cyc_i ",signal for i2c action pipe
//
//--------------------------------------------------I2C Master Ctrl TABLE--------------------------------------------------------
//	-------------------------------------------------------------------------------------	
//  |	Name	|	Address	|	Width	|	Access	|	Description						|
//	-------------------------------------------------------------------------------------
//	|	PRERlo	|	0x00	|	8		|	RW		|	Clock Prescale register lo-byte	|
//	-------------------------------------------------------------------------------------
//  |	PRERhi	|	0x01	|	8		|	RW		|	Clock Prescale register hi-byte	|
//	-------------------------------------------------------------------------------------
//	|	CTR		|	0x02	|	8		|	RW		|			Control register		|
//	-------------------------------------------------------------------------------------
//	|	TXR		|	0x03	|	8		|	W		|			Transmit register		|
//	-------------------------------------------------------------------------------------
//	|	RXR		|	0x03	|	8		|	R		|			Receive register		|
//	-------------------------------------------------------------------------------------
//	|	CR		|	0x04	|	8		|	W		|			Command register		|
//	-------------------------------------------------------------------------------------
//	|	SR		|	0x04	|	8		|	R		|			Status register			|
//	-------------------------------------------------------------------------------------
//	-----------------------------------------------------------------
//	|	7	|	6	|	5	|	4	|	3	|	2	|	1	|	0	|
//	-----------------------------------------------------------------
//Prescale Register------------------------------------------------------------------------------//
// 																								 //
//  prescale = (wb_clk_i / 5*SCL)-1																 //
//  Ex: wb_clk_i = 32MHz, desired SCL = 100KHz ,so prescale = (32MHz / 5*100KHz)-1=16'd63=16h'3F // 
// 																								 //
///////////////////////////////////////////////////////////////////////////////////////////////////
//Control register:------------------------------------------------------------------------------//
// 																								 //
// Bit[7]	:	EN, I2C core enable bit,‘1’, the core is enabled								 //
// Bit[6]	:	IEN, I2C core interrupt enable bit,‘1’, interrupt is enabled.					 //
// 																								 //
///////////////////////////////////////////////////////////////////////////////////////////////////
//Transmit register------------------------------------------------------------------------------//
// 																								 //
// Bit[7:1]	:	Next byte to transmit via I2C,													 //
// Bit[0]	:	slave address transfer: ‘1’ = reading from slave ‘0’ = writing to slave ,		 //
//				data transfer: represent the data’s LSB,										 //
// 																								 //
///////////////////////////////////////////////////////////////////////////////////////////////////
//Receive register-------------------------------------------------------------------------------//
// 																								 //
// Bit[7:0]	:	Last byte received via I2C														 //
// 																								 //
///////////////////////////////////////////////////////////////////////////////////////////////////
//Command register-------------------------------------------------------------------------------//
// 																								 //
// Bit[7]	:	STA, generate (repeated) start condition								 		 //
// Bit[6]	:	STO, generate stop condition													 //
// Bit[5]	:	RD, read from slave								 								 //
// Bit[4]	:	WR, write to slave					  											 //
// Bit[3]	:	ACK, when a receiver, sent ACK (ACK = ‘0’) or NACK (ACK = ‘1’)					 //
// Bit[2]	:	Reserved					 													 //
// Bit[1]	:	Reserved								 										 //
// Bit[0]	:	IACK, Interrupt acknowledge. When set, clears a pending interrupt.				 //
// 																								 //
///////////////////////////////////////////////////////////////////////////////////////////////////
//Status register--------------------------------------------------------------------------------//
// 																								 //
// Bit[7]	:	RxACK, Received acknowledge from slave.	‘1’ = No acknowledge received	 		 //
// Bit[6]	:	Busy, I2C bus busy,‘1’after START signal detected,‘0’ after STOP signal detected //
// Bit[5]	:	AL, Arbitration lost							 								 //
// Bit[4:2]	:	Reserved							  											 //
// Bit[1]	:	TIP, Transfer in progress.1’ when transferring data, ‘0’ when transfer complete	 //
// Bit[0]	:	IF, Interrupt Flag.																 //
// 																								 //
///////////////////////////////////////////////////////////////////////////////////////////////////
//I2C_INIT---------------------------------------------------------------------------------------//	
//  																							 //
//  task WISHBONE_WRITE;																		 //
//  input [2:0] address;   													 					 //
//	input [7:0] data;																			 //													
// 	WISHBONE_WRITE ( 3'h2, 8'h00 );  turn off the core 											 //
// 	WISHBONE_WRITE ( 3'h4, 8'h01 );  clearn any pening IRQ 										 //
// 	WISHBONE_WRITE ( 3'h0, 8'h63 );  load low presacle bit										 //			
//  WISHBONE_WRITE ( 3'h1, 8'h00 );  load upper prescale bit	     							 //
//  WISHBONE_WRITE ( 3'h2, 8'h80 );  turn on the core	 										 // 
//  WISHBONE_WRITE ( 3'h3, 8'h38 );  transmit the address shifted by one and the read/write bit  //
//  WISHBONE_WRITE ( 3'h4, 8'h90 );  set start and write  bits which will start the transaction  //
//	while ( wb_dat_o[1] == 1'b1 ) // Check Tip													 //	
//  WISHBONE_READ  ( 3'h4        );  transmit the address shifted by one and the read/write bit  //
//  WISHBONE_WRITE ( 3'h3, 8'hA5 );  transmit the address shifted by one and the read/write bit  //
//  WISHBONE_WRITE ( 3'h4, 8'h10 );  set start and write  bits which will start the transaction  //
//	while ( wb_dat_o[1] == 1'b1 ) // Check Tip													 //
//  WISHBONE_READ  ( 3'h4        );  transmit the address shifted by one and the read/write bit  //
//  WISHBONE_WRITE ( 3'h3, 8'h5A );  transmit the address shifted by one and the read/write bit  //
//  WISHBONE_WRITE ( 3'h4, 8'h50 );  set start and write  bits which will start the transaction  //
//	while ( wb_dat_o[6] == 1'b1 ) // Check Tip													 //
//  WISHBONE_READ  ( 3'h4        );  transmit the address shifted by one and the read/write bit  //
//																								 //
///////////////////////////////////////////////////////////////////////////////////////////////////


module i2c_master_wishbone_ctrl_2 ( 
	wb_clk_i, wb_rst_i,
	wb_we_i,
	wb_stb_i,
	wb_cyc_i, 
	arst_i,
	i2c_scl,
	i2c_sda
	//output reg [7:0]	LED
);

	input        wb_clk_i;     // master clock input
	input        wb_rst_i;     // synchronous active high reset
	reg [2:0]	 wb_adr_i;     // lower address bits
	reg [7:0] 	 wb_dat_i;     // databus input
	inout		 i2c_scl;
	inout		 i2c_sda;	
	reg [3:0]	 NS;
	reg [13:0]	 bitcnt;
	reg [7:0]	 bitcnt1;
	output reg   wb_we_i;      // write enable input
	output reg   wb_stb_i;     // stobe/core select signal
	output reg   wb_cyc_i;     // valid bus cycle input		
	input        arst_i;       // asynchronous reset

	wire [7:0]	 wb_dat_o;     // databus output
	wire      	 wb_ack_o;     // bus cycle acknowledge output
	wire     	 wb_inta_o;    // interrupt request signal output
	
///////////////////////////////////////////////////////////////////////////////

	// //The tri-state buffers for the SCL and SDA lines
	//scl
	wire		scl_pad_o;
	wire		scl_padoen_o;
	wire		scl_pad_i;
	//sda
	wire		sda_pad_o;
	wire		sda_padoen_o;
	wire		sda_pad_i;
	assign i2c_scl	 = scl_padoen_o ? 1'b1 : scl_pad_o; 
	assign i2c_sda	 = sda_padoen_o ? 1'b1 : sda_pad_o;	
	assign scl_pad_i = i2c_scl;
	assign sda_pad_i = i2c_sda;  
	
//////////////////////////////////////////////////////////////////////////////

i2c_master_top  U101 (
   .wb_clk_i		( wb_clk_i		),
   .wb_rst_i		( wb_rst_i		),
   .arst_i			( arst_i		),
   .wb_adr_i		( wb_adr_i		),
   .wb_dat_i		( wb_dat_i		),
   .wb_dat_o		( wb_dat_o		),
   .wb_we_i			( wb_we_i		),
   .wb_stb_i		( wb_stb_i		),
   .wb_cyc_i		( wb_cyc_i		),
   .wb_ack_o		( wb_ack_o		),
   .wb_inta_o		( wb_inta_o		),
   //The tri-state buffers for the SCL and SDA lines
   .scl_pad_i		( scl_pad_i		),
   .scl_pad_o		( scl_pad_o		),
   .scl_padoen_o	( scl_padoen_o	),
   .sda_pad_i		( sda_pad_i		),
   .sda_pad_o		( sda_pad_o		),
   .sda_padoen_o	( sda_padoen_o	)
   );
///////////////////////////////////////////////////////////////////////////////  
parameter idle					= 4'b0000;
parameter PRERlo				= 4'b0001;
parameter PRERhi				= 4'b0010;
parameter CTR					= 4'b0011;
parameter TXR					= 4'b0100;
parameter RXR					= 4'b0101;
parameter CR					= 4'b0110;
parameter SR					= 4'b0111;
parameter CTR1					= 4'b1000;
parameter CR1					= 4'b1001;
parameter TXR1					= 4'b1010;
parameter CR2					= 4'b1011;
parameter TXR2					= 4'b1100;
parameter CR3					= 4'b1101;

parameter stop					= 4'b1111;




always@(posedge wb_clk_i )
	begin
		if (wb_rst_i)
			begin
				bitcnt <=13'd0;
				bitcnt1 <= 8'd0;
			end
		else if (bitcnt==13'd1000)
				bitcnt	<= 13'd0;
		else
			begin
				bitcnt <= bitcnt+13'd1;
				bitcnt1 <=(wb_adr_i==3'b100)?((bitcnt==13'd1)?bitcnt1+8'd1:bitcnt1):8'd0;
			end
	end
	
always@(posedge wb_clk_i)		
	if (wb_rst_i)
		begin
            NS	<= idle;
			wb_adr_i<=3'b000;
			wb_dat_i<=8'h00;
		end
	else
		begin
			wb_we_i <=(bitcnt==2&&(bitcnt1<=1))?1:0;	
			wb_stb_i<=(bitcnt==2&&(bitcnt1<=1))?1:0;	
			wb_cyc_i<=(bitcnt==2&&(bitcnt1<=1))?1:0;	
			case(NS)
				idle:	begin
							wb_adr_i<=3'b000;
							wb_dat_i<=8'h00;
							NS 		<= (bitcnt==13'd1000) ? CTR : idle;
						end
				CTR:	begin
							wb_adr_i<=3'b010;
							wb_dat_i<=8'h00;
							NS 		<=(bitcnt==13'd1000)?CR:CTR;
						end
				CR:		begin
							wb_adr_i<=3'b100;
							wb_dat_i<=8'h01;
							NS 		<=(bitcnt==13'd1000)?PRERlo:CR;
						end
				PRERlo:	begin
							wb_adr_i<=3'b000;
							wb_dat_i<=8'h63;
							NS 		<=(bitcnt==13'd1000)?PRERhi:PRERlo;
						end
				PRERhi:	begin
							wb_adr_i<=3'b001;
							wb_dat_i<= 8'h00;
							NS 		<=(bitcnt==13'd1000)?CTR1:PRERhi;
						end
				CTR1:	begin
							wb_adr_i<=3'b010;
							wb_dat_i<= 8'h80;
							NS 		<=(bitcnt==13'd1000)?TXR:CTR1;
						end
				TXR:	begin
							wb_adr_i<=3'b011;
							wb_dat_i<=8'h38;
							NS 		<=(bitcnt==13'd1000)?CR1:TXR;
						end
				CR1:	begin
							wb_adr_i<=3'b100;
							wb_dat_i<= 8'h90;
							NS 		<=(wb_adr_i==3'b100&&wb_dat_o[1]==1'b0&&bitcnt==13'd1000)?TXR1:CR1;
						end
				TXR1:	begin
							wb_adr_i<=3'b011;
							wb_dat_i<= 8'hA5;
							NS 		<=(bitcnt==13'd1000)? CR2:TXR1;
						end	
				CR2:	begin
							wb_adr_i<=3'b100;
							wb_dat_i<= 8'h10;
						NS 		<=(wb_adr_i==3'b100&&wb_dat_o[1]==1'b0&&bitcnt==13'd1000)?TXR2:CR2;
						end
				TXR2:	begin
							wb_adr_i<=3'b011;
							wb_dat_i<= 8'h5A;
							NS 		<=(bitcnt==13'd1000)?CR3:TXR2;
						end
				CR3:	begin
							wb_adr_i<=3'b100;
							wb_dat_i<= 8'h50;
							NS 		<=(wb_adr_i==3'b100&&wb_dat_o[1]==1'b0&&bitcnt==13'd1000)?CR3:CR3;
						end						
				default:begin
							wb_adr_i<=3'b000;
							wb_dat_i<=8'h00;
						end
						
			endcase
		end	
endmodule
