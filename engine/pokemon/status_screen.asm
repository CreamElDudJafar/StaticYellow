DrawHP:
; Draws the HP bar in the stats screen
	call GetPredefRegisters
	ld a, $1
	jr DrawHP_

DrawHP2:
; Draws the HP bar in the party screen
	call GetPredefRegisters
	ld a, $2

DrawHP_:
	ld [wHPBarType], a
	push hl
	ld a, [wLoadedMonHP]
	ld b, a
	ld a, [wLoadedMonHP + 1]
	ld c, a
	or b
	jr nz, .nonzeroHP
	xor a
	ld c, a
	ld e, a
	ld a, $6
	ld d, a
	jp .drawHPBarAndPrintFraction
.nonzeroHP
	ld a, [wLoadedMonMaxHP]
	ld d, a
	ld a, [wLoadedMonMaxHP + 1]
	ld e, a
	predef HPBarLength
	ld a, $6
	ld d, a
	ld c, a
.drawHPBarAndPrintFraction
	pop hl
	push de
	push hl
	push hl
	call DrawHPBar
	pop hl
	ld a, [hUILayoutFlags]
	bit BIT_PARTY_MENU_HP_BAR, a
	jr z, .printFractionBelowBar
	ld bc, $9 ; right of bar
	jr .printFraction
.printFractionBelowBar
	ld bc, SCREEN_WIDTH + 1 ; below bar
.printFraction
	add hl, bc
	ld de, wLoadedMonHP
	lb bc, 2, 3
	call PrintNumber
	ld a, "/"
	ld [hli], a
	ld de, wLoadedMonMaxHP
	lb bc, 2, 3
	call PrintNumber
	pop hl
	pop de
	ret


; Predef 0x37
StatusScreen:
	call LoadMonData
	ld a, [wMonDataLocation]
	cp BOX_DATA
	jr c, .DontRecalculate
; mon is in a box or daycare
	ld a, [wLoadedMonBoxLevel]
	ld [wLoadedMonLevel], a
	ld [wCurEnemyLevel], a
	ld hl, wLoadedMonHPExp - 1
	ld de, wLoadedMonStats
	ld b, $1
	call CalcStats ; Recalculate stats
.DontRecalculate
	ld hl, wStatusFlags2
	set BIT_NO_AUDIO_FADE_OUT, [hl]
	ld a, $33
	ld [rNR50], a ; Reduce the volume
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	call LoadHpBarAndStatusTilePatterns
	ld de, BattleHudTiles1  ; source
	ld hl, vChars2 + $6d0 ; dest
	lb bc, BANK(BattleHudTiles1), $03
	call CopyVideoDataDouble ; ·│ :L and halfarrow line end
	ld de, BattleHudTiles2
	ld hl, vChars2 + $780
	lb bc, BANK(BattleHudTiles2), $01
	call CopyVideoDataDouble ; │
	ld de, BattleHudTiles3
	ld hl, vChars2 + $760
	lb bc, BANK(BattleHudTiles3), $02
	call CopyVideoDataDouble ; ─┘
	ld de, PTile
	ld hl, vChars2 tile $72
	lb bc, BANK(PTile), 1
	call CopyVideoDataDouble ; bold P (for PP)
	ldh a, [hTileAnimations]
	push af
	xor a
	ld [hTileAnimations], a
	coord hl, 19, 3
	lb bc, 2, 8
	call DrawLineBox ; Draws the box around name, HP and status
	hlcoord 2, 7
	nop
	ld [hl], "."
	dec hl
	ld [hl], "№"
	coord hl, 19, 9
	lb bc, 8, 6
	call DrawLineBox ; Draws the box around types, ID No. and OT
	coord hl, 10, 9
	ld de, Type1Text
	call PlaceString ; "TYPE1/"
	coord hl, 11, 3
	predef DrawHP

;joenote - print stat exp if select is held
	;parse dv stats here so they can be grabbed later
	push de
	ld bc, SCREEN_WIDTH + 1
	add hl, bc
	call DVParse
	call Joypad
	
	ld a, [hJoyHeld]
	and SELECT | START
	jr z, .noblank
	push hl
	ld a, " "
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop hl
.noblank
	
	ld a, [hJoyHeld]
	bit BIT_SELECT, a
	jr z, .checkstart
	ld de, wLoadedMonHPExp
	lb bc, 2, 5
	jr .printnum
.checkstart	;print DVs if start is held
	bit BIT_START, a
	jr z, .doregular
	ld de, wDVCalcVar2 + 4
	lb bc, 1, 2
.printnum
	call PrintNumber
