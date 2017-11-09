`timescale 1ns/1ns

module tb();
wire   SCL , SDA;
wire   SCL_s , SDA_s;
reg rClk;
reg rRstn;

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
               rClk = 1'b1;
   forever
   #clk_time   rClk = ~rClk;
end
//--------------------------------------------------------------------------------------------------------------------	
//RESETn
//--------------------------------------------------------------------------------------------------------------------	
initial
begin
               rRstn =  1'b0;
   # wait_time rRstn =  1'b1;
end

pullup(pull1) p21( SCL );
pullup(pull1) p22( SDA );

pullup(pull1) p11( SCL_s );
pullup(pull1) p12( SDA_s );

i2c_master_ctrl_top  i2c_master_ctrl_top_inst(
	.iRstn  (rRstn),
   .iClk   (rClk),
	.SCL    (SCL),
	.SDA    (SDA)

);

i2c_mux_top  i2c_mux_top_inst(

   .iRstn (rRstn),
   .iClk  (rClk),
   .SCL_m (SCL),
   .SDA_m (SDA),
   .SCL_s (SCL_s),
   .SDA_s (SDA_s)
   
);

i2c_slave_t_top i2c_slave_t_top_inst(
	.iRstn  (rRstn),
   .iClk   (rClk),
	.SCL    (SCL_s),
	.SDA    (SDA_s)


);




endmodule