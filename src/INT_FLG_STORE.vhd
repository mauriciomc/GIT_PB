----------------------------------------------------------------------------------
-- Company: mauricio.m.c@gmail.com
-- Engineer: Mauricio de Carvalho 
-- 
-- Create Date:    16:02:48 05/09/2010 
-- Design Name:    INT_FLG_STORE.vhd
-- Module Name:    INT_FLG_STORE - Behavioral 
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

entity INT_FLG_STORE is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
			  CTRL_out : in STD_LOGIC;
           CARRY_in : in  STD_LOGIC;
			  CARRY_out : out  STD_LOGIC;
           ZERO_in : in  STD_LOGIC;
			  ZERO_out : out  STD_LOGIC);
			  
end INT_FLG_STORE;

architecture Behavioral of INT_FLG_STORE is

signal OLD_INT : std_logic;
signal CARRY_SAVE : std_logic;
signal ZERO_SAVE:std_logic;
begin

P1:process(CLK,RST,CTRL_out,OLD_INT)
begin
	if(RST='1') then
--		CARRY_out<='0';
--		ZERO_out<='0';
	elsif(CLK'event and CLK='1') then
		CARRY_out <= CARRY_in;
		ZERO_out <= ZERO_in;
		if(CTRL_out='1' and OLD_INT='0') then
			CARRY_SAVE <= CARRY_in;
			ZERO_SAVE <= ZERO_in;
		elsif(CTRL_out='0' and OLD_INT='1') then
			CARRY_out <=  CARRY_SAVE;
			ZERO_out   <=   ZERO_SAVE ;
		end if;
	end if;
end process;


P2:process(CLK,RST)
begin
	if(RST='1') then
		OLD_INT<='0';
	elsif(CLK'event and CLK='1') then
		OLD_INT<=CTRL_out;
	end if;
end process;

end Behavioral;

