----------------------------------------------------------------------------------
-- Company: mauricio.m.c@gmail.com	
-- Engineer: Mauricio de Carvalho
-- 
-- Create Date:    15:30:52 05/09/2010 
-- Design Name:    FLOW_CTRL.vhd
-- Module Name:    FLOW_CTRL - Behavioral 
-- Project Name:   picoBlaze
-- Target Devices: 
-- Tool versions:  xilinx 10.2
-- Description: 
--
-- Dependencies: 
--
-- Revision: 1.0
-- Additional Comments: 
-- 
-- This module includes the Flow Control Unit, PC register and stack.
 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FLOW_CTRL is
    Port ( CLK 			: in  STD_LOGIC;    -- Clock
           RST 			: in  STD_LOGIC;    -- Reset
           CARRY_in 		: in  STD_LOGIC;    -- Carry Flag from Carry Flag Control Unit
           ZERO_in 		: in  STD_LOGIC;    -- Zero Flag from Zero
           KONSTANT 		: in  STD_LOGIC_VECTOR(7 downto 0); -- Constant value coming from Control Unit
           CALL 			: in  STD_LOGIC;    -- Call signal from Control Unit indicating a Call was made
			  JUMP 			: in  STD_LOGIC;    -- Jump signal from Control Unit indicating a jump was made
			  RETURN_CALL 	: in  STD_LOGIC;    -- Return call signal from control unit
			  INTERRUPT 	: in  STD_LOGIC;    -- Interrupt signal from Interrupt controller
			  RETURNI 		: in  STD_LOGIC;    -- Return from interrupt signal coming from Control Unit
			  CONDITION_JMP: in  STD_LOGIC_VECTOR(2 downto 0); -- Condition to jump signals coming from control unit
			  OUTPUT 		: out STD_LOGIC_VECTOR (7 downto 0)); -- Output address = Program Counter
end FLOW_CTRL;

architecture Behavioral of FLOW_CTRL is

signal saveOutput : std_logic_vector(7 downto 0):=(others=>'0');
signal takeJump : STD_LOGIC;
signal isInsideInterrupt : STD_LOGIC :='0';

signal stack0 : std_logic_vector(7 downto 0):=(others=>'0');
signal stack1 : std_logic_vector(7 downto 0):=(others=>'0');
signal stack2 : std_logic_vector(7 downto 0):=(others=>'0');
signal stack3 : std_logic_vector(7 downto 0):=(others=>'0');

signal stackPointer : std_logic_vector(1 downto 0):=(others=>'0');

signal pc : std_logic_vector(7 downto 0):=(others=>'0');

begin

P1:process(CLK,RST)
begin
	if(RST='1') then
		pc <= (others=>'0');
		isInsideInterrupt <= '0';
		stackPointer <= "00";
		stack0 <= (others=>'0');
		stack1 <= (others=>'0');
		stack2 <= (others=>'0');
		stack3 <= (others=>'0');
		
	elsif(CLK'event and CLK='1') then
		
		if(takeJump = '0') then
			pc <= pc+'1';
		end if;
		
		if(isInsideInterrupt='0' and INTERRUPT='1') then
			saveOutput <= pc;
			pc <= "11111111";
			isInsideInterrupt <= '1';
		end if;
		
		if(isInsideInterrupt='1' and RETURNI='1') then
			isInsideInterrupt <= '0';
			pc <= saveOutput+'1';
		end if;
		
		if(CALL='1' and takeJump='1') then
			pc <= KONSTANT;
			stackPointer <= stackPointer+'1';
			case stackPointer is
				when "00" => stack0 <= pc;
				when "01" => stack1 <= pc;
				when "10" => stack2 <= pc;
				when "11" => stack3 <= pc;
				when others => null;
			end case;
				
		elsif(JUMP='1' and takeJump='1') then
			pc <= KONSTANT;
		end if;

		if(RETURN_CALL='1') then
			--if(stackPointer/="00") then
				stackPointer <= stackPointer-'1';
			--end if;
			case stackPointer is
				when "00" => pc <= stack0;  
				when "01" => pc <= stack1;  
				when "10" => pc <= stack2;  
				when "11" => pc <= stack3;  
				when others => null;
			end case;
		end if;
	end if;
end process;

OUTPUT <= pc;

takeJump <= CONDITION_JMP(2) and(((not(CONDITION_JMP(1)) and ZERO_in) and not CONDITION_JMP(0))
										or ((not(CONDITION_JMP(1)) and not(ZERO_in)) and CONDITION_JMP(0))
										or ((CONDITION_JMP(1) and CARRY_in) and not(CONDITION_JMP(0)))
										or ((CONDITION_JMP(1) and not CARRY_in) and CONDITION_JMP(0)));

end Behavioral;

