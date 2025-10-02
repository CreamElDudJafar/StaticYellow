SetAttackAnimPal:
	call GetPredefRegisters

	;set wAnimPalette based on if in grayscale or color
	ld a, $e4
	ld [wAnimPalette], a
	ld a, [wOnSGB]
	and a
	ret z
	ld a, $f0
	ld [wAnimPalette], a
	
	;return if not on a GBC
	ld a, [hGBC]
	and a
	ret z 
	
	ld a, [wIsInBattle]
	and a
	ret z

	;only continue for valid move animations
	ld a, [wAnimationID]
	and a
	ret z
	cp STRUGGLE
	call nc, CheckIfBall
	jp z, SetAttackAnimPal_otheranim	;reset battle pals for any other battle animations
	
	ld a, $e4
	ld [wAnimPalette], a
	
	push hl
	push bc
	push de
	ld a, [wCurPartySpecies]
	push af

	call CheckIfBall
	jp nz, .do_ball_color

;doing a move animation, so find its type and apply color
	ld a, [hWhoseTurn]
	and a
	ld hl, wPlayerMoveType
	jr z, .playermove
	ld hl, wEnemyMoveType
.playermove
	ld a, [hl]
	ld bc, $0000
	ld c, a
	ld hl, TypePalColorList
	add hl, bc
	ld a, [hl]
	ld b, a

	ld a, [wAnimationID]
	and a
	ret z
	cp POUND
	jr nz, .noselfdamage 		;check for self inflicted confusion damage
	ld b, PAL_BLACK2
.noselfdamage
	cp ABSORB
	jr nz, .noleechseed
	ld b, PAL_GREENMON
.noleechseed
	cp GROWTH
	jr nz, .not_growth
	ld b, PAL_GREENMON
.not_growth
	cp LEECH_LIFE
	jr nz, .not_leechlife
	ld b, PAL_YELLOWMON
.not_leechlife
	cp SELFDESTRUCT
	jr nz, .not_selfdestruct
	ld b, PAL_REDMON
.not_selfdestruct
	cp EGG_BOMB
	jr nz, .not_eggbomb
	ld b, PAL_REDMON
.not_eggbomb
	cp EXPLOSION
	jr nz, .not_explosion
	ld b, PAL_REDMON
.not_explosion
	cp HYPER_BEAM
	jr nz, .not_hyperbeam
	ld b, PAL_YELLOWMON
.not_hyperbeam
	cp FOCUS_ENERGY
	jr nz, .not_focusenergy
	ld b, PAL_YELLOWMON
.not_focusenergy
	cp SWIFT
	jr nz, .not_swift
	ld b, PAL_YELLOWMON
.not_swift
	cp STUN_SPORE
	jr nz, .not_stunspore
	ld b, PAL_YELLOWMON
.not_stunspore
	cp PAY_DAY
	jr nz, .not_payday
	ld b, PAL_YELLOWMON
.not_payday
	cp RECOVER
	jr nz, .starttransfer
	ld b, PAL_YELLOWMON
.starttransfer
	;make sure to reset palette/shade data into OBP0
	;have to do this so colors transfer to the proper positions
;	ld a, %11100100
;	ld [rOBP0], a
;NOTE: rOBP0 value is now set before entering this function, and colors will transfer based on its value
;		;Typically this will be $E4 or a complemented version of it
	
	ld c, 4
.transfer
	ld d, CONVERT_OBP0
	ld e, c
	dec e
	ld a, b	
	add NUM_POKEMON_INDEXES+1
	ld [wCurPartySpecies], a
	push bc
	farcall TransferMonPal
	pop bc
	dec c
	jr nz, .transfer
	
	pop af
	ld [wCurPartySpecies], a
	pop de
	pop bc
	pop hl
	ret
.do_ball_color
	ld a, [wCurPartySpecies]
	ld hl, ItemPalList
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld b, a
	jr .starttransfer
;this functions sets z flag if not using a ball item, otherwise clears z flag if using a ball item
CheckIfBall:
	ld a, [wAnimationID]
	cp BLOCKBALL_ANIM
	jr z, .is_ball
	cp TOSS_ANIM
	jr z, .is_ball
	cp GREATTOSS_ANIM
	jr z, .is_ball
	cp ULTRATOSS_ANIM
	jr nz, .not_ball
.is_ball
	ld a, 1
	and a
	ret
.not_ball
	xor a
	ret


;This function copies BGP colors 0-3 into OBP colors 0-3
;It is meant to reset the object palettes on the fly
SetAttackAnimPal_otheranim:
	push hl
	push bc
	push de
	
	ld c, 4
.loop
	ld a, 4
	sub c
	;multiply index by 8 since each index represents 8 bytes worth of data
	add a
	add a
	add a
	ld [rBGPI], a
	or $80 ; set auto-increment bit for writing
	ld [rOBPI], a
	ld hl, rBGPD
	ld de, rOBPD
	
	ld b, 4
.loop2
	ld a, [rLCDC]
	and 1 << rLCDC_ENABLE ; is LCD off?
	jr z, .lcd_dis
	;lcd in enabled otherwise
.wait1
	;wait for current blank period to end
	ld a, [rSTAT]
	and %10 ; mask for non-V-blank/non-H-blank STAT mode
	jr z, .wait1
	;out of blank period now
.wait2
	ld a, [rSTAT]
	and %10 ; mask for non-V-blank/non-H-blank STAT mode
	jr nz, .wait2
	;back in blank period now
.lcd_dis	
	;LCD is disabled, so safe to read/write colors directly
	ld a, [hl]
	ld [de], a
	ld a, [rBGPI]
	inc a
	ld [rBGPI], a
	ld a, [hl]
	ld [de], a
	ld a, [rBGPI]
	inc a
	ld [rBGPI], a
	dec b
	jr nz, .loop2
	
	dec c
	jr nz, .loop
	
	pop de
	pop bc
	pop hl
	ret

TypePalColorList:
	db PAL_BLACK2;normal
	db PAL_GREYMON;fighting
	db PAL_MEWMON2;flying
	db PAL_PURPLEMON;poison
	db PAL_BROWNMON;ground
	db PAL_GREYMON;rock
	db PAL_BLACK2;unused
	db PAL_GREENBAR;bug
	db PAL_PURPLEMON;ghost
	db PAL_BLACK2;unused
	db PAL_BLACK2;unused
	db PAL_BLACK2;unused
	db PAL_BLACK2;unused
	db PAL_BLACK2;unused
	db PAL_BLACK2;unused
	db PAL_BLACK2;unused
	db PAL_BLACK2;unused
	db PAL_BLACK2;unused
	db PAL_BLACK2;unused
	db PAL_BLACK2;unused
	db PAL_REDMON;fire
	db PAL_BLUEMON;water
	db PAL_GREENMON;grass
	db PAL_YELLOWMON;electric
	db PAL_PINKMON;psychic
	db PAL_CYANMON;ice
	db PAL_MEWMON3;dragon

ItemPalList:
	db PAL_BLACK2	;null item
	db PAL_PURPLEMON	;master ball
	db PAL_YELLOWMON	;ultra ball
	db PAL_BLUEMON	;great ball
	db PAL_REDMON	;pokeball
	db PAL_BLACK2	;town map
	db PAL_BLACK2	;bike
	db PAL_BLACK2	;surfboard
	db PAL_GREENMON	;safari ball
