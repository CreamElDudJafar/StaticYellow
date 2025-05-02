ShowPokedexMenu:
	call GBPalWhiteOut
	call ClearScreen
	call UpdateSprites
	ld a, [wListScrollOffset]
	push af
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld [wLastMenuItem], a
	inc a
	ld [wPokedexNum], a
	ldh [hJoy7], a
.setUpGraphics
	callfar LoadPokedexTilePatterns
	;;;;;;;;;;; PureRGBnote: ADDED: load these new button prompt graphics into VRAM
	ld de, PokedexPromptGraphics
	ld hl, vChars1 tile $40
	lb bc, BANK(PokedexPromptGraphics), (PokedexPromptGraphicsEnd - PokedexPromptGraphics) / $10
	call CopyVideoData
;;;;;;;;;;
.loop
	farcall SendPokeballPal
.doPokemonListMenu
	ld hl, wTopMenuItemY
	ld a, 3
	ld [hli], a ; top menu item Y
	xor a
	ld [hli], a ; top menu item X
	inc a
	ld [wMenuWatchMovingOutOfBounds], a
	inc hl
	inc hl
	ld a, 6
	ld [hli], a ; max menu item ID
	ld [hl], D_LEFT | D_RIGHT | B_BUTTON | A_BUTTON | SELECT | START  
	call HandlePokedexListMenu
	jr c, .goToSideMenu ; if the player chose a pokemon from the list
	cp 1
	jr z, .selectPressed
	cp 2
	jr z, .startPressed
.exitPokedex
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ldh [hJoy7], a
	ld [wUnusedOverrideSimulatedJoypadStatesIndex], a
	ld [wOverrideSimulatedJoypadStatesMask], a
	pop af
	ld [wListScrollOffset], a
	call GBPalWhiteOutWithDelay3
	call RunDefaultPaletteCommand
.exitPokedex2
	jp ReloadMapData

.goToSideMenu
	call HandlePokedexSideMenu
	dec b
	jr z, .exitPokedex ; if the player chose Quit
	dec b
	jr z, .doPokemonListMenu ; if pokemon not seen or player pressed B button
	dec b
	jr z, .loop
	jp .setUpGraphics ; if pokemon data or area was shown
.selectPressed
	pop af
	ld [wListScrollOffset], a
	callfar DisplayTownMap
	jr .exitPokedex2
.startPressed
	pop af
	ld [wListScrollOffset], a
	jp ShowMovedexMenu

; handles the menu on the lower right in the pokedex screen
; OUTPUT:
; b = reason for exiting menu
; 00: showed pokemon data or area
; 01: the player chose Quit
; 02: the pokemon has not been seen yet or the player pressed the B button
HandlePokedexSideMenu:
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	push af
	ld b, a
	ld a, [wLastMenuItem]
	push af
	ld a, [wListScrollOffset]
	push af
	add b
	inc a
	ld [wPokedexNum], a
;	ld a, [wPokedexNum]
	push af
	ld a, [wDexMaxSeenMon]
	push af ; this doesn't need to be preserved
	ld hl, wPokedexSeen
	call IsPokemonBitSet
	ld b, 2
	jr z, .exitSideMenu
	call PokedexToIndex
	ld hl, wTopMenuItemY
	ld a, 8
	ld [hli], a ; top menu item Y
	ld a, 15
	ld [hli], a ; top menu item X
	xor a
	ld [hli], a ; current menu item ID
	inc hl
	ld a, 4
	ld [hli], a ; max menu item ID
	ld a, A_BUTTON | B_BUTTON
	ld [hli], a ; menu watched keys (A button and B button)
	xor a
	ld [hli], a ; old menu item ID
	ld [wMenuWatchMovingOutOfBounds], a
;	ldh [hJoy7], a
.handleMenuInput
	call HandleMenuInput
	bit BIT_B_BUTTON, a
	ld b, 2
	jr nz, .buttonBPressed
	ld a, [wCurrentMenuItem]
	and a
	jr z, .choseData
	dec a
	jr z, .choseStat
	dec a
	jr z, .choseMove
	dec a
	jr z, .choseArea
.choseQuit
	dec a
	jr z, .choseCry
.exitSideMenu
	pop af
	ld [wDexMaxSeenMon], a
	pop af
	ld [wPokedexNum], a
	pop af
	ld [wListScrollOffset], a
	pop af
	ld [wLastMenuItem], a
	pop af
	ld [wCurrentMenuItem], a
	ld a, $1
	ldh [hJoy7], a
	push bc
	hlcoord 0, 3
	ld de, 20
	lb bc, " ", 13
	call DrawTileLine ; cover up the menu cursor in the pokemon list
	pop bc
	ret

