-- ALU.vhd : 
-- Author: Aji Sjamsu

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-----------------------------------------------------------------------

entity ALU is
-- Implement: AND, OR, ADD (signed), SUBTRACT (signed)
--    as described in Section 4.4 in the textbook.
-- The functionality of each instruction can be found on the 'MIPS Reference Data' sheet at the
--    front of the textbook.
port(
     a         : in     STD_LOGIC_VECTOR(31 downto 0);
     b         : in     STD_LOGIC_VECTOR(31 downto 0);
     operation : in     STD_LOGIC_VECTOR(3 downto 0);
     result    : buffer STD_LOGIC_VECTOR(31 downto 0);
     zero      : buffer STD_LOGIC;
     overflow  : buffer STD_LOGIC
);
end ALU;

-----------------------------------------------------------------------

architecture ALU_arch of ALU is

signal result_sig : STD_LOGIC_VECTOR(31 downto 0);
signal a_sig, b_sig, sum_sig : signed(32 downto 0);
signal overflow_sig, zero_sig : std_logic;

begin

process(operation, a, b)
  begin
case operation is
	when "0000" =>
		result_sig <= a AND b;
	
	when "0001" =>
		result_sig <= a OR b;
	
	when "0010" => --add
		--a_sig   <= resize(signed(a), 33);
    --b_sig   <= resize(signed(b), 33);
		sum_sig <= resize(signed(a), 33) + resize(signed(b), 33);
                result_sig <= std_logic_vector(signed(a) + signed(b)); 
                
		if sum_sig(32) /= sum_sig(31) then
		  overflow_sig <= '1';  
		else
		  overflow_sig <= '0';
		end if;
		
		if result_sig(31 downto 0)= x"00000000" then
		  zero_sig <= '1';
		else
		  zero_sig <= '0';
    end if; 
	
	when "0110" => --subtract
		result_sig <= std_logic_vector(signed(a) - signed(b));
		
		if signed(a) > signed(b) then
		  overflow_sig <= '1';
		end if;
		
		if result_sig(31 downto 0)= x"00000000" then
		  zero_sig <= '1';
		else
		  zero_sig <= '0';
    end if; 
	
	when others =>
		result_sig <= x"00000000";
		zero_sig <= '0';
		overflow_sig <= '0';
		
end case;

end process;

result <= result_sig;
overflow <= overflow_sig;
zero <= zero_sig;

end ALU_arch;

-----------------------------------------------------------------------
