library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.Sys_Definition.all;

entity cpu is
   
   port ( 
            Reset : in std_logic;          
            clk   : in std_logic
	             
        );
end cpu;


architecture cpu_behave of cpu is

-- declare internal signals here

-- signal for control unit
          signal IRld : STD_LOGIC;
          signal PCincr : STD_LOGIC;
          signal PCclr : STD_LOGIC;
          signal PCld : STD_LOGIC;
          signal Addr_sel : STD_LOGIC_VECTOR(1 downto 0); --Ms

          signal Mre : STD_LOGIC;
          signal Mwe : STD_LOGIC;

	  signal IR_out : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);

-- signal for datapath
          
          signal RFs : STD_LOGIC_VECTOR(1 downto 0);
          signal RFwa, OPr1a, OPr2a : STD_LOGIC_VECTOR(3 downto 0);
          signal RFwe, OPr1e, OPr2e : STD_LOGIC;

          signal ALUs : STD_LOGIC_VECTOR(1 downto 0);
          signal ALUz : STD_LOGIC;

          signal Addr_out : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
          signal data_out_of_RF : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0); -- OPr1

-- signal for pc
          signal PC_out : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
-- signal for 8 bit of Q PC
          signal PC_in_7_downto_0 : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);

-- signal for mux of control unit
          signal addr_out_of_mux_to_mem : STD_LOGIC_VECTOR (ADDR_WIDTH - 1 downto 0);

-- signal for 8 bit of mux3to1 in control unit
	  signal IR_out_7_downto_0: std_logic_vector(DATA_WIDTH - 1 downto 0);

-- signal for data out of memory
	  signal data_out_of_mem : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
          

begin

-- write your code here
        IR_out_7_downto_0 <= "00000000" & IR_out(7 downto 0);
        PC_in_7_downto_0 <= "00000000" & IR_out(7 downto 0);

  --ctrl_U: controller port map(?);
  Ctrl_U: entity work.controller 
            port map (reset, clk, ALUz, IR_out, RFs, RFwa, RFwe, OPr1a, OPr1e, OPr2a,
        	      OPr2e, ALUs, IRld, PCincr, PCclr, PCld, Addr_sel, Mre, Mwe);

  pc_U: entity work.pc 
            port map (clk, PCclr, PCincr, PCld, PC_in_7_downto_0, PC_out);

  IR_U: entity work.instruction_register 
            port map (clk, data_out_of_mem, IRld, IR_out);

  mux3to1_U: entity work.mux3to1 
            port map (Addr_out, IR_out_7_downto_0, PC_out, Addr_sel, addr_out_of_mux_to_mem);

  --Dp_U: datapath port map(?);
  Dp_U: entity work.datapath 
	    port map (reset, clk, IR_out, data_out_of_mem, RFs, RFwa, OPr1a, OPR2a, RFwe,
                      OPr1e, OPr2e, ALUs, ALUz, Addr_out, data_out_of_RF);

  --Mem_U: dpmem port map (?);
  Mem_U: entity work.dpmem 
            port map (clk, reset, addr_out_of_mux_to_mem, Mwe,data_out_of_RF, Mre, data_out_of_mem);
							
end cpu_behave;




