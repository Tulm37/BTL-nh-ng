library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;
 
entity cpu_tb is

end cpu_tb;

 
 
architecture behavior of cpu_tb is
  signal Reset : std_logic;          
  signal clk   : std_logic := '0'; 
Begin
  -- write your code here
  cpu_U: entity work.cpu 
        port map (reset, clk);
  clk <= not clk after 10 ns; -- T = 20 ns
  process1: process
      begin
          reset <= '1';
          wait for 25 ns;
          reset <= '0';
          wait;

        end process;
  
  
End behavior;