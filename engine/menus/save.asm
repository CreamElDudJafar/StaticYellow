LoadSAV:
; if carry, write "the file data is destroyed"
	call ClearScreen
	call LoadFontTilePatterns
	call LoadTextBoxTilePatterns
	call LoadSAV0
	jr c, .badsum
	call LoadSAV1
	jr c, .badsum
	call LoadSAV2
	jr c, .badsum
	ld a, $2 ; good checksum
	jr .goodsum
.badsum
	ld hl, wStatusFlags5
	push hl
	set BIT_NO_TEXT_DELAY, [hl]
	ld hl, FileDataDestroyedText
	rst _PrintText
	ld c, 100
	rst _DelayFrames
	pop hl
	res BIT_NO_TEXT_DELAY, [hl]
	ld a, $1 ; bad checksum
.goodsum
	ld [wSaveFileStatus], a
	ret

FileDataDestroyedText:
	text_far _FileDataDestroyedText
	text_end

LoadSAV0:
	call EnableSRAM
	ld a, BANK("Save Data")
	ld [MBC1SRamBank], a
; This vc_hook does not have to be in any particular location.
; It is defined here because it refers to the same labels as the two lines below.
	vc_hook Unknown_save_limit
	ld hl, sGameData
	ld bc, sGameDataEnd - sGameData
	call SAVCheckSum
	ld c, a
	ld a, [sMainDataCheckSum]
	cp c
	jp z, .checkSumsMatched

; If the computed checksum didn't match the saved on, try again.
	ld hl, sGameData
	ld bc, sGameDataEnd - sGameData
	call SAVCheckSum
	ld c, a
	ld a, [sMainDataCheckSum]
	cp c
	jp nz, SAVBadCheckSum

.checkSumsMatched
	ld hl, sPlayerName
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	rst _CopyData
	ld hl, sMainData
	ld de, wMainDataStart
	ld bc, wMainDataEnd - wMainDataStart
	rst _CopyData
	ld hl, wCurMapTileset
	set BIT_NO_PREVIOUS_MAP, [hl]
	ld hl, sSpriteData
	ld de, wSpriteDataStart
	ld bc, wSpriteDataEnd - wSpriteDataStart
	rst _CopyData
	ld a, [sTileAnimations]
	ldh [hTileAnimations], a
	ld hl, sCurBoxData
	ld de, wBoxDataStart
	ld bc, wBoxDataEnd - wBoxDataStart
	rst _CopyData
	and a
	jp SAVGoodChecksum

LoadSAV1:
	call EnableSRAM
	ld a, BANK("Save Data")
	ld [MBC1SRamBank], a
	ld hl, sGameData
	ld bc, sGameDataEnd - sGameData
	call SAVCheckSum
	ld c, a
	ld a, [sMainDataCheckSum]
	cp c
	jr nz, SAVBadCheckSum
	ld hl, sCurBoxData
	ld de, wBoxDataStart
	ld bc, wBoxDataEnd - wBoxDataStart
	rst _CopyData
	and a
	jp SAVGoodChecksum

LoadSAV2:
	call EnableSRAM
	ld a, BANK("Save Data")
	ld [MBC1SRamBank], a
	ld hl, sGameData
	ld bc, sGameDataEnd - sGameData
	call SAVCheckSum
	ld c, a
	ld a, [sMainDataCheckSum]
	cp c
	jp nz, SAVBadCheckSum
	ld hl, sPartyData
	ld de, wPartyDataStart
	ld bc, wPartyDataEnd - wPartyDataStart
	rst _CopyData
	ld hl, sMainData
	ld de, wPokedexOwned
	ld bc, wPokedexSeenEnd - wPokedexOwned
	rst _CopyData
	and a
	jp SAVGoodChecksum

SAVBadCheckSum:
	scf

SAVGoodChecksum:
	call DisableSRAM
	ret

;LoadSAVIgnoreBadCheckSum:
; unused function that loads save data and ignores bad checksums
;	call LoadSAV0
;	call LoadSAV1
;	jp LoadSAV2

