--------------------------------------------------------------------------------
-- Company: mauricio.m.c@gmail.com	
-- Engineer: Mauricio de Carvalho
--
-- Create Date:   15:55:17 10/05/2011
-- Design Name:   tb_REGFILE.vhd
-- Module Name:   tb_REGFILE.vhd
-- Project Name:  Picoblaze
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: REGFILE
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
 
ENTITY tb_REGFILE IS
END tb_REGFILE;
 
ARCHITECTURE behavior OF tb_REGFILE IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT REGFILE
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         PORT_S_ADDR : IN  std_logic_vector(2 downto 0);
         PORT_T_ADDR : IN  std_logic_vector(2 downto 0);
         PORT_D_ADDR : IN  std_logic_vector(2 downto 0);
         WRITE_D_EN : IN  std_logic;
         PORT_sel : IN  std_logic;
         PORT_D_IN : IN  std_logic_vector(7 downto 0);
         PORT_S_OUT : OUT  std_logic_vector(7 downto 0);
         PORT_T_OUT : OUT  std_logic_vector(7 downto 0);
         OUT_PORT : OUT  std_logic_vector(7 downto 0);
         PA_PORT : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal PORT_S_ADDR : std_logic_vector(2 downto 0) := (others => '0');
   signal PORT_T_ADDR : std_logic_vector(2 downto 0) := (others => '0');
   signal PORT_D_ADDR : std_logic_vector(2 downto 0) := (others => '0');
   signal WRITE_D_EN : std_logic := '0';
   signal PORT_sel : std_logic := '0';
   signal PORT_D_IN : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal PORT_S_OUT : std_logic_vector(7 downto 0);
   signal PORT_T_OUT : std_logic_vector(7 downto 0);
   signal OUT_PORT : std_logic_vector(7 downto 0);
   signal PA_PORT : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: REGFILE PORT MAP (
          CLK => CLK,
          RST => RST,
          PORT_S_ADDR => PORT_S_ADDR,
          PORT_T_ADDR => PORT_T_ADDR,
          PORT_D_ADDR => PORT_D_ADDR,
          WRITE_D_EN => WRITE_D_EN,
          PORT_sel => PORT_sel,
          PORT_D_IN => PORT_D_IN,
          PORT_S_OUT => PORT_S_OUT,
          PORT_T_OUT => PORT_T_OUT,
          OUT_PORT => OUT_PORT,
          PA_PORT => PA_PORT
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
			PORT_S_ADDR <= "000"; PORT_D_ADDR <= "000"; WRITE_D_EN <= '1'; 
			PORT_sel <= '1'; PORT_D_IN <= X"01"; --wait for 5 ns;
			PORT_S_ADDR <= "001"; PORT_D_ADDR <= "001"; WRITE_D_EN <= '1'; 
			PORT_sel <= '1'; PORT_D_IN <= X"10"; --wait for 5 ns;
			PORT_S_ADDR <= "010"; PORT_T_ADDR <= "001"; PORT_D_ADDR <= "010"; WRITE_D_EN <= '1'; 
			PORT_sel <= '1'; PORT_D_IN <= X"10"; --wait for 5 ns;
			--PORT_S_ADDR <= "000"; PORT_T_ADDR <= "001"; PORT_D_ADDR <= "001"; PORT_D_IN <= X"11"; PORT_sel <= '0'; PORT_D_IN <= X"11"; wait for 5 ns;
			--PORT_S_ADDR <= "000"; PORT_T_ADDR <= "001"; PORT_D_ADDR <= "000"; WRITE_D_EN <= '1'; PORT_sel <= '1'; PORT_D_IN <= X"01"; wait for 5 ns;
	   end if;
     --wait;  
   end process;

END;
