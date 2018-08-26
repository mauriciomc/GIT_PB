--------------------------------------------------------------------------------
-- Company: mauricio.m.c@gmail.com	 
-- Engineer: Mauricio de Carvalho
--
-- Create Date:   14:56:17 10/05/2011
-- Design Name:   tb_picoblaze.vhd
-- Module Name:   tb_PicoBlaze.vhd
-- Project Name:  PicoBlaze
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PicoBlaze
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
 
ENTITY tb_PicoBlaze IS
END tb_PicoBlaze;
 
ARCHITECTURE behavior OF tb_PicoBlaze IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PicoBlaze
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         IN_PORT_in : IN  std_logic_vector(7 downto 0);
         INTERRUPT_in : IN  std_logic;
         PORT_ID_out : OUT  std_logic_vector(7 downto 0);
         READ_STROBE_out : OUT  std_logic;
         WRITE_STROBE_out : OUT  std_logic;
         ADDRESS_out : OUT  std_logic_vector(7 downto 0);
         OUTPORT : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal IN_PORT_in : std_logic_vector(7 downto 0) := (others => '0');
   signal INTERRUPT_in : std_logic := '0';

 	--Outputs
   signal PORT_ID_out : std_logic_vector(7 downto 0);
   signal READ_STROBE_out : std_logic;
   signal WRITE_STROBE_out : std_logic;
   signal ADDRESS_out : std_logic_vector(7 downto 0);
   signal OUTPORT : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PicoBlaze PORT MAP (
          CLK => CLK,
          RST => RST,
          IN_PORT_in => IN_PORT_in,
          INTERRUPT_in => INTERRUPT_in,
          PORT_ID_out => PORT_ID_out,
          READ_STROBE_out => READ_STROBE_out,
          WRITE_STROBE_out => WRITE_STROBE_out,
          ADDRESS_out => ADDRESS_out,
          OUTPORT => OUTPORT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
	
	process (CLK) 
	begin
	if CLK'event and CLK <= '1' then
		INTERRUPT_in <= '0'; 
	end if;
	end process;
END;
