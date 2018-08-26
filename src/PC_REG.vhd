----------------------------------------------------------------------------------
-- Company: mauricio.m.c@gmail.com	
-- Engineer: Mauricio de Carvalho
-- 
-- Create Date:    15:35:10 05/09/2010 
-- Design Name:    PC_REG.vhd
-- Module Name:    PC_REG - Behavioral 
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

entity PC_REG is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
			  CALL : in STD_LOGIC;
			  RETRN : in STD_LOGIC;
			  INPUT : in  STD_LOGIC_VECTOR (7 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (7 downto 0);
           TO_STACK_in : in STD_LOGIC_VECTOR (7 downto 0);
			  TO_STACK_out : out  STD_LOGIC_VECTOR (7 downto 0));
end PC_REG;

architecture Behavioral of PC_REG is

signal OUT_tmp : std_logic_vector(7 downto 0);

begin

P1:process(CLK,RST)
begin
	if(RST='1')then
		OUT_tmp<=(others=>'0');
		TO_STACK_out<=(others=>'0');
		
	elsif(CLK='1' and CLK'event) then
		if(CALL = '1' and RETRN='0' ) then
			TO_STACK_out <= OUT_tmp;
			OUT_tmp <= INPUT;
			
		elsif(CALL = '0' and RETRN ='0') then
			OUT_tmp <= INPUT;
			
		elsif(CALL='0' and RETRN='1') then
			OUT_tmp <= TO_STACK_in;

		end if;
	end if;
end process;

OUTPUT<=OUT_tmp;

end Behavioral;

