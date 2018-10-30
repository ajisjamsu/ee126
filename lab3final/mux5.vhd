-- MUX5: A 5-to-1 multiplexer
-- Author: Aji Sjamsu

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-----------------------------------------------------------------------

entity MUX5 is -- Two by one mux with 5 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(4 downto 0)
);
end MUX5;

-----------------------------------------------------------------------

architecture MUX5_arch of MUX5 is
begin

process(sel, in0, in1)
begin
	case sel is
		when '0' => 
			output <= in0;
		when '1' =>
			output <= in1;
		when others =>
			output <= (others => '0');
	end case;

end process;
  
end MUX5_arch;

-----------------------------------------------------------------------

