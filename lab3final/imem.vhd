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
			imemBytes(0) <= x"8C"; -- lw $t2 0($z)
			imemBytes(1) <= x"0A";
			imemBytes(2) <= x"00";
			imemBytes(3) <= x"00"; 
			imemBytes(4) <= x"11"; -- L1: beq $t0 $t2 L2
			imemBytes(5) <= x"0A";
			imemBytes(6) <= x"00";
			imemBytes(7) <= x"03";
			imemBytes(8) <= x"02"; -- sub $s0 $s0 $s1
			imemBytes(9) <= x"11";
			imemBytes(10) <= x"80";
			imemBytes(11) <= x"22";
			imemBytes(12) <= "00000001"; -- add
			imemBytes(13) <= "00001001";
			imemBytes(14) <= "01000000";
			imemBytes(15) <= "00100000"; 
			imemBytes(16) <= "00001000"; -- j L1
			imemBytes(17) <= "00000000";
			imemBytes(18) <= "00000000";
			imemBytes(19) <= "00000001"; 
			imemBytes(20) <= "00000010"; -- L2: or
			imemBytes(21) <= "00001011";
			imemBytes(22) <= "10010000";
			imemBytes(23) <= "00100101";
			imemBytes(24) <= "00000010"; -- and
			imemBytes(25) <= "01010011";
			imemBytes(26) <= "10010000";
			imemBytes(27) <= "00100100";
			imemBytes(28) <= "10101101"; -- sw
			imemBytes(29) <= "01110010";
			imemBytes(30) <= "00000000";
			imemBytes(31) <= "00000100";
			imemBytes(32) <= "00000000"; -- nop
			imemBytes(33) <= "00000000";
			imemBytes(34) <= "00000000";
			imemBytes(35) <= "00000000"; 
			first := false; -- Don't initialize the next time this process runs
		end if;
		  
		addr:=to_integer(unsigned(Address)); -- Convert the address
		if (addr+3 < NUM_BYTES) then -- Check that the address is within the bounds of the memory
			ReadData <= imemBytes(addr) & imemBytes(addr+1) &
				imemBytes(addr+2) & imemBytes(addr+3);
		else report "Invalid IMEM addr."
			severity error;
		end if;
		
	end process;
	
end IMEM_arch;

-----------------------------------------------------------------------
