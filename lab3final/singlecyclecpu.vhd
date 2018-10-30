-- singlecyclecpu.vhd : Full implementation of single cycle CPU
-- Author: Aji Sjamsu

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-----------------------------------------------------------------------

entity SingleCycleCPU is
port(clk :in STD_LOGIC;
     rst :in STD_LOGIC;
     --Probe ports used for testing
     --The current address (AddressOut from the PC)
     DEBUG_PC : out STD_LOGIC_VECTOR(31 downto 0);
     --The current instruction (Instruction output of IMEM)
     DEBUG_INSTRUCTION : out STD_LOGIC_VECTOR(31 downto 0);
     --DEBUG ports from other components
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0);
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0);
     DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(32*4 - 1 downto 0)
);
end SingleCycleCPU;

-----------------------------------------------------------------------

architecture SingleCycleCPU_arch of SingleCycleCPU is
	signal sys_rst : std_logic;
	signal sys_clk : std_logic;

	-- IMEM signals
	signal IMEM_addr	: std_logic_vector(31 downto 0);
	signal instruction  : std_logic_vector(31 downto 0);
	signal offset		: std_logic_vector(31 downto 0);
	signal offset_sl2	: std_logic_vector(31 downto 0);
	
	-- control unit signals
	-- opcode is part of instruction
	signal RegDst	: std_logic;
	signal Branch	: std_logic;
	signal MemRead	: std_logic;
	signal MemtoReg	: std_logic; -- controls 2x1 MUX
	signal MemWrite	: std_logic;
	signal ALUSrc	: std_logic;
	signal RegWrite	: std_logic;
	signal Jump		: std_logic;
	
	-- regfile signals
	-- RR1 and RR2 part of instruction
        signal WR       : STD_LOGIC_VECTOR (4 downto 0); --write reg
        signal WD       : STD_LOGIC_VECTOR (31 downto 0); --write data
        -- reg_clock is sys_clk
        signal RD1      : STD_LOGIC_VECTOR (31 downto 0);
        signal RD2      : STD_LOGIC_VECTOR (31 downto 0);
	-- debug regs?
	
	-- ALU/ALU control signals
        signal ALUOp     	: STD_LOGIC_VECTOR(1 downto 0);
        -- funct comes from instruction
        signal Operation	: STD_LOGIC_VECTOR(3 downto 0);
	-- ALU_in1 comes from RD1
        signal ALU_in2    	: STD_LOGIC_VECTOR(31 downto 0);
        signal ALU_out   	: STD_LOGIC_VECTOR(31 downto 0);
        signal ALU_zero   	: STD_LOGIC;
        signal ALU_overflow	: STD_LOGIC;
	
	-- DMEM signals
	-- write data is RD2
	-- write Address is ALU_out
	signal DMEM_out		: std_logic_vector(31 downto 0);
	-- debug mem contents?
	
	-- PC signals
	signal PC_addr_in	: std_logic_vector(31 downto 0);
	-- PC address out becomes imem addr
	signal increment	: std_logic_vector(31 downto 0);
	signal PC_add4		: std_logic_vector(31 downto 0);
	signal PC_offset	: std_logic_vector(31 downto 0);
	signal PC_no_jump	: std_logic_vector(31 downto 0);
	signal jump_addr	: std_logic_vector(31 downto 0);
	signal PC_jump_sl2	: std_logic_vector(31 downto 0);
	signal PC_final		: std_logic_vector(31 downto 0);
	signal PCSrc		: STD_LOGIC;
	
