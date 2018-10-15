library ieee;
use ieee.std_logic_1164.all;

entity tb_registers is
end tb_registers;

architecture tb of tb_registers is

    component registers
        port (RR1              : in std_logic_vector (4 downto 0);
              RR2              : in std_logic_vector (4 downto 0);
              WR               : in std_logic_vector (4 downto 0);
              WD               : in std_logic_vector (31 downto 0);
              RegWrite         : in std_logic;
              Clock            : in std_logic;
              RD1              : out std_logic_vector (31 downto 0);
              RD2              : out std_logic_vector (31 downto 0);
              DEBUG_TMP_REGS   : out std_logic_vector (32*4 - 1 downto 0);
              DEBUG_SAVED_REGS : out std_logic_vector (32*4 - 1 downto 0));
    end component;

    signal RR1              : std_logic_vector (4 downto 0);
    signal RR2              : std_logic_vector (4 downto 0);
    signal WR               : std_logic_vector (4 downto 0);
    signal WD               : std_logic_vector (31 downto 0);
    signal RegWrite         : std_logic;
    signal Clock            : std_logic;
    signal RD1              : std_logic_vector (31 downto 0);
    signal RD2              : std_logic_vector (31 downto 0);
    signal DEBUG_TMP_REGS   : std_logic_vector (32*4 - 1 downto 0);
    signal DEBUG_SAVED_REGS : std_logic_vector (32*4 - 1 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : registers
    port map (RR1              => RR1,
              RR2              => RR2,
              WR               => WR,
              WD               => WD,
              RegWrite         => RegWrite,
              Clock            => Clock,
              RD1              => RD1,
              RD2              => RD2,
              DEBUG_TMP_REGS   => DEBUG_TMP_REGS,
              DEBUG_SAVED_REGS => DEBUG_SAVED_REGS);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that Clock is really your main clock signal
    Clock <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        RR1 <= (others => '0');
        RR2 <= (others => '0');
        WR <= (others => '0');
        WD <= (others => '0');
        RegWrite <= '0';

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