.buttonBPressed
	push bc
	hlcoord 15, 8
	ld de, 20
	lb bc, " ", 9
	call DrawTileLine ; cover up the menu cursor in the side menu
	pop bc
	jr .exitSideMenu

.choseData
	xor a
	ld [wMoveListCounter], a
	ld [wPokedexModeSelect], a
	call ShowPokedexDataInternal
	ld b, 0
	jr .exitSideMenu

.choseStat
	ld a, 2
	ld [wPokedexModeSelect], a
	ld a, 0
	ld [wMoveListCounter], a
	call ShowPokedexDataInternal
	ld b, 0
	jr .exitSideMenu

.choseMove
	ld a, 1
	ld [wPokedexModeSelect], a
	ld [wMoveListCounter], a
	call ShowPokedexDataInternal
	ld b, 0
	jr .exitSideMenu
	
.choseArea
	predef LoadTownMap_Nest ; display pokemon areas
	ld b, 0
	jr .exitSideMenu

.choseCry
	ld a, [wPokedexNum]
	call GetCryData
	rst _PlaySound
	jp .handleMenuInput

; handles the list of pokemon on the left of the pokedex screen
; sets carry flag if player presses A, unsets carry flag if player presses B
HandlePokedexListMenu:
	call Pokedex_DrawInterface
.loop
	call Pokedex_PlacePokemonList
	call GBPalNormal
	call HandleMenuInput
;;;;;;;;;; PureRGBnote: ADDED: track the SELECT button in order to trigger town map when able
	bit BIT_START, a
	jp nz, .startPressed
;;;;;;;;;;
;;;;;;;;;; PureRGBnote: ADDED: track the SELECT button in order to trigger town map when able
	bit BIT_SELECT, a
	jp nz, .selectPressed
;;;;;;;;;;
	bit BIT_B_BUTTON, a ; was the B button pressed?
	jp nz, .buttonBPressed
	bit BIT_A_BUTTON, a ; was the A button pressed?
	jp nz, .buttonAPressed
.checkIfUpPressed
	bit BIT_D_UP, a ; was Up pressed?
	jr z, .checkIfDownPressed
.upPressed ; scroll up one row
	ld a, [wListScrollOffset]
	and a
	jp z, .loop
	dec a
	ld [wListScrollOffset], a
	jp .loop

.checkIfDownPressed
	bit BIT_D_DOWN, a ; was Down pressed?
	jr z, .checkIfRightPressed
.downPressed ; scroll down one row
	ld a, [wDexMaxSeenMon]
	cp 7
	jp c, .loop ; can't if the list is shorter than 7
	sub 7
	ld b, a
	ld a, [wListScrollOffset]
	cp b
	jp z, .loop
	inc a
	ld [wListScrollOffset], a
	jp .loop

.checkIfRightPressed
	bit BIT_D_RIGHT, a ; was Right pressed?
	jr z, .checkIfLeftPressed
.rightPressed ; scroll down 7 rows
	ld a, [wDexMaxSeenMon]
	cp 7
	jp c, .loop ; can't if the list is shorter than 7
	sub 6
	ld b, a
	ld a, [wListScrollOffset]
	add 7
	ld [wListScrollOffset], a
	cp b
	jp c, .loop
	dec b
	ld a, b
	ld [wListScrollOffset], a
	jp .loop

.checkIfLeftPressed ; scroll up 7 rows
	bit BIT_D_LEFT, a ; was Left pressed?
	jr z, .buttonAPressed
.leftPressed
	ld a, [wListScrollOffset]
	sub 7
	ld [wListScrollOffset], a
	jp nc, .loop
	xor a
	ld [wListScrollOffset], a
	jp .loop

.buttonAPressed
	scf
	ld a, 0
	ret

.buttonBPressed
	and a
	ld a, 0
	ret
;;;;;;;;;; PureRGBnote: CHANGED: SELECT button will open the town map while in the pokedex. You need the town map from rival's sister to do this.
;;;;;;;;;;                       Town map doesn't take up space in the bag due to this modification.
.selectPressed
	CheckEvent EVENT_GOT_TOWN_MAP
	jp z, .loop
	ld a, SFX_SWITCH
	rst _PlaySound
	ld a, 1
	and a
	ret
;;;;;;;;; PureRGBnote: CHANGED: START button will open new MoveDex.
.startPressed
	CheckEvent EVENT_GOT_MOVEDEX
	jp z, .loop
	ld a, SFX_SWITCH
	rst _PlaySound
	ld a, 2
	and a
	ret
;;;;;;;;;;


Pokedex_DrawInterface:
	xor a
	ldh [hAutoBGTransferEnabled], a
