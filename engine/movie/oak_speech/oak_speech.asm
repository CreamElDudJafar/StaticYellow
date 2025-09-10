PrepareOakSpeech:
	ld a, [wLetterPrintingDelayFlags]
	push af
	ld a, [wOptions]
	push af
	; Retrieve BIT_DEBUG_MODE set in DebugMenu for StartNewGameDebug.
	; BUG: StartNewGame carries over BIT_ALWAYS_ON_BIKE from previous save files,
	; which causes CheckForceBikeOrSurf to not return.
	; To fix this in debug builds, reset BIT_ALWAYS_ON_BIKE here or in StartNewGame.
	; In non-debug builds, the instructions can be removed.
	ld a, [wStatusFlags6]
	push af
	ld a, [wPrinterSettings]
	push af
	ld hl, wPlayerName
	ld bc, wBoxDataEnd - wPlayerName
	xor a
	call FillMemory
	ld hl, wSpriteDataStart
	ld bc, wSpriteDataEnd - wSpriteDataStart
	xor a
	call FillMemory
	xor a
	ld [wSurfingMinigameHiScore], a
	ld [wSurfingMinigameHiScore + 1], a
	ld [wSurfingMinigameHiScore + 2], a
	pop af
	ld [wPrinterSettings], a
	pop af
	ld [wStatusFlags6], a
	pop af
	ld [wOptions], a
	pop af
	ld [wLetterPrintingDelayFlags], a
	ld a, [wOptionsInitialized]
	and a
	call z, InitOptions
	; These debug names are used for StartNewGameDebug.
	; TestBattle uses the debug names from DebugMenu.
	; A variant of this process is performed in PrepareTitleScreen.
	ld hl, DebugNewGamePlayerName
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	rst _CopyData
	ld hl, DebugNewGameRivalName
	ld de, wRivalName
	ld bc, NAME_LENGTH
	rst _CopyData ; rip optimizations
	ret

OakSpeech:
	call StopAllMusic ; stop music
	ld a, BANK(Music_Routes2)
	ld c, a
	ld a, MUSIC_ROUTES2
	call PlayMusic
	call ClearScreen
	call LoadTextBoxTilePatterns
	call PrepareOakSpeech
	predef InitPlayerData2
	ld hl, wNumBoxItems
	ld a, POTION
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory
; Cheat Candy ; If wanted in PC at start of game
	ld a, CHEAT_CANDY
	ld [wCurItem], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory

	ld a, [wDefaultMap]
	ld [wDestinationMap], a
	call PrepareForSpecialWarp
	xor a
	ldh [hTileAnimations], a
	ld a, [wStatusFlags6]
	bit BIT_DEBUG_MODE, a
	jp nz, .skipSpeech
.MenuCursorLoop ; difficulty menu
	ld hl, DifficultyText
  	rst _PrintText
  	call DifficultyChoice
	ld a, [wCurrentMenuItem]
	ld [wDifficulty], a
	cp 0 ; normal
	jr z, .SelectedNormalMode
	cp 1 ; hard
	jr z, .SelectedHardMode
	; space for more game modes down the line
.SelectedNormalMode
	ld hl, NormalModeText
	rst _PrintText
	jp .YesNoNormalHard
.SelectedHardMode
	ld hl, HardModeText
	rst _PrintText
.YesNoNormalHard ; Give the player a brief description of each game mode and make sure that's what they want
  	call YesNoNormalHardChoice
	ld a, [wCurrentMenuItem]
	cp 0
	jr z, .doneLoop
	jp .MenuCursorLoop ; If player says no, back to difficulty selection
.doneLoop
   	call ClearScreen ; clear the screen before resuming normal intro

	; Gender Menu
	ld hl, BoyGirlText  ; added to the same file as the other oak text
	rst _PrintText     ; show this text
	call BoyGirlChoice ; added routine at the end of this file
	ld a, [wCurrentMenuItem]
	ld [wPlayerGender], a ; store player's gender. 00 for boy, 01 for girl
	call ClearScreen ; clear the screen before resuming normal intro

	farcall SendOakPal
	ld de, ProfOakPic
	lb bc, BANK(ProfOakPic), $00
	call IntroDisplayPicCenteredOrUpperRight
	call FadeInIntroPic
	ld hl, OakSpeechText1
	rst _PrintText
	call GBFadeOutToWhite
	call ClearScreen
	farcall SendPikaPal
	ld a, STARTER_PIKACHU
	ld [wCurSpecies], a
	ld [wCurPartySpecies], a
	call GetMonHeader
	hlcoord 6, 4
	call LoadFlippedFrontSpriteByMonIndex
	call MovePicLeft
	ld hl, OakSpeechText2
	rst _PrintText
	call GBFadeOutToWhite
	call ClearScreen
	farcall SendPlayerPal
	ld de, RedPicFront
	lb bc, BANK(RedPicFront), $00

	ld a, [wPlayerGender]
	and a

	jr z, .ContinueWithOakIntro1
	cp a, 2					; check gender: if a=2->gender=enby, jump to the yellow subroutine, otherwise continue below
	jp z, .LoadYellowPicFront1
	farcall SendGreenPal
	ld de, GreenPicFront
	lb bc, BANK(GreenPicFront), $00
	jr .ContinueWithOakIntro1
