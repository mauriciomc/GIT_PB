----------------------------------------------------------------------------------
-- Company: mauricio.m.c@gmail.com	
-- Engineer: Mauricio de Carvalho
-- 
-- Create Date:    15:33:09 05/09/2010 
-- Design Name:    PC_STACK.vhd
-- Module Name:    PC_STACK - Behavioral 
-- Project Name:   Picoblaze
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_STACK is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           PUSH : in  STD_LOGIC;
           POP : in STD_LOGIC;
			  FIRST_ELEMENT_in : in  STD_LOGIC_VECTOR (7 downto 0);
			  FIRST_ELEMENT_out : out  STD_LOGIC_VECTOR (7 downto 0));
end PC_STACK;

architecture Behavioral of PC_STACK is

signal top_element : std_logic_vector(7 downto 0) := (others=>'0');
signal CTRL_in_old : std_logic := '0';

begin

P1:process(CLK,RST)
begin
	if(RST='1') then
		FIRST_ELEMENT_out<=(others=>'0');
		top_element <= (others=>'0');
		
	elsif(CLK='1' and CLK'event) then
		if(PUSH='1' and POP='0')then
				top_element <= FIRST_ELEMENT_in; -- make an array
		elsif(PUSH='0' and POP='1') then
				FIRST_ELEMENT_out <= top_element;
		end if;
	end if;
end process;
		

end Behavioral;

