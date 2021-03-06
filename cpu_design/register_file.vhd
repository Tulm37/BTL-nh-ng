library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.sys_definition.ALL;

entity register_file is
    Port ( 
            reset : in STD_LOGIC;
            clk : in STD_LOGIC;
            RFin : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            RFwa : in STD_LOGIC_VECTOR (3 downto 0);
            RFwe : in STD_LOGIC;
            OPr1a : in STD_LOGIC_VECTOR (3 downto 0);
            OPr1e : in STD_LOGIC;
            OPr2a : in STD_LOGIC_VECTOR (3 downto 0);
            OPr2e : in STD_LOGIC;
            OPr1 : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
            OPr2 : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
           );

end register_file;


architecture register_file of register_file is
    type DATA_ARRAY is array (integer range<>) of STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);   
    signal RF : DATA_ARRAY(0 to 15) := (others => (x"0000")); -- GPIO register file: gom 16 thanh ghi da nang phuc vu cho tinh toan cua ALU
                                                              -- 16 thanh ghi da nang duoc khoi tao gia tri ban dau la 0

begin

    RW_Proc: process(clk, reset) -- declare process with list sensitivity are clk and reset

    begin
        if reset = '1' then         
                    OPr1 <= x"0000";
                    OPr2 <= x"0000";
                    RF <= (others => (x"0000"));

        elsif clk'event and clk = '1' then
            
            if RFwe = '1' then 
		RF(conv_integer(RFwa)) <= RFin;
            end if;

            if OPr1e = '1' then
                OPr1 <= RF(conv_integer(OPr1a));
            end if;

            if OPr2e = '1' then
                OPr2 <= RF(conv_integer(OPr2a));
            end if;

        end if;
    end process RW_Proc;
end register_file;