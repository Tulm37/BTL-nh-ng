-- Nguyen Kiem Hung
-- controller

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.sys_definition.all;

entity controller is             	
   port (
        nReset : in STD_LOGIC; 
        clk : in STD_LOGIC; 
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
        Addr_sel : out STD_LOGIC_VECTOR(1 downto 0); --Ms is memory select

        Mre : out STD_LOGIC;
        Mwe : out STD_LOGIC
          
        );                              
 
end controller;

architecture controller_behave of controller is
    type state_type is (RESET_S, 
			FETCH, FETCHa, FETCHb, 
			DECODE, 
			MOV1, MOV1a, MOV2, MOV2a, MOV3, MOV3a, MOV4, MOV4a, 
			ADD, ADDa, 
			SUB, SUBa,
			OR_S, OR_Sa,
			AND_S, AND_Sa, 
			JZ, JZa, JMP
			);
    signal state : state_type;
    signal rn, rm, OPCODE : STD_LOGIC_VECTOR(3 downto 0);
  begin
    rn <= Instr_in(11 downto 8);
    rm <= Instr_in(7 downto 4);
    OPCODE <= INSTR_in(15 downto 12);
    process(clk, nReset, OPCODE)
    begin
        if nReset = '1' then
            state <= RESET_S;
        elsif clk'event and clk = '1' then
            case state is
                when RESET_S =>
                            state <= FETCH;
                when FETCH =>
                         
                            state <= FETCHa;
                when FETCHa =>
                             state <= FETCHb;
                when FETCHb =>   --End FETCH
                            state <= DECODE;
                when DECODE =>
                    case OPCODE is
                        when "0000" => state <= MOV1; -- RF[rn] = M[direct] 
                        when "0001" => state <= MOV2; -- M[direct] = RF[rn] 
                        when "0010" => state <= MOV3; -- M[ RF[rm] ] = RF[rn] 
                        when "0011" => state <= MOV4; -- RF[rn] = immediate 
                        when "0100" => state <= ADD;  -- RF[rn] = RF[rn] + RF[rm] 
                        when "0101" => state <= SUB;  -- RF[rn] = RF[rn] - RF[rm] 
                        when "0110" => state <= JZ;   -- PC = addr only if RF[rn] = 0 (Jump condition) 
                        when "0111" => state <= OR_S; -- RF[rn] = RF[rn] OR RF[rm] 
                        when "1000" => state <= AND_S; -- RF[rn] = RF[rn] AND RF[rm]
                        when "1010" => state <= JMP; -- PC = addr (Jump uncondition)
                        when others => state <= FETCH; -- others state <= FETCH
                    end case;


                when MOV1 => --RF[rn] = M[dir]
                            state <= MOV1a;
                when MOV1a =>
                            state <= FETCH;
                when MOV2 =>  -- M[dir] = RF[rn]

                            state <= MOV2a;
                when MOV2a =>

                            state <= FETCH;
                when MOV3 =>  -- M[rn] <= RF[rm]
                            state <= MOV3a;
                when MOV3a =>
                            state <= FETCH;
                when MOV4 => -- RF[rn] = imm
                            state <= FETCH;
                when ADD => -- RF[rn] = RF[rn] + RF[rm]
                            state <= ADDa;
                when ADDa =>
                            state <= FETCH;    
                     
                when SUB => -- RF[rn] = RF[rn] - RF[rm]                         
                            state <= SUBa;
                when SUBa =>
                            state <= FETCH;	

		when OR_S => -- RF[rn] = RF[rn] OR RF[rm]
                            state <= OR_Sa;
                when OR_Sa =>
                            state <= FETCH;
                
                when AND_S => -- RF[rn] = RF[rn] AND RF[rm]
                            state <= AND_Sa;
                when AND_Sa =>
                            state <= FETCH;

                when JZ =>  
                            state <= JZa;
                when JZa =>
                            state <= FETCH;

		when JMP =>
                        state <= FETCH;

                when others => State <= FETCH;
            end case;
        end if;
    end process;

-- Combinational Circuit
-- for PC
 PCClr <= '1' WHEN (State =  RESET_S) ELSE '0';
 PCincr <= '1' WHEN (State = Fetchb) else '0';
 process2: process(ALUz, State)
        begin 
            case state is
                when JZa => PCld <= ALUz;

                when JMP => PCld <= '1';

                when others => PCld <= '0';
            end case;
        end process;

-- IR
 IRld <= '1' WHEN (state = Fetchb) ELSE '0';

-- Address slect
 WITH State Select Addr_sel <= "10" WHEN Fetch,
				"01" WHEN MOV1|MOV2a,
				"00" WHEN MOV3a,
				"11" WHEN others ;
 WITH State Select Mre <= '1' WHEN Fetch|MOV1,
			  '0' WHEN others ;
 WITH State Select Mwe <= '1' WHEN MOV2a|MOV3a,
			  '0' WHEN others ;
 WITH State Select Addr_sel <= "10" WHEN Fetch,
                        	"01" WHEN MOV1 | MOV2a,
                        	"00" WHEN MOV3a,
                        	"11" WHEN others ;
--Write RF
 WITH State Select  RFs <= "10" WHEN MOV1a,
    			   "01" WHEN MOv4,
    			   "00" WHEN ADDa|SUBa | OR_Sa | AND_Sa,
    			   "11" WHEN others;
WITH State Select   RFwe <= '1' WHEN MOV1a|MOv4|ADDa|SUBa|OR_Sa|AND_Sa,
			    '0' WHEN Others;
WITH State Select   RFwa <= rn WHEN MOV1a|MOv4|ADDa|SUBa|OR_Sa|AND_Sa,
    			    "0000" WHEN Others;
WITH State Select   OPr1e <= '1' WHEN MOV2|MOV3|ADD|SUB|JZ|OR_S|AND_S,
			     '0' WHEN OTHERS;
WITH State Select   OPr1a <= rn WHEN MOV2|MOV3|ADD|SUB|JZ|OR_S|AND_S,
			     "0000" WHEN OTHERS;
WITH State Select   OPr2e <= '1' WHEN MOV3|ADD|SUB|OR_S|AND_S,
			     '0' WHEN OTHERS;
WITH State Select   OPr2a <= rm WHEN MOV3|ADD|SUB|OR_S|AND_S,
			     "0000" WHEN OTHERS;
WITH State Select   ALUs <= "00" WHEN ADD|ADDa,
			    "01" WHEN SUB|SUBa,
			    "10" WHEN OR_S | OR_Sa,
			    "11" WHEN others; --AND_Sa

end controller_behave;










