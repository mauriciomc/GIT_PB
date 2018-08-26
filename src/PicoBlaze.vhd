----------------------------------------------------------------------------------
-- Company: mauricio.m.c@gmail.com
-- Engineer: Mauricio De Carvalho				
-- 
-- Create Date:    14:41:42 05/09/2010 
-- Design Name:  PicoBlaze.vhd
-- Module Name:    PicoBlaze - Behavioral 
-- Project Name: PicoBlaze
-- Target Devices: 
-- Tool versions: Xilinx 10.1 
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
use WORK.constants.all;
use WORK.alu_type.all;

entity PicoBlaze is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           IN_PORT_in : in  STD_LOGIC_vector(7 downto 0);
           INTERRUPT_in : in  STD_LOGIC;
         -- INSTRUCTION_in : in  STD_LOGIC_VECTOR (15 downto 0);
           PORT_ID_out : out  STD_LOGIC_VECTOR(7 downto 0);
           READ_STROBE_out : out  STD_LOGIC;
           WRITE_STROBE_out : out  STD_LOGIC;
           ADDRESS_out : out  STD_LOGIC_VECTOR (7 downto 0);
			  OUTPORT: out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end PicoBlaze;

architecture Structural of PicoBlaze is

component DATA_MEM is
	generic (N:integer:= 8);
	port (CLK : in std_logic;
			RST : in std_logic;
			DATA : in std_logic_vector (N-1 downto 0);
			ADDR  : in std_logic_vector (N-1 downto 0);
			r : in std_logic;
			w : in std_logic;
			OUTPUT : out std_logic_vector (N-1 downto 0));
end component;

