---- Hatem Abumadini
---- ECET 155
---- Final_Project
--
---- ** THIS IS THE MANUAL DOOR VERSION **
--library IEEE;
--use IEEE.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
--
--
--entity Final_Project is 
--		port(
--				FL1_btn, FL2_btn, FL3_btn, door, Reset, CLK: in std_logic;
--				
--				-- 1 seven segment display (floor#)
--				FL_Num   : out std_logic_vector(6 downto 0); 
--				
--				--  2seven seg display (Door open/close)
--				Door_out : out std_logic_vector (13 downto 0) 
--			  );
--			  
--end entity;
--
---- Define the architecture of the elevator_controller
--architecture Elevator_controller of final_Project is
--
---- A 2-bit vector(MOD2) to count floor# 
--signal count 	  : std_logic_vector (1 downto 0); 
--
---- A 2-bit vector to store current floor btn pressed
--signal temp 	  : std_logic_vector (1 downto 0); 
--
----the clock signal for the freq_div
--signal moded_clk : std_logic; 
--
----to count the number of clock cycles
--signal time_count: integer := 0;  
--
--
--begin
--	process (Clk)
--	begin
--	-- Reset time_count & moded_clk 
--		IF reset = '0'  THEN
--		
--			time_count <= 0;
--			moded_clk <= '0';
--
---- On the rising edge of the clock, transition between states based on the inputs
--		elsif rising_edge(clk) then 
--		
--				if (time_count = 24_499_999) then
--				
--					moded_clk <= NOT moded_clk;
--					time_count <= 0;
--					
--				else
--				
--					time_count <= time_count + 1;
--					
--				end if;
--				
--		END IF;							
--	end process;
--	
--	PROCESS(moded_clk) -- process for the counter 
--	begin
--	
--	-- Check if reset is low
--		IF reset = '0' THEN 
--		
--			count <= "00"; --resets count to 0
--			temp<="00";		-- reset temp to 0
--			Fl_num <= "1111001"; --sets display to show 1
--			
--		ELSif(rising_edge (moded_clk)) then 
--		
--			-- Check which floor button is pressed
--		      if FL1_btn = '0' and FL2_btn = '1' and  FL3_btn = '1' then
--				
--				temp<="01";
--				
--				elsif FL1_btn = '1' and FL2_btn = '0' and  FL3_btn = '1' then
--				
--				 temp<="10";
--				 
--				elsif FL1_btn = '1' and FL2_btn = '1' and  FL3_btn = '0' then
--				
--				 temp<="11";
--				 
--				end if;
--				
-- -- Check the current count and +/- 1 based on the door and temp signals
--				if count < temp then
--				
--					if door= '0' then
--					
--						count<=count + 1;
--						
--					else
--					
--						count<= count;
--						
--					end if;
--					
--					
--				elsif count > temp then
--				
--					if door = '0' then
--				
--						count<= count - 1;
--						
--					else 
--					
--						count <= count;
--						
--					end if;
--					
--
--				  
--				end if; 
--
--		case count is 
--		
--		-- To display floor number on svevn segment display
--			when "01" => fl_Num <= "1111001"; --1
--			when "10" => fl_Num<= "0100100"; --2
--			when "11" => fl_Num<= "0110000"; -- 3
--			when others =>Fl_Num <= "1111001";
--			
--			end case;	
--			
--		case door is 
--		
--		-- To display door open/close on svevn segment display
--		
--			when '1' => Door_out <= "10011111111001"; --l  l open
--			when '0' => Door_out<= "11110011001111"; --ll   close
--			when others =>Door_out <= "10000001000000";
--			
--			end case;
--													
--		end if;
--		end process;
--		
--end elevator_controller;

---- ** END OF MANUAL DOOR VERSION ** --



-- ^^ THIS IS THE AUTOMATIC DOOR VERSION ^^ 

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity final_Project is 
		port(
				FL1_btn, FL2_btn, FL3_btn, Reset, CLK: in std_logic;
				
				-- 1 seven segment display (floor#)
				FL_Num   : out std_logic_vector(6 downto 0);
				
				-- 2seven seg display (Door open/close)
				Door_out : out std_logic_vector (13 downto 0) 
			  );
			  
end entity;

-- Define the architecture of the elevator_controller
architecture Elevator_controller of final_Project is


signal door_state :std_logic;

-- A 4-bit(MOD4) to count floor# 
signal count 	  : std_logic_vector (3 downto 0); 

-- A 2-bit vector to store current floor btn pressed
signal temp 	  : std_logic_vector (3 downto 0); 

--the clock signal for the freq_div
signal moded_clk : std_logic; 

--to count the number of clock cycles 
signal time_count: integer := 0; 


begin
	process (Clk)
	begin
	
	-- Check if reset is low 
		IF reset = '0'  THEN
		
			time_count <= 0; --rest to 0
			moded_clk <= '0'; -- reset to 0

		-- On the rising edge of the clock, transition between states based on the inputs
		elsif rising_edge(clk) then 
		
				if (time_count = 24_499_999) then
				
					moded_clk <= NOT moded_clk;
					time_count <= 0;
					
				else
				
					time_count <= time_count + 1;
					
				end if;

		END IF;	

		
	end process;
	
	PROCESS(moded_clk) -- process for the counter 
	
	begin
	
	-- Check if reset is low.
		IF reset = '0' THEN 
		
			count <= "0000"; --resets count to 0
			temp<="0010";	 -- rest temp to 1
			door_state<='0'; -- close the door.
			Fl_num <= "1111001"; --sets display to show 1
			
		ELSif(rising_edge (moded_clk)) then 
		
				-- Check which floor button is pressed
		      if FL1_btn = '0' and FL2_btn = '1' and  FL3_btn = '1' then
				
					temp<="0010";
					
				elsif FL1_btn = '1' and FL2_btn = '0' and  FL3_btn = '1' then
				
				 temp<="0101";
				 
				elsif FL1_btn = '1' and FL2_btn = '1' and  FL3_btn = '0' then
				
				 temp<="1000";

				end if;
			    
			
	-- Check the current count and +/- 1 based on the door and temp signals		
				if count < temp then 
				
				count<=count+1;
				door_state<='0';
				
				elsif count > temp  then 
				
				 count<= count - 1;
				 door_state<='0';
				 
				elsif count = temp then
				
				 door_state<='1';
				
				end if;

		case count is 
		
			when "0001" => fl_Num <= "1111001"; -- to add a delay before moving for the door to close.
			when "0010" => fl_Num <= "1111001"; -- 1
			when "0011" => fl_Num <= "1111001"; -- to add a delay after ariving for the door to open.

			when "0100" => fl_Num <= "0100100"; -- to add a delay before moving for the door to close.
			when "0101" => fl_Num <= "0100100"; --2
			when "0110" => fl_Num <= "0100100"; -- to add a delay after ariving for the door to open


			
			when "0111" => fl_Num <= "0110000"; -- to add a delay before moving for the door to close.
			when "1000" => fl_Num <= "0110000"; --3
			when "1001" => fl_Num <= "0110000"; -- to add a delay after ariving for the door to open


			when others =>Fl_Num <= "1111001";
			end case;	
			
		
		case door_state is 
		
		   -- To display door open/close on svevn segment display
			
			when '1' => Door_out <= "10011111111001"; --l  l open
			when '0' => Door_out<= "11110011001111"; --ll   close
			when others =>Door_out <= "10000001000000";
			
			end case;
													
		end if;
		end process;
		
end elevator_controller;