.LoadYellowPicFront1
	farcall SendYellowPal
	ld de, YellowPicFront
	lb bc, BANK(YellowPicFront), $00
.ContinueWithOakIntro1:	
	call IntroDisplayPicCenteredOrUpperRight

	call MovePicLeft
	ld hl, IntroducePlayerText
	rst _PrintText
	call ChoosePlayerName
	call GBFadeOutToWhite
	farcall SendRivalPal
	call ClearScreen
	ld de, Rival1Pic
	lb bc, BANK(Rival1Pic), $00
	call IntroDisplayPicCenteredOrUpperRight
	call FadeInIntroPic
	ld hl, IntroduceRivalText
	rst _PrintText
	call ChooseRivalName
.skipSpeech
	call GBFadeOutToWhite
	call ClearScreen
	farcall SendPlayerPal
	ld de, RedPicFront
	lb bc, BANK(RedPicFront), $00
;	call IntroDisplayPicCenteredOrUpperRight

	ld a, [wPlayerGender] ; check gender
 	and a      ; check gender -> if male, jump to vanilla code
	jr z, .ContinueWithOakIntro2		; previously "NotGreen2"
	cp a, 2
	jp z, .LoadYellowPicFront2
	farcall SendGreenPal
  	ld de, GreenPicFront
  	lb bc, BANK(GreenPicFront), $00
	jr .ContinueWithOakIntro2
.LoadYellowPicFront2
	farcall SendYellowPal
	ld de, YellowPicFront
	lb bc, BANK(YellowPicFront), $00
.ContinueWithOakIntro2:					; previously "NotGreen2"
	call IntroDisplayPicCenteredOrUpperRight

	call GBFadeInFromWhite
	ld a, [wStatusFlags3]
	and a ; ???
	jr nz, .next
	ld hl, OakSpeechText3
	rst _PrintText
.next
	ldh a, [hLoadedROMBank]
	push af
	ld a, SFX_SHRINK
	rst _PlaySound
	pop af
	call BankswitchCommon
	ld c, 4
	rst _DelayFrames
	ld hl, vSprites
	ld de, RedSprite
	ld b, BANK(RedSprite)
	ld c, $0C
	ld a, [wPlayerGender] ; check gender
	and a      ; check gender -> if male, jump to vanilla code
	jr z, .ContinueWithOakIntro3		; previously "NotGreen2"
	cp a, 2
	jp z, .LoadYellowPicFront3
	ld de, GreenSprite
	lb bc, BANK(GreenSprite), $0C
	jr .ContinueWithOakIntro3
.LoadYellowPicFront3
	ld de, YellowSprite
	lb bc, BANK(YellowSprite), $0C
.ContinueWithOakIntro3:					; previously "NotGreen2"
	ld hl, vSprites
	call CopyVideoData
	ld de, ShrinkPic1
	lb bc, BANK(ShrinkPic1), $00
	call IntroDisplayPicCenteredOrUpperRight

	ld c, 4
	rst _DelayFrames
	ld de, ShrinkPic2
	lb bc, BANK(ShrinkPic2), $00
	call IntroDisplayPicCenteredOrUpperRight
	call ResetPlayerSpriteData
	ldh a, [hLoadedROMBank]
	push af
	ld a, BANK(Music_PalletTown)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, 10
	ld [wAudioFadeOutControl], a
	call StopAllMusic
	pop af
	call BankswitchCommon
	ld c, 20
	rst _DelayFrames
	hlcoord 6, 5
	lb bc, 7, 7
	call ClearScreenArea
	call LoadTextBoxTilePatterns
	ld a, 1
	ld [wUpdateSpritesEnabled], a
	ld c, 50
	rst _DelayFrames
	call GBFadeOutToWhite
	call ClearScreen ; rip more tail-end optimizations
	ret

OakSpeechText1:
	text_far _OakSpeechText1
	text_end
