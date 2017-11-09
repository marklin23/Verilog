`define	PEX_A_1_ADDR	7'h23
`define	PEX_A_2_ADDR	7'h20
`define	PEX_A_3_ADDR	7'h20
`define	PEX_A_4_ADDR	7'h20
`timescale 1ns/1ns
module i2c_mux_tb();


wire   SCL , SDA;

//assign SDA  = wSDAoe ? 1'bz :1'b0;

pullup(pull1) p00( SCL );  
pullup(pull1) p01( SDA ); 
reg [8:0]read_data;

reg clk_25m;
reg globle_rstn;
//mux
wire SCL_m;
wire SDA_m;
wire SCL_s;
wire SDA_s;
wire SCL_t;
wire SDA_t;
//host



//slave
wire wSDAoe1;
wire PEX_A_I2C_SCL1;
wire PEX_A_I2C_SDA1;
wire PEX_A_I2C_SCL2;
wire PEX_A_I2C_SDA2;
wire PEX_A_I2C_SCL3;
wire PEX_A_I2C_SDA3;
wire PEX_A_I2C_SCL4;
wire PEX_A_I2C_SDA4;
//host
pullup(pull1) p21( SCL );
pullup(pull1) p22( SDA );




//slave
pullup(pull1) p02( PEX_A_I2C_SCL1 );
pullup(pull1) p03( PEX_A_I2C_SDA1 );

pullup(pull1) p04( PEX_A_I2C_SCL2 );
pullup(pull1) p05( PEX_A_I2C_SDA2 );

pullup(pull1) p06( PEX_A_I2C_SCL3 );
pullup(pull1) p07( PEX_A_I2C_SDA3 );

pullup(pull1) p08( PEX_A_I2C_SCL4 );
pullup(pull1) p09( PEX_A_I2C_SDA4 );

pullup(pull1) p10( SCL_m );
pullup(pull1) p11( SDA_m );

pullup(pull1) p12( SCL_s );
pullup(pull1) p13( SDA_s );

pullup(pull1) p32( SCL_t );
pullup(pull1) p33( SDA_t );

//--------------------------------------------------------------------------------------------------------------------	
//parameter
//--------------------------------------------------------------------------------------------------------------------	
parameter time_unit      = 1;					//1ns
parameter clk_time       = 40 * time_unit;   	// 2.5MHz
parameter clk_time_div2  = ( clk_time /   2 );	//1.25Mhz
parameter clk_time_div10 = ( clk_time / 100 );	//4ns,250Mhz 
parameter wait_time      = clk_time * 1000; 	//400ns*1000
parameter wait_long_time = clk_time * 10000;	//1310us
//--------------------------------------------------------------------------------------------------------------------	
//SYSTEM_CLK
//--------------------------------------------------------------------------------------------------------------------	
initial
begin
					clk_25m = 1'b1;
  forever
	#clk_time		clk_25m = ~clk_25m;
end
//--------------------------------------------------------------------------------------------------------------------	
//RESETn
//--------------------------------------------------------------------------------------------------------------------	
initial
begin
  globle_rstn   = 1'b0;
  release SDA; 
  release SCL; 

  # wait_time   globle_rstn = 1'b1;
//==============================================
// altera iic to spi ip  test 
//==============================================
  // Function --- I2C
  # wait_time I2C_WRITE(8'h46, 8'h08, 8'h47 );
  # wait_time I2C_READ (8'h46, 8'h08, 8'h47 ,read_data);  

  
  //==============================================
  // non continue read command  Test
  //==============================================  
 
  //# wait_time   I2C_Single_read( 8'h47, 8'h02 );  
  

end

//--------------------------------------------------------------------------------------------------------------------	
//i2c_host
//--------------------------------------------------------------------------------------------------------------------	
wire	iSDA, oSDAOE, oSCLOE;

assign	SDA_m	=	(!oSDAOE)	?	1'b0	:	1'bz;
assign	SCL_m	=	(!oSCLOE)	?	1'b0	:	1'bz;

assign	iSDA			=	SDA_m;

i2c_master_ctrl mi2c_master_ctrl(

	.iRstn          ( globle_rstn   ),
	.iClk           ( clk_25m       ),                
	.iSDA           ( iSDA          ),
	.oSDAOE         ( oSDAOE        ),
	.oSCLOE         ( oSCLOE        )
	
);



//--------------------------------------------------------------------------------------------------------------------	
//i2c_mux
//--------------------------------------------------------------------------------------------------------------------
// CPU I2C
wire i2c_mux_host_scl_out_sig_n;

wire i2c_mux_host_sda_out_sig_n;
wire host_i2c_scl_in_sig;
wire host_i2c_sda_out_sig_n;
wire host_i2c_sda_in_sig;
wire i2c_mux_dev_scl_in_sig     ;
wire i2c_mux_dev_scl_out_sig_n  ;
wire i2c_mux_dev_sda_in_sig     ;
wire i2c_mux_dev_sda_out_sig_n  ;



//assign SCL_m                  = (!i2c_mux_host_scl_out_sig_n) ? 1'b0 : 1'bZ;
assign host_i2c_scl_in_sig    = SCL_m;

assign host_i2c_sda_out_sig_n = i2c_mux_host_sda_out_sig_n;

assign SDA_m                    = (!host_i2c_sda_out_sig_n) ? 1'b0 : 1'bZ;
assign host_i2c_sda_in_sig    = SDA_m;



 i2c_mux  i2c_mux_inst(
  .iClk     ( clk_25m                    ),
  .iRstn    ( globle_rstn                ),
  .iSCL_m   ( host_i2c_scl_in_sig        ),
  .oSCLoe_m ( i2c_mux_host_scl_out_sig_n ),
  .iSDA_m   ( host_i2c_sda_in_sig        ),
  .oSDAoe_m ( i2c_mux_host_sda_out_sig_n ),
  .iSCL_s   ( i2c_mux_dev_scl_in_sig     ), 
  .oSCLoe_s ( i2c_mux_dev_scl_out_sig_n  ),
  .iSDA_s   ( i2c_mux_dev_sda_in_sig     ),
  .oSDAoe_s ( i2c_mux_dev_sda_out_sig_n  )

);

	
//--------------------------------------------------------------------------------------------------------------------	
//i2c_slave
//--------------------------------------------------------------------------------------------------------------------

//// I2C Bus of Fan CPLD
//assign SCL_s                 = (!i2c_mux_dev_scl_out_sig_n[0]) ? 1'b0 : 1'bZ;
//assign i2c_mux_dev_scl_in_sig[0] = SCL_s;
//assign SDA_s                 = (!i2c_mux_dev_sda_out_sig_n[0]) ? 1'b0 : 1'bZ;
//assign i2c_mux_dev_sda_in_sig[0] = SDA_s;
//
//// I2C Bus of LM75BD
//assign LM75BD_SCL                = (!i2c_mux_dev_scl_out_sig_n[1]) ? 1'b0 : 1'bZ;
//assign i2c_mux_dev_scl_in_sig[1] = LM75BD_SCL;
//assign LM75BD_SDA                = (!i2c_mux_dev_sda_out_sig_n[1]) ? 1'b0 : 1'bZ;
//assign i2c_mux_dev_sda_in_sig[1] = LM75BD_SDA;

// I2C Bus of Fan CPLD
assign SCL_s              = (!i2c_mux_dev_scl_out_sig_n) ? 1'b0 : 1'bZ;
assign i2c_mux_dev_scl_in_sig = SCL_s;
assign SDA_s              = (!i2c_mux_dev_sda_out_sig_n) ? 1'b0 : 1'bZ;
assign i2c_mux_dev_sda_in_sig = SDA_s;


assign SDA_t    = !wSDAoe1 ? 1'b0 : 1'bz;


parameter GlitchFilter_STAGES = 3;

wire	   	wPEX_A_SCL_Filter;
wire	   	wPEX_A_SDA_Filter;
wire[7:0]	PEX_A_1_Input0;
wire[7:0]	PEX_A_1_Input1;
wire[7:0]	PEX_A_1_Output0;
wire[7:0]	PEX_A_1_Output1;
wire[7:0]	PEX_A_2_Input0;
wire[7:0]	PEX_A_2_Input1;
wire[7:0]	PEX_A_2_Output0;
wire[7:0]	PEX_A_2_Output1;
wire[7:0]	PEX_A_3_Input0;
wire[7:0]	PEX_A_3_Input1;
wire[7:0]	PEX_A_3_Output0;
wire[7:0]	PEX_A_3_Output1;	
wire[7:0]	PEX_A_4_Input0;
wire[7:0]	PEX_A_4_Input1;
wire[7:0]	PEX_A_4_Output0;
wire[7:0]	PEX_A_4_Output1;
 
wire PEX_A_1_sda_oe_n  ;
wire PEX_A_2_sda_oe_n  ;
wire PEX_A_3_sda_oe_n  ;
wire PEX_A_4_sda_oe_n  ;
wire PEX_A_1_INT       ;
wire PEX_A_2_INT       ;
wire PEX_A_3_INT       ;
wire PEX_A_4_INT       ;
 





assign 	PEX_A_I2C_SDA1		=	(!PEX_A_1_sda_oe_n)	?	1'b0	:	1'bz	; 
assign 	PEX_A_SHPC_INT_N1	=	(PEX_A_1_INT)		   ?	1'bz	:	1'b0	;

assign 	PEX_A_I2C_SDA2		=	(!PEX_A_2_sda_oe_n)	?	1'b0	:	1'bz	; 
assign 	PEX_A_SHPC_INT_N2	=	(PEX_A_2_INT)		   ?	1'bz	:	1'b0	;
 
assign 	PEX_A_I2C_SDA3		=	(!PEX_A_3_sda_oe_n)	?	1'b0	:	1'bz	; 
assign 	PEX_A_SHPC_INT_N3	=	(PEX_A_3_INT)		   ?	1'bz	:	1'b0	;
 
assign 	PEX_A_I2C_SDA4		=	(!PEX_A_4_sda_oe_n)	?	1'b0	:	1'bz	; 
assign 	PEX_A_SHPC_INT_N4	=	(PEX_A_4_INT)		   ?	1'bz	:	1'b0	;



GlitchFilter #(.TOTAL_STAGES(GlitchFilter_STAGES)) mGlitchFilterSCL_A
	(				
		.iClk	( clk_25m ),
		.iRst	( ~globle_rstn ),
		.iCE	(1'b1),
		.iSignal (PEX_A_I2C_SCL1),
		.oGlitchlessSignal ( wPEX_A_SCL_Filter )
	);
	
	
GlitchFilter #(.TOTAL_STAGES(GlitchFilter_STAGES)) mGlitchFilterSDA_A
	(				

		.iClk	( clk_25m ),
		.iRst	( ~globle_rstn ),
		.iCE	(1'b1),
		.iSignal (PEX_A_I2C_SDA1),
		.oGlitchlessSignal ( wPEX_A_SDA_Filter )
	);

PCA9555  PEX_A_1
	(		
		.iModule_Address(`PEX_A_1_ADDR),
		.iClk(clk_25m),
		.iRstn(globle_rstn),
		.ivIO0(PEX_A_1_Input0),
		.ovIO0(PEX_A_1_Output0),
		.onvOE0(),
		.iSCL(PEX_A_I2C_SCL1),
		.iSDA(PEX_A_I2C_SDA1),
		.onSDAOE(PEX_A_1_sda_oe_n),
		.ivIO1(PEX_A_1_Input1),
		.ovIO1(PEX_A_1_Output1),
		.onvOE1(),
		.onIntOE(PEX_A_1_INT) 
	);
