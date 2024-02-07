//*****************************************************************************
// Universidad del Valle de Guatemala
// IE2023: Programación de microcontroladores
// Proyecto: Laboratorio 1
// Created: 30/01/2024 23:12:46
// Author : Paul Mateo Castañeda Paredes
// Hardware: ATMEGA328P
//*****************************************************************************
//Encabezado
//*****************************************************************************
.include "M328PDEF.inc"
.cseg
.org 0x00
//*****************************************************************************
// Stack
//*****************************************************************************
LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R17, HIGH(RAMEND)
OUT SPH, R17
//*****************************************************************************
// Configuración
//*****************************************************************************
Setup:
LDI R19, 0b0000_0000
LDI R18, 0b0010_0000
LDI R16, 0b1111_1111
OUT DDRD, R16
OUT DDRB, R16
OUT DDRC, R18
OUT PORTC, R19 // Definición de entrada y salida de puertos

CBI PORTC, PC0
CBI PORTC, PC1

CBI PORTB, PB0
CBI PORTB, PB1
CBI PORTB, PB2
CBI PORTB, PB3
CBI PORTB, PB4

LDI R17, 0b0000_0000
LDI R16, 0b1111_1111
LDI R18, 0b1111_1111
LDI R20, 0b0000_1111
LDI R21, 0b0000_0000 // Cargar valores iniciales para el delay


Loop:
IN R19, PINC
CPI R19, 0b0000_0000 // Se lee el pinc y se compara para verificar si algún botón se presionó
BREQ Loop
CALL DELAY // Delay anti-rebote y para bajar la velocidad de conteo
CPI R19, 0b0000_0001
BREQ Suma1
CPI R19, 0b0000_0010
BREQ Resta1
CPI R19, 0b0000_0100
BREQ Suma2
CPI R19, 0b0000_1000
BREQ Resta2 
CPI R19, 0b0001_0000
BREQ SumaT // Verificar en serie todas las posibles opciones que tenemos
RJMP Loop



//*****************************************************************************
// Subrutinas
//*****************************************************************************
Suma1:
INC R17
OUT PORTB, R17
RJMP Loop // Sumar del contador 1

Delay:
DEC R16 
CPI R16, 0b0000_0000 
BRNE Delay 
LDI R16, 0b1111_1111
DEC R18
CPI R18, 0b0000_0000
BRNE DELAY
LDI R18, 0b1111_1111
DEC R20 
CPI R20, 0b0000_0000
BRNE DELAY
LDI R20, 0b0000_1111 // Delay
RET

Resta1:
DEC R17
OUT PORTB, R17
RJMP Loop //Resta del contador1

Suma2:
INC R21
LSL R21
LSL R21
OUT PORTD, R21
LSR R21
LSR R21
RJMP Loop // Suma del contador2

Resta2:
DEC R21
LSL R21
LSL R21
OUT PORTD, R21
LSR R21
LSR R21
RJMP Loop // Resta del contador2 

SumaT:
ADD R17, R21
CLR R21
MOV R21, R17
SWAP R21
LSL R21
LSL R21
OUT PORTD, R21
LSL R17
LSL R17
CBR R17, 0b0000_1111 
OUT PORTB, R17
LSR R17
OUT PORTC, R17
CLR R17
CLR R18
RJMP Loop // Suma total