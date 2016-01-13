`timescale 1 ns/100 ps
module tb_Top;

reg   RESETn, SYSTEM_CLK;
wire  SCL, SDA;


i2c_mark_rw U01  ( .RESETn     ( RESETn     ),
				 .SYSTEM_CLK ( SYSTEM_CLK ),
				 // I2C_Interface
				 .SCL        ( SCL        ),
				 .SDA        ( SDA        )
			   );

pullup(pull1) p00( SCL );  // why?? mark: pullup resistor so SCL =1 ???
pullup(pull1) p01( SDA );  // why??

parameter time_unit      = 1;					//1ns
parameter clk_time       = 400 * time_unit;   	// 2.5MHz
parameter clk_time_div2  = ( clk_time /   2 );	//200ns,1.25Mhz
parameter clk_time_div10 = ( clk_time / 100 );	//4ns,250Mhz 
parameter wait_time      = clk_time * 1000; 	//400ns*1000
parameter wait_long_time = clk_time * 10000;	//10us

initial
begin
  SYSTEM_CLK = 1'b1;
  forever
    #clk_time_div2 SYSTEM_CLK = ~SYSTEM_CLK;
end

/*initial
begin
  CP = 1'b1;
  forever
    #clk_time CP = ~CP;
end */

initial
begin
  RESETn   = 1'b0;
  release SDA; // why??
  release SCL; // why??

  # wait_time   RESETn = 1'b1;
  // Function --- I2C
  # wait_time   I2C_WRITE  ( 8'h46, 8'h08, 8'hA5 ); //0100,0110,  0000,1000  1010,0101
  # wait_time   I2C_READ   ( 8'h46, 8'h08, 8'h47 );	//0100,0110,  0000,1000  0100,0111

  # wait_time   $finish;
end


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
    I2C_HOST_ACK;
  end

  I2C_STOP;
  $display ( "------------------------------------ I2C_Read -------------------------------------" );
  $display ( "  Slave_Address  Register_Address  Slave_Address    Register_Data  " );
  $display ("       0x%h             0x%h            0x%h              0x%h       ",
                slave_addr_w,      reg_addr,      slave_addr_r,      reg_data       );
end
endtask


endmodule
