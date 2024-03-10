; I/O Addresses
PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

; Control flags for display
E = %10000000  ; Enable
RW = %01000000 ; Read/Write
RS = %00100000 ; Register select

	.org $8000
reset:
	ldx #$FF       ; Set stack pointer to 0xFF
	txs 
     
	lda #%11111111 ; Enable all pins as output on port B
	sta DDRB

	lda #%11100000 ; Enable top 3 pines as output on port A
	sta DDRA

init_display:
	lda #%00111000 ; 8 bit mode, 2-line display, 5x8 font
	sta PORTB
	jsr lcd_instruction

	lda #%00001110 ; Display on, cursor on, no cursor blink.
	sta PORTB
	jsr lcd_instruction

	lda #%00000110 ; Set entry mode, shift right, no scroll.
	sta PORTB
	jsr lcd_instruction

	lda #%00000010 ; Return cursor home.
	sta PORTB
	jsr lcd_instruction
main:
	ldx #0
print:
	lda print_txt,x  ; Read next character
	beq main_loop    ; If 0x00 exit loop
	jsr lcd_print    ; Else print character
	inx              ; x++
	jmp print        

main_loop:
	jmp main_loop

print_txt: .asciiz " Zero Day Coffee                          We Have Food. "

;
; lcd_wait - Reads the busy flag from the LCD display and loops until it clears.
;
lcd_wait:
	pha             ; Push contents of A on to stack.
	lda #%00000000  ; Set port B to input.
	sta DDRB
lcd_busy:
	lda #RW         ; Set RW to read from port B.
	sta PORTA    
	lda #(RW | E)   ; Toggle enable.
	sta PORTA
	lda PORTB       ; Read status from LCD display.
	and #%10000000  ; Is the busy flag set?
	bne lcd_busy    ; Z != 1 if flag is set. Jump to lcd_busy and try again.

	lda #0          ; Clear RS/RW/E bits. 
	sta PORTA
	lda #%11111111  ; All pins of port B are output.
	sta DDRB
	pla             ; Pull original contents of A off stack.
	rts

;
; lcd_instruction - Sends a comment to control the output of the LCD display.
;
lcd_instruction:
	jsr lcd_wait   ; Wait for LCD display to be ready.
	lda #E         ; Clear RS/RW/E bits, set enable.
	sta PORTA
	lda #0	       ; Clear enable bit.
	sta PORTA
	rts

;
; lcd_print - Print the character in register A to the LCD display.
;
lcd_print:
	jsr lcd_wait   ; Wait for LCD display to be ready.
	sta PORTB      ; Write contents of register A to PORTB.
	lda #(RS | E)  ; Toggle register select & enable.
	sta PORTA
	lda #0	       ; Clear RS/RW/E bits.
	sta PORTA
	rts

;
; Reset vector, IRQ vector
;	
	.org $FFFC
	.word reset
	.word $0000

