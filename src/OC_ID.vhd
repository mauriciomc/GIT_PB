----------------------------------------------------------------------------------
-- Company:  mauricio.m.c@gmail.com
-- Engineer: Mauricio de Carvalho
-- 
-- Create Date:  15:43:06 05/09/2010 
-- Design Name:  OC_IC.vhd
-- Module Name:  OC_ID - Behavioral 
-- Project Name: PicoBlaze
-- Target Devices: 
-- Tool versions: Xilinx 10.2
-- Description: 
--
-- Dependencies: 
--
-- Revision: 1.0
-- Revision 0.01 - File Created
-- Additional Comments: 
-- Control Unit
 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.constants.all;
use WORK.alu_type.all;


---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity OC_ID is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           INSTRUCTION : in  STD_LOGIC_VECTOR (15 downto 0);
           CTRL_PORT_S_ADDR : out  STD_LOGIC_VECTOR (2 downto 0);
           CTRL_PORT_T_ADDR : out  STD_LOGIC_VECTOR (2 downto 0);
			  CTRL_REGS_en : out STD_LOGIC;
			  CTRL_REGS_rw : out STD_LOGIC;
			  CTRL_REGS_PA_sel : out STD_LOGIC;
			  CTRL_ALU : out TYPE_OP;
			  CTRL_K_ALU : out std_logic;
           CONST_DATA : out  STD_LOGIC_VECTOR (7 downto 0);
			  INTERRUPT_en:out STD_LOGIC;
			  RETURNI:out STD_LOGIC;
			  READ_WRITE_PA:out STD_LOGIC;
			  PORT_ADDRESS_en:out STD_LOGIC;
			  CALL:out STD_LOGIC;
			  JUMP:out STD_LOGIC;
			  CONDITION_JMP:out STD_LOGIC_VECTOR(2 downto 0);
			  RETURN_CALL : out STD_LOGIC;
			  MUX_sel : out STD_LOGIC);
end OC_ID;

architecture Behavioral of OC_ID is

--PROGRAM CONTROL SIGNALS
signal command : std_logic_vector(4 downto 0):= (others=>'0');
signal condition : std_logic_vector(2 downto 0) := (others=>'0');
signal address : std_logic_vector(7 downto 0) := (others=>'0');


--SHIFT ROTATE SIGNALS
signal shift_op : std_logic_vector(2 downto 0):=(others=>'0');
signal shift_dir : std_logic:='0';
signal sx : std_logic_vector(2 downto 0):=(others=>'0');

--LOGICAL GROUP SIGNALs
signal sy : std_logic_vector(2 downto 0):=(others=>'0');
signal konstant : std_logic_vector(7 downto 0):=(others=>'0');


--INTERRUPT GROUP
signal interrupt_enable : std_logic:='0';

--TEMPORARY VARIABLES
signal strobeRegsDelay : std_logic:='0';

begin

--PROGRAM CONTROL GROUP
command <= INSTRUCTION (15 downto 11);
condition <= INSTRUCTION (10 downto 8);
address <= INSTRUCTION (7 downto 0);

--SHIFT AND ROTATE 
shift_op <= INSTRUCTION (2 downto 0);
shift_dir <= INSTRUCTION(3);
CTRL_PORT_S_ADDR <= INSTRUCTION(10 downto 8);

--LOGICAL GROUP
CTRL_PORT_T_ADDR <= INSTRUCTION(7 downto 5);
konstant <= INSTRUCTION(7 downto 0);

--INTERRUPT GROUP
interrupt_enable <= INSTRUCTION(0);

