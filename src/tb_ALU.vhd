--------------------------------------------------------------------------------
-- Company: mauricio.m.c@gmail.com	
-- Engineer: Mauricio De Carvalho
--
-- Create Date:   16:41:17 10/05/2011
-- Design Name:   tb_ALU.vhd
-- Module Name:   tb_ALU.vhd
-- Project Name:  Picoblaze
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
use WORK.constants.all;
use WORK.alu_type.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_ALU IS
END tb_ALU;
 
ARCHITECTURE behavior OF tb_ALU IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         FUNC : IN  TYPE_OP;
         KONST_OR_DATA2 : IN  std_logic;
         DATA1 : IN  std_logic_vector(7 downto 0);
         DATA2 : IN  std_logic_vector(7 downto 0);
         KONSTANT : IN  std_logic_vector(7 downto 0);
         OUTALU : OUT  std_logic_vector(7 downto 0);
         CARRY : OUT  std_logic;
         ZERO : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal FUNC : TYPE_OP := NOP;
   signal KONST_OR_DATA2 : std_logic := '0';
   signal DATA1 : std_logic_vector(7 downto 0) := (others => '0');
   signal DATA2 : std_logic_vector(7 downto 0) := (others => '0');
   signal KONSTANT : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal OUTALU : std_logic_vector(7 downto 0);
   signal CARRY : std_logic;
   signal ZERO : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          FUNC => FUNC,
          KONST_OR_DATA2 => KONST_OR_DATA2,
          DATA1 => DATA1,
          DATA2 => DATA2,
          KONSTANT => KONSTANT,
          OUTALU => OUTALU,
          CARRY => CARRY,
          ZERO => ZERO
        );

   -- Clock process definitions
   

   -- Stimulus process
   stim_proc: process
   begin		
		
		--after 5 ns
		FUNC <= ADD; 
		KONST_OR_DATA2 <= '1'; -- select DATA2 		
		DATA1 <= X"01";
		DATA2 <= X"10";
		KONSTANT <= X"11";
		wait for 5 ns;
		
		--after 10 ns
      FUNC <= ADD; 
		KONST_OR_DATA2 <= '0'; -- select KONSTANT 		
		DATA1 <= X"01";
		DATA2 <= X"10";
		KONSTANT <= X"FF";
		wait for 5 ns;
		
		--after 15 ns
		FUNC <= ADDC; 
		KONST_OR_DATA2 <= '1'; -- select DATA2 		
		DATA1 <= X"01";
		DATA2 <= X"10";
		KONSTANT <= X"11";
		wait for 5 ns;
		
		--after 20 ns
		
		FUNC <= ADDC; 
		KONST_OR_DATA2 <= '0'; -- select KONSTANT 		
		DATA1 <= X"01";
		DATA2 <= X"10";
		KONSTANT <= X"FF";
		wait for 5 ns;
		
		--after 25 ns
		
		FUNC <= SUB; 
		KONST_OR_DATA2 <= '1'; -- select DATA2 		
		DATA1 <= X"01";
		DATA2 <= X"10";
		KONSTANT <= X"FF";
		wait for 5 ns;
		
		--after 30 ns
		
		FUNC <= SUB; 
		KONST_OR_DATA2 <= '1'; -- select DATA2 		
		DATA1 <= X"01";
		DATA2 <= X"01";
		KONSTANT <= X"FF";
		wait for 5 ns;
		
		--after 35 ns
		
		FUNC <= SUBC; 
		KONST_OR_DATA2 <= '0'; -- select KONSTANT 		
		DATA1 <= X"01";
		DATA2 <= X"10";
		KONSTANT <= X"01";
		wait for 5 ns;
		
		--after 40 ns
		
		FUNC <= ADDC; 
		KONST_OR_DATA2 <= '0'; -- select KONSTANT 		
		DATA1 <= X"01";
		DATA2 <= X"10";
		KONSTANT <= X"FF";
		wait for 5 ns;
		
		wait;
		
		
   end process;

END;