.doregular
	pop de
	ld hl, wStatusScreenHPBarColor
	call GetHealthBarColor
	ld b, SET_PAL_STATUS_SCREEN
	call RunPaletteCommand
	coord de, 18, 5
	ld a, [wBattleMonLevel]
	push af
	ld a, [wLoadedMonLevel]
	ld [wBattleMonLevel], a
	push af
	callfar PrintEXPBar
	pop af
	ld [wLoadedMonLevel], a
	pop af
	ld [wBattleMonLevel], a
	coord hl, 16, 6
	ld de, wLoadedMonStatus
	call PrintStatusCondition
	jr nz, .StatusWritten
	coord hl, 16, 6
	ld de, OKText
	call PlaceString ; "OK"
.StatusWritten
	coord hl, 9, 6
	ld de, StatusText
	call PlaceString ; "STATUS/"
	coord hl, 14, 2
	call PrintLevel ; Pokémon level
	ld a, [wMonHIndex]
	ld [wPokedexNum], a
	ld [wCurSpecies], a
	predef IndexToPokedex
	coord hl, 3, 7
	ld de, wPokedexNum
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber ; Pokémon no.
	coord hl, 11, 10
	predef PrintMonType
	ld hl, NamePointers2
	call .GetStringPointer
	ld d, h
	ld e, l
	coord hl, 9, 1
	call PlaceString ; Pokémon name
	ld hl, OTPointers
	call .GetStringPointer
	ld d, h
	ld e, l
	coord hl, 12, 16
	call PlaceString ; OT
	coord hl, 12, 14
	ld de, wLoadedMonOTID
	lb bc, LEADING_ZEROES | 2, 5
	call PrintNumber ; ID Number
	ld d, $0
	call PrintStatsBox
	call Delay3
	call GBPalNormal
	coord hl, 1, 0
	call LoadFlippedFrontSpriteByMonIndex ; draw Pokémon picture
	ld a, [wMonDataLocation]
	cp ENEMY_PARTY_DATA
	jr z, .playRegularCry
	cp BOX_DATA
	jr z, .checkBoxData
	callfar IsThisPartymonStarterPikachu_Party
	jr nc, .playRegularCry
	jr .playPikachuSoundClip
.checkBoxData
	callfar IsThisPartymonStarterPikachu_Box
	jr nc, .playRegularCry
.playPikachuSoundClip
	ldpikacry e, PikachuCry17
	callfar PlayPikachuSoundClip
	jr .continue
.playRegularCry
	ld a, [wCurPartySpecies]
	call PlayCry
.continue
	pop af
	ret

.GetStringPointer
	ld a, [wMonDataLocation]
	add a
	ld c, a
	ld b, 0
	add hl, bc

	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMonDataLocation]
	cp DAYCARE_DATA
	ret z
	ld a, [wWhichPokemon]
	jp SkipFixedLengthTextEntries

OTPointers:
	dw wPartyMonOT
	dw wEnemyMonOT
	dw wBoxMonOT
	dw wDayCareMonOT

NamePointers2:
	dw wPartyMonNicks
	dw wEnemyMonNicks
	dw wBoxMonNicks
	dw wDayCareMonName

Type1Text:
	db   "TYPE1/"
	next ""
	; fallthrough
Type2Text:
	db   "TYPE2/"
	next ""
	; fallthrough
IDNoText:
	db   "<ID>№/"
	next ""
	; fallthrough
OTText:
	db   "OT/"
	next "@"

StatusText:
	db "STATUS/@"

OKText:
	db "OK@"

; Draws a line starting from hl high b and wide c
DrawLineBox:
	ld de, SCREEN_WIDTH ; New line
.PrintVerticalLine
	ld [hl], $78 ; │
	add hl, de
	dec b
	jr nz, .PrintVerticalLine
	ld [hl], $77 ; ┘
	dec hl
.PrintHorizLine
	ld [hl], $76 ; ─
	dec hl
	dec c
	jr nz, .PrintHorizLine
	ld [hl], $6f ; ← (halfarrow ending)
	ret

PTile: INCBIN "gfx/font/P.1bpp"

PrintStatsBox:
	ld a, d
	and a ; a is 0 from the status screen
	jr nz, .DifferentBox
	hlcoord 0, 8
	lb bc, 8, 8
	call TextBoxBorder ; Draws the box
	hlcoord 1, 9 ; Start printing stats from here
	ld bc, $19 ; Number offset
	jr .PrintStats
.DifferentBox
	hlcoord 9, 2
	lb bc, 8, 9
	call TextBoxBorder
	hlcoord 11, 3
	ld bc, $18
.PrintStats
	push bc
	push hl
	ld de, StatsText
	call PlaceString
	pop hl
	pop bc
	add hl, bc
