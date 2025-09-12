DisplayOptionMenu_:
	call InitOptionsMenu
.optionMenuLoop
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	ld b, a
	and START | B_BUTTON
	jr nz, .exitOptionMenu
	bit BIT_SELECT, b ; Select button pressed
	jp nz, DisplaySoundTestMenu
	call OptionsControl
	jr c, .dpadDelay
	call GetOptionPointer
	jr c, .exitOptionMenu
.dpadDelay
	call OptionsMenu_UpdateCursorPosition
	rst _DelayFrame
	rst _DelayFrame
        rst _DelayFrame
	jr .optionMenuLoop
.exitOptionMenu
	ret

GetOptionPointer:
	ld a, [wOptionsCursorLocation]
	ld e, a
	ld d, $0
	ld hl, OptionMenuJumpTable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl ; jump to the function for the current highlighted option

OptionMenuJumpTable:
	dw OptionsMenu_TextSpeed
	dw OptionsMenu_BattleAnimations
	dw OptionsMenu_BattleStyle
	dw OptionsMenu_SpeakerSettings
	dw OptionsMenu_GBPrinterBrightness
	dw OptionsMenu_Dummy
	dw OptionsMenu_Dummy
	dw OptionsMenu_Cancel

OptionsMenu_TextSpeed:
    	call GetTextSpeed ; c = 0 (instant), 1 (fast), 2 (medium), 3 (slow),
    	ldh a, [hJoy5]    ; d = left speed, e = right speed
    	bit BIT_D_RIGHT, a
    	jr nz, .pressedRight
    	bit BIT_D_LEFT, a
    	jr nz, .pressedLeft
    	jr .nonePressed
.pressedRight ; pick right speed e and increase c
    	inc c
    	ld a, c
    	cp 4
    	jr nz, .save
    	ld c, 0   ; wrap around to 0 if c = 4
    	jr .save
.pressedLeft  ; pick left speed d and decrease c
    	ld e, d
    	dec c
    	ld a, c
    	cp -1 ; inc a
    	jr nz, .save
    	ld c, 3   ; wrap around to 3 if c = 0
.save
    	ld a, [wOptions]
    	and ~TEXT_DELAY_MASK
    	or e
    	ld [wOptions], a
.nonePressed
    	ld b, 0
    	sla c
    	ld hl, TextSpeedStringsPointerTable
    	add hl, bc
    	ld a, [hli]
    	ld e, a
    	ld d, [hl]
    	hlcoord 14, 2
    	call PlaceString
    	and a
    	ret

TextSpeedStringsPointerTable:
    	dw InstantText
    	dw FastText
    	dw MediumText
    	dw SlowText

InstantText:
    	db "INST@"
FastText:
    	db "FAST@"
MediumText:
    	db "MID @"
SlowText:
    	db "SLOW@"

GetTextSpeed:
    	ld a, [wOptions]
    	and TEXT_DELAY_MASK
    	ld c, 0
    	cp TEXT_DELAY_INSTANT
    	jr z, .instantTextOption
    	inc c
    	cp TEXT_DELAY_FAST
    	jr z, .fastTextOption
    	inc c
    	cp TEXT_DELAY_MEDIUM
    	jr z, .mediumTextOption
; slow text option
    	inc c
    	lb de, TEXT_DELAY_MEDIUM, TEXT_DELAY_INSTANT
    	ret
.mediumTextOption
    	lb de, TEXT_DELAY_FAST, TEXT_DELAY_SLOW
    	ret
.fastTextOption
    	lb de, TEXT_DELAY_INSTANT, TEXT_DELAY_MEDIUM
    	ret
.instantTextOption
    	lb de, TEXT_DELAY_SLOW, TEXT_DELAY_FAST
    	ret


OptionsMenu_BattleAnimations:
	ldh a, [hJoy5]
	and D_RIGHT | D_LEFT
	jr nz, .buttonPressed
	ld a, [wOptions]
	and $80 ; mask other bits
	jr .nothingPressed
.buttonPressed
	ld a, [wOptions]
	xor $80
	ld [wOptions], a
.nothingPressed
	ld bc, $0
	sla a
	rl c
	ld hl, AnimationOptionStringsPointerTable
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 14, 4
	call PlaceString
	and a
	ret

AnimationOptionStringsPointerTable:
	dw AnimationOnText
	dw AnimationOffText

AnimationOnText:
	db "ON @"
AnimationOffText:
	db "OFF@"

OptionsMenu_BattleStyle:
	ldh a, [hJoy5]
	and D_LEFT | D_RIGHT
	jr nz, .buttonPressed
	ld a, [wDifficulty]
	and a
	jr nz, .lockedToSet
	ld a, [wOptions]
	and 1 << BIT_BATTLE_SHIFT
	jr .done
.buttonPressed
	ld a, [wDifficulty]
	and a
	jr nz, .lockedToSet
	ld a, [wOptions]
	xor 1 << BIT_BATTLE_SHIFT
	ld [wOptions], a
	jr .done
.lockedToSet
	ld a, [wOptions]
	or 1 << BIT_BATTLE_SHIFT
	ld [wOptions], a
.done
	ld bc, $0
	sla a
	sla a
	rl c
	ld hl, BattleStyleOptionStringsPointerTable
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 14, 6
	call PlaceString
	and a
	ret

BattleStyleOptionStringsPointerTable:
	dw BattleStyleShiftText
	dw BattleStyleSetText

BattleStyleShiftText:
	db "SHIFT@"
BattleStyleSetText:
	db "SET  @"