component REGISTER_N is
	 GENERIC (N : INTEGER:=8);
    Port ( RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           INPUT : in  STD_LOGIC_VECTOR (N-1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

component ROM1 is
	port( address : in std_logic_vector(7 downto 0);
		clk : in std_logic;
		dout : out std_logic_vector(15 downto 0));
end component;
	
component REGFILE is
	 generic(N:integer:=8);
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC; 
           PORT_S_ADDR : in  STD_LOGIC_VECTOR (2 downto 0);
           PORT_T_ADDR : in  STD_LOGIC_VECTOR (2 downto 0);
           PORT_D_ADDR : in  STD_LOGIC_VECTOR (2 downto 0);
           WRITE_D_EN : in  STD_LOGIC;
  	   PORT_sel : in  STD_LOGIC;
           PORT_D_IN : in  STD_LOGIC_VECTOR (N-1 downto 0);
           PORT_S_OUT : out  STD_LOGIC_VECTOR (N-1 downto 0);
           PORT_T_OUT : out  STD_LOGIC_VECTOR (N-1 downto 0);
           OUT_PORT : out  STD_LOGIC_VECTOR (N-1 downto 0);
			  PA_PORT : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

component PORT_ADD_CTRL is
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
end component;

component ALU is
  generic (N : integer := 8);
  port 	 ( FUNC: IN TYPE_OP;
	   KONST_OR_DATA2 : IN std_logic;
           DATA1 : IN std_logic_vector(N-1 downto 0);
	   DATA2 : IN std_logic_vector(N-1 downto 0);
	   KONSTANT : IN std_logic_vector(N-1 downto 0);
           OUTALU: OUT std_logic_vector(N-1 downto 0);
	   CARRY : out std_logic;
	   ZERO : out std_logic);
end component;

component ZERO_CARRY_FLG is
    Port ( CLK : in  STD_LOGIC;          -- Clock Signal
           RST : in  STD_LOGIC;          -- Asynchronous reset 
           CARRY_in : in  STD_LOGIC;     -- Carry Flag value from ALU
           ZERO_in : in  STD_LOGIC;      -- Zero Flag value from ALU
           INTERRUPT_in : in  STD_LOGIC; -- Interrupt pulse from Interrupt Controller
	   RETURNI : in STD_LOGIC;       -- Return from interrupt signal from Control Unit  
           CARRY_out : out  STD_LOGIC;   -- Carry Flag output to Flow control Unit 
           ZERO_out : out  STD_LOGIC);   -- Zero Flag output to Flow control Unit
end component;

component FLOW_CTRL is
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
end component;

component OC_ID is
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
end component;

component INTERRUPT_CTRL is
    Port ( CLK : in  STD_LOGIC;           -- Clock signal
           RST : in  STD_LOGIC;           -- Asynchronous Reset
	   INTERRUPT_en : STD_LOGIC;      -- Interrupt enable signal from Control unit
	   INTERRUPT_in : in  STD_LOGIC;  -- Interrupt signal from peripheral 
  	   RETURNI : in STD_LOGIC;        -- Return from interrupt signal 
	   INTERRUPT_out : out STD_LOGIC);-- Interrupt pulse to other modules 
end component;

component MUX is
    Generic (N:integer);
	 Port ( input1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           input2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

signal MUX_out : std_logic_vector(7 downto 0):= (others=>'0');

signal REGBANK_PA_PORT : std_logic_vector(7 downto 0):= (others=>'0');
signal REGBANK_OUTPORT : std_logic_vector(7 downto 0):= (others=>'0');
signal REGBANK_OUTA : std_logic_vector(7 downto 0):= (others=>'0');
signal REGBANK_OUTB : std_logic_vector(7 downto 0):= (others=>'0');

signal ALU_out : std_logic_vector(7 downto 0):= (others=>'0');
signal ALU_CARRY_out : std_logic := '0';
signal ALU_ZERO_out : std_logic := '0';

signal ZC_CARRY_out : std_logic := '0';
signal ZC_ZERO_out : std_logic := '0';
signal ZC_IFS_CARRY_in: std_logic := '0';
signal ZC_IFS_CARRY_out: std_logic := '0';
signal ZC_IFS_ZERO_in: std_logic := '0';
signal ZC_IFS_ZERO_out: std_logic := '0';

signal PROG_FLOW_out : std_logic_vector(7 downto 0) := (others=>'0');

signal OC_KONSTANT:  std_logic_vector(7 downto 0) := (others=>'0');
signal OC_MUX_sel : std_logic := '0';
signal OC_PA_CTRL : std_logic := '0';
signal OC_PA_en : std_logic := '0';
signal OC_INT_en : std_logic := '0';
signal OC_PA_rw : std_logic := '0';
signal OC_REGS_en : std_logic := '0';
signal OC_REGS_rw : std_logic := '0';
signal OC_PORT_sel:  std_logic := '0'; --_vector(2 downto 0) := (others=>'0');
signal OC_REGS_KONST_sel :  std_logic := '0';
signal OC_REGS_PA_sel : std_logic := '0';
signal OC_COND_JUMP :  STD_LOGIC_VECTOR(2 downto 0) := (others=>'0');
signal OC_RETURN_CALL:  std_logic:= '0';
signal OC_RETURNI : std_logic:= '0';
signal OC_CALL : std_logic:='0';
signal OC_JUMP : std_logic:='0';
signal OC_ALU_FUNC : TYPE_OP := ADD;

signal INT_CTRL_out : std_logic:= '0';
signal INT_out : std_logic:= '0';

signal PORT_S_ADDR : std_logic_vector(2 downto 0) := (others=>'0');
signal PORT_T_ADDR : std_logic_vector(2 downto 0) := (others=>'0');
signal PORT_D_ADDR : std_logic_vector(2 downto 0) := (others=>'0');

--signal ADDRESS_out : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
signal INSTRUCTION_in : STD_LOGIC_VECTOR (15 downto 0) := (others=>'0');

--signal CLK : std_logic := '0';
--signal RST : std_logic := '1';
--signal INTERRUPT_in : STD_LOGIC := '0';
--signal IN_PORT_in :  STD_LOGIC_vector(7 downto 0) := (others=>'0');
 
--signal READ_STROBE_out: STD_LOGIC := '0';
--signal WRITE_STROBE_out :  STD_LOGIC := '0';
--signal ADDRESS_out :   STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
--signal OUTPORT:   STD_LOGIC_VECTOR (7 downto 0):= (others=>'0');
--signal PORT_ID_out :  STD_LOGIC_VECTOR(7 downto 0):= (others=>'0');

begin

--RST <= '0' after 50 ms;
--INTERRUPT_in <= '0','1' after 100 ms, '0' after 100 ms;
--IN_PORT_in <= "00000001" after 51 ms, "01010101" after 52 ms;

--process(RST,CLK)
--begin
--	 if(RST = '1') then
--		CLK <= '0';
--	 end if;
--	 CLK <= not CLK after 50 ms;
--end process;

MUX_REGS:MUX generic map(8) port map(ALU_out,
												 IN_PORT_in,
												 OC_MUX_sel,
												 MUX_out);

REGBANK:REGFILE generic map (8)
					 port map( CLK, 
								  RST,
								  PORT_S_ADDR,
							     PORT_T_ADDR,
								  PORT_S_ADDR,
								  OC_REGS_rw, 
								  OC_REGS_PA_sel,
								  MUX_out, 
								  REGBANK_OUTA,
								  REGBANK_OUTB,
								  OUTPORT,
								  REGBANK_PA_PORT);
				
PA_UNIT:PORT_ADD_CTRL port map     (CLK,                -- Clock Signal
												RST,                -- Asynchronour Reset Signal
 	  										   OC_PA_en,           -- Module enable input signal from Control Unit	 
												REGBANK_PA_PORT,    -- Port Address input value from Register bank
											   OC_KONSTANT,        -- Port Address input value from Instruction word, signal comes from Control Unit
											   OC_REGS_KONST_sel,   -- Select Port Address input value from REG or CONSTANT, signal comes from Control Unit 
												OC_PA_rw,           -- Read or Write input signal (input or output instructions), signal from Control unit
												READ_STROBE_out,    -- Read pulse out to external peripheral
											   WRITE_STROBE_out,   -- Write pulse out to external peripheral
												PORT_ID_out);       -- Port Address out                                                                      

					

ALU1:ALU generic map(8) port map(OC_ALU_FUNC,
										   OC_REGS_KONST_sel,
										   REGBANK_OUTA, 
										   REGBANK_OUTB,
										   OC_KONSTANT,
										   ALU_out,
										   ALU_CARRY_out,
										   ALU_ZERO_out);
					 

ZERO_CARRY_UNIT:ZERO_CARRY_FLG  port map(CLK,            -- Clock Signal
													  RST,            -- Asynchronous reset 
													  ALU_CARRY_out,  -- Carry Flag value from ALU
													  ALU_ZERO_out,   -- Zero Flag value from ALU
													  INT_CTRL_out,   -- Interrupt pulse from Interrupt Controller
													  OC_RETURNI,     -- Return from interrupt signal from Control Unit  
													  ZC_CARRY_out,   -- Carry Flag output to Flow control Unit 
													  ZC_ZERO_out);   -- Zero Flag output to Flow control Unit             

FLOW_UNIT:FLOW_CTRL port map      (CLK,                -- Clock
											  RST,                -- Reset
											  ZC_CARRY_out,       -- Carry Flag from Zero Carry Flag Control Unit
											  ZC_ZERO_out,        -- Zero Flag from Zero Carry Flag Control Unit
											  OC_KONSTANT,        -- Constant value coming from Control Unit
											  OC_CALL,            -- Call signal from Control Unit indicating a Call was made
											  OC_JUMP,            -- Jump signal from Control Unit indicating a jump was made
											  OC_RETURN_CALL,     -- Return call signal from control unit
											  INT_CTRL_out,       -- Interrupt signal from Interrupt controller
											  OC_RETURNI,         -- Return from interrupt signal coming from Control Unit    
											  OC_COND_JUMP,       -- Condition to jump signals coming from control unit 
											  PROG_FLOW_out);-- Output address = Program Counter

OC_ID_UNIT:OC_ID port map(CLK, 
								  RST, 
								  INSTRUCTION_in,
								  PORT_S_ADDR,
								  PORT_T_ADDR,
								  OC_REGS_en,
								  OC_REGS_rw,
								  OC_REGS_PA_sel,
								  OC_ALU_FUNC,
								  OC_REGS_KONST_sel,
								  OC_KONSTANT,
								  OC_INT_en,
								  OC_RETURNI,
								  OC_PA_rw,
								  OC_PA_en,
								  OC_CALL,
								  OC_JUMP,
								  OC_COND_JUMP,
								  OC_RETURN_CALL,
								  OC_MUX_sel);
								  
INT_CTRL_UNIT:INTERRUPT_CTRL port map(CLK,          -- Clock signal
										        RST,          -- Asynchronous Reset
										        OC_INT_en,	 -- Interrupt enable signal from Control unit				  
										        INTERRUPT_in, -- Interrupt signal from peripheral 
										        OC_RETURNI,   -- Return from interrupt signal 
										        INT_CTRL_out);-- Interrupt pulse to other modules            

--ADDRESS_out <= PROG_FLOW_out;
ROM11:ROM1 port map(PROG_FLOW_out,
						  CLK,
						  INSTRUCTION_in);
			
--DATA_MEM1: DATA_MEM port map (CLK, 
--									  RST, 
--									  OUTPORT, 
--									  ADDRESS_out, 
--										READ_STROBE_out, 
--										WRITE_STROBE_out,
--										IN_PORT_in);
									 
end Structural;


