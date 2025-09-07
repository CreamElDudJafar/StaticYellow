;Convert a value from the 1st party pkmn into a normalized BCD-value score stored in wNameBuffer+1 & wNameBuffer+2
;takes a number loaded into wNameBuffer to determine value:
;	1 is catch rate
;	2 is level
;	default is DVs
Mon1BCDScore::
	push de
	push hl
	push bc
	ld a, [wNameBuffer]

	cp 2
	jr nz, .next1
	;make a = 1 * wPartyMon1Level
	ld a, [wPartyMon1Level]
	jr .AddToTotal

.next1
	cp 1
	jr nz, .default
	;calculate a = $FF - wPartyMon1CatchRate
	ld a, [wPartyMon1CatchRate]
	ld b, a
	ld a, $FF
	sub b
	jr .AddToTotal

.default
	;calculate a = $00 to $FF based on average of DVs
	ld a, [wPartyMon1DVs]	;load first two nybbles of DVs
	call .add_nybbles
	push bc
	ld a, [wPartyMon1DVs + 1]	;load second two nybbles of DVs
	call .add_nybbles
	ld a, b
	srl a	;a = mean of first two nybbles
	pop bc
	srl b	;b = mean of second two nybbles
	add b
	srl a	;a = mean of all four nybbles
	ld b, a
	swap a
	add b	;use mean to make a byte of 00,11,22...,EE,FF

.AddToTotal
	;double the score and return it
	ld b, a
	xor a
	ld [hCoins], a
	ld [hCoins + 1], a
	ld [wNameBuffer], a
	ld [wNameBuffer + 1], a
	ld [wNameBuffer + 2], a
	
	ld a, b
	ld hl, hCoins
	call Hex2BCD
	
	ld de, wNameBuffer + 2
	ld hl, hCoins + 1
	ld c, $2
	predef AddBCDPredef	;add value in hl location to value in de location
	ld de, wNameBuffer + 2
	ld hl, hCoins + 1
	ld c, $2
	predef AddBCDPredef	;add value in hl location to value in de location

	xor a
	ld [hCoins], a
	ld [hCoins + 1], a

	pop bc
	pop hl
	pop de
	ret
.add_nybbles
	;get first nybble
	push af
	and $F0
	swap a
	ld b, a
	pop af
	;add second nybble
	push af
	and $0F
	add b
	ld b, a
	pop af
	ret

Hex2BCD:	;convert number in A to BCD in HL
	ld [hDividend + 3], a
	xor a
	ld [hDividend], a
	ld [hDividend + 1], a
	ld [hDividend + 2], a
	ld a, 100
	ld [hDivisor], a
	ld b, $4
	call Divide
	ld a, [hQuotient + 3]
	ld [hli], a
	ld a, [hRemainder]
	ld [hDividend + 3], a
	ld a, 10
	ld [hDivisor], a
	ld b, $4
	call Divide
	ld a, [hQuotient + 3]
	swap a
	ld b, a
	ld a, [hRemainder]
	add b
	ld [hl], a
	ret

;gets a random pokemon and puts its hex ID in register a and wCurPartySpecies
GetRandMonAny::
	ld de, ListRealPkmn
	;fall through
GetRandMon:
	push hl
	push bc
	ld h, d
	ld l, e
	call Random
	ld b, a
.loop
	ld a, b
	and a
	jr z, .endloop
	inc hl
	dec b
	ld a, [hl]
	and a
	jr nz, .loop
	ld h, d
	ld l, e
	jr .loop
.endloop
	ld a, [hl]
	pop bc
	pop hl
	ld [wCurPartySpecies], a
	ret