SaveSAV:
	farcall PrintSaveScreenText
	ld c, 10
	rst _DelayFrames
	ld hl, WouldYouLikeToSaveText
	call SaveSAVConfirm
	and a   ;|0 = Yes|1 = No|
	ret nz
	ld c, 10
	rst _DelayFrames
	ld a, [wSaveFileStatus]
	cp $1
	jr z, .save
	call SAVCheckRandomID
	jr z, .save
	ld hl, OlderFileWillBeErasedText
	call SaveSAVConfirm
	and a
	ret nz
.save
	call SaveSAVtoSRAM
	ld hl, SavingText
	rst _PrintText
	ld c, 128
	rst _DelayFrames
	ld hl, GameSavedText
	rst _PrintText
	ld c, 10
	rst _DelayFrames
	ld a, SFX_SAVE
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ld c, 10 ; Shorter time to save
	rst _DelayFrames
	ret

SaveSAVConfirm:
	rst _PrintText
	hlcoord 0, 7
	lb bc, 8, 1
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID ; yes/no menu
	ld a, [wCurrentMenuItem]
	ret

WouldYouLikeToSaveText:
	text_far _WouldYouLikeToSaveText
	text_end

SavingText:
	text_far _SavingText
	text_end

GameSavedText:
	text_far _GameSavedText
	text_end

OlderFileWillBeErasedText:
	text_far _OlderFileWillBeErasedText
	text_end

SaveSAVtoSRAM0:
	call EnableSRAM
	ld a, BANK("Save Data")
	ld [MBC1SRamBank], a
	ld hl, wPlayerName
	ld de, sPlayerName
	ld bc, NAME_LENGTH
	rst _CopyData
	ld hl, wMainDataStart
	ld de, sMainData
	ld bc, wMainDataEnd - wMainDataStart
	rst _CopyData
	ld hl, wSpriteDataStart
	ld de, sSpriteData
	ld bc, wSpriteDataEnd - wSpriteDataStart
	rst _CopyData
	ld hl, wBoxDataStart
	ld de, sCurBoxData
	ld bc, wBoxDataEnd - wBoxDataStart
	rst _CopyData
	ldh a, [hTileAnimations]
	ld [sTileAnimations], a
	ld hl, sGameData
	ld bc, sGameDataEnd - sGameData
	call SAVCheckSum
	ld [sMainDataCheckSum], a
	call DisableSRAM
	ret

SaveSAVtoSRAM1:
; stored pokémon
	call EnableSRAM
	ld a, BANK("Save Data")
	ld [MBC1SRamBank], a
	ld hl, wBoxDataStart
	ld de, sCurBoxData
	ld bc, wBoxDataEnd - wBoxDataStart
	rst _CopyData
	ld hl, sGameData
	ld bc, sGameDataEnd - sGameData
	call SAVCheckSum
	ld [sMainDataCheckSum], a
	call DisableSRAM
	ret

SaveSAVtoSRAM2:
	call EnableSRAM
	ld a, BANK("Save Data")
	ld [MBC1SRamBank], a
	ld hl, wPartyDataStart
	ld de, sPartyData
	ld bc, wPartyDataEnd - wPartyDataStart
	rst _CopyData
	ld hl, wPokedexOwned ; pokédex only
	ld de, sMainData
	ld bc, wPokedexSeenEnd - wPokedexOwned
	rst _CopyData
	ld hl, wPikachuHappiness
	ld de, sMainData + $179
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld hl, sGameData
	ld bc, sGameDataEnd - sGameData
	call SAVCheckSum
	ld [sMainDataCheckSum], a
	call DisableSRAM
	ret

SaveSAVtoSRAM::
	ld a, $2
	ld [wSaveFileStatus], a
	call SaveSAVtoSRAM0
	call SaveSAVtoSRAM1
	jp SaveSAVtoSRAM2

SAVCheckSum:
;Check Sum (result[1 byte] is complemented)
	ld d, 0
.loop
	ld a, [hli]
	add d
	ld d, a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ld a, d
	cpl
	ret

CalcIndividualBoxCheckSums:
	ld hl, sBox1 ; sBox7
	ld de, sBank2IndividualBoxChecksums ; sBank3IndividualBoxChecksums
	ld b, NUM_BOXES / 2
.loop
	push bc
	push de
	ld bc, wBoxDataEnd - wBoxDataStart
	call SAVCheckSum
	pop de
	ld [de], a
	inc de
	pop bc
	dec b
	jr nz, .loop
	ret

