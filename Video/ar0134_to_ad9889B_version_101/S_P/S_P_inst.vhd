	component S_P is
		port (
			probe  : in  std_logic_vector(255 downto 0) := (others => 'X'); -- probe
			source : out std_logic_vector(255 downto 0)                     -- source
		);
	end component S_P;

	u0 : component S_P
		port map (
			probe  => CONNECTED_TO_probe,  --  probes.probe
			source => CONNECTED_TO_source  -- sources.source
		);