; New Stat Exp / DVs display functionality, from shin pokered.
;joenote - print stat exp if select is held
	call Joypad
	ld a, [hJoyHeld]
	bit 2, a
	jr z, .checkstart
	dec l	;shift alignment 2 tiles to the left
	dec l
	ld de, wLoadedMonAttackExp
	lb bc, 2, 5
	call PrintStat
	ld de, wLoadedMonDefenseExp
	call PrintStat
	ld de, wLoadedMonSpeedExp
	call PrintStat
	ld de, wLoadedMonSpecialExp
	jp PrintNumber
.checkstart	;joenote - print DVs if start is held
	bit 3, a
	jr z, .doregular
	ld de, wDVCalcVar2
	lb bc, 1, 2
	call PrintStat
	ld de, wDVCalcVar2 + 1
	call PrintStat
	ld de, wDVCalcVar2 + 2
	call PrintStat
	ld de, wDVCalcVar2 + 3
	jp PrintNumber
.doregular
	ld de, wLoadedMonAttack
	lb bc, 2, 3
	call PrintStat
	ld de, wLoadedMonDefense
	call PrintStat
	ld de, wLoadedMonSpeed
	call PrintStat
	ld de, wLoadedMonSpecial
	jp PrintNumber
PrintStat:
	push hl
	call PrintNumber
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret

StatsText:
	db   "ATTACK"
	next "DEFENSE"
	next "SPEED"
	next "SPECIAL@"

StatusScreen2:
	ldh a, [hTileAnimations]
	push af
	xor a
	ldh [hTileAnimations], a
	ldh [hAutoBGTransferEnabled], a
	ld bc, NUM_MOVES + 1
	ld hl, wMoves
	call FillMemory
	ld hl, wLoadedMonMoves
	ld de, wMoves
	ld bc, NUM_MOVES
	rst _CopyData
	callfar FormatMovesString
	hlcoord 9, 2
	lb bc, 5, 10
	call ClearScreenArea ; Clear under name
	hlcoord 19, 1
	lb bc, 6, 10
	call DrawLineBox ; Draws the box around name, HP and status
	hlcoord 0, 8
	lb bc, 8, 18
	call TextBoxBorder ; Draw move container
	hlcoord 2, 9
	ld de, wMovesString
	call PlaceString ; Print moves
	ld a, [wNumMovesMinusOne]
	inc a
	ld c, a
	ld a, $4
	sub c
	ld b, a ; Number of moves ?
	hlcoord 11, 10
	ld de, SCREEN_WIDTH * 2
	ld a, "<BOLD_P>"
	call StatusScreen_PrintPP ; Print "PP"
	ld a, b
	and a
	jr z, .InitPP
	ld c, a
	ld a, "-"
	call StatusScreen_PrintPP ; Fill the rest with --
.InitPP
	ld hl, wLoadedMonMoves
	decoord 14, 10
	ld b, 0
.PrintPP
	ld a, [hli]
	and a
	jr z, .PPDone
	push bc
	push hl
	push de
	ld hl, wCurrentMenuItem
	ld a, [hl]
	push af
	ld a, b
	ld [hl], a
	push hl
	callfar GetMaxPP
	pop hl
	pop af
	ld [hl], a
	pop de
	pop hl
	push hl
	ld bc, wPartyMon1PP - wPartyMon1Moves - 1
	add hl, bc
	ld a, [hl]
	and $3f
	ld [wStatusScreenCurrentPP], a
	ld h, d
	ld l, e
	push hl
	ld de, wStatusScreenCurrentPP
	lb bc, 1, 2
	call PrintNumber
	ld a, "/"
	ld [hli], a
	ld de, wMaxPP
	lb bc, 1, 2
	call PrintNumber
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ld d, h
	ld e, l
	pop hl
	pop bc
	inc b
	ld a, b
	cp $4
	jr nz, .PrintPP
.PPDone
	hlcoord 9, 3
	ld de, StatusScreenExpText
	call PlaceString
	ld a, [wLoadedMonLevel]
	push af
	cp MAX_LEVEL
	jr z, .Level100
	inc a
	ld [wLoadedMonLevel], a ; Increase temporarily if not 100
.Level100
	hlcoord 14, 6
	ld [hl], "<to>"
	inc hl
	inc hl
	call PrintLevel
	pop af
	ld [wLoadedMonLevel], a
	ld de, wLoadedMonExp
	hlcoord 12, 4
	lb bc, 3, 7
	call PrintNumber ; exp
	call CalcExpToLevelUp
	ld de, wLoadedMonExp
	hlcoord 7, 6
	lb bc, 3, 7
	call PrintNumber ; exp needed to level up
	hlcoord 9, 0
	call StatusScreen_ClearName
	hlcoord 9, 1
	call StatusScreen_ClearName
	ld a, [wMonHIndex]
	ld [wNamedObjectIndex], a
	call GetMonName
	hlcoord 9, 1
	call PlaceString
	ld a, $1
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	pop af
	ret

