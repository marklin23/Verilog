	component simple_avmm_bfm is
		port (
			clk_clk                                     : in  std_logic                     := 'X';             -- clk
			reg32_read_port_external_connection_export  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			reg32_write_port_external_connection_export : out std_logic_vector(31 downto 0);                    -- export
			reset_reset_n                               : in  std_logic                     := 'X'              -- reset_n
		);
	end component simple_avmm_bfm;

	u0 : component simple_avmm_bfm
		port map (
			clk_clk                                     => CONNECTED_TO_clk_clk,                                     --                                  clk.clk
			reg32_read_port_external_connection_export  => CONNECTED_TO_reg32_read_port_external_connection_export,  --  reg32_read_port_external_connection.export
			reg32_write_port_external_connection_export => CONNECTED_TO_reg32_write_port_external_connection_export, -- reg32_write_port_external_connection.export
			reset_reset_n                               => CONNECTED_TO_reset_reset_n                                --                                reset.reset_n
		);

