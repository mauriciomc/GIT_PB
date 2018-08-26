----------------------------------------------------------------------------------
-- Company:  mauricio.m.c@gmail.com
-- Engineer: Mauricio de Carvalho 
-- 
-- Create Date:    14:56:20 05/09/2010 
-- Design Name:    PORT_ADD_CTRL.vhd
-- Module Name:    PORT_ADD_CTRL - Behavioral 
-- Project Name:   Picoblaze
-- Target Devices: 
-- Tool versions:  Xilinx 10.2
-- Description:    Port Address Controller
--
-- Dependencies: 
--
-- Revision: 1.0
-- Revision 0.01 - File Created
-- Additional Comments: 
-- Module tested with tb_PA_CTRL
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PORT_ADD_CTRL is
    Port ( CLK : in  STD_LOGIC;                               -- Clock Signal
           RST : in  STD_LOGIC;							           -- Reset Signal
           ENABLE : in  STD_LOGIC;									  -- Module enable from Control Unit	 
			  REG_in : in  STD_LOGIC_VECTOR(7 downto 0);         -- Port Address from Register bank
           KONSTANT : in STD_LOGIC_VECTOR(7 downto 0);        -- Port Address from Instruction word, signal comes from Control Unit
			  REG_KONST_sel : in STD_LOGIC;                      -- Select Port Address value from REG or CONSTANT, signal comes from Control Unit 
			  READ_WRITE_in : in STD_LOGIC;                      -- Read or Write (input or output), signal from Control unit
           READ_STROBE_out : out  STD_LOGIC;                  -- Read pulse to external peripheral
           WRITE_STROBE_out : out  STD_LOGIC;                 -- Write pulse to external peripheral
			  PORT_ID_out : out  STD_LOGIC_VECTOR (7 downto 0)); -- Port Address out
end PORT_ADD_CTRL;

architecture Behavioral of PORT_ADD_CTRL is

begin

P1:process(CLK,RST)

begin
	if(RST='1') then
		READ_STROBE_out  <= '0';
		WRITE_STROBE_out <= '0';
		PORT_ID_out <= (others=>'0');
	
	elsif(CLK'event and CLK='1') then
		if(ENABLE='1') then
			if(REG_KONST_sel = '1') then
				PORT_ID_out <= REG_in;
			else
				PORT_ID_out <= KONSTANT;
			end if;
			 
			if(READ_WRITE_in = '0') then
				READ_STROBE_out <= '1';
				WRITE_STROBE_out <= '0';
			else
				WRITE_STROBE_out <= '1';
				READ_STROBE_out <='0';
			end if;
		else
			WRITE_STROBE_out <= '0';
			READ_STROBE_out <= '0';
		end if;
	end if;
end process;

end Behavioral;