; draw the horizontal line separating the seen and owned amounts from the menu
;;;;;;;;;;; PureRGBnote: ADDED: If we got the town map, draw the "SELECT: MAP" prompt at the very bottom
	CheckEvent EVENT_GOT_TOWN_MAP
	jr z, .movedexPrompt
	hlcoord 1, 17
	ld a, $C0 ; tile in VRAM that this prompt starts at, it's 5 tiles horizontally across
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
.movedexPrompt
	hlcoord 7, 17
	CheckEvent EVENT_GOT_MOVEDEX
	jr z, .noSelectPrompt
	ld a, $C5
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hl], a
.noSelectPrompt
	hlcoord 15, 6
	ld a, "─"
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	hlcoord 14, 0
	ld [hl], $71 ; vertical line tile
	hlcoord 14, 1
	call DrawPokedexVerticalLine
	hlcoord 14, 9
	call DrawPokedexVerticalLine
	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen
	call CountSetBits
	ld de, wNumSetBits
	hlcoord 16, 2
	lb bc, 1, 3
	call PrintNumber ; print number of seen pokemon
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld de, wNumSetBits
	hlcoord 16, 5
	lb bc, 1, 3
	call PrintNumber ; print number of owned pokemon
	hlcoord 16, 1
	ld de, PokedexSeenText
	call PlaceString
	hlcoord 16, 4
	ld de, PokedexOwnText
	call PlaceString
	hlcoord 1, 1
	ld de, PokedexContentsText
	call PlaceString
	hlcoord 16, 8
	ld de, PokedexMenuItemsText
	call PlaceString
; find the highest pokedex number among the pokemon the player has seen
	ld hl, wPokedexSeenEnd - 1
	ld b, (wPokedexSeenEnd - wPokedexSeen) * 8 + 1
.maxSeenPokemonLoop
	ld a, [hld]
	ld c, 8
.maxSeenPokemonInnerLoop
	dec b
	sla a
	jr c, .storeMaxSeenPokemon
	dec c
	jr nz, .maxSeenPokemonInnerLoop
	jr .maxSeenPokemonLoop

.storeMaxSeenPokemon
	ld a, b
	ld [wDexMaxSeenMon], a
	ret

DrawPokedexVerticalLine:
	ld c, 9 ; height of line
	ld de, SCREEN_WIDTH ; width of screen
	ld a, $71 ; vertical line tile
.loop
	ld [hl], a
	add hl, de
	xor 1 ; toggle between vertical line tile and box tile
	dec c
	jr nz, .loop
	ret

PokedexSeenText:
	db "SEEN@"

PokedexOwnText:
	db "OWN@"

PokedexContentsText:
	db "CONTENTS@"

PokedexMenuItemsText:
	db   "DATA"
	next "STAT"
	next "MOVE"
	next "AREA"
	next "CRY@"

Pokedex_PlacePokemonList:
	xor a
	ldh [hAutoBGTransferEnabled], a
	hlcoord 4, 2
	lb bc, 14, 10
	call ClearScreenArea
	hlcoord 1, 3
	ld a, [wListScrollOffset]
	ld [wPokedexNum], a
	ld d, 7
	ld a, [wDexMaxSeenMon]
	cp 7
	jr nc, .printPokemonLoop
	ld d, a
	dec a
	ld [wMaxMenuItem], a
; loop to print pokemon pokedex numbers and names
; if the player has owned the pokemon, it puts a pokeball beside the name
.printPokemonLoop
	ld a, [wPokedexNum]
	inc a
	ld [wPokedexNum], a
	push af
	push de
	push hl
	ld de, -SCREEN_WIDTH
	add hl, de
	ld de, wPokedexNum
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber
	ld de, SCREEN_WIDTH
	add hl, de
	dec hl
	push hl
	ld hl, wPokedexOwned
	call IsPokemonBitSet
	pop hl
	ld a, " "
	jr z, .writeTile
	ld a, $72 ; pokeball tile
.writeTile
	ld [hl], a ; put a pokeball next to pokemon that the player has owned
	push hl
	ld hl, wPokedexSeen
	call IsPokemonBitSet
	jr nz, .getPokemonName ; if the player has seen the pokemon
	ld de, .dashedLine ; print a dashed line in place of the name if the player hasn't seen the pokemon
	jr .skipGettingName
.dashedLine ; for unseen pokemon in the list
	db "----------@"
.getPokemonName
	call PokedexToIndex
	call GetMonName
.skipGettingName
	pop hl
	inc hl
	call PlaceString
	pop hl
	ld bc, 2 * SCREEN_WIDTH
	add hl, bc
	pop de
	pop af
	ld [wPokedexNum], a
	dec d
	jr nz, .printPokemonLoop
	ld a, 01
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	ret

