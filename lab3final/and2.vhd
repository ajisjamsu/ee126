-- AND2: A 2-input AND gate
-- Author: Aji Sjamsu

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-----------------------------------------------------------------------

entity AND2 is
port (
      in0    : in  STD_LOGIC;
      in1    : in  STD_LOGIC;
      output : out STD_LOGIC -- in0 and in1
);
end AND2;

-----------------------------------------------------------------------

architecture AND2_arch of AND2 is
begin

  output <= in0 and in1;
  
end AND2_arch;

-----------------------------------------------------------------------

