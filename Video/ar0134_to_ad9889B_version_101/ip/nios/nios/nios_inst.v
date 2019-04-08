	nios u0 (
		.clk_clk                          (<connected-to-clk_clk>),                          //                       clk.clk
		.i2c_camera_i2c_serial_sda_in     (<connected-to-i2c_camera_i2c_serial_sda_in>),     //     i2c_camera_i2c_serial.sda_in
		.i2c_camera_i2c_serial_scl_in     (<connected-to-i2c_camera_i2c_serial_scl_in>),     //                          .scl_in
		.i2c_camera_i2c_serial_sda_oe     (<connected-to-i2c_camera_i2c_serial_sda_oe>),     //                          .sda_oe
		.i2c_camera_i2c_serial_scl_oe     (<connected-to-i2c_camera_i2c_serial_scl_oe>),     //                          .scl_oe
		.i2c_hdmi_tx_i2c_serial_sda_in    (<connected-to-i2c_hdmi_tx_i2c_serial_sda_in>),    //    i2c_hdmi_tx_i2c_serial.sda_in
		.i2c_hdmi_tx_i2c_serial_scl_in    (<connected-to-i2c_hdmi_tx_i2c_serial_scl_in>),    //                          .scl_in
		.i2c_hdmi_tx_i2c_serial_sda_oe    (<connected-to-i2c_hdmi_tx_i2c_serial_sda_oe>),    //                          .sda_oe
		.i2c_hdmi_tx_i2c_serial_scl_oe    (<connected-to-i2c_hdmi_tx_i2c_serial_scl_oe>),    //                          .scl_oe
		.pio_0_external_connection_export (<connected-to-pio_0_external_connection_export>), // pio_0_external_connection.export
		.reset_reset_n                    (<connected-to-reset_reset_n>)                     //                     reset.reset_n
	);

