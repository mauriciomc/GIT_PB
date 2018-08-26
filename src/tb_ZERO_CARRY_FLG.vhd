--------------------------------------------------------------------------------
-- Company: mauricio.m.c@gmail.com
-- Engineer: Mauricio de Carvalho
--
-- Create Date:   17:32:10 10/05/2011
-- Design Name:   tb_ZERO_CARRY_FLG.vhd
-- Module Name:   tb_ZERO_CARRY_FLG.vhd
-- Project Name:  Picoblaze
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ZERO_CARRY_FLG
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
 
ENTITY tb_ZERO_CARRY_FLG IS
END tb_ZERO_CARRY_FLG;
 
ARCHITECTURE behavior OF tb_ZERO_CARRY_FLG IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ZERO_CARRY_FLG
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         CARRY_in : IN  std_logic;
         ZERO_in : IN  std_logic;
         INTERRUPT_in : IN  std_logic;
         RETURNI : IN  std_logic;
         CARRY_out : OUT  std_logic;
         ZERO_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal CARRY_in : std_logic := '0';
   signal ZERO_in : std_logic := '0';
   signal INTERRUPT_in : std_logic := '0';
   signal RETURNI : std_logic := '0';

 	--Outputs
   signal CARRY_out : std_logic;
   signal ZERO_out : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ZERO_CARRY_FLG PORT MAP (
          CLK => CLK,
          RST => RST,
          CARRY_in => CARRY_in,
          ZERO_in => ZERO_in,
          INTERRUPT_in => INTERRUPT_in,
          RETURNI => RETURNI,
          CARRY_out => CARRY_out,
          ZERO_out => ZERO_out
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
      if clk'event and clk = '1' then
			CARRY_in <= '1';
			ZERO_in <= '1';
			INTERRUPT_in <= '1';
			RETURNI <= '0';
			
		end if;
   end process;

END;
