library IEEE;

use IEEE.std_logic_1164.all;
USE ieee.numeric_std.all ;
use std.textio.all;

package Sys_Definition is

-- Constant for datapath
  Constant   DATA_WIDTH  :     integer   := 16;     -- Word Width
  Constant   ADDR_WIDTH  :     integer   := 16 ;     -- Address width
--constant PORT_NUM : integer := 5;

-- Type Definition
   -- type ADDR_ARRAY_TYPE is array (VC_NUM-1 DOWNTO 0) of std_logic_vector (ADDR_WIDTH-1 downto 0);
   type DATA_ARRAY is array(integer range<>) of STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);

   type register_file_array is array (integer range <>) of std_logic_vector(DATA_WIDTH - 1 downto 0);
   type state_type is (fetch, decode);
   signal state: state_type;
-- **************************************************************
--COMPONENTs

----------------------------------------------------------------
-- alu component
COMPONENT ALU is
  Port ( 
        OPr1 : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
        OPr2 : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
        ALUs : in STD_LOGIC_VECTOR (1 downto 0);
        ALUr : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
        ALUz : out STD_LOGIC --
        --
      );
end COMPONENT;
----------------------------------------------------------------

----------------------------------------------------------------
-- register file component
COMPONENT register_file is
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
end COMPONENT;

----------------------------------------------------------------

----------------------------------------------------------------
-- mux3to1 component
COMPONENT mux3to1 is
  port( 
        data_in0, data_in1, data_in2 : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        sel : in STD_LOGIC_VECTOR(1 downto 0);
        data_out : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
  );
end COMPONENT;

----------------------------------------------------------------

----------------------------------------------------------------
-- instruction register component
COMPONENT instruction_register is
  Port ( clk : in STD_LOGIC;
         IR_in : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
         IRld : in STD_LOGIC;
         IR_out : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
         );
end COMPONENT;
----------------------------------------------------------------


----------------------------------------------------------------
-- program component component
COMPONENT pc is
  Port ( clk : in STD_LOGIC;
         PCclr : in STD_LOGIC;
         PCincr : in STD_LOGIC;
         PCld : in STD_LOGIC;
         PC_in : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
         PC_out : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0));
end COMPONENT;
----------------------------------------------------------------

---------------------------------------------------------------
-- data memory component
COMPONENT dpmem is
  
  port (
    -- Writing
    Clk              : in  std_logic;          -- clock
	  Reset             : in  std_logic; -- Reset input
    addr              : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);   --  Address
	-- Writing Port
	  Wen               : in  std_logic;          -- Write Enable
    Datain            : in  std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');   -- Input Data: Initialize to 0
    -- Reading Port
    
    Ren               : in  std_logic;          -- Read Enable
    Dataout           : buffer std_logic_vector(DATA_WIDTH - 1 downto 0)   -- Output data
    
    );
end COMPONENT;
---------------------------------------------------------------

---------------------------------------------------------------
-- controller component
COMPONENT controller is
  port(
      reset : in STD_LOGIC; -- high activate reset signal
   -- controller_en : in STD_LOGIC; -- high activate Start: enable CPU
      clk : in STD_LOGIC; -- Clock
      ALUz : in STD_LOGIC;
      Instr_in : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
      RFs : out STD_LOGIC_VECTOR(1 downto 0);

      RFwa : out STD_LOGIC_VECTOR(3 downto 0);
      RFwe : out STD_LOGIC;
      OPr1a : out STD_LOGIC_VECTOR(3 downto 0);
      OPr1e : out STD_LOGIC;
      OPr2a : out STD_LOGIC_VECTOR(3 downto 0);
      OPr2e : out STD_LOGIC;

      ALUs : out STD_LOGIC_VECTOR(1 downto 0);

      IRld : out STD_LOGIC;
      PCincr : out STD_LOGIC;
      PCclr : out STD_LOGIC;
      PCld : out STD_LOGIC;
      Addr_sel : out STD_LOGIC_VECTOR(1 downto 0); --Ms

      Mre : out STD_LOGIC;
      Mwe : out STD_LOGIC
      --OP2 : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0) --?????
  );
end COMPONENT;
---------------------------------------------------------------

---------------------------------------------------------------
-- datapath component
COMPONENT datapath is
  Port(
        reset : in STD_LOGIC;
        clk: in STD_LOGIC;

        data_in1 : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        data_in2 : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);

        RFs : in STD_LOGIC_VECTOR(1 downto 0);
        RFwa, OPr1a, OPr2a : in STD_LOGIC_VECTOR(3 downto 0);
        RFwe, OPr1e, OPr2e : in STD_LOGIC;

        ALUs : in STD_LOGIC_VECTOR(1 downto 0);
        ALUz : out STD_LOGIC;

        Addr_out : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        data_out : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
      );
end COMPONENT;
---------------------------------------------------------------

---------------------------------------------------------------
-- cpu component
COMPONENT cpu is
   
  port ( 
           Reset : in std_logic;          --
           clk   : in std_logic --

       );
end COMPONENT;

---------------------------------------------------------------

-----------------
end Sys_Definition;

PACKAGE BODY Sys_Definition IS
	-- package body declarations

END PACKAGE BODY Sys_Definition;