begin
	sys_clk <= clk;
	sys_rst <= rst;

	pc_inst	: entity work.pc
	port map(
		clk		=>	sys_clk,
		rst		=>	sys_rst,
		write_enable	=> 	'1',
		AddressIn	=>	PC_addr_in,
		AddressOut	=>	IMEM_addr
	);
	DEBUG_PC <= IMEM_addr;
	
	increment <= x"00000004";
	pc_incrementer_inst : entity work.add
	port map(
		in0 	=>	IMEM_addr,
		in1	=>	increment,
		output	=>	PC_add4
	);
	
	jump_addr <= "000000" & instruction(25 downto 0);
	pc_jump_sl2_inst : entity work.shiftleft2
	port map(
		x	=>	jump_addr,
		y	=>	PC_jump_sl2
	);
	
	pc_addOffset_inst : entity work.add
	port map(
		in0	=>	PC_add4,
		in1	=>	offset_sl2,
		output	=>	PC_offset
	);
	
	pc_chooseOffset_inst : entity work.mux32
	port map(
		in0	=>	PC_add4,
		in1	=>	PC_offset,
		sel	=>	PCSrc,
		output	=>	PC_final
	);
	
	PC_no_jump <= PC_add4(31 downto 28) & PC_jump_sl2(27 downto 0);
	pc_muxfinal_inst : entity work.mux32
	port map(
		in0 	=>	PC_final,
		in1 	=> 	PC_no_jump,
		sel	=>	Jump,
		output	=>	PC_addr_in
	);
	
	imem_inst : entity work.imem
	port map(	
		Address		=>	IMEM_addr,
		ReadData	=>	instruction
	);
	DEBUG_INSTRUCTION <= instruction;
	
	offset_sign_extend_inst : entity work.signextend
	port map(
		x 	=>	instruction(15 downto 0),
		y 	=>	offset
	);
	
	offset_SL2_inst : entity work.shiftleft2
	port map(
		x	=>	offset,
		y	=>	offset_sl2
	);
	
	control_inst : entity work.cpucontrol
	port map(
		Opcode		=>  instruction(31 downto 26),
		RegDst   	=>	RegDst,
		Branch   	=>	Branch,
		MemRead  	=>	MemRead,
		MemtoReg 	=> 	MemtoReg,
		MemWrite 	=>	MemWrite,
		ALUSrc   	=>	ALUSrc,
		RegWrite 	=>	RegWrite,
		Jump    	=>	Jump,
		ALUOp		=>	ALUOp
	);
	
	register_mux_inst : entity work.mux5
	port map(
		in0		=>	instruction(20 downto 16),
		in1		=>	instruction(15 downto 11),
		sel		=>	RegDst,
		output	        =>	WR
	);
	
	registers_inst : entity work.registers
	port map(
		RR1			=>	instruction(25 downto 21),
		RR2			=>	instruction(20 downto 16),
		WR			=>	WR,
		WD			=>	WD,
		RegWrite	        =>	RegWrite,
		Clock		        =>	sys_clk,
		RD1			=>	RD1,
		RD2			=>	RD2,
		DEBUG_TMP_REGS 		=> 	DEBUG_TMP_REGS,
		DEBUG_SAVED_REGS        => 	DEBUG_SAVED_REGS
	);
		
	ALU_mux_inst : entity work.mux32
	port map(
		in0		=>	RD2,
		in1		=>	offset,
		sel		=>	ALUSrc,
		output 	        =>	ALU_in2
	);
	
	ALUControl_inst : entity work.ALUControl
	port map(
		ALUOp		=>	ALUOp,
		Funct		=>	instruction(5 downto 0),
		Operation 	=>	Operation
	);
	
	ALU_inst : entity work.ALU
	port map(
		a		=>	RD1,
		b		=>	ALU_in2,
		operation 	=>	Operation,
		result 		=>	ALU_out,
		zero 		=>	ALU_zero,
		overflow	=>	ALU_overflow	
	);
	
	PCSrc_and_inst : entity work.and2
	port map(
		in0	=>	Branch,
		in1 	=>	ALU_zero,
		output	=>	PCSrc
	);
	
	DMEM_inst : entity work.DMEM
	port map(
		WriteData	=>	RD2,
		Address		=>	ALU_out,
		MemRead		=>	MemRead,
		MemWrite	=>	MemWrite,
		Clock		=>	sys_clk,
		ReadData	=>	DMEM_out,
		DEBUG_MEM_CONTENTS => DEBUG_MEM_CONTENTS
	);
	
	DMEM_mux_inst : entity work.mux32
	port map(
		in0	=>	ALU_out,
		in1	=>	DMEM_out,
		sel	=>	MemtoReg,
		output  =>	WD
	);
	
end SingleCycleCPU_arch;