; tests if a pokemon's bit is set in the seen or owned pokemon bit fields
; INPUT:
; [wPokedexNum] = pokedex number
; hl = address of bit field
IsPokemonBitSet:
	ld a, [wPokedexNum]
	dec a
	ld c, a
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	and a
	ret

; function to display pokedex data from outside the pokedex
ShowPokedexData:
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	callfar LoadPokedexTilePatterns ; load pokedex tiles

; function to display pokedex data from inside the pokedex
ShowPokedexDataInternal:
	ld hl, wStatusFlags2
	set BIT_NO_AUDIO_FADE_OUT, [hl]
	ld a, $33 ; 3/7 volume
	ldh [rNR50], a
	ldh a, [hTileAnimations]
	push af
	xor a
	ldh [hTileAnimations], a
	call GBPalWhiteOut ; zero all palettes
	ld a, [wPokedexNum]
	ld [wCurPartySpecies], a
	push af
	ld b, SET_PAL_POKEDEX
	call RunPaletteCommand
	ld a, [wPokedexModeSelect] ; using this as a temp variable
	cp 1
	jr z, .PrintMoves
	cp 2
	jr z, .PrintStats
.PrintDescription
	pop af
	ld [wPokedexNum], a
	call DrawDexEntryOnScreen
	jp z, .displaySeenBottomInfo
	call c, Pokedex_PrintFlavorTextAtRow11
	jr .waitForButtonPress
.PrintMoves
	pop af
	ld [wPokedexNum], a
	call DrawDexEntryOnScreen
	jp z, .displaySeenBottomInfo
	call c, Pokedex_PrintMovesText
	jr .waitForButtonPress
.PrintStats
	pop af
	ld [wPokedexNum], a
	call DrawDexEntryOnScreen
	jp z, .displaySeenBottomInfo
	call c, Pokedex_PrintStatsText
.waitForButtonPress
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	and A_BUTTON | B_BUTTON
	jr z, .waitForButtonPress
	pop af
	ldh [hTileAnimations], a
	call GBPalWhiteOut
	call ClearScreen
	call RunDefaultPaletteCommand
	call LoadTextBoxTilePatterns
	call GBPalNormal
	ld hl, wStatusFlags2
	res BIT_NO_AUDIO_FADE_OUT, [hl]
	ld a, $77 ; max volume
	ldh [rNR50], a
	ret
.displaySeenBottomInfo
	call PrintMonTypes ; PureRGBnote: ADDED: for pokemon you have seen but not caught it displays just their types on the bottom
	jr .waitForButtonPress

HeightWeightText:
	db   "HT  ?′??″"
	next "WT   ???lb@"

; XXX does anything point to this?
PokeText:
	db "#@"

; horizontal line that divides the pokedex text description from the rest of the data
PokedexDataDividerLine:
	db $68, $69, $6B, $69, $6B, $69, $6B, $69, $6B, $6B
	db $6B, $6B, $69, $6B, $69, $6B, $69, $6B, $69, $6A
	db "@"

DrawDexEntryOnScreen:
	call ClearScreen

	hlcoord 0, 0
	ld de, 1
	lb bc, $64, SCREEN_WIDTH
	call DrawTileLine ; draw top border

	hlcoord 0, 17
	ld b, $6f
	call DrawTileLine ; draw bottom border

	hlcoord 0, 1
	ld de, 20
	lb bc, $66, $10
	call DrawTileLine ; draw left border

	hlcoord 19, 1
	ld b, $67
	call DrawTileLine ; draw right border

	ld a, $63 ; upper left corner tile
	ldcoord_a 0, 0
	ld a, $65 ; upper right corner tile
	ldcoord_a 19, 0
	ld a, $6c ; lower left corner tile
	ldcoord_a 0, 17
	ld a, $6e ; lower right corner tile
	ldcoord_a 19, 17

	hlcoord 0, 9
	ld de, PokedexDataDividerLine
	call PlaceString ; draw horizontal divider line

	hlcoord 9, 6
	ld de, HeightWeightText
	call PlaceString

	call GetMonName
	hlcoord 9, 2
	call PlaceString

	ld hl, PokedexEntryPointers
	ld a, [wPokedexNum]
	dec a
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl] ; de = address of pokedex entry

	hlcoord 9, 4
	call PlaceString ; print species name

	ld h, b
	ld l, c
	push de
	ld a, [wPokedexNum]
	push af
	call IndexToPokedex

	hlcoord 2, 8
	ld a, "№"
	ld [hli], a
	ld a, "."
	ld [hli], a
	ld de, wPokedexNum
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber ; print pokedex number

	ld hl, wPokedexOwned
	call IsPokemonBitSet
	pop af
	ld [wPokedexNum], a
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	pop de

	push af
	push bc
	push de
	push hl

	call Delay3
	call GBPalNormal
	call GetMonHeader ; load pokemon picture location
	hlcoord 1, 1
	call LoadFlippedFrontSpriteByMonIndex ; draw pokemon picture
	ld a, [wCurPartySpecies]
	call PlayCry

	pop hl
	pop de
	pop bc
	pop af

	ld a, c
	and a

	ret z ; if the pokemon has not been owned, don't print the height, weight, or description

	inc de ; de = address of feet (height)
	ld a, [de] ; reads feet, but a is overwritten without being used
	hlcoord 12, 6
	lb bc, 1, 2
	call PrintNumber ; print feet (height)
	ld a, "′"
	ld [hl], a
	inc de
	inc de ; de = address of inches (height)
	hlcoord 15, 6
	lb bc, LEADING_ZEROES | 1, 2
	call PrintNumber ; print inches (height)
	ld a, "″"
	ld [hl], a
