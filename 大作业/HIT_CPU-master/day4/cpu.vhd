library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity cpu is
    Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           ABUS : out  STD_LOGIC_VECTOR (15 downto 0);
           DBUS : inout  STD_LOGIC_VECTOR (15 downto 0);
           nMREQ : out  STD_LOGIC;
           nWR : out  STD_LOGIC;
           nRD : out  STD_LOGIC;
           nBHE : out  STD_LOGIC;
           nBLE : out  STD_LOGIC;
		   CS:out STD_LOGIC;
			tempt:out std_logic_vector(3 downto 0);
			tempIR:out std_logic_vector(15 downto 0);
			tempALUOUT:out std_logic_vector(7 downto 0);
			tempRtemp:out std_logic_vector(7 downto 0);
			tempAddr:out std_logic_vector(15 downto 0);
			tempPCout:out std_logic_vector(15 downto 0);
			tempz : out  std_logic;
            tempcy : out std_logic
			);
end cpu;
architecture Behavioral of cpu is
	component clock is
		 port ( 
			reset: in std_logic; 
			clk: in STD_LOGIC; 
			t: out STD_LOGIC_VECTOR (3 downto 0) 
		); 
	end component;

	component save is
	Port ( t2 : in  STD_LOGIC;
		   IR : in  STD_LOGIC_VECTOR (15 downto 0);
		   data : in  STD_LOGIC_VECTOR (7 downto 0);
		   nMWR : out  STD_LOGIC;
		   nMRD : out  STD_LOGIC;
		   Rtemp : out  STD_LOGIC_VECTOR (7 downto 0);
		  ALUOUT: in std_logic_vector(7 downto 0));
	end component;

	component backw is
	Port (
	    PCin:in std_logic_vector(15 downto 0);
		t3 : in  STD_LOGIC;
		Rtemp : in  STD_LOGIC_VECTOR (7 downto 0);
		IR : in  STD_LOGIC_VECTOR (15 downto 0);
		z:in STD_LOGIC;
		cy:in STD_LOGIC;
		Rupdate : out  STD_LOGIC;
		 Rdata : out  STD_LOGIC_VECTOR (7 downto 0);
		PCupdate : out  STD_LOGIC;
		PCnew : out  STD_LOGIC_VECTOR (15 downto 0)
	);
	end component;

	component getIR is
		Port (
		 clk: in std_logic;
		t0 : in  STD_LOGIC;
			   t1 : in  STD_LOGIC;
			   reset : in  STD_LOGIC;
			   PCupdate : in  STD_LOGIC;
			   PCnew : in  STD_LOGIC_VECTOR (15 downto 0);
			   IRnew : in  STD_LOGIC_VECTOR (15 downto 0);
			   IRreq : out  STD_LOGIC;
			   IR: out  STD_LOGIC_VECTOR (15 downto 0);
			   PCout : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	component calculate is
	Port ( 
		 t1 : in  STD_LOGIC;
		 Rupdate : in  STD_LOGIC;
		 IR : in  STD_LOGIC_VECTOR (15 downto 0);
		 Rdata : in  STD_LOGIC_VECTOR (7 downto 0);
		 Addr : out  STD_LOGIC_VECTOR (15 downto 0);
		 ALUOUT : out  STD_LOGIC_VECTOR (7 downto 0);
		cy : out  STD_LOGIC;
		z : out STD_LOGIC);
	end component;

	component control is
	port(
	   IRreq :in STD_LOGIC;
	   IR:out  STD_LOGIC_VECTOR (15 downto 0);  
	   PCout: in  STD_LOGIC_VECTOR (15 downto 0);
	   ALUOUT : in  STD_LOGIC_VECTOR (7 downto 0);
	   Addr : in  STD_LOGIC_VECTOR (15 downto 0);  
	   ABUS : out  STD_LOGIC_VECTOR (15 downto 0);
	   DBUS : inout  STD_LOGIC_VECTOR (15 downto 0);
	   --给主存发
	   nWR : out  STD_LOGIC;
	   nRD : out  STD_LOGIC;
	   nMREQ : out  STD_LOGIC;
	   nBHE : out  STD_LOGIC;
	   nBLE : out  STD_LOGIC;
	   --运算模块/取指模块给出??要不要访内?
	   nMWR : in  STD_LOGIC;
	   nMRD : in  STD_LOGIC;
	   --来自存储模块
	   data:out  STD_LOGIC_VECTOR (7 downto 0)
	);
	end component;
signal clkgp ,PCupdate,IRreq ,Rupdate ,nMWR ,cy,z,nMRD: std_logic;	
signal t : std_logic_vector(3 downto 0);
signal IR : std_logic_vector(15 downto 0);
signal data : std_logic_vector(7 downto 0);
signal PCnew : std_logic_vector(15 downto 0);
signal PCout : std_logic_vector(15 downto 0);
signal Addr : std_logic_vector(15 downto 0);
signal Rdata : std_logic_vector(7 downto 0);
signal ALUOUT : std_logic_vector(7 downto 0);
signal Rtemp : std_logic_vector(7 downto 0);
signal IRtmp:std_logic_vector(15 downto 0);
begin 
tempz<=z;
tempcy<=cy;
tempPCout<=PCout;
tempt<=t;
tempIR<=IRtmp;
tempALUOUT<=ALUOUT;
tempRtemp<=Rtemp;
tempAddr<=Addr;
u0 : clock PORT MAP (reset ,clk,t);
u1 : getIR PORT MAP (clk,t(0) ,t(1),reset ,PCupdate ,PCnew ,IRtmp,IRreq ,IR ,PCout);
u2 : calculate PORT MAP (t(1),Rupdate ,IR,Rdata ,Addr ,ALUOUT,cy,z);
u3 : save PORT MAP (t(2) ,IR ,data,nMWR ,nMRD ,Rtemp,ALUOUT);	
u4 : backw PORT MAP (PCout,t(3) ,Rtemp ,IR,z,cy,Rupdate,Rdata,PCupdate,PCnew);
u5 : control PORT MAP (IRreq,IRtmp,PCout, ALUOUT, Addr,ABUS,DBUS,nWR,nRD,nMREQ ,nBHE, nBLE,nMWR,nMRD,data);
CS<='0';		
end Behavioral;
--时钟模块
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity clock is
    Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           t : out  STD_LOGIC_VECTOR(3 downto 0));
