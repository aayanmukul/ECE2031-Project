Switches    EQU 000
Mode	    EQU &H020
LEDs        EQU &H022
Duty        EQU &H024
Timer       EQU 002
Hex0        EQU 004
Hex1        EQU 005

; Constants used in the game:
TEN: DW 10     ; Used to wait a minimum delay (simulate randomness)
HUNDRED: DW 128    ; Maximum brightness value scale
ONE: DW 1      ; Minimum brightness value
MASK: DW 15     ; Mask to extract lower 4 bits for LED pattern (0-15)

         LOADI 0
         OUT Mode
         OUT Duty
         OUT Timer
         OUT LEDs         ; Clear LEDs at startup
         
         LOAD Pattern1
         OUT LEDs
INIT:
		 IN Switches      
         JPOS INIT

START:   
		 LOADI 0
         OUT MODE
         LOAD Pattern1
         OUT LEDs
         CALL NOPDELAY
         LOAD Pattern2
         OUT LEDs
         CALL NOPDELAY
         IN Switches        ; Wait for switch 9 press to start a round
		 AND Bit9
         JZERO START        ; Loop until a switch is pressed

; --- RANDOM DELAY & PATTERN GENERATION ---
         ; Use Timer value to generate a random LED pattern:
	 LOADI 0
	 OUT Mode
         IN Timer
         AND MASK           ; Mask out all but the lower 4 bits
         ADDI 1
         STORE LEDPattern
         OUT LEDs         ; Display the random LED pattern

         ; Reset Timer to measure the user’s reaction time
         OUT Timer

; --- WAIT FOR USER REACTION ---
REACTION:
         IN Switches       ; Read switch input
         AND MASK
         SUB LEDPattern          ; Subtract displayed LED pattern from the switch input
         JZERO DONE        ; If the result is zero, the correct switch was pressed
         JUMP REACTION     ; Otherwise, keep waiting

; --- REACTION TIME MEASUREMENT & SCORING ---
DONE:    IN Timer         ; Read reaction time (in ticks) from the Timer
         STORE ReactionVal  ; Save reaction time in a temporary variable

         ; Compute brightness value: brightness = 100 – reaction_time.
         ; Faster responses (lower reaction time) yield higher brightness.
         LOAD HUNDRED
         SUB ReactionVal
         SHIFT -2
         STORE ReactionVal
         JNEG SET_ONE      ; If result is negative, force brightness to 1
AFTERNEGATIVE:

		 LOADI 31
         STORE TEMP
         
ENDINGLOOP:         
         LOADI 2
         OUT MODE
	 LOAD TEMP
         OUT DUTY
         ADDI -1
         STORE TEMP
         
         LOAD ALLLED
         OUT LEDs
         
         CALL DELAY
         
         LOAD TEMP
         ADDI 1
         SUB ReactionVal
         JPOS ENDINGLOOP

         
         ; OUT LEDs        ; Output brightness value on LEDs
RESULTS:
		 IN Switches        ; Wait for all switches off to start again
         JPOS RESULTS
         JUMP START

SET_ONE:
         LOAD ONE
         STORE ReactionVal        ; Set a minimum brightness value of 1 on LEDs
         JUMP AFTERNEGATIVE

DELAY:
		OUT TIMER
        
	DELAYLOOP:
		IN TIMER
        ADDI -8 ; change this number to shorten delay
        JNEG DELAYLOOP
		RETURN

NOPDELAY:
	LOADI 100 ; change this number to shorten delay
    STORE TEMP
   
NOPLOOP:
	LOAD TEMP
    ADDI -1
    STORE TEMP
    JPOS NOPLOOP
    RETURN
    


; --- VARIABLE STORAGE ---
TEMP: DW 0
LEDPattern: DW 0
ReactionVal: DW 0         ; Temporary storage for reaction time
THREE: DW 3
ALLLED: DW 1023
Bit9:      DW &B1000000000
Pattern1: DW  &B1010101010
Pattern2: DW  &B0101010101