GetBoxSRAMLocation:
; in: a = box num
; out: b = box SRAM bank, hl = pointer to start of box
	ld hl, BoxSRAMPointerTable
	ld a, [wCurrentBoxNum]
	and $7f
	cp NUM_BOXES / 2
	ld b, 2
	jr c, .next
	inc b
	sub NUM_BOXES / 2
.next
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

BoxSRAMPointerTable:
	dw sBox1 ; sBox7
	dw sBox2 ; sBox8
	dw sBox3 ; sBox9
	dw sBox4 ; sBox10
	dw sBox5 ; sBox11
	dw sBox6 ; sBox12

ChangeBox::
	ld hl, WhenYouChangeBoxText
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ret nz ; return if No was chosen
	ld hl, wCurrentBoxNum
	bit BIT_HAS_CHANGED_BOXES, [hl] ; is it the first time player is changing the box?
	call z, EmptyAllSRAMBoxes ; if so, empty all boxes in SRAM
	call DisplayChangeBoxMenu
	call UpdateSprites
	ld hl, hUILayoutFlags
	set BIT_DOUBLE_SPACED_MENU, [hl]
	call HandleMenuInput
	ld hl, hUILayoutFlags
	res BIT_DOUBLE_SPACED_MENU, [hl]
	bit BIT_B_BUTTON, a
	ret nz
	ld a, $b6
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	call GetBoxSRAMLocation
	ld e, l
	ld d, h
	ld hl, wBoxDataStart
	call CopyBoxToOrFromSRAM ; copy old box from WRAM to SRAM
	ld a, [wCurrentMenuItem]
	set BIT_HAS_CHANGED_BOXES, a
	ld [wCurrentBoxNum], a
	call GetBoxSRAMLocation
	ld de, wBoxDataStart
	call CopyBoxToOrFromSRAM ; copy new box from SRAM to WRAM
	ld hl, wCurMapTextPtr
	ld de, wChangeBoxSavedMapTextPointer
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	call RestoreMapTextPointer
	call SaveSAVtoSRAM
	ld hl, wChangeBoxSavedMapTextPointer
	call SetMapTextPointer
	ret

WhenYouChangeBoxText:
	text_far _WhenYouChangeBoxText
	text_end

CopyBoxToOrFromSRAM:
; copy an entire box from hl to de with b as the SRAM bank
	push hl
	call EnableSRAM
	ld a, b
	ld [MBC1SRamBank], a
	ld bc, wBoxDataEnd - wBoxDataStart
	rst _CopyData
	pop hl

; mark the memory that the box was copied from as am empty box
	xor a
	ld [hli], a
	dec a
	ld [hl], a

	ld hl, sBox1 ; sBox7
	ld bc, sBank2AllBoxesChecksum - sBox1
	call SAVCheckSum
	ld [sBank2AllBoxesChecksum], a ; sBank3AllBoxesChecksum
	call CalcIndividualBoxCheckSums
	call DisableSRAM
	ret

DisplayChangeBoxMenu:
	xor a
	ldh [hAutoBGTransferEnabled], a
	ld a, A_BUTTON | B_BUTTON
	ld [wMenuWatchedKeys], a
	ld a, 11
	ld [wMaxMenuItem], a
	ld a, 1
	ld [wTopMenuItemY], a
	ld a, 7
	ld [wTopMenuItemX], a
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld a, [wCurrentBoxNum]
	and %01111111
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a	
;;;;;;;
	decoord 0, 0
	call DrawCurrentBoxPrompt
	jr nz, .printPrompt 
	call SendPokeballPal ;;;; Red Pokeball Color in Prompt
	ld hl, ChooseABoxText
.printPrompt
	rst _PrintText
	hlcoord 6, 0
	lb bc, 12, 12
	call TextBoxBorder
.addExtraBorder
	ld a, $C0 ; menu connector 1
	ldcoord_a 6, 0 
	ld a, $C1 ; menu connector 2
	ldcoord_a 19, 13 
	ld a, $C4 ; menu connector 5
	ldcoord_a 6, 4 
	ldcoord_a 6, 12
	ld de, 1
	lb bc, $C8, 3 ; start of FROM prompt
	hlcoord 1, 0
	call DrawTileLineIncrement
	lb bc, $CB, 2 ; start of TO prompt
	hlcoord 7, 0
	call DrawTileLineIncrement

	call GetMonCountsForAllBoxes

	hlcoord 8, 1
	ld de, wBoxMonCounts
	ld bc, SCREEN_WIDTH
	ld a, NUM_BOXES
