DisplayMonFrontSpriteInBox:
; Displays a pokemon's front sprite in a pop-up window.
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	xor a
	ldh [hWY], a
	call SaveScreenTilesToBuffer1
	ld a, MON_SPRITE_POPUP
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call UpdateSprites
	call Delay3 ; allow box to finish rendering before setting palette
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetMonHeader
	ld de, vChars1 tile $31
	call LoadMonFrontSprite
	ld a, $80
	ldh [hStartTileID], a
	hlcoord 10, 11
	predef AnimateSendingOutMon
	ld a, [wCurPartySpecies]
	cp FOSSIL_KABUTOPS
	jr z, .skipCry
	cp FOSSIL_AERODACTYL
	call nz, PlayCry
.skipCry
	call WaitForTextScrollButtonPress
	ld a, MON_SPRITE_POPUP
	ld [wTextBoxID], a
	call DisplayTextBoxID ; redisplay the box to clear the pokemon sprite out
	call Delay3 ; allow box to finish clearing 
	call RunDefaultPaletteCommand ; reset palette to what it was before displaying this box
	call LoadScreenTilesFromBuffer1 ; close the box
	call Delay3
	ld a, $90
	ldh [hWY], a
;	xor a
;	ldh [hAutoBGTransferEnabled], a
	ret
