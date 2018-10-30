-- SignExtend: Handles sign extension from 16 to 32 bit reg
-- Author: Aji Sjamsu

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-----------------------------------------------------------------------

entity SignExtend is
port(
     x : in  STD_LOGIC_VECTOR(15 downto 0);
     y : out STD_LOGIC_VECTOR(31 downto 0) -- sign-extend(x)
);
end SignExtend;

-----------------------------------------------------------------------

architecture SignExtend_arch of SignExtend is
begin

-- use the resize function to sign extend in the appropriate manner
-- for x, then convert back to a SLV
y <= std_logic_vector(resize(signed(x), y'length));
  
end SignExtend_arch;

-----------------------------------------------------------------------