process(CLK,RST)
begin
	if(RST='1') then
		RETURN_CALL <= '0';
		CALL <= '0';
		JUMP <= '0';
		CTRL_ALU <= ADD;
		READ_WRITE_PA <=  '0';
		CONST_DATA <= (others=>'0');
		INTERRUPT_en <= '0';
		RETURNI <= '0';
		CTRL_K_ALU <= '0';
		PORT_ADDRESS_en<='0';
		CONDITION_JMP <= (others=>'0');
		RETURN_CALL <= '0';
		CTRL_REGS_en <= '0';
		CTRL_REGS_rw <= '0';
		strobeRegsDelay <='0';
		MUX_sel <='0';
		
	elsif(CLK='1' and CLK'event) then
		CONDITION_JMP <= condition;
		CONST_DATA <= konstant;
		RETURN_CALL <= '0';
		RETURNI <= '0';
		CTRL_ALU <= NOP;
		PORT_ADDRESS_en <= '0';
		CTRL_REGS_en <= '0';
		CTRL_REGS_rw <= '0';
		CTRL_REGS_PA_sel <= '0';
		CTRL_K_ALU <= COMMAND(3);
		strobeRegsDelay<='0';
		MUX_sel<='0';
		
		case COMMAND is
		
		--PROGRAM CONTROL GROUP
		when "1101-" => -- JUMP OR CALL
	
			if(COMMAND(0)='1') then --CALL
				CALL <= '1';
			else                    --JUMP
				JUMP <= '0';
			end if;
		

		when "10010" => -- RETURN
			RETURN_CALL <= '1';
	
		--SHIFT/ROTATE GROUP
		when "10100" => -- SHIFT/ROTATE
			strobeRegsDelay <= '1';
			case INSTRUCTION(3 downto 0) is
				--left
				when "0110" => -- shift left injecting zero
					CTRL_ALU <= SL0;
			 
				when "0111" => -- shift left injecting one
					CTRL_ALU <= SL1;
				
				when "0010" => -- shift left injecting MSB/LSB
					CTRL_ALU <= SLX;
			
				when "0000" => -- shift left injecting carry
					CTRL_ALU <= SLC;
			
				when "0100" => -- rotate left injecting LSB/MSB
					CTRL_ALU <= RL;
			
				-- right
				when "1110" => -- shift right injecting zero
					CTRL_ALU <= SR0;
				
				when "1111" => -- shift right injecting one
					CTRL_ALU <= SR1;
			
				when "1010" => -- shift right injecting MSB/LSB
					CTRL_ALU <= SRX;
			
				when "1000" => -- shift right injecting carry
					CTRL_ALU <= SRC;
			
				when "1100" => -- rotate right injecting LSB/MSB
					CTRL_ALU <= RR;
			
				when others => null;
			end case;
			
		--LOGICAL GROUP
		when "0-000" => -- LOAD
			CTRL_ALU <= LOAD;
			strobeRegsDelay<='1';
	
		when "0-001" => -- AND
			CTRL_ALU <= BITAND;
			strobeRegsDelay<='1';

		when "0-010" => -- OR
			CTRL_ALU <= BITOR;
			strobeRegsDelay<='1';
		
		when "0-011" => -- XOR
			CTRL_ALU <= BITXOR;
			strobeRegsDelay<='1';

		--ARITHMETIC GROUP
		when "0-100" => -- ADD    sX,C
			CTRL_ALU <= ADD;
			strobeRegsDelay<='1';
			
		when "0-101" => -- ADDCY  sX,C
			CTRL_ALU <= ADDC;
			strobeRegsDelay<='1';
		
		when "0-110" => -- SUB	  sX,C
			CTRL_ALU <= SUB;
			strobeRegsDelay<='1';
	
		when "0-111" => -- SUBY   sX,C
			CTRL_ALU <= SUBC;
			strobeRegsDelay<='1';
	
		--INPUT/OUTPUT GROUP
		when "1-000" => -- INPUT
			READ_WRITE_PA <= '0';
			PORT_ADDRESS_en <= '1';
			CTRL_REGS_en <= '1';
			CTRL_REGS_rw <= '1';
			CTRL_REGS_PA_sel <= '1';
			strobeRegsDelay<='0';
			MUX_sel<='1';
			
		when "1-001" => -- OUTPUT
			READ_WRITE_PA <= '1';
			PORT_ADDRESS_en <= '1';
			CTRL_REGS_en <= '1';
			CTRL_REGS_rw <= '0';
			strobeRegsDelay<='0';			
	
		--INTERRUPT GROUP
		when "11110" => INTERRUPT_en  <= interrupt_enable; -- INTERRUPT
		when "10110" => RETURNI <= '1';
		when others => null;
	end case;
	
	if(strobeRegsDelay='1') then
		CTRL_REGS_en<='1';
		CTRL_REGS_rw <= '1';
		strobeRegsDelay<='0';
		
	end if;	
end if;
end process;
end Behavioral;

