library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.Sys_Definition.all;

entity pc is
    Port (  clk : in STD_LOGIC;
            PCclr : in STD_LOGIC;
            PCincr : in STD_LOGIC;
            PCld : in STD_LOGIC;
            PC_in : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            PC_out : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
            
            );
end pc;

architecture pc_behave of pc is
        signal PC_current: STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
begin
    
    process(clk)
    begin
       if PCclr = '1' then
            PC_current <= "0000000000000000";

       elsif clk'event and clk = '1' then
            if PCld = '1' then
                PC_current <= PC_in;
            elsif PCincr = '1' then
                PC_current <= PC_current + 1; -- PC = PC + 1
            end if;
        end if;
    end process;
    PC_out <= PC_current;

end pc_behave;