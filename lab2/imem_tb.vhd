library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_IMEM is
end tb_IMEM;

architecture tb of tb_IMEM is

    component IMEM
        port (Address  : in std_logic_vector (31 downto 0);
              ReadData : out std_logic_vector (31 downto 0));
    end component;

    signal Address  : std_logic_vector (31 downto 0);
    signal ReadData : std_logic_vector (31 downto 0);

begin

    dut : IMEM
    port map (Address  => Address,
              ReadData => ReadData);

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        Address <= (others => '0');

        -- EDIT Add stimuli here

        wait;
    end process;

end tb;