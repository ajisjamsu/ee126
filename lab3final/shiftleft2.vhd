-- ShiftLeft2: Shifts the input by 2 bits
-- Author: Aji Sjamsu

library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

-----------------------------------------------------------------------

entity ShiftLeft2 is -- Shifts the input by 2 bits
port(
     x : in  STD_LOGIC_VECTOR(31 downto 0);
     y : out STD_LOGIC_VECTOR(31 downto 0) -- x << 2
);
end ShiftLeft2;

-----------------------------------------------------------------------

architecture ShiftLeft2_arch of ShiftLeft2 is
begin

y(31 downto 2) <= x(29 downto 0);
y(1 downto 0) <= "00";
  
end ShiftLeft2_arch;

-----------------------------------------------------------------------

