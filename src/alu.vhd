library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use WORK.constants.all;
use WORK.alu_type.all;


entity ALU is
  generic (N : integer := 8);
  port 	 ( FUNC: IN TYPE_OP;
			  KONST_OR_DATA2 : IN std_logic;
           DATA1 : IN std_logic_vector(N-1 downto 0);
			  DATA2 : IN std_logic_vector(N-1 downto 0);
			  KONSTANT : IN std_logic_vector(N-1 downto 0);
           OUTALU: OUT std_logic_vector(N-1 downto 0);
			  CARRY : out std_logic;
			  ZERO : out std_logic);
end ALU;

architecture BEHAVIOR of ALU is

signal DATA2_tmp : std_logic_vector(N-1 downto 0) := (others=>'0');
signal CARRY_tmp : std_logic := '0';
signal ZERO_tmp : std_logic := '0';
signal OUTALU_tmp : std_logic_vector(N downto 0) := (others=>'0');

begin
P_DATA2:process(KONST_OR_DATA2,DATA2,KONSTANT)
begin
	if(KONST_OR_DATA2 = '0') then
		DATA2_tmp <= KONSTANT;
	else
		DATA2_tmp <= DATA2;
	end if;
end process;
		

P_ALU: process (FUNC, DATA1, DATA2_tmp,CARRY_tmp)
  -- complete all the requested functions

  begin
    case FUNC is
	 when ADD 	=> OUTALU_tmp <= ('0' & DATA1) + ('0' & DATA2_tmp) ; 
 	 when ADDC 	=> OUTALU_tmp <= ('0' & DATA1) + ('0' & DATA2_tmp) + CARRY_tmp; 
	 when SUB 	=> OUTALU_tmp <= ('0' & DATA1) - ('0' & DATA2_tmp);
	 when SUBC  => OUTALU_tmp <= ('0' & DATA1) - ('0' & DATA2_tmp) - CARRY_tmp;
	 --when MULT 	=> OUTALU <= ((N-1 downto N/2 => '0')&DATA1(N/2-1 downto 0)) * ((N-1 downto N/2 => '0')&DATA2_tmp(N/2-1 downto 0));
	 when BITAND 	=> OUTALU_tmp <= ('0' & DATA1) and ('0' & DATA2_tmp); -- bitwise operations
	 when BITOR 	=> OUTALU_tmp <= ('0' & DATA1) or ('0' & DATA2_tmp);
	 when BITXOR 	=> OUTALU_tmp <= ('0' & DATA1) xor ('0' & DATA2_tmp);
	 when SL0 	=> OUTALU_tmp <= DATA1(N-1) & DATA1(N-2 downto 0)&'0'; -- logical shift left, HELP: use the concatenation operator &  
	 when SL1 	=> OUTALU_tmp <= DATA1(N-1) & DATA1(N-2 downto 0)&'1';
	 when SL_A 	=> OUTALU_tmp <= DATA1(N-1) & DATA1(N-2 downto 0)&CARRY_tmp;
	 when SLX 	=> OUTALU_tmp <= DATA1(N-1) & DATA1(N-2 downto 0)&DATA1(0);
	 when SR0 	=> OUTALU_tmp <= DATA1(0) & '0'&DATA1(N-1 downto 1); -- shift right with 0 injection
	 when SR1 	=> OUTALU_tmp <= DATA1(0) & '1'&DATA1(N-1 downto 1); -- shift right with 1 injection
	 when SR_A 	=> OUTALU_tmp <= DATA1(0) & CARRY_tmp&DATA1(N-1 downto 1); -- shift right with CARRY injection
	 when SRX 	=> OUTALU_tmp <= DATA1(0) & DATA1(N-1)&DATA1(N-1 downto 1); --shift right with sign extend
	 when RL 	=> OUTALU_tmp <= DATA1(N-1) & DATA1(N-2 downto 0)&DATA1(N-1); -- rotate left
	 when RR 	=> OUTALU_tmp <= DATA1(0) & DATA1(0)&DATA1(N-1 downto 1); -- rotate right
	 when LOAD => OUTALU_tmp <= '0' & DATA2_tmp;
	 when NOP => OUTALU_tmp <= '0' & DATA1;
	 when others => null;
   end case; 
  end process P_ALU;

--P_CARRY:process(OUTALU_tmp,DATA1,DATA2_tmp,CARRY_tmp)
--begin	
--	if(OUTALU_tmp > X"11") then
--		CARRY_tmp <= '1';
--	else
--		CARRY_tmp <= '0';
--	end if;
--end process P_CARRY;


ZERO_tmp <= OUTALU_tmp(7) or OUTALU_tmp(6) or OUTALU_tmp(5) or OUTALU_tmp(4) or OUTALU_tmp(3) or OUTALU_tmp(2) or OUTALU_tmp(1) or OUTALU_tmp(0);
ZERO <= not ZERO_tmp;

CARRY_tmp <= OUTALU_tmp(N);
CARRY <=  CARRY_tmp;

OUTALU <= OUTALU_tmp(7 downto 0);

end BEHAVIOR;

configuration CFG_ALU_BEHAVIORAL of ALU is
  for BEHAVIOR
  end for;
end CFG_ALU_BEHAVIORAL;
