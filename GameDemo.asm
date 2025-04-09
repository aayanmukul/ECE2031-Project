Switches    EQU 000
Mode	    EQU 020
LEDs        EQU 022
Duty        EQU 024
Timer       EQU 002
Hex0        EQU 004
Hex1        EQU 005

; Constants used in the game:
TEN         EQU 10     ; Used to wait a minimum delay (simulate randomness)
HUNDRED     EQU 100    ; Maximum brightness value scale
ONE         EQU 1      ; Minimum brightness value
MASK        EQU 15     ; Mask to extract lower 4 bits for LED pattern (0-15)

         LOADI 0
         OUT Mode
         OUT Duty
         OUT Timer
         OUT LEDs         ; Clear LEDs at startup
INIT:
		 IN Switches      
         JPOS INIT

START:   
		 LOADI 0
         OUT Mode
         OUT LEDs
         IN Switches        ; Wait for any switch press to start a round
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
         SHIFT 3
         JNEG SET_ONE      ; If result is negative, force brightness to 1
AFTERNEGATIVE:
         OUT Duty
         LOADI 2
         OUT Mode
         LOADI 1023
         OUT LEDs
         ; OUT LEDs        ; Output brightness value on LEDs
RESULTS:
		 IN Switches        ; Wait for any switch press to start a round
         JPOS RESULTS
         JUMP START

SET_ONE:
         LOAD ONE
         STORE LEDs        ; Set a minimum brightness value of 1 on LEDs
         JUMP AFTERNEGATIVE


; --- VARIABLE STORAGE ---
LEDPattern: DW 0
ReactionVal: DW 0         ; Temporary storage for reaction time
Bit9:      DW &B1000000000