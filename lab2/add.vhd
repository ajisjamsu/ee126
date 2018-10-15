-- ADD : Adds two signed 32-bit inputs
-- Author: Aji Sjamsu

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-----------------------------------------------------------------------

entity ADD is
-- Adds two signed 32-bit inputs
-- output = in1 + in2
port(
     in0    : in  STD_LOGIC_VECTOR(31 downto 0);
     in1    : in  STD_LOGIC_VECTOR(31 downto 0);
     output : out STD_LOGIC_VECTOR(31 downto 0)
);
end ADD;

-----------------------------------------------------------------------

architecture ADD_arch of ADD is
begin

	output <= std_logic_vector(signed(in0) + signed(in1));
  
end ADD_arch;

-----------------------------------------------------------------------