module i2c_mux_top(
   input   iRstn, iClk,
   //master_in
	input  SCL_m,
	inout   SDA_m,
   
   
   //mux out
	output  SCL_s,
	inout   SDA_s

);






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
  .iClk     ( iClk                       ),
  .iRstn    ( iRstn                      ),
  .iSCL_m   ( host_i2c_scl_in_sig        ),
  .oSCLoe_m ( i2c_mux_host_scl_out_sig_n ),
  .iSDA_m   ( host_i2c_sda_in_sig        ),
  .oSDAoe_m ( i2c_mux_host_sda_out_sig_n ),
  .iSCL_s   ( i2c_mux_dev_scl_in_sig     ), 
  .oSCLoe_s ( i2c_mux_dev_scl_out_sig_n  ),
  .iSDA_s   ( i2c_mux_dev_sda_in_sig     ),
  .oSDAoe_s ( i2c_mux_dev_sda_out_sig_n  )
 
);

assign SCL_s              = (!i2c_mux_dev_scl_out_sig_n) ? 1'b0 : 1'bZ;
assign i2c_mux_dev_scl_in_sig = SCL_s;
assign SDA_s              = (!i2c_mux_dev_sda_out_sig_n) ? 1'b0 : 1'bZ;
assign i2c_mux_dev_sda_in_sig = SDA_s;



endmodule