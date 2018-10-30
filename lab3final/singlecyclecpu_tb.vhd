library ieee;
use ieee.std_logic_1164.all;

entity SingleCycleCPU_tb is
end SingleCycleCPU_tb;

architecture tb of SingleCycleCPU_tb is

    component SingleCycleCPU
        port (clk                : in std_logic;
              rst                : in std_logic;
              DEBUG_PC           : out std_logic_vector (31 downto 0);
              DEBUG_INSTRUCTION  : out std_logic_vector (31 downto 0);
              DEBUG_TMP_REGS     : out std_logic_vector (32*4 - 1 downto 0);
              DEBUG_SAVED_REGS   : out std_logic_vector (32*4 - 1 downto 0);
              DEBUG_MEM_CONTENTS : out std_logic_vector (32*4 - 1 downto 0));
    end component;

    signal clk                : std_logic := '0';
    signal rst                : std_logic;
    signal DEBUG_PC           : std_logic_vector (31 downto 0);
    signal DEBUG_INSTRUCTION  : std_logic_vector (31 downto 0);
    signal DEBUG_TMP_REGS     : std_logic_vector (32*4 - 1 downto 0);
    signal DEBUG_SAVED_REGS   : std_logic_vector (32*4 - 1 downto 0);
    signal DEBUG_MEM_CONTENTS : std_logic_vector (32*4 - 1 downto 0);

    constant TbPeriod : time := 100 ns; -- Put right period here
    signal TbSimEnded : std_logic := '0';

begin

    dut : SingleCycleCPU
    port map (clk                => clk,
              rst                => rst,
              DEBUG_PC           => DEBUG_PC,
              DEBUG_INSTRUCTION  => DEBUG_INSTRUCTION,
              DEBUG_TMP_REGS     => DEBUG_TMP_REGS,
              DEBUG_SAVED_REGS   => DEBUG_SAVED_REGS,
              DEBUG_MEM_CONTENTS => DEBUG_MEM_CONTENTS);

    -- Clock generation

	stim_proc : process
	begin
        -- Reset generation
        clk <= '1';
		rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 20 ns;
		clk <= '0';
		wait for 80 ns;
		
		loop
		clk <= '1';
		wait for 100 ns;
		clk <= '0';
		wait for 100 ns;
		end loop;
		
		wait;
	end process;


end tb;