library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.Sys_Definition.all;

entity instruction_register is
    Port ( 

            clk : in STD_LOGIC;
            IR_in : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            IRld : in STD_LOGIC;
            IR_out : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)

           );
end instruction_register;

architecture instruction_register_behave of instruction_register is

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if IRld = '1' then
                IR_out <= IR_in;
            end if;
        end if;
    end process;
    
end instruction_register_behave;