library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.sys_definition.ALL;
 
-------------------------------------------------------------------------------
-- Synchronous Dual Port Memory
-------------------------------------------------------------------------------
entity dpmem is
  
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
end dpmem;
 



architecture dpmem_arch of dpmem is
   
  type DATA_ARRAY is array (integer range <>) of std_logic_vector(DATA_WIDTH - 1 downto 0); -- Memory Type

  signal   M       :     DATA_ARRAY(0 to (30) -1) := (others => (others => '0'));  -- Memory model ** equals power
-- you can add more code for your ap  m plication by increase the PM_Size
  constant PM_Size : Integer := 13; -- Size of program memory :(range 255 downto 0 )
  --type P_MEM is array (0 to PM_Size-1) of std_logic_vector(DATA_WIDTH -1 downto 0); -- Program Memory is instruction memory
  constant PM : DATA_ARRAY(0 to PM_Size-1) := (	

-- Machine code for your application is initialized here 
    X"0712",     -- MOV1: Mov R7,18  => R7 = M(18) = A = 10

    X"1716",     -- MOV2: Mov 22,R7 => M(22) = R7

    X"0813",	 -- MOV1: Mov R8,19 => R8 = M(19) = B = 11

    X"2560",     -- MOV3: Mov R5,@R7 => M(R7) = R5

    X"3513",     -- MOV4: Mov R5,#19 => R5 = 19

    X"3940",	 -- MOV4: Mov R9,#64 => R9 = 64

    X"3401",     -- MOV4: Mov R4,#1 => R4 = 1 

    X"3602",	 -- MOV4: Mov R6,#s => R6 = 2

    X"4750",     -- ADD: ADD R7,R5  => R7 = R7 + R5

    X"5750",     -- SUB: SUB R7,R5  => R7 = R7 - R5

    X"7640",	 -- OR: OR R6,R4 => R6 = R6 OR R4 : 0010 OR 0001=0011

    X"8470",     -- AND: AND R4,R7 => R4 = R4 AND R7 : 0001 AND 1010

    X"6501"    -- JZ: JZ R5,1   

    );
begin  -- begin of architecture
	
  --  Read/Write process

  RW_Proc : process (clk, Reset)
  begin  -- begin of process
    if Reset = '1' then

                    Dataout <= (others => '0');
                    M(0 to PM_Size-1) <= PM; -- initialize program memory
                    M(18 to 19) <= (x"000A", x"000B");

    elsif (clk'event and clk = '1') then   -- rising clock edge
          if Wen = '1' then
                          M(conv_integer(addr)) <= Datain; -- ensure that data cant overwrite on program
          else
              if Ren = '1' then
                    Dataout <= M(conv_integer(addr));
              else
                    Dataout <= Dataout;
              end if;
          end if;
      end if;
  end process  RW_Proc;
     
end dpmem_arch;