.loop
	push af
	push hl
	push bc
	push de
	n_sub_a NUM_BOXES + 1
	push af
	ld de, BoxText
	call PlaceString 
	lb bc, 0, 3
	add hl, bc
	pop af
	ld de, wSum
	ld [de], a
	lb bc, 1, 2
	call PrintNumber
	pop de
	ld a, [de]
	and a ; is the box empty?
	jr z, .boxEmpty ; don't print anything beside it
	push af
	cp MONS_PER_BOX
	ld a, $78 ; pokeball tile
	jr nz, .placeBallTile
	ld a, $77 ; ball tile with X on top
.placeBallTile
	ld [hli], a ; place pokeball tile next to box name if box not empty
.placeBoxCount
	pop af
	push de
	ld de, wSum
	ld [de], a
	lb bc, 1, 2
	call PrintNumber
	ld de, BoxOutOf20
	call PlaceString
	pop de
.boxEmpty
	pop bc
	pop hl
	add hl, bc
	inc de
	pop af
	dec a
	jr nz, .loop
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	ret

ChooseABoxText:
	text_far _ChooseABoxText
	text_end

; draws a box that says info about the current box (used in pc and change box menus)
; input = de, top left coord of the prompt box
DrawCurrentBoxPrompt::
	ld h, d
	ld l, e
	push hl
	lb bc, 3, 5
	call TextBoxBorder
	pop hl
	inc_hl_ycoord
	inc hl
	ld de, BoxText
	call PlaceString
	inc_hl_ycoord
	push hl
	ld a, $76 ; "No" tile
	ld [hli], a
	ld a, "."
	ld [hli], a
	ld a, [wCurrentBoxNum]
	and $7f
	cp 9
	jr c, .singleDigitBoxNum
	sub 9
	ld [hl], "1"
	inc hl
	add NUMBER_CHAR_OFFSET
	jr .next
.singleDigitBoxNum
	add NUMBER_CHAR_OFFSET + 1 ; wCurrentBoxNum starts at 0 so we need to increment it by 1
.next
	ld [hli], a
	pop hl
	push hl
	lb de, 0, 4
	add hl, de
	ld a, [wBoxCount]
	push af
	and a
	jr z, .noBallTile
	cp 20
	ld a, $78 ; normal pokeball tile
	jr nz, .loadBallTile
	ld a, $77 ; x over pokeball tile
.loadBallTile
	ld [hl], a
.noBallTile
	pop af
	pop hl
	inc_hl_ycoord
	ld de, wSum
	ld [de], a
	lb bc, 1, 2
	call PrintNumber
	ld de, BoxOutOf20
	jp PlaceString

BoxText:
	db "BOX@"
BoxNames:
	db   "BOX 1"
	next "BOX 2"
	next "BOX 3"
	next "BOX 4"
	next "BOX 5"
	next "BOX 6"
	next "BOX 7"
	next "BOX 8"
	next "BOX 9"
	next "BOX10"
	next "BOX11"
	next "BOX12@"

;BoxNoText:
;	db "BOX No.@"

BoxOutOf20:
	db "/20@"

EmptyAllSRAMBoxes:
; marks all boxes in SRAM as empty (initialisation for the first time the
; player changes the box)
	call EnableSRAM
	ld a, BANK("Saved Boxes 1")
	ld [MBC1SRamBank], a
	call EmptySRAMBoxesInBank
	ld a, BANK("Saved Boxes 2")
	ld [MBC1SRamBank], a
	call EmptySRAMBoxesInBank
	call DisableSRAM
	ret

EmptySRAMBoxesInBank:
; marks every box in the current SRAM bank as empty
	ld hl, sBox1 ; sBox7
	call EmptySRAMBox
	ld hl, sBox2 ; sBox8
	call EmptySRAMBox
	ld hl, sBox3 ; sBox9
	call EmptySRAMBox
	ld hl, sBox4 ; sBox10
	call EmptySRAMBox
	ld hl, sBox5 ; sBox11
	call EmptySRAMBox
	ld hl, sBox6 ; sBox12
	call EmptySRAMBox
	ld hl, sBox1 ; sBox7
	ld bc, sBank2AllBoxesChecksum - sBox1
	call SAVCheckSum
	ld [sBank2AllBoxesChecksum], a ; sBank3AllBoxesChecksum
	call CalcIndividualBoxCheckSums
	ret

