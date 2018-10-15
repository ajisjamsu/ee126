-- registers : 32-bit registers for quick-access use by MIPS processor
-- Author: Aji Sjamsu

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

-----------------------------------------------------------------------

entity registers is
-- This component is described in the textbook, starting on page 2.52
-- The indices of each of the registers can be found on the MIPS reference page at the front of the
--    textbook
-- Keep in mind that register 0(zero) has a constant value of 0 and cannot be overwritten

-- This should only write on the negative edge of Clock when RegWrite is asserted.
-- Reads should be purely combinatorial, i.e. they don't depend on Clock
-- HINT: Use the provided dmem.vhd as a starting point
port(RR1      : in  STD_LOGIC_VECTOR (4 downto 0); 
     RR2      : in  STD_LOGIC_VECTOR (4 downto 0); 
     WR       : in  STD_LOGIC_VECTOR (4 downto 0); 
     WD       : in  STD_LOGIC_VECTOR (31 downto 0);
     RegWrite : in  STD_LOGIC;
     Clock    : in  STD_LOGIC;
     RD1      : out STD_LOGIC_VECTOR (31 downto 0);
     RD2      : out STD_LOGIC_VECTOR (31 downto 0);
     --Probe ports used for testing
     -- $t0 & $t1 & t2 & t3
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0);
     -- $s0 & $s1 & s2 & s3
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0)
);
end registers;

-----------------------------------------------------------------------

architecture registers_arch of registers is

type MemArray is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0); 
signal registers : MemArray;

begin

process(Clock,RR1,RR2,WR,WD,RegWrite) -- Run when any of these inputs change
	variable addr1 : integer;
	variable addr2 : integer;
	variable addrW : integer;
	variable first:boolean := true; -- Used for initialization
	begin
	-- This part of the process initializes the memory and is only here for simulation purposes
    -- It does not correspond with actual hardware!
    if(first) then
      registers(0)  <= x"00000000";
      registers(8)  <= x"00000000";
      registers(9)  <= x"00000001";  
      registers(10) <= x"00000002";  
      registers(11) <= x"00000004"; 
		  registers(16) <= x"00000008"; 
		  registers(17) <= x"00000010"; 
		  registers(18) <= x"00000020"; 
		  registers(19) <= x"00000040"; 
      first := false; -- Don't initialize the next time this process runs
	 end if;

	 -- Write on the negative edge of the clock
  if falling_edge(Clock) and RegWrite='1' then 
        addrW:=to_integer(unsigned(WR)); 
		if addrW = 0 then report "Attempting to overwrite hard-wired zero register."
			severity error;
		--elsif addrW = 26 or addrW = 27 then report "Attempting to --overwrite reserved kernel registers."
		--	severity error;
		else
			registers(addrW) <= WD;
		end if;
		
	else -- Reads don't need to be edge triggered
        addr1:=to_integer(unsigned(RR1));
		addr2:=to_integer(unsigned(RR2));

		RD1 <= registers(addr1);
		RD2 <= registers(addr2);
	
  end if;
	
	DEBUG_TMP_REGS <= 
		registers(8) & registers(9) & registers(10) & registers(11);
	DEBUG_SAVED_REGS <= 
		registers(16) & registers(17) & registers(18) & registers(19);

end process;

end registers_arch;

-----------------------------------------------------------------------

