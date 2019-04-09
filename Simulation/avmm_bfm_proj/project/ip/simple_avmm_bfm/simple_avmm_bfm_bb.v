
module simple_avmm_bfm (
	clk_clk,
	reg32_read_port_external_connection_export,
	reg32_write_port_external_connection_export,
	reset_reset_n);	

	input		clk_clk;
	input	[31:0]	reg32_read_port_external_connection_export;
	output	[31:0]	reg32_write_port_external_connection_export;
	input		reset_reset_n;
endmodule
