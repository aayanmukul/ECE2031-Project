-- LEDController.VHD
-- 2025.03.09
--
-- This SCOMP peripheral drives ten outputs high or low based on
-- a value from SCOMP.

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY LEDController IS
PORT(
    MODE_DATA      : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
    CS_MODE        : IN  STD_LOGIC;
    PATTERN_DATA   : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
    CS_PATTERN     : IN  STD_LOGIC;
    DUTYCYCLE_DATA : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
    CS_DUTYCYCLE   : IN  STD_LOGIC;
	 WRITE_EN       : IN  STD_LOGIC;
    RESETN         : IN  STD_LOGIC;
	 LEDs           : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
END LEDController;

ARCHITECTURE a OF LEDController IS
    -- Internal set of registers to hold input values
    SIGNAL REG_MODE_DATA      : STD_LOGIC_VECTOR(9 downto 0) := (others => '0'); -- 10-bit REG register
    SIGNAL REG_PATTERN_DATA   : STD_LOGIC_VECTOR(9 downto 0) := (others => '0'); -- 10-bit REG register
    SIGNAL REG_DUTYCYCLE_DATA : STD_LOGIC_VECTOR(9 downto 0) := (others => '0'); -- 10-bit REG register
	 
	 -- Duty cycle value for each LED
	 -- input to ARRAY_LED_DUTYCYCLES for PWM controller
	 SIGNAL LED0_VALUE : STD_LOGIC_VECTOR(9 downto 0);
	 SIGNAL LED1_VALUE : STD_LOGIC_VECTOR(9 downto 0);
	 SIGNAL LED2_VALUE : STD_LOGIC_VECTOR(9 downto 0);
	 SIGNAL LED3_VALUE : STD_LOGIC_VECTOR(9 downto 0);
	 SIGNAL LED4_VALUE : STD_LOGIC_VECTOR(9 downto 0);
	 SIGNAL LED5_VALUE : STD_LOGIC_VECTOR(9 downto 0);
	 SIGNAL LED6_VALUE : STD_LOGIC_VECTOR(9 downto 0);
	 SIGNAL LED7_VALUE : STD_LOGIC_VECTOR(9 downto 0);
	 SIGNAL LED8_VALUE : STD_LOGIC_VECTOR(9 downto 0);
	 SIGNAL LED9_VALUE : STD_LOGIC_VECTOR(9 downto 0);
	 
	 -- Declare new array type for the LED duty cycle array used by PWM controller
    TYPE REG_ARRAY is array (0 to 9) of STD_LOGIC_VECTOR(9 downto 0);
    SIGNAL ARRAY_LED_DUTYCYCLES : REG_ARRAY := (others => (others => '0'));    
    
	 -- 10-bit integer representation of MODE
	 SIGNAL MODE_INT  : INTEGER RANGE 0 TO 1023;
	 
BEGIN
    -- Process Mode peripheral input
    PROCESS (RESETN, CS_MODE)
    BEGIN
        IF (RESETN = '0') THEN
            REG_MODE_DATA <= "0000000000";
        ELSIF (RISING_EDGE(CS_MODE)) THEN
            IF WRITE_EN = '1' THEN
				    REG_MODE_DATA <= MODE_DATA;
            END IF;
        END IF;
    END PROCESS;
	 
	 -- Process Duty Cycle peripheral input
	 -- (only used in PWM mode)
	 PROCESS (RESETN, CS_DUTYCYCLE)
    BEGIN
        IF (RESETN = '0') THEN
            -- Turn off LEDs at reset (a nice usability feature)
            REG_DUTYCYCLE_DATA <= "0000000000";
        ELSIF (RISING_EDGE(CS_DUTYCYCLE)) THEN
            IF WRITE_EN = '1' THEN
                REG_DUTYCYCLE_DATA <= DUTYCYCLE_DATA;
            END IF;
        END IF;
    END PROCESS;
	 
	 -- Process Pattern peripheral input
	 PROCESS (RESETN, CS_PATTERN)
    BEGIN
        IF (RESETN = '0') THEN
            -- Turn off LEDs at reset (a nice usability feature)
            REG_PATTERN_DATA <= "0000000000";
        ELSIF (RISING_EDGE(CS_PATTERN)) THEN
            IF WRITE_EN = '1' THEN
                -- If SCOMP is sending data to this peripheral,
                -- use that data indirectly as the on/off values
                -- for the LEDs by setting their PWM duty cycle
					 REG_PATTERN_DATA <= PATTERN_DATA;
					 
					 CASE REG_MODE_DATA(1 downto 0) IS
                    -- Regular Pattern Mode
		              WHEN "00"=>
						      -- Set duty cycles to 100% or 0% based on pattern input
    			            IF REG_PATTERN_DATA(0) = '1' THEN
	    			             LED0_VALUE <= "1111111111";
		    	            ELSE
			    	             LED0_VALUE <= "0000000000";
			               END IF;
								
								IF REG_PATTERN_DATA(1) = '1' THEN
	    			             LED1_VALUE <= "1111111111";
		    	            ELSE
			    	             LED1_VALUE <= "0000000000";
			               END IF;
								
								IF REG_PATTERN_DATA(2) = '1' THEN
	    			             LED2_VALUE <= "1111111111";
		    	            ELSE
			    	             LED2_VALUE <= "0000000000";
			               END IF;
								
								IF REG_PATTERN_DATA(3) = '1' THEN
	    			             LED3_VALUE <= "1111111111";
		    	            ELSE
			    	             LED3_VALUE <= "0000000000";
			               END IF;
								
								IF REG_PATTERN_DATA(4) = '1' THEN
	    			             LED4_VALUE <= "1111111111";
		    	            ELSE
			    	             LED4_VALUE <= "0000000000";
			               END IF;
								
								IF REG_PATTERN_DATA(5) = '1' THEN
	    			             LED5_VALUE <= "1111111111";
		    	            ELSE
			    	             LED5_VALUE <= "0000000000";
			               END IF;
								
								IF REG_PATTERN_DATA(6) = '1' THEN
	    			             LED6_VALUE <= "1111111111";
		    	            ELSE
			    	             LED6_VALUE <= "0000000000";
			               END IF;
								
								IF REG_PATTERN_DATA(7) = '1' THEN
	    			             LED7_VALUE <= "1111111111";
		    	            ELSE
			    	             LED7_VALUE <= "0000000000";
			               END IF;
								
								IF REG_PATTERN_DATA(8) = '1' THEN
	    			             LED8_VALUE <= "1111111111";
		    	            ELSE
			    	             LED8_VALUE <= "0000000000";
			               END IF;
								
								IF REG_PATTERN_DATA(9) = '1' THEN
	    			             LED9_VALUE <= "1111111111";
		    	            ELSE
			    	             LED9_VALUE <= "0000000000";
			               END IF;
		 
		              -- Regular Toggle Mode
    		           WHEN "01"=>
                        -- Set duty cycles to 100% if they are 0% and to 0% if they are not 0% (not necessarily 100%)
								-- for every LED selected by the input pattern
    			            IF REG_PATTERN_DATA(0) = '1' THEN
								    IF ARRAY_LED_DUTYCYCLES(0) = "0000000000" THEN
									     LED0_VALUE <= "1111111111";
								    ELSE
									     LED0_VALUE <= "0000000000";
									 END IF;
		    	            ELSE
			    	             LED0_VALUE <= ARRAY_LED_DUTYCYCLES(0);
			               END IF;

    			            IF REG_PATTERN_DATA(1) = '1' THEN
								    IF ARRAY_LED_DUTYCYCLES(1) = "0000000000" THEN
									     LED1_VALUE <= "1111111111";
								    ELSE
									     LED1_VALUE <= "0000000000";
									 END IF;
		    	            ELSE
			    	             LED1_VALUE <= ARRAY_LED_DUTYCYCLES(1);
			               END IF;
								
    			            IF REG_PATTERN_DATA(2) = '1' THEN
								    IF ARRAY_LED_DUTYCYCLES(2) = "0000000000" THEN
									     LED2_VALUE <= "1111111111";
								    ELSE
									     LED2_VALUE <= "0000000000";
									 END IF;
		    	            ELSE
			    	             LED2_VALUE <= ARRAY_LED_DUTYCYCLES(2);
			               END IF;
								
								IF REG_PATTERN_DATA(3) = '1' THEN
								    IF ARRAY_LED_DUTYCYCLES(3) = "0000000000" THEN
									     LED3_VALUE <= "1111111111";
								    ELSE
									     LED3_VALUE <= "0000000000";
									 END IF;
		    	            ELSE
			    	             LED3_VALUE <= ARRAY_LED_DUTYCYCLES(3);
			               END IF;
								
								IF REG_PATTERN_DATA(4) = '1' THEN
								    IF ARRAY_LED_DUTYCYCLES(4) = "0000000000" THEN
									     LED4_VALUE <= "1111111111";
								    ELSE
									     LED4_VALUE <= "0000000000";
									 END IF;
		    	            ELSE
			    	             LED4_VALUE <= ARRAY_LED_DUTYCYCLES(4);
			               END IF;
								
								IF REG_PATTERN_DATA(5) = '1' THEN
								    IF ARRAY_LED_DUTYCYCLES(5) = "0000000000" THEN
									     LED5_VALUE <= "1111111111";
								    ELSE
									     LED5_VALUE <= "0000000000";
									 END IF;
		    	            ELSE
			    	             LED5_VALUE <= ARRAY_LED_DUTYCYCLES(5);
			               END IF;
								
								IF REG_PATTERN_DATA(6) = '1' THEN
								    IF ARRAY_LED_DUTYCYCLES(6) = "0000000000" THEN
									     LED6_VALUE <= "1111111111";
								    ELSE
									     LED6_VALUE <= "0000000000";
									 END IF;
		    	            ELSE
			    	             LED6_VALUE <= ARRAY_LED_DUTYCYCLES(6);
			               END IF;
								
								IF REG_PATTERN_DATA(7) = '1' THEN
								    IF ARRAY_LED_DUTYCYCLES(7) = "0000000000" THEN
									     LED7_VALUE <= "1111111111";
								    ELSE
									     LED7_VALUE <= "0000000000";
									 END IF;
		    	            ELSE
			    	             LED7_VALUE <= ARRAY_LED_DUTYCYCLES(7);
			               END IF;
								
								IF REG_PATTERN_DATA(8) = '1' THEN
								    IF ARRAY_LED_DUTYCYCLES(8) = "0000000000" THEN
									     LED8_VALUE <= "1111111111";
								    ELSE
									     LED8_VALUE <= "0000000000";
								    END IF;
		    	            ELSE
			    	             LED8_VALUE <= ARRAY_LED_DUTYCYCLES(8);
			               END IF;
								
								IF REG_PATTERN_DATA(9) = '1' THEN
								    IF ARRAY_LED_DUTYCYCLES(9) = "0000000000" THEN
									     LED9_VALUE <= "1111111111";
								    ELSE
									     LED9_VALUE <= "0000000000";
									 END IF;
		    	            ELSE
			    	             LED9_VALUE <= ARRAY_LED_DUTYCYCLES(9);
			               END IF;
		 
                    -- PWM Pattern Mode
		              WHEN others=>
			               -- Set duty cycles to the duty cycle input for each LED
    			            IF REG_PATTERN_DATA(0) = '1' THEN
	    			             LED0_VALUE <= REG_DUTYCYCLE_DATA;
		    	            ELSE
			    	             LED0_VALUE <= ARRAY_LED_DUTYCYCLES(0);
			               END IF;
								
								IF REG_PATTERN_DATA(1) = '1' THEN
	    			             LED1_VALUE <= REG_DUTYCYCLE_DATA;
		    	            ELSE
			    	             LED1_VALUE <= ARRAY_LED_DUTYCYCLES(1);
			               END IF;
								
								IF REG_PATTERN_DATA(2) = '1' THEN
	    			             LED2_VALUE <= REG_DUTYCYCLE_DATA;
		    	            ELSE
			    	             LED2_VALUE <= ARRAY_LED_DUTYCYCLES(2);
			               END IF;
								
								IF REG_PATTERN_DATA(3) = '1' THEN
	    			             LED3_VALUE <= REG_DUTYCYCLE_DATA;
		    	            ELSE
			    	             LED3_VALUE <= ARRAY_LED_DUTYCYCLES(3);
			               END IF;
								
								IF REG_PATTERN_DATA(4) = '1' THEN
	    			             LED4_VALUE <= REG_DUTYCYCLE_DATA;
		    	            ELSE
			    	             LED4_VALUE <= ARRAY_LED_DUTYCYCLES(4);
			               END IF;
								
								IF REG_PATTERN_DATA(5) = '1' THEN
	    			             LED5_VALUE <= REG_DUTYCYCLE_DATA;
		    	            ELSE
			    	             LED5_VALUE <= ARRAY_LED_DUTYCYCLES(5);
			               END IF;
								
								IF REG_PATTERN_DATA(6) = '1' THEN
	    			             LED6_VALUE <= REG_DUTYCYCLE_DATA;
		    	            ELSE
			    	             LED6_VALUE <= ARRAY_LED_DUTYCYCLES(6);
			               END IF;
								
								IF REG_PATTERN_DATA(7) = '1' THEN
	    			             LED7_VALUE <= REG_DUTYCYCLE_DATA;
		    	            ELSE
			    	             LED7_VALUE <= ARRAY_LED_DUTYCYCLES(7);
			               END IF;
								
								IF REG_PATTERN_DATA(8) = '1' THEN
	    			             LED8_VALUE <= REG_DUTYCYCLE_DATA;
		    	            ELSE
			    	             LED8_VALUE <= ARRAY_LED_DUTYCYCLES(8);
			               END IF;
								
								IF REG_PATTERN_DATA(9) = '1' THEN
	    			             LED9_VALUE <= REG_DUTYCYCLE_DATA;
		    	            ELSE
			    	             LED9_VALUE <= ARRAY_LED_DUTYCYCLES(9);
			               END IF;
                END CASE;
					 
					 ARRAY_LED_DUTYCYCLES(0) <= LED0_VALUE;
					 ARRAY_LED_DUTYCYCLES(1) <= LED1_VALUE;
					 ARRAY_LED_DUTYCYCLES(2) <= LED2_VALUE;
					 ARRAY_LED_DUTYCYCLES(3) <= LED3_VALUE;
					 ARRAY_LED_DUTYCYCLES(4) <= LED4_VALUE;
					 ARRAY_LED_DUTYCYCLES(5) <= LED5_VALUE;
					 ARRAY_LED_DUTYCYCLES(6) <= LED6_VALUE;
					 ARRAY_LED_DUTYCYCLES(7) <= LED7_VALUE;
					 ARRAY_LED_DUTYCYCLES(8) <= LED8_VALUE;
					 ARRAY_LED_DUTYCYCLES(9) <= LED9_VALUE;
			   ELSE
				    ARRAY_LED_DUTYCYCLES(0) <= ARRAY_LED_DUTYCYCLES(0);
					 ARRAY_LED_DUTYCYCLES(1) <= ARRAY_LED_DUTYCYCLES(1);
					 ARRAY_LED_DUTYCYCLES(2) <= ARRAY_LED_DUTYCYCLES(2);
					 ARRAY_LED_DUTYCYCLES(3) <= ARRAY_LED_DUTYCYCLES(3);
					 ARRAY_LED_DUTYCYCLES(4) <= ARRAY_LED_DUTYCYCLES(4);
					 ARRAY_LED_DUTYCYCLES(5) <= ARRAY_LED_DUTYCYCLES(5);
					 ARRAY_LED_DUTYCYCLES(6) <= ARRAY_LED_DUTYCYCLES(6);
					 ARRAY_LED_DUTYCYCLES(7) <= ARRAY_LED_DUTYCYCLES(7);
					 ARRAY_LED_DUTYCYCLES(8) <= ARRAY_LED_DUTYCYCLES(8);
					 ARRAY_LED_DUTYCYCLES(9) <= ARRAY_LED_DUTYCYCLES(9);
            END IF;
        END IF;
    END PROCESS;


    -- REG PWM LED Controller
    -- (not yet implemented)
	 -- Placeholder: use first bit to test functionality
	 -- LEDs <= ARRAY_LED_DUTYCYCLES;
    LEDs(0) <= ARRAY_LED_DUTYCYCLES(0)(0);
    LEDs(1) <= ARRAY_LED_DUTYCYCLES(1)(0);
    LEDs(2) <= ARRAY_LED_DUTYCYCLES(2)(0);
    LEDs(3) <= ARRAY_LED_DUTYCYCLES(3)(0);
    LEDs(4) <= ARRAY_LED_DUTYCYCLES(4)(0);
    LEDs(5) <= ARRAY_LED_DUTYCYCLES(5)(0);
    LEDs(6) <= ARRAY_LED_DUTYCYCLES(6)(0);
    LEDs(7) <= ARRAY_LED_DUTYCYCLES(7)(0);
    LEDs(8) <= ARRAY_LED_DUTYCYCLES(8)(0);
    LEDs(9) <= ARRAY_LED_DUTYCYCLES(9)(0);
END a;