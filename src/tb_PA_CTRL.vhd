--------------------------------------------------------------------------------
-- Company: mauricio.m.c@gmail.com	
-- Engineer: Mauricio de Carvalho
--
-- Create Date:   17:02:24 10/05/2011
-- Design Name:   tb_PA_CTRL.vhd
-- Module Name:   tb_PA_CTRL.vhd
-- Project Name:  Picoblaze
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PORT_ADD_CTRL
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_PA_CTRL IS
END tb_PA_CTRL;
 
ARCHITECTURE behavior OF tb_PA_CTRL IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PORT_ADD_CTRL
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         ENABLE : IN  std_logic;
         REG_in : IN  std_logic_vector(7 downto 0);
         KONSTANT : IN  std_logic_vector(7 downto 0);
         REG_KONST_sel : IN  std_logic;
         READ_WRITE_in : IN  std_logic;
         READ_STROBE_out : OUT  std_logic;
         WRITE_STROBE_out : OUT  std_logic;
         PORT_ID_out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal ENABLE : std_logic := '0';
   signal REG_in : std_logic_vector(7 downto 0) := (others => '0');
   signal KONSTANT : std_logic_vector(7 downto 0) := (others => '0');
   signal REG_KONST_sel : std_logic := '0';
   signal READ_WRITE_in : std_logic := '0';

 	--Outputs
   signal READ_STROBE_out : std_logic;
   signal WRITE_STROBE_out : std_logic;
   signal PORT_ID_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PORT_ADD_CTRL PORT MAP (
          CLK => CLK,
          RST => RST,
          ENABLE => ENABLE,
          REG_in => REG_in,
          KONSTANT => KONSTANT,
          REG_KONST_sel => REG_KONST_sel,
          READ_WRITE_in => READ_WRITE_in,
          READ_STROBE_out => READ_STROBE_out,
          WRITE_STROBE_out => WRITE_STROBE_out,
          PORT_ID_out => PORT_ID_out
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process(CLK)
   begin		
      if CLK'event and CLK = '1' then
			ENABLE <= '1'; 
			REG_in <= X"10"; 
			KONSTANT <= X"01"; 
			REG_KONST_sel <= '1'; --Select Konstant
			READ_WRITE_in <= '1'; --Perform a READ => READ_STROBE_out = 1 and WRITE_STROBE_out = 0 and PORT_ID_out = KONSTANT
		end if;
   end process;

END;
