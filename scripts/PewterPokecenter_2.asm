PewterPokecenterPrintCooltrainerFText::
	ld hl, .text
	rst _PrintText
	ret

.text
	text_far _PewterPokecenterText3
	text_end

PewterJigglypuff::
	ld a, TRUE
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, .Text
	rst _PrintText

	call StopAllMusic
	ld c, 32
	rst _DelayFrames

	ld hl, .FacingDirections
	ld de, wJigglypuffFacingDirections
	ld bc, .FacingDirectionsEnd - .FacingDirections
	rst _CopyData

	ld a, [wSprite03StateData1ImageIndex]
	ld hl, wJigglypuffFacingDirections
.findMatchingFacingDirectionLoop
	cp [hl]
	inc hl
	jr nz, .findMatchingFacingDirectionLoop
	dec hl

	push hl
	ld c, BANK(Music_JigglypuffSong)
	ld a, MUSIC_JIGGLYPUFF_SONG
	call PlayMusic
	pop hl

.spinMovementLoop
	ld a, [hl]
	ld [wSprite03StateData1ImageIndex], a
; rotate the array
	push hl
	ld hl, wJigglypuffFacingDirections
	ld de, wJigglypuffFacingDirections - 1
	ld bc, .FacingDirectionsEnd - .FacingDirections
	rst _CopyData
	ld a, [wJigglypuffFacingDirections - 1]
	ld [wJigglypuffFacingDirections + 3], a
	pop hl
	ld c, 24
	rst _DelayFrames
	ld a, [wChannelSoundIDs]
	ld b, a
	ld a, [wChannelSoundIDs + CHAN2]
	or b
	jr nz, .spinMovementLoop

	ld c, 48
	rst _DelayFrames
	call PlayDefaultMusic
	ld a, [wd471]
	bit 7, a
	ret z
	callfar CheckPikachuFaintedOrStatused
	ret c
	call DisablePikachuFollowingPlayer
	ret

.Text:
	text_far _PewterPokecenterJigglypuffText
	text_end

.FacingDirections:
	db $40 | SPRITE_FACING_DOWN
	db $40 | SPRITE_FACING_LEFT
	db $40 | SPRITE_FACING_UP
	db $40 | SPRITE_FACING_RIGHT
.FacingDirectionsEnd:
