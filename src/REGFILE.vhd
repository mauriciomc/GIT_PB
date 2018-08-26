library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity REGFILE is
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
end REGFILE;

architecture Structural of REGFILE is

component REGISTER_N is
	 GENERIC (N : INTEGER);
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
			  ENABLE : in  STD_LOGIC;
           INPUT : in  STD_LOGIC_VECTOR (N-1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;


subtype register_address is natural range 0 to 7;
type register_array is array (register_address) of std_logic_vector(7 downto 0);

--Create array of signals 
signal reg_i : register_array := (others=>"00000000"); 
signal en  : std_logic_vector (7 downto 0) := (others=>'0') ;


begin

--Make as if reg[0]="000000...00" ALWAYS
--reg_i(0)<=(others=>'0');

--Generates 30 registers
GEN:for i in 0 to 7 generate
	REGBANK:REGISTER_N generic map(8) port map(CLK,RST,en(i),PORT_D_IN,reg_i(i));
	end generate;

--Enables only the selected registers, specified by PORT_D_ADDR, which will receive the input data to store
--No need to insert RST because they are reseted at RTL level on each register
P1:process(RST,CLK)
begin
	if(RST='1') then
		en<=(others=>'0');
	
	elsif(CLK'event and CLK='0') then
		if(WRITE_D_EN='1') then
				en<=(others=>'0');
				en(conv_integer(unsigned(PORT_D_ADDR)))<='1';
		else
			en<=(others=>'0');
		end if;
	end if;
end process;

--Always send output values from PORT_S and PORT_T selected by Instruction Register 	

P2:process(RST,CLK)
begin
	if(RST='1') then
		PORT_S_OUT<=(others=>'0');
		PORT_T_OUT<=(others=>'0');
	
		OUT_PORT<=(others=>'0');
		PA_PORT<=(others=>'0');
	
	elsif(CLK'event and CLK='1')then
		if(PORT_sel='0') then
			PORT_S_OUT<=reg_i(conv_integer(unsigned(PORT_S_ADDR)));
			PORT_T_OUT<=reg_i(conv_integer(unsigned(PORT_T_ADDR)));
		elsif(PORT_sel='1') then
			OUT_PORT <= reg_i(conv_integer(unsigned(PORT_T_ADDR)));
			PA_PORT <= reg_i(conv_integer(unsigned(PORT_S_ADDR)));
		end if;
	end if;
end process;	
		
end Structural;