; now print the weight (note that weight is stored in tenths of pounds internally)
	inc de
	inc de
	inc de ; de = address of upper byte of weight
	push de
; put weight in big-endian order at hDexWeight
	ld hl, hDexWeight
	ld a, [hl] ; save existing value of [hDexWeight]
	push af
	ld a, [de] ; a = upper byte of weight
	ld [hli], a ; store upper byte of weight in [hDexWeight]
	ld a, [hl] ; save existing value of [hDexWeight + 1]
	push af
	dec de
	ld a, [de] ; a = lower byte of weight
	ld [hl], a ; store lower byte of weight in [hDexWeight + 1]
	ld de, hDexWeight
	hlcoord 11, 8
	lb bc, 2, 5 ; 2 bytes, 5 digits
	call PrintNumber ; print weight
	hlcoord 14, 8
	ldh a, [hDexWeight + 1]
	sub 10
	ldh a, [hDexWeight]
	sbc 0
	jr nc, .next
	ld [hl], "0" ; if the weight is less than 10, put a 0 before the decimal point
.next
	inc hl
	ld a, [hli]
	ld [hld], a ; make space for the decimal point by moving the last digit forward one tile
	ld [hl], "." ; decimal point tile
	pop af
	ldh [hDexWeight + 1], a ; restore original value of [hDexWeight + 1]
	pop af
	ldh [hDexWeight], a ; restore original value of [hDexWeight]
	pop hl
	inc hl ; hl = address of pokedex description text
	scf
	ret

Pokedex_PrintFlavorTextAtRow11:
	bccoord 1, 11
Pokedex_PrintFlavorTextAtBC:
	ld a, %10
	ldh [hClearLetterPrintingDelayFlags], a
	call TextCommandProcessor ; print pokedex description text
	xor a
	ldh [hClearLetterPrintingDelayFlags], a
	ret

PrintMonTypes:
	hlcoord 1, 11
	ld de, DexType1Text
	call PlaceString
	hlcoord 2, 12
	predef PrintMonType
	ld a, [wMonHType1]
	ld b, a
	ld a, [wMonHType2]
	cp b
	jr z, .done ; don't print TYPE2/ if the pokemon has 1 type only.
	hlcoord 1, 13
	ld de, DexType2Text
	call PlaceString
.done
	ret

	
Pokedex_PrintStatsText:
;;;;;;;;;; PureRGBnote: ADDED: pokedex will display the pokemon's types and their base stats on a new third page.
	CheckEvent EVENT_GOT_POKEDEX
	jp z, .clearLetterPrintingFlags ; don't display this new third page if we're showing the starters before getting the pokedex.
	hlcoord 1, 10
	lb bc, 7, 18
	call ClearScreenArea
	call PrintMonTypes
	; print mon base stats
	hlcoord 9, 10
	ld de, BaseStatsText
	call PlaceString
	hlcoord 12, 11
	ld de, HPText
	call PlaceString
	ld de, wMonHBaseHP
	hlcoord 15, 11
	lb bc, 1, 3
	call PrintNumber 
	hlcoord 11, 12
	ld de, AtkText
	call PlaceString
	ld de, wMonHBaseAttack
	hlcoord 15, 12
	lb bc, 1, 3
	call PrintNumber 
	hlcoord 11, 13
	ld de, DefText
	call PlaceString
	ld de, wMonHBaseDefense
	hlcoord 15, 13
	lb bc, 1, 3
	call PrintNumber
	hlcoord 11, 14
	ld de, SpdText
	call PlaceString
	ld de, wMonHBaseSpeed
	hlcoord 15, 14
	lb bc, 1, 3
	call PrintNumber
	hlcoord 11, 15
	ld de, SpcText
	call PlaceString
	ld de, wMonHBaseSpecial
	hlcoord 15, 15
	lb bc, 1, 3
	call PrintNumber 
	hlcoord 9, 16
	ld de, TotalText
	call PlaceString
	; calculate the base stat total to print it
	ld b, 0
	ld a, [wMonHBaseHP]
	ld hl, 0
	ld c, a
	add hl, bc
	ld a, [wMonHBaseAttack]
	ld c, a
	add hl, bc
	ld a, [wMonHBaseDefense]
	ld c, a
	add hl, bc
	ld a, [wMonHBaseSpeed]
	ld c, a
	add hl, bc
	ld a, [wMonHBaseSpecial]
	ld c, a
	add hl, bc
	ld a, h
	ld [wSum], a
	ld a, l
	ld [wSum+1], a
	ld de, wSum
	hlcoord 15, 16
	lb bc, 2, 3
	call PrintNumber