OptionsMenu_SpeakerSettings:
	ld a, [wOptions]
	and $30
	swap a
	ld c, a
	ldh a, [hJoy5]
	bit BIT_D_RIGHT, a
	jr nz, .pressedRight
	bit BIT_D_LEFT, a
	jr nz, .pressedLeft
	jr .nothingPressed
.pressedRight
	ld a, c
	inc a
	and $3
	jr .save
.pressedLeft
	ld a, c
	dec a
	and $3
.save
	ld c, a
	swap a
	ld b, a
	xor a
	ldh [rNR51], a
	ld a, [wOptions]
	and $cf
	or b
	ld [wOptions], a
.nothingPressed
	ld b, $0
	ld hl, SpeakerOptionStringsPointerTable
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 8, 8
	call PlaceString
	and a
	ret

SpeakerOptionStringsPointerTable:
	dw MonoSoundText
	dw Earphone1SoundText
	dw Earphone2SoundText
	dw Earphone3SoundText

MonoSoundText:
	db "MONO     @"
Earphone1SoundText:
	db "EARPHONE1@"
Earphone2SoundText:
	db "EARPHONE2@"
Earphone3SoundText:
	db "EARPHONE3@"

OptionsMenu_GBPrinterBrightness:
	call GetGBPrinterBrightness
	ldh a, [hJoy5]
	bit BIT_D_RIGHT, a
	jr nz, .pressedRight
	bit BIT_D_LEFT, a
	jr nz, .pressedLeft
	jr .nothingPressed
.pressedRight
	ld a, c
	cp $4
	jr c, .increase
	ld c, $ff
.increase
	inc c
	ld a, e
	jr .save
.pressedLeft
	ld a, c
	and a
	jr nz, .decrease
	ld c, $5
.decrease
	dec c
	ld a, d
.save
	ld b, a
	ld [wPrinterSettings], a

.nothingPressed
	ld b, $0
	ld hl, GBPrinterOptionStringsPointerTable
	add hl, bc
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	hlcoord 8, 10
	call PlaceString
	and a
	ret

GBPrinterOptionStringsPointerTable:
	dw LightestPrintText
	dw LighterPrintText
	dw NormalPrintText
	dw DarkerPrintText
	dw DarkestPrintText

LightestPrintText:
	db "LIGHTEST@"
LighterPrintText:
	db "LIGHTER @"
NormalPrintText:
	db "NORMAL  @"
DarkerPrintText:
	db "DARKER  @"
DarkestPrintText:
	db "DARKEST @"

GetGBPrinterBrightness:
	ld a, [wPrinterSettings]
	and a
	jr z, .setLightest
	cp $20
	jr z, .setLighter
	cp $60
	jr z, .setDarker
	cp $7f
	jr z, .setDarkest
	ld c, $2
	lb de, $20, $60
	ret
.setLightest
	ld c, $0
	lb de, $7f, $20
	ret
.setLighter
	ld c, $1
	lb de, $0, $40
	ret
.setDarker
	ld c, $3
	lb de, $40, $7f
	ret
.setDarkest
	ld c, $4
	lb de, $60, $0
	ret

OptionsMenu_Dummy:
	and a
	ret

OptionsMenu_Cancel:
	ldh a, [hJoy5]
	and A_BUTTON
	jr nz, .pressedCancel
	and a
	ret
.pressedCancel
	scf
	ret

OptionsControl:
	ld hl, wOptionsCursorLocation
	ldh a, [hJoy5]
	cp D_DOWN
	jr z, .pressedDown
	cp D_UP
	jr z, .pressedUp
	and a
	ret
.pressedDown
	ld a, [hl]
	cp $7
	jr nz, .doNotWrapAround
	ld [hl], $0
	scf
	ret
.doNotWrapAround
	cp $4
	jr c, .regularIncrement
	ld [hl], $6
.regularIncrement
	inc [hl]
	scf
	ret
.pressedUp
	ld a, [hl]
	cp $7
	jr nz, .doNotMoveCursorToPrintOption
	ld [hl], $4
	scf
	ret
.doNotMoveCursorToPrintOption
	and a
	jr nz, .regularDecrement
	ld [hl], $8
.regularDecrement
	dec [hl]
	scf
	ret

OptionsMenu_UpdateCursorPosition:
	hlcoord 1, 1
	ld de, SCREEN_WIDTH
	ld c, 16
.loop
	ld [hl], " "
	add hl, de
	dec c
	jr nz, .loop
	hlcoord 1, 2
	ld bc, SCREEN_WIDTH * 2
	ld a, [wOptionsCursorLocation]
	call AddNTimes
	ld [hl], "▶"
	ret

InitOptionsMenu:
	hlcoord 0, 0
	lb bc, SCREEN_HEIGHT - 2, SCREEN_WIDTH - 2
	call TextBoxBorder
	hlcoord 2, 2
	ld de, AllOptionsText
	call PlaceString
	hlcoord 2, 16
	ld de, OptionMenuCancelText
	call PlaceString
	xor a
	ld [wOptionsCursorLocation], a
	ld c, 5 ; the number of options to loop through
.loop
	push bc
	call GetOptionPointer ; updates the next option
	pop bc
	ld hl, wOptionsCursorLocation
	inc [hl] ; moves the cursor for the highlighted option
	dec c
	jr nz, .loop
	xor a
	ld [wOptionsCursorLocation], a
	inc a
	ldh [hAutoBGTransferEnabled], a
	call Delay3
	ret

AllOptionsText:
	db "TEXT SPEED :"
	next "ANIMATION  :"
	next "BATTLESTYLE:"
	next "SOUND:"
	next "PRINT:@"

OptionMenuCancelText:
	db "CANCEL     SELECT@"
