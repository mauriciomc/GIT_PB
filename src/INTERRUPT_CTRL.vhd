----------------------------------------------------------------------------------
-- Company:  mauricio.m.c@gmail.com
-- Engineer: Mauricio de Carvalho
-- 
-- Create Date:    15:44:49 05/09/2010 
-- Design Name:    PicoBlaze
-- Module Name:    INTERRUPT_CTRL - Behavioral 
-- Project Name:   PicoBlaze
-- Target Devices: 
-- Tool versions:  Xilinx 10.2
-- Description:  Provides a single interrupt pulse to other modules indicating that an interrupt occured 
--
-- Dependencies: 
--
-- Revision: 1.0
-- Revision 
-- Additional Comments: 
-- Module tested and working as specified tb_INT_CTRL
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity INTERRUPT_CTRL is
    Port ( CLK : in  STD_LOGIC;           -- Clock signal
           RST : in  STD_LOGIC;           -- Asynchronous Reset
			  INTERRUPT_en : STD_LOGIC;      -- Interrupt enable signal from Control unit
			  INTERRUPT_in : in  STD_LOGIC;  -- Interrupt signal from peripheral 
  			  RETURNI : in STD_LOGIC;        -- Return from interrupt signal 
			  INTERRUPT_out : out STD_LOGIC);-- Interrupt pulse to other modules 
end INTERRUPT_CTRL;

architecture Behavioral of INTERRUPT_CTRL is

signal isInInterrupt : std_logic := '0';

begin

INTERRUPT_CONTROL:process(CLK,RST)
begin
	if(RST='1') then
		INTERRUPT_out <= '0';
		isInInterrupt <= '0';

	elsif(CLK'event and CLK='1') then
		INTERRUPT_out<='0';
		if(INTERRUPT_en = '1') then
			if(INTERRUPT_in = '1') then
				if(isInInterrupt = '0') then
					INTERRUPT_out <= '1';
					isInInterrupt <= '1';
	
				else
					INTERRUPT_out <= '0';
					
				end if;
			else
				INTERRUPT_out <= '0';
			end if;
			if(RETURNI = '1') then
				isInInterrupt <= '0';
			end if;
		end if;
	end if;
end process;	
				
	
end Behavioral;

