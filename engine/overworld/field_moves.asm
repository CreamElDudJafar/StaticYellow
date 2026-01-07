TryFieldMove:: ; predef
	call GetPredefRegisters
	call TrySurf
	ret z
	call TryCut
	ret z
	call TryFlash
	ret

TrySurf:
	ld a, [wWalkBikeSurfState]
	cp 2 ; is the player already surfing?
	jr z, .no
	farcall IsNextTileShoreOrWater
	jr nc, .no
	ld hl, TilePairCollisionsWater
	call CheckForTilePairCollisions2
	jr c, .no
	ld d, SURF
	call HasPartyMove
	jr nz, .no
	ld a, [wObtainedBadges]
	bit 4, a ; SOUL BADGE
	jr z, .no
	farcall IsSurfingAllowed
	ld hl, wStatusFlags1
	bit BIT_SURF_ALLOWED, [hl]
	res BIT_SURF_ALLOWED, [hl]
	jr z, .no2 ; Changed from .no
	call InitializeFieldMoveTextBox
	ld hl, PromptToSurfText
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .no2
	call GetPartyMonName2
	ld a, SURFBOARD
	ld [wCurItem], a
	ld [wPseudoItemID], a
	call UseItem
.yes2
	call CloseFieldMoveTextBox
.yes
	xor a
	ret
.no2
	call CloseFieldMoveTextBox
.no
	ld a, 1
	and a
	ret

TryCut:
	call IsCutTile
	jr nc, TrySurf.no
	call InitializeFieldMoveTextBox
	ld hl, ExplainCutText
	rst _PrintText
	call ManualTextScroll
	ld d, CUT
	call HasPartyMove
	jr nz, TrySurf.no2
	ld a, [wObtainedBadges]
	bit 1, a ; CASCADE BADGE
	jr z, TrySurf.no2
	ld hl, PromptToCutText
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, TrySurf.no2
	call GetPartyMonName2
	farcall Cut2
	call CloseFieldMoveTextBox
	jr TrySurf.yes2

IsCutTile:
; partial copy from UsedCut
	ld a, [wCurMapTileset]
	and a ; OVERWORLD
	jr z, .overworld
	cp GYM
	jr nz, .no
	ld a, [wTileInFrontOfPlayer]
	cp $50 ; gym cut tree
	jr nz, .no
	jr .yes
.overworld
	ld a, [wTileInFrontOfPlayer]
	cp $3d ; cut tree
	jr nz, .no
.yes
	scf
	ret
.no
	and a
	ret

TryFlash::
	ldh a, [hJoyHeld]
	bit BIT_A_BUTTON, a
	ret z
; A button is pressed
	ld a, [wMapPalOffset]
   	and a
    	ret z
; area is dark
    	ld a, [wObtainedBadges] ; badges obtained
    	bit BIT_BOULDERBADGE, a ; BROCK	
	jr z, TrySurf.no2
	xor a
	ld [wMapPalOffset], a
	tx_pre_jump FlashLightsAreaText


HasPartyMove::
; Return z (optional: in wWhichTrade) if a PartyMon has move d.
; Updates wWhichPokemon.
	push bc
	push de
	push hl

	ld a, [wPartyCount]
	and a
	jr z, .no
	ld b, a
	ld c, 0
	ld hl, wPartyMons + (wPartyMon1Moves - wPartyMon1)
.loop
	ld e, NUM_MOVES
.check_move
	ld a, [hli]
	cp d
	jr z, .yes
	dec e
	jr nz, .check_move

	ld a, wPartyMon2 - wPartyMon1 - NUM_MOVES
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a

	inc c
	ld a, c
	cp b
	jr c, .loop
	jr .no

.yes
	ld a, c
	ld [wWhichPokemon], a
	xor a ; probably redundant
	ld [wWhichTrade], a
	jr .done
.no
	ld a, 1
	and a
	ld [wWhichTrade], a
.done
	pop hl
	pop de
	pop bc
	ret

InitializeFieldMoveTextBox:
	call EnableAutoTextBoxDrawing
	ld a, 1 ; not 0
	ld [hTextID], a
	farcall DisplayTextIDInit
	ret

CloseFieldMoveTextBox:
	ld a,[hLoadedROMBank]
	push af
	jp CloseTextDisplay

ExplainSurfText:
	text "This water can"
	line "be SURF!@@"
	
PromptToSurfText:
	text "The water is calm."
	line "Would you like to"
	cont "SURF?@@"

ExplainCutText:
	text "This tree can be"
	line "CUT!@@"

PromptToCutText:
	text "Would you like to"
	line "use CUT?@@"

FlashLightsAreaText::
	text_far _FlashLightsAreaText2
	text_end

_FlashLightsAreaText2::
	text "A blinding FLASH"
	line "lights the area!"
	done