PCA9555  PEX_A_2
	(		
		.iModule_Address(`PEX_A_2_ADDR),
		.iClk(clk_25m),
		.iRstn(globle_rstn),
		.ivIO0(PEX_A_2_Input0),
		.ovIO0(PEX_A_2_Output0),
		.onvOE0(),
		.iSCL(PEX_A_I2C_SCL2),
		.iSDA(PEX_A_I2C_SDA2),
		.onSDAOE(PEX_A_2_sda_oe_n),
		.ivIO1(PEX_A_2_Input1),
		.ovIO1(PEX_A_2_Output1),
		.onvOE1(),
		.onIntOE(PEX_A_2_INT) 
	);
PCA9555  PEX_A_3
	(		
		.iModule_Address(`PEX_A_3_ADDR),
		.iClk(clk_25m),
		.iRstn(globle_rstn),
		.ivIO0(PEX_A_3_Input0),
		.ovIO0(PEX_A_3_Output0),
		.onvOE0(),
		.iSCL(PEX_A_I2C_SCL3),
		.iSDA(PEX_A_I2C_SDA3),
		.onSDAOE(PEX_A_3_sda_oe_n),
		.ivIO1(PEX_A_3_Input1),
		.ovIO1(PEX_A_3_Output1),
		.onvOE1(),
		.onIntOE(PEX_A_3_INT) 
	);