EmptySRAMBox:
	xor a
	ld [hli], a
	dec a
	ld [hl], a
	ret

GetMonCountsForAllBoxes:
	ld hl, wBoxMonCounts
	push hl
	call EnableSRAM
	ld a, BANK("Saved Boxes 1")
	ld [MBC1SRamBank], a
	call GetMonCountsForBoxesInBank
	ld a, BANK("Saved Boxes 2")
	ld [MBC1SRamBank], a
	call GetMonCountsForBoxesInBank
	call DisableSRAM
	pop hl

; copy the count for the current box from WRAM
	ld a, [wCurrentBoxNum]
	and $7f
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wBoxCount]
	ld [hl], a

	ret

GetMonCountsForBoxesInBank:
	ld a, [sBox1] ; sBox7
	ld [hli], a
	ld a, [sBox2] ; sBox8
	ld [hli], a
	ld a, [sBox3] ; sBox9
	ld [hli], a
	ld a, [sBox4] ; sBox10
	ld [hli], a
	ld a, [sBox5] ; sBox11
	ld [hli], a
	ld a, [sBox6] ; sBox12
	ld [hli], a
	ret

SAVCheckRandomID:
; checks if Sav file is the same by checking player's name 1st letter
; and the two random numbers generated at game beginning
; (which are stored at wPlayerID)s
	call EnableSRAM
	ld a, BANK("Save Data")
	ld [MBC1SRamBank], a
	ld a, [sPlayerName]
	and a
	jr z, .next
	ld hl, sGameData
	ld bc, sGameDataEnd - sGameData
	call SAVCheckSum
	ld c, a
	ld a, [sMainDataCheckSum]
	cp c
	jr nz, .next
	ld hl, sMainData + (wPlayerID - wMainDataStart) ; player ID
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wPlayerID]
	cp l
	jr nz, .next
	ld a, [wPlayerID + 1]
	cp h
.next
	ld a, SRAM_DISABLE
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret

SaveHallOfFameTeams:
	ld a, [wNumHoFTeams]
	dec a
	cp HOF_TEAM_CAPACITY
	jr nc, .shiftHOFTeams
	ld hl, sHallOfFame
	ld bc, HOF_TEAM
	call AddNTimes
	ld e, l
	ld d, h
	ld hl, wHallOfFame
	ld bc, HOF_TEAM
	jr HallOfFame_Copy

.shiftHOFTeams
; if the space designated for HOF teams is full, then shift all HOF teams to the next slot, making space for the new HOF team
; this deletes the last HOF team though
	ld hl, sHallOfFame + HOF_TEAM
	ld de, sHallOfFame
	ld bc, HOF_TEAM * (HOF_TEAM_CAPACITY - 1)
	call HallOfFame_Copy
	ld hl, wHallOfFame
	ld de, sHallOfFame + HOF_TEAM * (HOF_TEAM_CAPACITY - 1)
	ld bc, HOF_TEAM
	jr HallOfFame_Copy

LoadHallOfFameTeams:
	ld hl, sHallOfFame
	ld bc, HOF_TEAM
	ld a, [wHoFTeamIndex]
	call AddNTimes
	ld de, wHallOfFame
	ld bc, HOF_TEAM
	; fallthrough

HallOfFame_Copy:
	call EnableSRAM
	xor a
	ld [MBC1SRamBank], a
	rst _CopyData
	call DisableSRAM
	ret

ClearSAV:
	call EnableSRAM
	ld a, $4
.loop
	dec a
	push af
	call PadSRAM_FF
	pop af
	jr nz, .loop
	call DisableSRAM
	ret

PadSRAM_FF:
	ld [MBC1SRamBank], a
	ld hl, STARTOF(SRAM)
	ld bc, SIZEOF(SRAM)
	ld a, $ff
	jp FillMemory

EnableSRAM:
	ld a, SRAM_BANKING_MODE
	ld [MBC1SRamBankingMode], a
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	ret

DisableSRAM:
	ld a, SRAM_DISABLE
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamEnable], a
	ret