; print evolution data
	ld hl, DexPromptText
	call TextCommandProcessor
	hlcoord 1, 10
	lb bc, 7, 18
	call ClearScreenArea
	hlcoord 5, 10
	ld de, EvolutionsText
	call PlaceString
; load pokemon data
	ld a, [wPokedexNum]
	ld [wWhichPokemon], a
	ld [wCurPartySpecies], a
	farcall PrepareEvolutionData
	ld de, wPokedexDataBuffer
	ld a, 1
	ldh [hEvoCounter], a
.loopEvolutionData
	ld a, [wMoveListCounter] 
	ld c, a ; loop counter
	cp 0
	jp z, .clearLetterPrintingFlags
	ld a, [de]
	cp EVOLVE_LEVEL
	jr z, .printLevelText
	cp EVOLVE_TRADE
	jr z, .printTradeText
	cp EVOLVE_ITEM
	jr z, .printItemText
.printLevelText
	push de
	push bc
	ld de, EvolveLevelText
	hlcoord 1, 11
	ldh a, [hEvoCounter]
	ld bc, SCREEN_WIDTH ; * 3
	call AddNTimes
	call PlaceString
	pop bc
	pop de
	jr .itemIdByte
.printTradeText
	push de
	push bc
	ld de, EvolveTradeText
	hlcoord 1, 11
	ldh a, [hEvoCounter]
	ld bc, SCREEN_WIDTH ; * 3
	call AddNTimes
	call PlaceString
	pop bc
	pop de
	jr .itemIdByte
.printItemText
	push de
	push bc
	ld de, EvolveItemText
	hlcoord 1, 11
	ldh a, [hEvoCounter]
	ld bc, SCREEN_WIDTH ; * 3
	call AddNTimes
	call PlaceString
	pop bc
	pop de
	jr .itemIdByte
.itemIdByte
	inc de
	ld a, [de]
	cp $FF
	jr z, .levelByte
	push de
	push bc
	ld [wPokedexNum], a 
	call GetItemName
	hlcoord 2, 11	
	ldh a, [hEvoCounter]
	ld bc, SCREEN_WIDTH ; * 3
	call AddNTimes
	call PlaceString
	pop bc
	pop de
	ld a, [wWhichPokemon]
	ld [wPokedexNum], a
	jr .levelByte
.clearBullet
	push de
	push bc
	hlcoord 1, 11
	ldh a, [hEvoCounter]
	ld bc, SCREEN_WIDTH ; * 3
	call AddNTimes
	ld [hl], " "
	pop bc
	pop de
.levelByte
	inc de
	ld a, [de]
	cp 1
	jr z, .targetByte
	
	push de
	push bc
	hlcoord 16, 11
	ldh a, [hEvoCounter]
	ld bc, SCREEN_WIDTH ; * 3
	call AddNTimes
	lb bc, LEFT_ALIGN | 1, 3
	call PrintNumber
	pop bc
	pop de

	push de
	push bc
	ld de, EvolveLVLText
	hlcoord 15, 11
	ldh a, [hEvoCounter]
	ld bc, SCREEN_WIDTH ; * 3
	call AddNTimes
	call PlaceString
	pop bc
	pop de

	jr .targetByte
.targetByte
	inc de
	dec c
	ld a, c
	ld [wMoveListCounter], a
	ld hl, hEvoCounter
	inc [hl]
	inc de
	jp .loopEvolutionData
.clearLetterPrintingFlags
;;;;;;;;;;
	xor a
	ldh [hClearLetterPrintingDelayFlags], a
	ret

EvolveLevelText:
	db "*LEVEL-UP@"

EvolveTradeText:
	db "*TRADE@"

EvolveItemText:
	db "*@"

EvolveLVLText:
	db "<LVL>@"

