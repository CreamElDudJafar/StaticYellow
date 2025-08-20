SetDebugNewGameParty: ; unreferenced except in _DEBUG
	ld de, DebugNewGameParty
.loop
	ld a, [de]
	cp -1
	ret z
	ld [wCurPartySpecies], a
	inc de
	ld a, [de]
	ld [wCurEnemyLevel], a
	inc de
	call AddPartyMon
	jr .loop

DebugNewGameParty: ; unreferenced except in _DEBUG
	db SNORLAX, 80
	db PERSIAN, 80
	db JIGGLYPUFF, 80
	db STARTER_PIKACHU, 80
	db -1 ; end

PrepareNewGameDebug: ; dummy except in _DEBUG
IF DEF(_DEBUG)
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a

	; Fly anywhere.
	dec a ; $ff (all bits)
	ld [wTownVisitedFlag], a
	ld [wTownVisitedFlag + 1], a

	; Get all badges except Earth Badge.
	ld a, ~(1 << BIT_EARTHBADGE)
	ld a, %11111111
;	ld a, %00000100
;	ld a, %11111100
	ld [wObtainedBadges], a

	call SetDebugNewGameParty

	; Pikachu gets 3 HM moves.
	ld a, FLY
	ld hl, wPartyMon4Moves
	ld [hl], a
	ld a, FLASH
	ld hl, wPartyMon4Moves + 2
	ld [hl], a
	ld a, SURF
	ld hl, wPartyMon4Moves + 3
	ld [hl], a

	; Snorlax gets four HM moves.
	ld hl, wPartyMon1Moves
	ld a, FLY
	ld [hli], a
	ld a, CUT
	ld [hli], a
	ld a, SURF
	ld [hli], a
	ld a, STRENGTH
	ld [hl], a

	; Get some debug items.
	ld hl, wNumBagItems
	ld de, DebugItemsList
.items_loop
	ld a, [de]
	cp -1
	jr z, .items_end
	ld [wCurItem], a
	inc de
	ld a, [de]
	inc de
	ld [wItemQuantity], a
	call AddItemToInventory
	jr .items_loop
.items_end

	; Complete the Pokédex and Movedex
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned - 1
	call DebugSetPokedexEntries
	ld [hl], %01111111
	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen - 1
	call DebugSetPokedexEntries
	ld [hl], %01111111
	ld hl, wMovedexSeen
	ld b, wMovedexSeenEnd - wMovedexSeen - 1
	call DebugSetPokedexEntries
	ld [hl], %00011111
	SetEvent EVENT_GOT_POKEDEX
	SetEvent EVENT_GOT_MOVEDEX

	; Rival chose Jolteon.
	ld hl, wRivalStarter
	ld a, RIVAL_STARTER_JOLTEON
	ld [hli], a
	ld a, NUM_POKEMON
	ld [hli], a ; hl = wUnknownDebugByte
	ld a, STARTER_PIKACHU
	ld [hl], a ; hl = wPlayerStarter

	; Give max money.
	ld hl, wPlayerMoney
	ld a, $99
	ld [hli], a
	ld [hli], a
	ld [hl], a

	ret

DebugSetPokedexEntries:
	ld a, %11111111
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

DebugItemsList:
	db MASTER_BALL, 99
	db COIN_CASE,  1
	db SILPH_SCOPE, 1
	db BICYCLE, 1
	db FULL_RESTORE, 99
	db ESCAPE_ROPE, 99
	db SECRET_KEY, 1
	db POKE_FLUTE, 1
	db SILPH_SCOPE, 1
	db CARD_KEY, 1
	db REVIVE, 99
	db CHEAT_CANDY, 1
	db S_S_TICKET, 1
	db LIFT_KEY, 1
	db MAX_ELIXER, 99
	db -1 ; end

DebugUnusedList:
	db OLD_AMBER, 1
	db DOME_FOSSIL, 1
	db HELIX_FOSSIL, 1
	db X_ACCURACY, 99
	db DIRE_HIT, 99
	db FRESH_WATER, 1
	db S_S_TICKET, 1
	db GOLD_TEETH, 1
	db COIN_CASE, 1
	db SILPH_SCOPE, 1
	db POKE_FLUTE, 1
	db LIFT_KEY, 1
	db ETHER, 99
	db MAX_ETHER, 99
	db ELIXER, 99
	db MAX_ELIXER, 99
	db TM_RAZOR_WIND, 10
	db TM_HORN_DRILL, 10
	db TM_TAKE_DOWN, 10
	db TM_BLIZZARD, 10
	db TM_HYPER_BEAM, 10
	db TM_SOLARBEAM, 10
	db TM_DRAGON_RAGE, 10
	db TM_MIMIC, 10
	db TM_BIDE, 10
	db TM_METRONOME, 10
	db TM_SELFDESTRUCT, 10
	db TM_SWIFT, 10
	db TM_SOFTBOILED, 10
	db TM_DREAM_EATER, 10
	db TM_REST, 10
	db TM_SUBSTITUTE, 10
	db -1 ; end
ELSE
	ret
ENDC