end clock;
architecture Behavioral of clock is
begin
	process(clk , reset)
	variable temp : integer range 0 to 5 := 0;
	begin
		if(reset = '1') then 
			t <=  "0000";
			temp := 0;
		elsif clk' event and clk = '1' then
			temp := temp + 1;
			if temp = 5 then temp := 1;
			end if;
			case temp is
				when 1 => t <= "0001";
				when 2 => t <= "0010";
				when 3 => t <= "0100";
				when 4 => t <= "1000";
				when others => null;
			end case;	
		end if;
	end process;
end Behavioral;
--取指模块
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity getIR is
    Port (
    clk: in std_logic;
	t0 : in  STD_LOGIC;
		   t1 : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           PCupdate : in  STD_LOGIC;
           PCnew : in  STD_LOGIC_VECTOR (15 downto 0);
           IRnew : in  STD_LOGIC_VECTOR (15 downto 0);
           IRreq : out  STD_LOGIC;
           IR: out  STD_LOGIC_VECTOR (15 downto 0);
           PCout : out  STD_LOGIC_VECTOR (15 downto 0));
end getIR;

architecture Behavioral of getIR is
--signal PC : STD_LOGIC_VECTOR(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
signal PC : STD_LOGIC_VECTOR(15 downto 0);
begin
   --PC <= PCnew when PCupdate = '1';
	process(reset,t0,t1,PCupdate,clk)
	begin
		if reset = '1' then
			IRreq <= '0';
			PC <= "0000000000000000";
		elsif t0 = '1' then
			IRreq <= '1';
			IR <= IRnew;
		elsif PCupdate = '1' then
				PC <= PCnew;
				IRreq <= '0';
		elsif t1 = '1' then
			IRreq <= '0';
		   if(clk'event and clk = '0')then
			PC <= PC + 1; 	
			end if; 	
		end if;
	end process;
	PCout<=PC;
end Behavioral;

--控制模块
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control is
port(
   IRreq :in STD_LOGIC;
   IR:out  STD_LOGIC_VECTOR (15 downto 0);  
   PCout: in  STD_LOGIC_VECTOR (15 downto 0);
   
   ALUOUT : in  STD_LOGIC_VECTOR (7 downto 0);
   Addr : in  STD_LOGIC_VECTOR (15 downto 0);  
   
   ABUS : out  STD_LOGIC_VECTOR (15 downto 0);
   DBUS : inout  STD_LOGIC_VECTOR (15 downto 0);

   --给主存发
   nWR : out  STD_LOGIC;
   nRD : out  STD_LOGIC;
   nMREQ : out  STD_LOGIC;
   nBHE : out  STD_LOGIC;
   nBLE : out  STD_LOGIC;
   --运算模块/取指模块给出，要不要访内存
   nMWR : in  STD_LOGIC;
   nMRD : in  STD_LOGIC;
   --来自存储模块
   data : out  STD_LOGIC_VECTOR (7 downto 0)
);
end control;
architecture Behavioral of control is

begin 	
   --IR <= DBUS;		  
	--DBUS<="00000000"&ALUOUT when nMWR='0' else "ZZZZZZZZZZZZZZZZ";
	--data <= DBUS(7 downto 0) when nMRD = '0' else "ZZZZZZZZ";
	--ABUS<=PCout when IRreq='1' else Addr; 
process(IRreq,nMRD,nMWR)
	begin 
    if IRreq ='1' then   --取指模块
			nBHE <= '0';
			nBLE <= '0';--高低位都?行?		
			nMREQ <= '0';
			nWR <= '1';
			nRD <= '0';--读有效 
			IR <= DBUS;	
         DBUS<="ZZZZZZZZZZZZZZZZ";	
			ABUS<=PCout;		
		elsif nMRD = '0' then --需要读内存(运算模块)
			nBHE <= '1';
			nBLE <= '0';
			nMREQ <= '0';
			nRD <= '0';	--?劣行?
			nWR <= '1';
			ABUS<=Addr;
			data<=DBUS(7 downto 0);	
			DBUS<="ZZZZZZZZZZZZZZZZ";	
		elsif nMWR = '0' then --写内存(运算模块)
		   nBHE <= '1';
		   nBLE <= '0';
		   nMREQ <= '0';
		   nRD <= '1';	
		   nWR <= '0';--写有??
			DBUS<="00000000"&ALUOUT;
			ABUS<=Addr; 
		else 	 
		   nBHE <= '1';
		   nBLE <= '1';
		   nMREQ <= '1';
		   nRD <= '1';	
		   nWR <= '1';
			data<="ZZZZZZZZ";
			DBUS<="ZZZZZZZZZZZZZZZZ";	
	end if;
end process;
end Behavioral;


--运算模块
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity calculate is
Port ( 
t1 : in  STD_LOGIC;
Rupdate : in  STD_LOGIC;
IR : in  STD_LOGIC_VECTOR (15 downto 0);
Rdata : in  STD_LOGIC_VECTOR (7 downto 0);
Addr : out  STD_LOGIC_VECTOR (15 downto 0);
ALUOUT : out  STD_LOGIC_VECTOR (7 downto 0);
cy : out  STD_LOGIC;
z : out STD_LOGIC);
end calculate;
architecture Behavioral of calculate is
type reg is array(7 downto 0) of std_logic_vector(7 downto 0);
signal R : reg;
signal cytmp:std_logic:='0';
signal ztmp:std_logic:='0';
signal ALUTMP : std_logic_vector(8 downto 0):= "011111111";
signal tempa: std_logic_vector(8  downto 0);
signal tempb: std_logic_vector(8  downto 0);
signal tempc: std_logic_vector(8  downto 0);
begin 
	 tempa <= '0'&R(conv_integer(IR(10 downto 8)));
    tempb <= '0'&IR(7 downto 0);
	 tempc <= '0'&R(conv_integer(IR(2 downto 0)));
	process(t1,IR,ALUTMP)
    begin 
	   --LUTMP(8)<='0';
		if t1='1' then
			case IR(15 downto 11) is 
				when "00000" => ALUTMP(7 downto 0) <= IR(7 downto 0);
				                Addr <= "ZZZZZZZZZZZZZZZZ";
				--MOV R,立即数   ==
				when "00001" => Addr <= R(7)&IR(7 downto 0);
				--MOV R,主存     ==
				when "00010" => ALUTMP(7 downto 0) <=R(conv_integer(IR(2 downto 0)));
				                Addr <= "ZZZZZZZZZZZZZZZZ";
				--MOV R,R        ==
				when "00011" =>Addr <= R(7)&R(conv_integer(IR(2 downto 0)));
		      --MOV R,*R(寄存器间接寻址)   ==
				
        		when "00100" => ALUTMP(7 downto 0) <=R(conv_integer(IR(2 downto 0)));
								Addr <=R(7)&IR(10 downto 3);
				--MOV 主存,R   ==
 				
				when "00101" => Addr <= R(7)&(R(6)+IR(7 downto 0));
				--MOV R,F_addr(变址寻址) ==
				when "00110" => ALUTMP <=tempa+tempb+cytmp;
				                Addr <= "ZZZZZZZZZZZZZZZZ";
								if ALUTMP(8)='1' then  cytmp<='1';
								else cytmp<='0';
								end if;
								if ALUTMP(7 downto 0)="00000000" then ztmp<='1'; 
								else ztmp<='0';
								end if;
				--ADC R,立即数   
				when "00111" =>ALUTMP<=tempa+tempc+cytmp;
				            Addr <= "ZZZZZZZZZZZZZZZZ";
								if ALUTMP(8)='1' then  cytmp<='1';
								else cytmp<='0';
								end if;
								if ALUTMP(7 downto 0)="00000000" then ztmp<='1'; 
								else ztmp<='0';
								end if;
				--ADC R,R
				when "01000" =>ALUTMP<=tempa-tempb-cytmp;
				               Addr <= "ZZZZZZZZZZZZZZZZ";
				           if ALUTMP(8)='1' then  cytmp<='1';
								else cytmp<='0';
								end if;
								if ALUTMP(7 downto 0)="00000000" then ztmp<='1'; 
								else ztmp<='0';
								end if;
				--SBB R,立即数
				when "01001" =>ALUTMP<=tempa-tempc-cytmp;
				               Addr <= "ZZZZZZZZZZZZZZZZ";
								if ALUTMP(8)='1' then  cytmp<='1';
								else cytmp<='0';
								end if;
								if ALUTMP(7 downto 0)="00000000" then ztmp<='1'; 
								else ztmp<='0';
								end if;
				--SBB R,R
				when "01010" =>ALUTMP<=tempa and tempb;
				               Addr <= "ZZZZZZZZZZZZZZZZ";
							   if ALUTMP(7 downto 0)="00000000" then ztmp<='1'; 
								end if;
				--AND R,立??数
				when "01011" =>ALUTMP<=tempa and tempc;
				               Addr <= "ZZZZZZZZZZZZZZZZ";
							  if ALUTMP(7 downto 0)="00000000" then ztmp<='1'; 
								else ztmp<='0';
								end if;
				--AND R,R
				when "01100" =>ALUTMP<=tempa or tempb;
				               Addr <= "ZZZZZZZZZZZZZZZZ";
							   if ALUTMP(7 downto 0)="00000000" then ztmp<='1'; 
								else ztmp<='0';
								end if;
				--OR R,立即数
				when "01101" =>ALUTMP<=tempa or tempc;
				               Addr <= "ZZZZZZZZZZZZZZZZ";
							   if ALUTMP(7 downto 0)="00000000" then ztmp<='1'; 
								else ztmp<='0';
								end if;
				--OR R,R
				when "01110" =>cytmp<='0';
				               Addr <= "ZZZZZZZZZZZZZZZZ";
				--CLC
				when "01111" =>cytmp<='1';
				               Addr <= "ZZZZZZZZZZZZZZZZ";
				--STC
				when others => Addr <= "ZZZZZZZZZZZZZZZZ";
				--jmp jc jz
			end case;
		end if;
	end process;
	R(conv_integer(IR(10 downto 8))) <= Rdata when Rupdate = '1';
	ALUOUT(7 downto 0)<= ALUTMP(7 downto 0);		
	cy<=cytmp;
	z<=ztmp;
end Behavioral;

--存储??
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity save is
Port ( 
       t2 : in  STD_LOGIC;
       IR : in  STD_LOGIC_VECTOR (15 downto 0);
       data : in  STD_LOGIC_VECTOR (7 downto 0);
       nMWR : out  STD_LOGIC;
       nMRD : out  STD_LOGIC;
       Rtemp : out  STD_LOGIC_VECTOR (7 downto 0);
		 ALUOUT:in std_logic_vector(7 downto 0));
end save;


architecture Behavioral of save is
begin 
	process(t2,data,ALUOUT,IR)
	begin 
		if t2='1' then 
			case IR(15 downto 11) is
				when  "00001" => nMWR <= '1'; nMRD <= '0'; --MOV R,主存
				                 Rtemp(7 downto 0) <= data(7 downto 0);
				when  "00011" => nMWR <= '1'; nMRD <= '0';--MOV R,*R(寄存器间接寻址)	
				                  Rtemp(7 downto 0) <= data(7 downto 0);
				when "00100" => nMWR <= '0'; nMRD <= '1';--MOV 主存,R
				when "00101" => nMWR <= '1'; nMRD <= '0';--MOV R,F_addr(变址寻址)
                                Rtemp(7 downto 0) <= data(7 downto 0);				
				when others => nMWR <= '1';nMRD <= '1';--不访存
				                Rtemp(7 downto 0) <= ALUOUT(7 downto 0);
			end case;
      else 	nMWR <= '1';nMRD <= '1';
		end if;	
		
		  end process;	
end Behavioral;

--回写模块
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity backw is
Port (
    PCin:in std_logic_vector(15 downto 0);
    t3 : in  STD_LOGIC;
	Rtemp : in  STD_LOGIC_VECTOR (7 downto 0);
    IR : in  STD_LOGIC_VECTOR (15 downto 0);
	 z:in STD_LOGIC;
	 cy:in STD_LOGIC;
     Rupdate : out  STD_LOGIC;
	 Rdata : out  STD_LOGIC_VECTOR (7 downto 0);
	 PCupdate : out  STD_LOGIC;
    PCnew : out  STD_LOGIC_VECTOR (15 downto 0)
);
end backw;

architecture Behavioral of backw is
signal tempa:std_logic_vector(15 downto 0);
signal tempb:std_logic_vector(15 downto 0);
begin 
   tempa<="00000000"&(IR(7 downto 0));
	tempb<="11111111"&(IR(7 downto 0));
	process(t3,z,cy,IR)
	begin 
		if t3='1' then 
			case IR(15 downto 11) is 
				when "10000" =>Rupdate <= '0';  --jmp 
				               PCupdate <= '1';
				               PCnew <= tempa;
				when "10001" => Rupdate <= '0';	   
					 if  z='1' and IR(7)='1' then
					     PCupdate <= '1';--jz
						   PCnew<=PCin+tempb;
                elsif z='1' and IR(7)='0' then
					      PCupdate <= '1';
					      PCnew<=PCin+tempa;
                else PCupdate<='0';										 
				    end if;
				when "10010" => Rupdate <= '0';--jc
						if  cy='1' and IR(7)='1' then
					       PCupdate <= '1';
						    PCnew <= PCin+tempb;
                  elsif cy='1' and IR(7)='0' then
					       PCupdate <= '1';
					       PCnew<=PCin+tempa;
                  else PCupdate<='0';
					   end if;		
		        when "01110" =>null;--CLC
				  when "01111" =>null;--STC
				  when "00100" =>null;--MOV 主存,R
			 	  when others  =>Rupdate<='1';
				               PCupdate <= '0';
							      Rdata(7 downto 0)<= Rtemp(7 downto 0);
			end case;
      else PCupdate<='0';Rupdate<='0';
      end if;
	end process;
end Behavioral;
