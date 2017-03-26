`timescale 1 ns/10 ps
module tb_spi_slave;
    reg        CLK;

	reg		   reset; //mark add
    // SPI Signal
    reg        SCLK = 1'b0;    // SPI clock
    reg        SSn  = 1'b1;    // Slave select lines
    reg        MOSI = 1'b1;    // Master out slave in
    wire       MISO;           // Master in slave out
    // Local Bus Signal
    wire [2:0] SLOT_ID;
   //wire       WRITE;
   //wire       READ;
    wire [7:0] ADDRESS;
    wire [7:0] WRITEDATA;
    reg  [7:0] READDATA;
	
// spi master
	reg				CLK_1Mhz;
	reg		[23:0]	PEX_PWRGOOD	='b01010101;
	reg		[23:0]	IO_STATUE	='ha55a;
	wire	[11:0]	data_from_cpld;
	wire			spi_clk;
	wire			spi_cs; 
	wire			spi_dout;
	//wire			spi_din;
//
parameter	DATA_WIDTH	=	32;
wire	spi_din	=	'b10101010101010101010101;
reg		[DATA_WIDTH-1:0]	iTx_Data	=	32'h516A5AD5;
wire	[DATA_WIDTH-1:0]	oRx_Data_m;
wire	[DATA_WIDTH-1:0]	oRx_Data_s;
wire	iMISO;
wire	oMOSI;
wire	oSCLK;
wire	oSSn;
	spi_master#(
		.DATA_WIDTH(DATA_WIDTH)
	)spi_master_inst
	(
		.iClk		( CLK_1Mhz	),   
		.iRstn		( !reset	),
		.iMISO		( iMISO		),
		.iTx_Data	( iTx_Data	),
		.oSCLK		( oSCLK		),
		.oSSn		( oSSn		),
		.oMOSI		( oMOSI		),
		.oRx_Data	( oRx_Data_m)
	
	);		

    spi_slave#(
		.DATA_WIDTH(DATA_WIDTH)
	)spi_slave_inst
	( 
		.iClk		( CLK       ),
		.iRstn		( !reset    ),
       // SPI Signal
		.iSCLK		( oSCLK		),   // SPI clock
		.iSSn		( oSSn		),   // Slave select lines
		.iMOSI		( oMOSI		),   // Master out slave in
		.oMISO		( iMISO		),   // Master in slave out
       // Local Bus Signal
		.ivREADDATA	( 32'h149824AF),
		.ovWRITEDATA( oRx_Data_s)

    );

	
	
/* 	spi_communication	spi_master
	(
		.clk			(CLK_1Mhz	),       
		.rstn			(!reset		),
		.PEX_PWRGOOD	(PEX_PWRGOOD),
		.IO_STATUE		(IO_STATUE	),
		.data_from_cpld	(data_from_cpld),
		.spi_clk		(spi_clk	),
		.spi_cs			(spi_cs		),
		.spi_dout		(spi_dout	),
		.spi_din		(spi_din	)	

	);
 */

			 
//-----------------------------------------------------------------				 
//-----------------------------------------------------------------					 
    parameter time_unit = 1;
    parameter clk_time  = 1 * time_unit;   // 1ns
	parameter clk_1Mhz  = 10 * time_unit;   // 10ns
    parameter wait_time = clk_time * 1000; //5000ns
	reg [7:0] read_data = 8'hFF; 
	initial
    begin
        reset = 1;
        while(1)
            #100 reset = 0;

    end
    initial
    begin
      CLK = 1'b1;
      forever
        #clk_time CLK = ~CLK;  // Generate 100MHz Clock
    end

	 initial
    begin
      CLK_1Mhz = 1'b1;
      forever
        #clk_1Mhz CLK_1Mhz = ~CLK_1Mhz;  // Generate 100MHz Clock
    end
	
	
	
initial
    begin
      READDATA = 8'h55;
      // SPI_Host
      # wait_time   SPI_READ   ( 3'b111, 5'b0_0010, 8'hB0        );
      # wait_time   SPI_WRITE  ( 3'b111, 5'b0_0001, 8'hB0, 8'h55 );
      # wait_time   SPI_READ   ( 3'b111, 5'b0_0010, 8'hB0        );
      # wait_time   SPI_WRITE  ( 3'b101, 5'b0_0001, 8'hA2, 8'hC3 );
      # wait_time   SPI_READ   ( 3'b101, 5'b0_0010, 8'hA2        );
      # wait_time   SPI_WRITE  ( 3'b100, 5'b0_0001, 8'hA2, 8'h60 );
      # wait_time   SPI_READ   ( 3'b011, 5'b0_0010, 8'hA3        );

      # wait_time   $finish;
    end
	
    /*********************************************************************/
    /****** SMBus task section ******/
    /*********************************************************************/
	
    integer i,j,k;
    parameter spi_frequency      = 40 * time_unit; // 40ns
    parameter spi_frequency_div2 = ( spi_frequency/2 );
    parameter spi_frequency_div4 = ( spi_frequency/4 );

    task SPI_WRITE;
    input [2:0] slot_id;
    input [4:0] command;
    input [7:0] address;
    input [7:0] write_data;
    begin
      SSn = 1'b0;
      #spi_frequency_div4;
      // Slot_ID
      for ( i=2; i>=0; i=i-1 )
      begin
        if ( i==2 )
        begin
          #spi_frequency_div4   MOSI = slot_id[i];
          #spi_frequency_div4   SCLK = SCLK;
          #spi_frequency_div4   SCLK = ~SCLK;
          #spi_frequency_div4   SCLK = SCLK;
        end
        else
        begin
          #spi_frequency_div4   MOSI = slot_id[i];
                                SCLK = ~SCLK;
          #spi_frequency_div4   SCLK = SCLK;
          #spi_frequency_div4   SCLK = ~SCLK;
          #spi_frequency_div4   SCLK = SCLK;
        end
      end
      // Command
      for ( i=4; i>=0; i=i-1 )
      begin
        #spi_frequency_div4   MOSI = command[i];
                              SCLK = ~SCLK;
        #spi_frequency_div4   SCLK = SCLK;
        #spi_frequency_div4   SCLK = ~SCLK;
        #spi_frequency_div4   SCLK = SCLK;
      end
      // Address
      for ( i=7; i>=0; i=i-1 )
      begin
        #spi_frequency_div4   MOSI = address[i];
                              SCLK = ~SCLK;
        #spi_frequency_div4   SCLK = SCLK;
        #spi_frequency_div4   SCLK = ~SCLK;
        #spi_frequency_div4   SCLK = SCLK;
      end
      // Data
      for ( i=7; i>=0; i=i-1 )
      begin
        #spi_frequency_div4   MOSI = write_data[i];
                              SCLK = ~SCLK;
        #spi_frequency_div4   SCLK = SCLK;
        #spi_frequency_div4   SCLK = ~SCLK;
        #spi_frequency_div4   SCLK = SCLK;
      end

      #spi_frequency_div4     SCLK = 1'b0;
      #spi_frequency          SSn  = 1'b1;

      $display ( "-------------- SPI_WRITE ---------------" );
      $display ( "  SLOT_ID   COMMAND   ADDRESS   DATA    " );
      $display ( "   0x%h      0x%h      0x%h     0x%h    ",
                   slot_id,  command,   address, write_data );
    end
    endtask

    task SPI_READ;
    input      [2:0] slot_id;
    input      [4:0] command;
    input      [7:0] address;
    begin
      SSn = 1'b0;
      #spi_frequency_div4;
      // Slot_ID
      for ( i=2; i>=0; i=i-1 )
      begin
        if ( i==2 )
        begin
          #spi_frequency_div4   MOSI = slot_id[i];
          #spi_frequency_div4   SCLK  = SCLK;
          #spi_frequency_div4   SCLK  = ~SCLK;
          #spi_frequency_div4   SCLK  = SCLK;
        end
        else
        begin
          #spi_frequency_div4   MOSI = slot_id[i];
                                SCLK  = ~SCLK;
          #spi_frequency_div4   SCLK  = SCLK;
          #spi_frequency_div4   SCLK  = ~SCLK;
          #spi_frequency_div4   SCLK  = SCLK;
        end
      end
      // Command
      for ( i=4; i>=0; i=i-1 )
      begin
        #spi_frequency_div4   MOSI = command[i];
                              SCLK  = ~SCLK;
        #spi_frequency_div4   SCLK  = SCLK;
        #spi_frequency_div4   SCLK  = ~SCLK;
        #spi_frequency_div4   SCLK  = SCLK;
      end
      // Address
      for ( i=7; i>=0; i=i-1 )
      begin
        #spi_frequency_div4   MOSI = address[i];
                              SCLK  = ~SCLK;
        #spi_frequency_div4   SCLK  = SCLK;
        #spi_frequency_div4   SCLK  = ~SCLK;
        #spi_frequency_div4   SCLK  = SCLK;
      end

      #spi_frequency;
      #spi_frequency;
      #spi_frequency;

      // Data
      for ( i=7; i>=0; i=i-1 )
      begin
        #spi_frequency_div4   SCLK      = ~SCLK;
        #spi_frequency_div4   SCLK      = SCLK;
        #spi_frequency_div4   SCLK      = ~SCLK;
                              read_data[i] = MISO;
        #spi_frequency_div4   SCLK      = SCLK;
      end

      #spi_frequency_div4     SCLK  = 1'b0;
      #spi_frequency          SSn  = 1'b1;

      $display ( "-------------- SPI_READ ---------------" );
      $display ( "  SLOT_ID   COMMAND   ADDRESS   DATA    " );
      $display ( "   0x%h      0x%h      0x%h     0x%h    ",
                   slot_id,  command,   address, read_data );
    end
    endtask

endmodule