Pokedex_PrepareDexEntryForPrinting: ; not used anympre
	hlcoord 0, 0
	ld de, SCREEN_WIDTH
	lb bc, $66, $d
	call DrawTileLine
	hlcoord 19, 0
	ld b, $67
	call DrawTileLine
	hlcoord 0, 13
	ld de, $1
	lb bc, $6f, SCREEN_WIDTH
	call DrawTileLine
	ld a, $6c
	ldcoord_a 0, 13
	ld a, $6e
	ldcoord_a 19, 13
	ld a, [wPrinterPokedexEntryTextPointer]
	ld l, a
	ld a, [wPrinterPokedexEntryTextPointer + 1]
	ld h, a
	bccoord 1, 1
	ldh a, [hUILayoutFlags]
	set 3, a
	ldh [hUILayoutFlags], a
	call Pokedex_PrintFlavorTextAtBC
	ldh a, [hUILayoutFlags]
	res 3, a
	ldh [hUILayoutFlags], a
	ret

Pokedex_PrintMovesText:
	ld a, [wPokedexNum]
	ld [wWhichPokemon], a
	ld [wCurPartySpecies], a
	farcall PrepareLevelUpMoveList
	ld de, wMoveBuffer
	ld b, 0 ; counter
	ld a, [wMoveListCounter]
	cp 0
	jp z, .done
.PrintLevelUpMovesLoop
	push de
	push bc
	ld de, LevelUpMovesText
	hlcoord 1, 10
	call PlaceString
	xor a
	ldh [hMoveCounter], a
	pop bc
	pop de
.firstLevelUpLine
	call PrintLevelUpMoveLine
	inc b
	ld a, [wMoveListCounter]
	cp b
	jr z, .done
.secondLevelUpLine
	inc de
	call PrintLevelUpMoveLine
	inc b
	ld a, [wMoveListCounter]
	cp b
	jr z, .done
.thirdLevelUpLine
	inc de
	call PrintLevelUpMoveLine
	inc b
	ld a, [wMoveListCounter]
	cp b
	jr z, .done
.fourthLevelUpLine
	inc de
	call PrintLevelUpMoveLine
	inc b
	ld a, [wMoveListCounter]
	cp b
	jr z, .done
.fifthLevelUpLine
	inc de
	call PrintLevelUpMoveLine
	inc b
	ld a, [wMoveListCounter]
	cp b
	jr z, .done
	inc de
	push de
	push bc
	ld hl, DexPromptText
	call TextCommandProcessor
	hlcoord 1, 10
	lb bc, 7, 18
	call ClearScreenArea
	pop bc
	pop de
	jp .PrintLevelUpMovesLoop
.done
	ld hl, DexPromptText
	call TextCommandProcessor
	hlcoord 1, 10
	lb bc, 7, 18
	call ClearScreenArea
	; clear move buffer
	ld hl, wMoveBuffer
	ld bc, 164
	call FillMemory
.tmMoveset
	; print header and loading text
	push de
	ld de, TMHMMovesText
	hlcoord 1, 10
	call PlaceString
	ld de, LoadingText
	hlcoord 2, 12
	call PlaceString
	pop de
	; start fetching moves
	farcall GetTMMoves
	ld de, wMoveBuffer
	ld a, [de]
	push de
	hlcoord 1, 10
	lb bc, 7, 18
	call ClearScreenArea
	pop de
.PrintTMMovesLoop
	push de
	ld de, TMHMMovesText
	hlcoord 1, 10
	call PlaceString
	pop de
	xor a
	ldh [hMoveCounter], a
	ld a, [de]
	ld [wPokedexNum], a
.firstTMLine
	cp 0
	jp z, .done2
	call PrintTMHMMoveLine
	inc de
	ld a, [de]
	ld [wPokedexNum], a
.secondTMLine
	cp 0
	jp z, .done2
	call PrintTMHMMoveLine
	inc de
	ld a, [de]
	ld [wPokedexNum], a
.thirdTMLine
	cp 0
	jp z, .done2
	call PrintTMHMMoveLine
	inc de
	ld a, [de]
	ld [wPokedexNum], a
.fourthTMLine
	cp 0
	jp z, .done2
	call PrintTMHMMoveLine
	inc de
	ld a, [de]
	ld [wPokedexNum], a
.fifthTMLine
	cp 0
	jp z, .done2
	call PrintTMHMMoveLine
.tmsDone
	inc de
	ld a, [de]
	cp 0
	jr z, .done2
	; wait for button press
	push de
	ld hl, DexPromptText
	call TextCommandProcessor
	hlcoord 1, 10
	lb bc, 7, 18
	call ClearScreenArea
	pop de
	jp .PrintTMMovesLoop
.done2
	ret

ClearMoveBuffer:
	xor a

