-- IMEM : byte addressable, big-endian, read-only memory
-- Author: Aji Sjamsu

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

-----------------------------------------------------------------------

entity IMEM is
-- The instruction memory is a byte addressable, big-endian, read-only memory
-- Reads occur continuously
-- HINT: Use the provided dmem.vhd as a starting point
generic(NUM_BYTES : integer := 128);
-- NUM_BYTES is the number of bytes in the memory (small to save computation resources)
port(
     Address  : in  STD_LOGIC_VECTOR(31 downto 0); -- Address to read from
     ReadData : out STD_LOGIC_VECTOR(31 downto 0)
);
end IMEM;

-----------------------------------------------------------------------

architecture IMEM_arch of IMEM is

type ByteArray is array (0 to NUM_BYTES) of STD_LOGIC_VECTOR(7 downto 0); 
signal imemBytes:ByteArray;

begin

	process(Address)
	variable addr:integer;
	variable first:boolean := true; -- Used for initialization

	begin
		-- This part of the process initializes the memory and is only here for simulation purposes
		-- It does not correspond with actual hardware!
		if(first) then
			-- Example: MEM(0x4) = 0x11330098 = 0b 0001 0001 0011 0011 0000 0000 1001 1000 = 288555160(decimal)
			imemBytes(4)  <= "00010001";  
			imemBytes(5)  <= "00110011";  
			imemBytes(6)  <= "00000000";  
			imemBytes(7)  <= "10011000"; 
			first := false; -- Don't initialize the next time this process runs
		end if;
		  
		addr:=to_integer(unsigned(Address)); -- Convert the address
		if (addr+3 < NUM_BYTES) then -- Check that the address is within the bounds of the memory
			ReadData <= imemBytes(addr) & imemBytes(addr+1) &
				imemBytes(addr+2) & imemBytes(addr+3);
		else report "Invalid DMEM addr."
			severity error;
		end if;
		
	end process;
	
end IMEM_arch;

-----------------------------------------------------------------------
