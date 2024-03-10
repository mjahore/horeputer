	.org $8000

	lda #$FF
	sta $6002

	lda #$55
	sta $6000

	lda #$AA
	sta $6000
 
	jmp $8005

	.org $FFFC
	.word $8000
	.word $0000