PrintLevelUpMoveLine:
	push bc
	ld a, [de]
	cp 1
	jp z, .printStartingMove
	push de
	hlcoord 2, 12
	ldh a, [hMoveCounter]
	ld bc, SCREEN_WIDTH
	call AddNTimes
	lb bc, LEFT_ALIGN | 1, 3
	call PrintNumber ; print move level
	pop de
	hlcoord 1, 12
	ldh a, [hMoveCounter]
	ld bc, SCREEN_WIDTH
	call AddNTimes
	ld [hl], "<LVL>"
	jr .printMoveName
.printStartingMove
	push de
	ld de, StartingMoveText
	hlcoord 1, 12
	ld bc, SCREEN_WIDTH
	ldh a, [hMoveCounter]
	call AddNTimes
	call PlaceString
	pop de
.printMoveName
	inc de
	ld a, [de]
	push de
	ld [wPokedexNum], a
	call GetMoveName
	hlcoord 5, 12
	ldh a, [hMoveCounter]
	ld bc, SCREEN_WIDTH
	call AddNTimes
	call PlaceString
	pop de
	pop bc

	push hl
	ld hl, hMoveCounter
	inc [hl]
	pop hl
	ret

PrintTMHMMoveLine:
	; print TM/HM symbol
	push de
	push bc
	ld a, [wPokedexNum] ; tm number
	cp NUM_TMS + 1
	jr z, .gotHM
	jr nc, .gotHM
	ld de, TMSymbolText
	jr .printSymbol
.gotHM
	ld de, HMSymbolText
.printSymbol
	hlcoord 1, 12
	ldh a, [hMoveCounter]
	ld bc, SCREEN_WIDTH
	call AddNTimes
	call PlaceString
	pop bc
	pop de
	; print TM/HM number
	push bc
	hlcoord 3, 12
	ldh a, [hMoveCounter]
	ld bc, SCREEN_WIDTH
	call AddNTimes
	ld a, [wPokedexNum]
	cp NUM_TMS + 1
	jr z, .printHMNumber
	jr nc, .printHMNumber
.printTMNumber
	lb bc, LEADING_ZEROES | 1, 2
	call PrintNumber
	jr .donePrinting
.printHMNumber
	sub a, NUM_TMS
	ld [de], a
	lb bc, LEADING_ZEROES | 1, 2
	call PrintNumber
	add a, NUM_TMS
	ld [de], a
.donePrinting
	pop bc
	; print move name
	inc de
	inc de
	ld a, [de]
	push de
	push bc
	ld [wPokedexNum], a
	call GetMoveName
	hlcoord 6, 12
	ldh a, [hMoveCounter]
	ld bc, SCREEN_WIDTH
	call AddNTimes
	call PlaceString
	pop bc
	pop de

	push hl
	ld hl, hMoveCounter
	inc [hl]
	pop hl
	ret

LevelUpMovesText:
	db   "LEVEL-UP MOVES:@"

TMHMMovesText:
	db   "TM/HM MOVES:@"

TMSymbolText:
	db   "TM@"

HMSymbolText:
	db   "HM@"

LoadingText:
	db   "LOADING...@"

StartingMoveText:
	db   "---@"

DexPromptText:
	text_promptbutton
	text_end

DexType1Text:
	db "TYPE1/@"

DexType2Text:
	db "TYPE2/@"

BaseStatsText:
	db "BASE STATS@"

EvolutionsText:
	db "EVOLUTIONS@"

HPText:
	db "HP@"

AtkText:
	db "ATK@"

DefText:
	db "DEF@"

SpdText:
	db "SPD@"

SpcText:
	db "SPC@"

TotalText:
	db "TOTAL@"

; draws a line of tiles
; INPUT:
; b = tile ID
; c = number of tile ID's to write
; de = amount to destination address after each tile (1 for horizontal, 20 for vertical)
; hl = destination address
;DrawTileLine:
;	push bc
;	push de
;.loop
;	ld [hl], b
;	add hl, de
;	dec c
;	jr nz, .loop
;	pop de
;	pop bc
;	ret

INCLUDE "data/pokemon/dex_entries.asm"

PokedexToIndex:
	; converts the Pokédex number at [wPokedexNum] to an index
	push bc
	push hl
	ld a, [wPokedexNum]
	ld b, a
	ld c, 0
	ld hl, PokedexOrder

.loop ; go through the list until we find an entry with a matching dex number
	inc c
	ld a, [hli]
	cp b
	jr nz, .loop

	ld a, c
	ld [wPokedexNum], a
	pop hl
	pop bc
	ret

IndexToPokedex:
	; converts the index number at [wPokedexNum] to a Pokédex number
	push bc
	push hl
	ld a, [wPokedexNum]
	dec a
	ld hl, PokedexOrder
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wPokedexNum], a
	pop hl
	pop bc
	ret

INCLUDE "data/pokemon/dex_order.asm"
