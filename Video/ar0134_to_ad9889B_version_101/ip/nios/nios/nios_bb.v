
module nios (
	clk_clk,
	i2c_camera_i2c_serial_sda_in,
	i2c_camera_i2c_serial_scl_in,
	i2c_camera_i2c_serial_sda_oe,
	i2c_camera_i2c_serial_scl_oe,
	i2c_hdmi_tx_i2c_serial_sda_in,
	i2c_hdmi_tx_i2c_serial_scl_in,
	i2c_hdmi_tx_i2c_serial_sda_oe,
	i2c_hdmi_tx_i2c_serial_scl_oe,
	pio_0_external_connection_export,
	reset_reset_n);	

	input		clk_clk;
	input		i2c_camera_i2c_serial_sda_in;
	input		i2c_camera_i2c_serial_scl_in;
	output		i2c_camera_i2c_serial_sda_oe;
	output		i2c_camera_i2c_serial_scl_oe;
	input		i2c_hdmi_tx_i2c_serial_sda_in;
	input		i2c_hdmi_tx_i2c_serial_scl_in;
	output		i2c_hdmi_tx_i2c_serial_sda_oe;
	output		i2c_hdmi_tx_i2c_serial_scl_oe;
	output	[31:0]	pio_0_external_connection_export;
	input		reset_reset_n;
endmodule