CalcExpToLevelUp:
	ld a, [wLoadedMonLevel]
	cp MAX_LEVEL
	jr z, .atMaxLevel
	inc a
	ld d, a
	callfar CalcExperience
	ld hl, wLoadedMonExp + 2
	ldh a, [hExperience + 2]
	sub [hl]
	ld [hld], a
	ldh a, [hExperience + 1]
	sbc [hl]
	ld [hld], a
	ldh a, [hExperience]
	sbc [hl]
	ld [hld], a
	ret
.atMaxLevel
	ld hl, wLoadedMonExp
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

StatusScreenExpText:
	db   "EXP POINTS"
	next "LEVEL UP@"

StatusScreen_ClearName:
	ld bc, 10
	ld a, " "
	jp FillMemory

StatusScreen_PrintPP:
; print PP or -- c times, going down two rows each time
	ld [hli], a
	ld [hld], a
	add hl, de
	dec c
	jr nz, StatusScreen_PrintPP
	ret

; DV parsing from shin pokered
;joenote - parse DV scores
DVParse:
	push hl
	push bc
	ld hl, wDVCalcVar2
	ld b, $00

	ld a, [wLoadedMonDVs]	;get attack dv
	swap a
	and $0F
	ld [hl], a
	inc hl
	and $01
	sla a
	sla a
	sla a
	or b
	ld b, a
	
	
	ld a, [wLoadedMonDVs]	;get defense dv
	and $0F
	ld [hl], a
	inc hl
	and $01
	sla a
	sla a
	or b
	ld b, a
	
	ld a, [wLoadedMonDVs + 1]	;get speed dv
	swap a
	and $0F
	ld [hl], a
	inc hl
	and $01
	sla a
	or b
	ld b, a
	
	ld a, [wLoadedMonDVs + 1]	;get special dv
	and $0F
	ld [hl], a
	inc hl
	and $01
	or b
	ld b, a

	ld [hl], b	;load hp dv
	
	pop bc
	pop hl
	ret

;;;;;;;;;; PureRGBnote: ADDED: code that allows immediately backing out of the status menu with B from all status menus

StatusScreenOriginal:
	ldh a, [hTileAnimations]
	push af
	call StatusScreen
	ld b, A_BUTTON | B_BUTTON
	call PokedexStatusWaitForButtonPressLoop
	bit BIT_B_BUTTON, a
	jr nz, ExitStatusScreen
	call StatusScreen2
	ld b, A_BUTTON | B_BUTTON
	call PokedexStatusWaitForButtonPressLoop
ExitStatusScreen:
	pop af
	ldh [hTileAnimations], a
	ld hl, wStatusFlags2
	res 1, [hl]
	ld a, $77
	ldh [rNR50], a
	call GBPalWhiteOut
	jp ClearScreen

;;;;;;;;;; PureRGBnote: ADDED: code that allows going up and down on the dpad
;;;;;;;;;; to next and previous party pokemon while in battle or in the start POKEMON menu.

StatusScreenLoop:
	ldh a, [hTileAnimations]
	push af
.displayNextMon
	call StatusScreen
	call PokemonStatusWaitForButtonPress
	bit BIT_D_UP, a
	jr nz, .prevMon
	bit BIT_D_DOWN, a
	jr nz, .nextMon
	bit BIT_B_BUTTON, a
	jr nz, .exitStatus
	call StatusScreen2
	call PokemonStatusWaitForButtonPress
	bit BIT_D_UP, a
	jr nz, .prevMon
	bit BIT_D_DOWN, a
	jr nz, .nextMon
.exitStatus
	jp ExitStatusScreen
.nextMon
	ld hl, wWhichPokemon
	inc [hl]
	ld hl, wPartyAndBillsPCSavedMenuItem
	inc [hl]
	jr .displayNextMon
.prevMon
	ld hl, wWhichPokemon
	dec [hl]
	ld hl, wPartyAndBillsPCSavedMenuItem
	dec [hl]
	jr .displayNextMon

PokemonStatusWaitForButtonPress:
.decideButtons
	ld a, A_BUTTON | B_BUTTON
	ld b, a
	ld a, [wWhichPokemon]
	and a
	jr z, .checkRight
	ld a, b
	or D_UP
	ld b, a
.checkRight
	ld a, [wPartyCount]
	dec a
	ld c, a
	ld a, [wWhichPokemon]
	cp c
	jr z, PokedexStatusWaitForButtonPressLoop
	ld a, b
	or D_DOWN
	ld b, a
PokedexStatusWaitForButtonPressLoop:
.waitForButtonPress
	push bc
	call JoypadLowSensitivity
	pop bc
	ldh a, [hJoy5]
	and b
	jr z, .waitForButtonPress
	ret

;;;;;;;;;;