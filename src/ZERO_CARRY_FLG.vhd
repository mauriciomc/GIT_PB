----------------------------------------------------------------------------------
-- Company: mauricio.m.c@gmail.com	
-- Engineer: Mauricio de Carvalho
-- 
-- Create Date:    15:09:59 05/09/2010 
-- Design Name:  ZERO_CARRY_FLG
-- Module Name:  ZERO_CARRY_FLG - Behavioral 
-- Project Name: Picoblaze 
-- Target Devices: 
-- Tool versions: xilinx 10.2 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 1.0
-- Revision 0.01 - File Created
-- Additional Comments: 
-- Module tested with tb_ZERO_CARRY_UNIT
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ZERO_CARRY_FLG is
    Port ( CLK : in  STD_LOGIC;          -- Clock Signal
           RST : in  STD_LOGIC;          -- Asynchronous reset 
           CARRY_in : in  STD_LOGIC;     -- Carry Flag value from ALU
           ZERO_in : in  STD_LOGIC;      -- Zero Flag value from ALU
           INTERRUPT_in : in  STD_LOGIC; -- Interrupt pulse from Interrupt Controller
			  RETURNI : in STD_LOGIC;       -- Return from interrupt signal from Control Unit  
           CARRY_out : out  STD_LOGIC;   -- Carry Flag output to Flow control Unit 
           ZERO_out : out  STD_LOGIC);   -- Zero Flag output to Flow control Unit
end ZERO_CARRY_FLG;

architecture Behavioral of ZERO_CARRY_FLG is

signal saveCarry : std_logic:='0';  -- Saves Carry Flag when entered Interrupt
signal saveZero : std_logic := '0'; -- Saves Zero Flag when entered Interrupt

signal isInInterrupt : std_logic := '0';   -- Saves interrupt state

begin
P1:process(CLK,RST)
begin
	if(RST='1') then
		CARRY_out <= '0';
		ZERO_out  <= '0';
		saveCarry <= '0';
		saveZero  <= '0';
		isInInterrupt <= '0';
		
	elsif(CLK='1' and CLK'event) then
		CARRY_out <= CARRY_in;
		ZERO_out  <= ZERO_in;
		if(isInInterrupt='0') then
			if(INTERRUPT_in='1') then
				isInInterrupt<='1';
				saveCarry <= CARRY_in;
				saveZero  <= ZERO_in;
				CARRY_out <= '0';
				ZERO_out  <= '0';
			end if;
		
		elsif(isInInterrupt='1' and RETURNI = '1') then
			CARRY_out <= saveCarry;
			ZERO_out  <= saveZero;
			isInInterrupt<='0';
		
		end if;	
	end if;
end process;		
end Behavioral;