OakSpeechText2:
	text_far _OakSpeechText2A
	sound_cry_pikachu
	text_far _OakSpeechText2B
	text_end
IntroducePlayerText:
	text_far _IntroducePlayerText
	text_end
IntroduceRivalText:
	text_far _IntroduceRivalText
	text_end
OakSpeechText3:
	text_far _OakSpeechText3
	text_end
NormalModeText:
	text_far _NormalModeText
	text_end
HardModeText:
	text_far _HardModeText
	text_end
DifficultyText:
	text_far _DifficultyText
	text_end
BoyGirlText:
    text_far _BoyGirlText
    text_end

FadeInIntroPic:
	ld hl, IntroFadePalettes
	ld b, 6
.next
	ld a, [hli]
	ldh [rBGP], a
	call UpdateGBCPal_BGP
	ld c, 10
	rst _DelayFrames
	dec b
	jr nz, .next
	ret

IntroFadePalettes:
	dc 1, 1, 1, 0
	dc 2, 2, 2, 0
	dc 3, 3, 3, 0
	dc 3, 3, 2, 0
	dc 3, 3, 1, 0
	dc 3, 2, 1, 0

MovePicLeft:
	ld a, 119
	ldh [rWX], a
	rst _DelayFrame

	ld a, %11100100
	ldh [rBGP], a
	call UpdateGBCPal_BGP
.next
	rst _DelayFrame
	ldh a, [rWX]
	sub 8
	cp $FF
	ret z
	ldh [rWX], a
	jr .next

DisplayPicCenteredOrUpperRight:
	call GetPredefRegisters
IntroDisplayPicCenteredOrUpperRight:
; b = bank
; de = address of compressed pic
; c: 0 = centred, non-zero = upper-right
	push bc
	ld a, b
	call UncompressSpriteFromDE
	ld a, $0
	call OpenSRAM
	ld hl, sSpriteBuffer1
	ld de, sSpriteBuffer0
	ld bc, $310
	rst _CopyData
	call CloseSRAM
	ld de, vFrontPic
	call InterlaceMergeSpriteBuffers
	pop bc
	ld a, c
	and a
	hlcoord 15, 1
	jr nz, .next
	hlcoord 6, 4
.next
	xor a
	ldh [hStartTileID], a
	predef_jump CopyUncompressedPicToTilemap

; displays difficulty choice
DifficultyChoice::
	call SaveScreenTilesToBuffer1
	call InitDifficultyTextBoxParameters
	jr DisplayDifficultyChoice

InitDifficultyTextBoxParameters::
  	ld a, DIFFICULTY_MENU
	ld [wTwoOptionMenuID], a
	hlcoord 5, 5
	lb bc, 6, 6 ; Cursor Pos
	ret
	
DisplayDifficultyChoice::
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID
	jp LoadScreenTilesFromBuffer1

; display yes/no choice
YesNoNormalHardChoice::
	call SaveScreenTilesToBuffer1
	call InitYesNoNormalHardTextBoxParameters
	jr DisplayYesNoNormalHardChoice

InitYesNoNormalHardTextBoxParameters::
  	ld a, YES_NO_MENU
	ld [wTwoOptionMenuID], a
	hlcoord 7, 5
	lb bc, 6, 8 ; Cursor Pos
	ret
	
DisplayYesNoNormalHardChoice::
	ld a, TWO_OPTION_MENU
	ld [wTextBoxID], a
	call DisplayTextBoxID
	jp LoadScreenTilesFromBuffer1

; displays boy/girl choice
BoyGirlChoice::
	call SaveScreenTilesToBuffer1
	jr DisplayBoyGirlNoChoice

DisplayBoyGirlNoChoice::
	ld a, BOY_GIRL_NO
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, wTopMenuItemY
	ld a, 7
	ld [hli], a ; top menu item Y
	ld a, 14
	ld [hli], a ; top menu item X
	xor a
	ld [hli], a ; current menu item ID
	inc hl
	ld a, $2
	ld [hli], a ; wMaxMenuItem
	ld a, B_BUTTON | A_BUTTON
	ld [hli], a ; wMenuWatchedKeys
	xor a
	ld [hl], a ; wLastMenuItem
	call HandleMenuInput
	bit BIT_B_BUTTON, a
	jr nz, .defaultOption ; if B was pressed, assign enby
; A was pressed
	call PlaceUnfilledArrowMenuCursor
	ld a, [wCurrentMenuItem]
	jp LoadScreenTilesFromBuffer1
.defaultOption
	ld a, $02
	ld [wCurrentMenuItem], a
	jp LoadScreenTilesFromBuffer1
