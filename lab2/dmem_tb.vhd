library ieee;
use ieee.std_logic_1164.all;

entity DMEM_tb is
end DMEM_tb;

architecture tb of DMEM_tb is

    component DMEM
        port (WriteData          : in std_logic_vector (31 downto 0);
              Address            : in std_logic_vector (31 downto 0);
              MemRead            : in std_logic;
              MemWrite           : in std_logic;
              Clock              : in std_logic;
              ReadData           : out std_logic_vector (31 downto 0);
              DEBUG_MEM_CONTENTS : out std_logic_vector (32*4 - 1 downto 0));
    end component;

    signal WriteData          : std_logic_vector (31 downto 0);
    signal Address            : std_logic_vector (31 downto 0);
    signal MemRead            : std_logic;
    signal MemWrite           : std_logic;
    signal Clock              : std_logic;
    signal ReadData           : std_logic_vector (31 downto 0);
    signal DEBUG_MEM_CONTENTS : std_logic_vector (32*4 - 1 downto 0);

    constant TbPeriod : time := 100 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : DMEM
    port map (WriteData          => WriteData,
              Address            => Address,
              MemRead            => MemRead,
              MemWrite           => MemWrite,
              Clock              => Clock,
              ReadData           => ReadData,
              DEBUG_MEM_CONTENTS => DEBUG_MEM_CONTENTS);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that Clock is really your main clock signal
    Clock <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        WriteData <= (others => '0');
        Address <= (others => '0');
        MemRead <= '0';
        MemWrite <= '0';

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;