PCA9555  PEX_A_4
	(		
		.iModule_Address(`PEX_A_4_ADDR),
		.iClk(clk_25m),
		.iRstn(globle_rstn),
		.ivIO0(PEX_A_4_Input0),
		.ovIO0(PEX_A_4_Output0),
		.onvOE0(),
		.iSCL(PEX_A_I2C_SCL4),
		.iSDA(PEX_A_I2C_SDA4),
		.onSDAOE(PEX_A_4_sda_oe_n),
		.ivIO1(PEX_A_4_Input1),
		.ovIO1(PEX_A_4_Output1),
		.onvOE1(),
		.onIntOE(PEX_A_4_INT) 
	);

   
i2c_slave_t#(
  .slave_addr   ( 7'h23 ),
  .TX_DATA_BYTE ( 1     )

)   i2c_slave_t_inst
(
	.RESETn      ( globle_rstn ),
   .SYSTEM_CLK  ( clk_25m  ),
	.iSCL        ( SCL_t    ),
	.iSDA        ( SDA_t    ),
   .oSDA        ( wSDAoe1  ),
	.tx_data     ( 8'hA5    ),
	.rx_address	 (  ),
	.rx_data     (  ),
	.rx_offset   (  ),
	.owrite_en   (  ),
	.oread_en    (  )
);



/*********************************************************************
SMBus task section
*********************************************************************/
integer i,j,k;

parameter i2c_frequency  = 10_000 * time_unit; // 100KHz = 10_000 ns
parameter i2c_cycle_div2 = (i2c_frequency/2); //200Khz 50_000 ns
parameter i2c_cycle_div4 = (i2c_frequency/4); //400Khz 2_500 ns 

task I2C_START;
begin
  release SDA;
  release SCL;
  # i2c_cycle_div4 force SDA = 1'b0;
  # i2c_cycle_div4 force SCL = 1'b0;
end
endtask

task I2C_WAIT_ACK;
begin
    release SDA;
    # i2c_cycle_div4 release SCL;
    # i2c_cycle_div4 if (SDA) $display ("  !!!!!! Device Not ACK !!!!!!");
    # i2c_cycle_div4 force SCL = 0;
end
endtask

task I2C_HOST_ACK;
begin
    force SDA = 1'b0;
    # i2c_cycle_div4 release SCL;
    # i2c_cycle_div2 force SCL = 0;
end
endtask

task I2C_HOST_NACK;
begin
    force SDA = 1'b1;
    # i2c_cycle_div4 release SCL;
    # i2c_cycle_div2 force SCL = 0;
end
endtask

task I2C_STOP;
begin
  force SDA = 1'b0;
  # i2c_cycle_div4 release SCL;
  # i2c_cycle_div4 release SDA;
  # i2c_cycle_div4;
  $display ("       ");
end
endtask


task I2C_WRITE;
input [7:0] slave_addr; // 8'h46,
input [7:0] reg_addr;   // 8'h08, 
input [7:0] reg_data;   // 8'hA5,
begin
  I2C_START;

  for ( j=0; j<=2; j=j+1 )
  begin
    # i2c_cycle_div4
    for ( i=7; i>=0; i=i-1 )
    begin
      if      ( j==0 ) if ( slave_addr[i] ) release SDA; else force SDA = 1'b0;
      else if ( j==1 ) if ( reg_addr[i]   ) release SDA; else force SDA = 1'b0;
      else if ( j==2 ) if ( reg_data[i]   ) release SDA; else force SDA = 1'b0;
      # i2c_cycle_div4 release SCL;
      # i2c_cycle_div2 force SCL = 0;
      # i2c_cycle_div4;
    end
    I2C_WAIT_ACK;
  end

  # i2c_cycle_div4;
  I2C_STOP;

  $display ( "-------------------- I2C_Write --------------------" );
  $display ( "  Slave_Address   Register_Address  Register_Data  " );
  $display ("       0x%h              0x%h            0x%h       ",
                 slave_addr,        reg_addr,       reg_data       );
end
endtask


task I2C_READ;
input [7:0] slave_addr_w;
input [7:0] reg_addr;
input [7:0] slave_addr_r;
output[7:0] read_data;
reg   [7:0] reg_data;
begin
  I2C_START;

  for ( j=0; j<=1; j=j+1 )
  begin
    # i2c_cycle_div4
    for ( i=7; i>=0; i=i-1 )
    begin
      if      ( j==0 ) if ( slave_addr_w[i] ) release SDA; else force SDA = 1'b0;
      else if ( j==1 ) if ( reg_addr[i]     ) release SDA; else force SDA = 1'b0;
      # i2c_cycle_div4 release SCL;
      # i2c_cycle_div2 force SCL = 0;
      # i2c_cycle_div4;
    end
    I2C_WAIT_ACK;
  end

  # i2c_cycle_div4;
  I2C_START;
    
  for ( j=0; j<=0; j=j+1 )
  begin
    # i2c_cycle_div4
    for ( i=7; i>=0; i=i-1 )
    begin
      if      ( j==0 ) if ( slave_addr_r[i] ) release SDA; else force SDA = 1'b0;
      # i2c_cycle_div4 release SCL;
      # i2c_cycle_div2 force SCL = 0;
      # i2c_cycle_div4;
    end
    I2C_WAIT_ACK;
  end

  for ( j=0; j<=0; j=j+1 )
  begin
    # i2c_cycle_div4
    for ( i=7; i>=0; i=i-1 )
    begin
      release SDA;
      # i2c_cycle_div4 release SCL;
      # i2c_cycle_div4;
      if      ( j==0 ) reg_data[i] = SDA;
      # i2c_cycle_div4 force SCL = 0;
      # i2c_cycle_div4;
    end
    //I2C_HOST_ACK;
    I2C_HOST_NACK;
    

  end

  I2C_STOP;
  read_data = reg_data;
  $display ( "------------------------------------ I2C_Read -------------------------------------" );
  $display ( "  Slave_Address  Register_Address  Slave_Address    Register_Data  "  );
  $display ( "       0x%h             0x%h            0x%h              0x%h     ",
                slave_addr_w,      reg_addr,      slave_addr_r,      reg_data       );
end
endtask



//*******************************************************************************************************
//PCA9555
//*******************************************************************************************************

task I2C_READ_2Byte;
input [7:0] slave_addr_w;
input [7:0] reg_addr;
input [7:0] slave_addr_r;
reg   [7:0] reg_data;
reg   [7:0] reg_data2;
begin
  I2C_START;

  for ( j=0; j<=1; j=j+1 )
  begin
    # i2c_cycle_div4
    for ( i=7; i>=0; i=i-1 )
    begin
      if      ( j==0 ) if ( slave_addr_w[i] ) release SDA; else force SDA = 1'b0;
      else if ( j==1 ) if ( reg_addr[i]     ) release SDA; else force SDA = 1'b0;
      # i2c_cycle_div4 release SCL;
      # i2c_cycle_div2 force SCL = 0;
      # i2c_cycle_div4;
    end
    I2C_WAIT_ACK;
  end

  # i2c_cycle_div4;
  I2C_START;
    
  for ( j=0; j<=0; j=j+1 )
  begin
    # i2c_cycle_div4
    for ( i=7; i>=0; i=i-1 )
    begin
      if      ( j==0 ) if ( slave_addr_r[i] ) release SDA; else force SDA = 1'b0;
      # i2c_cycle_div4 release SCL;
      # i2c_cycle_div2 force SCL = 0;
      # i2c_cycle_div4;
    end
    I2C_WAIT_ACK;
  end

  for ( j=0; j<=0; j=j+1 )
  begin
    # i2c_cycle_div4
    for ( i=7; i>=0; i=i-1 )
    begin
      release SDA;
      # i2c_cycle_div4 release SCL;
      # i2c_cycle_div4;
      if      ( j==0 ) reg_data[i] = SDA;
      # i2c_cycle_div4 force SCL = 0;
      # i2c_cycle_div4;
    end
    I2C_HOST_ACK;
  end

  for ( j=0; j<=0; j=j+1 )
  begin
    # i2c_cycle_div4
    for ( i=7; i>=0; i=i-1 )
    begin
      release SDA;
      # i2c_cycle_div4 release SCL;
      # i2c_cycle_div4;
      if      ( j==0 ) reg_data2[i] = SDA;
      # i2c_cycle_div4 force SCL = 0;
      # i2c_cycle_div4;
    end
    I2C_HOST_NACK;
  end
  
  
  I2C_STOP;
  $display ( "------------------------------------ I2C_Read -------------------------------------" );
  $display ( "  Slave_Address  Register_Address  Slave_Address    Register_Data  " );
  $display ("       0x%h             0x%h            0x%h              0x%h       ",
                slave_addr_w,      reg_addr,      slave_addr_r,      reg_data       );
end
endtask
//*******************************************************************************************************
//*******************************************************************************************************

task I2C_WRITE_2Byte;
input [7:0] slave_addr; //
input [7:0] reg_addr;   //
input [7:0] reg_data;   //
input [7:0] reg_data2;  //
begin
   I2C_START;
     for ( j=0; j<=3; j=j+1 )
     begin
       # i2c_cycle_div4
       for ( i=7; i>=0; i=i-1 )
       begin
         if      ( j==0 ) if ( slave_addr[i] ) release SDA; else force SDA = 1'b0;
         else if ( j==1 ) if ( reg_addr[i]   ) release SDA; else force SDA = 1'b0;
         else if ( j==2 ) if ( reg_data[i]   ) release SDA; else force SDA = 1'b0;
        else if  ( j==3 ) if ( reg_data2[i]  ) release SDA; else force SDA = 1'b0;
         # i2c_cycle_div4 release SCL;
         # i2c_cycle_div2 force SCL = 0;
         # i2c_cycle_div4;
       end
       I2C_WAIT_ACK;
     end

     # i2c_cycle_div4;
     I2C_STOP;

     $display ( "-------------------- I2C_Write --------------------" );
     $display ( "  Slave_Address   Register_Address  Register_Data  " );
     $display ("       0x%h              0x%h            0x%h       ",
                    slave_addr,        reg_addr,       reg_data       );
   end
   endtask
   
task I2C_WRITE_4Byte;
input [7:0] slave_addr; //
input [7:0] reg_addr;   //
input [7:0] reg_data;   //
input [7:0] reg_data2;  //
input [7:0] reg_data3;   //
input [7:0] reg_data4;  //
begin
   I2C_START;
     for ( j=0; j<=5; j=j+1 )
     begin
       # i2c_cycle_div4
       for ( i=7; i>=0; i=i-1 )
       begin
         if      ( j==0 ) if ( slave_addr[i] ) release SDA; else force SDA = 1'b0;
         else if ( j==1 ) if ( reg_addr[i]   ) release SDA; else force SDA = 1'b0;
         else if ( j==2 ) if ( reg_data[i]   ) release SDA; else force SDA = 1'b0;
        else if  ( j==3 ) if ( reg_data2[i]  ) release SDA; else force SDA = 1'b0;
        else if  ( j==4 ) if ( reg_data3[i]  ) release SDA; else force SDA = 1'b0;
        else if  ( j==5 ) if ( reg_data4[i]  ) release SDA; else force SDA = 1'b0;
         # i2c_cycle_div4 release SCL;
         # i2c_cycle_div2 force SCL = 0;
         # i2c_cycle_div4;
       end
       I2C_WAIT_ACK;
     end

     # i2c_cycle_div4;
     I2C_STOP;

     $display ( "-------------------- I2C_Write --------------------" );
     $display ( "  Slave_Address   Register_Address  Register_Data  " );
     $display ("       0x%h              0x%h            0x%h       ",
                    slave_addr,        reg_addr,       reg_data       );
   end
   endtask
   
   
task I2C_READ_4Byte;
input [7:0] slave_addr_w;
input [7:0] reg_addr;
input [7:0] slave_addr_r;
reg   [7:0] reg_data1;
reg   [7:0] reg_data2;
reg   [7:0] reg_data3;
reg   [7:0] reg_data4;
begin
  I2C_START;

  for ( j=0; j<=1; j=j+1 )
  begin
    # i2c_cycle_div4
    for ( i=7; i>=0; i=i-1 )
    begin
      if      ( j==0 ) if ( slave_addr_w[i] ) release SDA; else force SDA = 1'b0;
      else if ( j==1 ) if ( reg_addr[i]     ) release SDA; else force SDA = 1'b0;
      # i2c_cycle_div4 release SCL;
      # i2c_cycle_div2 force SCL = 0;
      # i2c_cycle_div4;
    end
    I2C_WAIT_ACK;
  end

  # i2c_cycle_div4;
  I2C_START;
    
  for ( j=0; j<=0; j=j+1 )
  begin
    # i2c_cycle_div4
    for ( i=7; i>=0; i=i-1 )
    begin
      if      ( j==0 ) if ( slave_addr_r[i] ) release SDA; else force SDA = 1'b0;
      # i2c_cycle_div4 release SCL;
      # i2c_cycle_div2 force SCL = 0;
      # i2c_cycle_div4;
    end
    I2C_WAIT_ACK;
  end

  for ( j=0; j<=2; j=j+1 )
  begin
    # i2c_cycle_div4
    for ( i=7; i>=0; i=i-1 )
    begin
      release SDA;
      # i2c_cycle_div4 release SCL;
      # i2c_cycle_div4;
      if      ( j==0 ) reg_data1[i] = SDA;
      else if ( j==1 ) reg_data2[i] = SDA;
      else if ( j==2 ) reg_data3[i] = SDA; 
      # i2c_cycle_div4 force SCL = 0;
      # i2c_cycle_div4;
    end
    I2C_HOST_ACK;
  end

  for ( j=0; j<=0; j=j+1 )
  begin
    # i2c_cycle_div4
    for ( i=7; i>=0; i=i-1 )
    begin
      release SDA;
      # i2c_cycle_div4 release SCL;
      # i2c_cycle_div4;
      if      ( j==0 ) reg_data4[i] = SDA;
      # i2c_cycle_div4 force SCL = 0;
      # i2c_cycle_div4;
    end
    I2C_HOST_NACK;
  end
  
  
  I2C_STOP;
  $display ( "------------------------------------ I2C_Read -------------------------------------" );
  $display ( "  Slave_Address  Register_Address  Slave_Address    Register_Data  " );
  $display ("       0x%h             0x%h            0x%h              0x%h       ",
                slave_addr_w,      reg_addr,      slave_addr_r,      reg_data1       );
end
endtask
   
   
   
//*******************************************************************************************************
// non continue read command 
//*******************************************************************************************************

task I2C_Single_read;
   input [7:0] slave_addr_r;
   input [7:0] reg_addr;
   reg   [7:0] reg_data;
   reg   [7:0] slave_addr;
   begin
      slave_addr = {slave_addr_r[7:1],1'b0};
      I2C_START;
        //Wirte
        for ( j=0; j<=1; j=j+1 )
        begin
          # i2c_cycle_div4
          for ( i=7; i>=0; i=i-1 )
          begin
            if      ( j==0 ) if ( slave_addr[i] ) release SDA; else force SDA = 1'b0;
            else if ( j==1 ) if ( reg_addr[i]   ) release SDA; else force SDA = 1'b0;
            # i2c_cycle_div4 release SCL;
            # i2c_cycle_div2 force SCL = 0;
            # i2c_cycle_div4;
          end
          I2C_WAIT_ACK;
        end

        # i2c_cycle_div4;
      I2C_STOP;

        
        //Read
      I2C_START;

        for ( j=0; j<=0; j=j+1 )
        begin
          # i2c_cycle_div4
          for ( i=7; i>=0; i=i-1 )
          begin
            if      ( j==0 ) if ( slave_addr_r[i] ) release SDA; else force SDA = 1'b0;
            //else if ( j==1 ) if ( reg_addr[i]     ) release SDA; else force SDA = 1'b0;
            # i2c_cycle_div4 release SCL;
            # i2c_cycle_div2 force SCL = 0;
            # i2c_cycle_div4;
          end
          I2C_WAIT_ACK;
        end

        for ( j=0; j<=0; j=j+1 )
        begin
          # i2c_cycle_div4
          for ( i=7; i>=0; i=i-1 )
          begin
            release SDA;
            # i2c_cycle_div4 release SCL;
            # i2c_cycle_div4;
            if      ( j==0 ) reg_data[i] = SDA;
            # i2c_cycle_div4 force SCL = 0;
            # i2c_cycle_div4;
          end
          I2C_HOST_NACK;
        end

      I2C_STOP;
        $display ( "-----------------------------------I2C_Single_read-----------------------------------" );
        $display ( "  Slave_Address  Register_Address      Register_Data  " );
        $display ("       0x%h             0x%h                0x%h       ",
                      slave_addr_r,      reg_addr,           reg_data       );
   end
endtask	
endmodule