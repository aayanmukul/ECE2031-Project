; LED Peripheral Test
; Date: 04/11/2025
; 3 Modes: Static Pattern, Toggle, PWM
; Mode Register: Set Mode
; Duty Register: Set Duty Cycle (only for PWM Mode)
; Patern Register: Set Pattern (choose LEDs to change duty cycles)
; Pattern Register is also trigger for changing LED duty cycles

Start:
; STATIC PATTERN MODE
LOADI &H00
OUT Mode

LOADI &H0F0
OUT Duty

LOADI &B0101010101
OUT Pattern
CALL Delay

; STATIC TOGGLE MODE
LOADI &H01
OUT Mode

LOADI &B1111100000
OUT Pattern
CALL Delay

LOADI &B0000011111
OUT Pattern
CALL Delay

; PWM MODE
LOADI &H02
OUT Mode

LOADI &H00
OUT Duty
LOADI &B1111111111
OUT Pattern
CALL Delay

LOADI &H01
OUT Duty
LOADI &B0000000011
OUT Pattern
CALL Delay

LOADI &H0F
OUT Duty
LOADI &B0000110000
OUT Pattern
CALL Delay

LOADI &H1F
OUT Duty
LOADI &B1000000000
OUT Pattern
CALL Delay

LOADI &B0100000000
OUT Pattern
CALL Delay

; STATIC TOGGLE MODE
LOADI &H01
OUT Mode

LOADI &B1111111111
OUT Pattern
CALL Delay

LOADI &B0000000000
OUT Pattern
CALL Delay

Loop:
LOADI &B1000000001
OUT Pattern
CALL Delay
JUMP Loop

; IO address constants
Switches:  EQU 000
Timer:     EQU 002
Mode:	   EQU &H020
Pattern:   EQU &H022
Duty:	   EQU &H024

Delay:
OUT Timer
Delay_Loop:
IN Timer
ADDI -15
JNEG Delay_Loop
RETURN