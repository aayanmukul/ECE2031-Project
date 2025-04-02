; PWM Mode Test
Start:
LOADI &H02
STORE Mode

LOADI &H0F0
STORE Duty

LOADI &B0101010101
STORE Pattern

OUT LEDs

Loop:
JUMP Loop

; IO address constants
Dut:	   DW  &H0F0
Pat:	   DW  &B0101010101
Switches:  EQU 000
LEDs:      EQU 001
Mode:	   EQU 020
Pattern:   EQU 022
Duty:	   EQU 024