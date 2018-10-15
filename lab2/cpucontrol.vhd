-- CPUControl : 
-- Author: Aji Sjamsu

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-----------------------------------------------------------------------

entity CPUControl is
-- Functionality should match the truth table shown in Figure 4.22 of the textbook, inlcuding the
--    output 'X' values.
-- The truth table in Figure 4.22 omits the jump instruction:
--    Jump = '1'
--    MemWrite = RegWrite = '0'
--    all other outputs = 'X'
port(Opcode   : in  STD_LOGIC_VECTOR(5 downto 0);
     RegDst   : out STD_LOGIC;
     Branch   : out STD_LOGIC;
     MemRead  : out STD_LOGIC;
     MemtoReg : out STD_LOGIC;
     MemWrite : out STD_LOGIC;
     ALUSrc   : out STD_LOGIC;
     RegWrite : out STD_LOGIC;
     Jump     : out STD_LOGIC;
     ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
);
end CPUControl;

-----------------------------------------------------------------------

architecture CPUControl_arch of CPUControl is
begin

process(Opcode)
  begin
case Opcode is 
	when "000000" => -- R-format
		RegDst 	 <= '1';
		AluSrc 	 <= '0';
		MemtoReg <= '0';
		RegWrite <= '1';
		MemRead  <= '0';
		MemWrite <= '0';
		Branch 	 <= '0';
		ALUOp	   <= "10";
		Jump	 <= '0';
		
	when "100011" => -- load word
		RegDst 	 <= '0';
		AluSrc 	 <= '1';
		MemtoReg <= '1';
		RegWrite <= '1';
		MemRead  <= '1';
		MemWrite <= '0';
		Branch 	 <= '0';
		ALUOp	 <= "00";
		Jump	 <= '0';
	
	when "101011" => -- store word
		RegDst 	 <= 'X';
		AluSrc 	 <= '1';
		MemtoReg <= 'X';
		RegWrite <= '0';
		MemRead  <= '0';
		MemWrite <= '1';
		Branch 	 <= '0';
		ALUOp	 <= "00";
		Jump	 <= '0';
	
	when "000100" => -- branch on equal
		RegDst 	 <= 'X';
		AluSrc 	 <= '0';
		MemtoReg <= 'X';
		RegWrite <= '0';
		MemRead  <= '0';
		MemWrite <= '0';
		Branch 	 <= '1';
		ALUOp	 <= "01";
		Jump	 <= '0';
	
	when "000010" => -- jump
		RegDst 	 <= 'X';
		AluSrc 	 <= 'X';
		MemtoReg <= 'X';
		RegWrite <= '0';
		MemRead  <= 'X';
		MemWrite <= '0';
		Branch 	 <= 'X';
		ALUOp	 <= "XX";
		Jump	 <= '1';
		
	when others =>
		RegDst 	 <= '0';
		AluSrc 	 <= '0';
		MemtoReg <= '0';
		RegWrite <= '0';
		MemRead  <= '0';
		MemWrite <= '0';
		Branch 	 <= '0';
		ALUOp	 <= "00";
end case;
end process;

end CPUControl_arch;

-----------------------------------------------------------------------
