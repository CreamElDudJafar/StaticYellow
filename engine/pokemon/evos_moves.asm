; try to evolve the mon in [wWhichPokemon]
TryEvolvingMon:
	ld hl, wCanEvolveFlags
	xor a
	ld [hl], a
	ld a, [wWhichPokemon]
	ld c, a
	ld b, FLAG_SET
	call Evolution_FlagAction

; this is only called after battle
; it does level up evolutions, though there was a bug in red/blue that allows item evolutions to occur which is patched here
EvolutionAfterBattle:
	ldh a, [hTileAnimations]
	push af
	xor a
	ld [wEvolutionOccurred], a
	dec a
	ld [wWhichPokemon], a
	push hl
	push bc
	push de
	ld hl, wPartyCount
	push hl

Evolution_PartyMonLoop: ; loop over party mons
	ld hl, wWhichPokemon
	inc [hl]
	pop hl
	inc hl
	ld a, [hl]
	cp $ff ; have we reached the end of the party?
	jp z, .done
	ld [wEvoOldSpecies], a
	push hl
	ld a, [wWhichPokemon]
	ld c, a
	ld hl, wCanEvolveFlags
	ld b, FLAG_TEST
	call Evolution_FlagAction
	ld a, c
	and a ; is the mon's bit set?
	jp z, Evolution_PartyMonLoop ; if not, go to the next mon
	ld a, [wEvoOldSpecies]
	dec a
	ld b, 0
	ld hl, EvosMovesPointerTable
	add a
	rl b
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld a, [wCurPartySpecies]
	push af
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	call LoadMonData
	pop af
	ld [wCurPartySpecies], a
	pop hl

.evoEntryLoop ; loop over evolution entries
	ld a, [hli]
	and a ; have we reached the end of the evolution data?
	jr z, Evolution_PartyMonLoop
	ld b, a ; evolution type
	cp EVOLVE_TRADE
	jr z, .checkTradeEvo
; not trade evolution
	ld a, [wLinkState]
	cp LINK_STATE_TRADING
	jr z, Evolution_PartyMonLoop ; if trading, go the next mon
	ld a, b
	cp EVOLVE_ITEM
	jr z, .checkItemEvo
	ld a, [wForceEvolution]
	and a
	jr nz, Evolution_PartyMonLoop
	ld a, b
	cp EVOLVE_LEVEL
	jr z, .checkLevel
.checkTradeEvo
	ld a, [wLinkState]
	cp LINK_STATE_TRADING
	jp nz, .nextEvoEntry1 ; if not trading, go to the next evolution entry
	ld a, [hli] ; level requirement
	ld b, a
	ld a, [wLoadedMonLevel]
	cp b ; is the mon's level greater than the evolution requirement?
	jp c, Evolution_PartyMonLoop ; if so, go the next mon
	jr .doEvolution
.checkItemEvo
	ld a, [wIsInBattle] ; are we in battle?
	and a
	ld a, [hli]
	jp nz, .nextEvoEntry1 ; don't evolve if we're in a battle as wCurPartySpecies could be holding the last mon sent out

	ld b, a ; evolution item
	ld a, [wCurItem]
	cp b ; was the evolution item in this entry used?
	jp nz, .nextEvoEntry1 ; if not, go to the next evolution entry
.checkLevel
	ld a, [hli] ; level requirement
	ld b, a
	ld a, [wLoadedMonLevel]
	cp b ; is the mon's level greater than the evolution requirement?
	jp c, .nextEvoEntry2 ; if so, go the next evolution entry
.doEvolution
	ld [wCurEnemyLevel], a
	ld a, 1
	ld [wEvolutionOccurred], a
	push hl
	ld a, [hl]
	ld [wEvoNewSpecies], a
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	call CopyToStringBuffer
	ld hl, IsEvolvingText
	rst _PrintText
	ld c, 50
	rst _DelayFrames
	xor a
	ldh [hAutoBGTransferEnabled], a
	hlcoord 0, 0
	lb bc, 12, 20
	call ClearScreenArea
	ld a, $1
	ldh [hAutoBGTransferEnabled], a
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	call ClearSprites
	callfar EvolveMon
	jp c, CancelledEvolution
	ld hl, EvolvedText
	rst _PrintText
	pop hl
	ld a, [hl]
	ld [wCurSpecies], a
	ld [wLoadedMonSpecies], a
	ld [wEvoNewSpecies], a
	ld a, MONSTER_NAME
	ld [wNameListType], a
	ld a, BANK(MonsterNames) ; bank is not used for monster names
	ld [wPredefBank], a
	call GetName
	push hl
	ld hl, IntoText
	call PrintText_NoCreatingTextBox
	ld a, SFX_GET_ITEM_2
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ld c, 40
	rst _DelayFrames
	call ClearScreen
	call RenameEvolvedMon
	ld a, [wPokedexNum]
	push af
	ld a, [wCurSpecies]
	ld [wPokedexNum], a
	predef IndexToPokedex
	callfar CopyBaseStats
	ld a, [wCurSpecies]
	ld [wMonHIndex], a
	pop af
	ld [wPokedexNum], a
	ld hl, wLoadedMonHPExp - 1
	ld de, wLoadedMonStats
	ld b, $1
	call CalcStats
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	push hl
	push bc
	ld bc, wPartyMon1MaxHP - wPartyMon1
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wLoadedMonMaxHP + 1
	ld a, [hld]
	sub c
	ld c, a
	ld a, [hl]
	sbc b
	ld b, a
	ld hl, wLoadedMonHP + 1
	ld a, [hl]
	add c
	ld [hld], a
	ld a, [hl]
	adc b
	ld [hl], a
	dec hl
	pop bc
	rst _CopyData
	ld a, [wCurSpecies]
	ld [wPokedexNum], a
	xor a
	ld [wMonDataLocation], a
	call LearnMoveFromLevelUp
	pop hl
	predef SetPartyMonTypes
	ld a, [wIsInBattle]
	and a
	call z, Evolution_ReloadTilesetTilePatterns
	predef IndexToPokedex
	ld a, [wPokedexNum]
	dec a
	ld c, a
	ld b, FLAG_SET
	ld hl, wPokedexOwned
	push bc
	call Evolution_FlagAction
	pop bc
	ld hl, wPokedexSeen
	call Evolution_FlagAction
	pop de
	pop hl
	ld a, [wLoadedMonSpecies]
	ld [hl], a
	push hl
	ld l, e
	ld h, d
	jr .nextEvoEntry2

.nextEvoEntry1
	inc hl

.nextEvoEntry2
	inc hl
	jp .evoEntryLoop

.done
	pop de
	pop bc
	pop hl
	pop af
	ldh [hTileAnimations], a
	ld a, [wLinkState]
	cp LINK_STATE_TRADING
	ret z
	ld a, [wIsInBattle]
	and a
	ret nz
	ld a, [wEvolutionOccurred]
	and a
	call nz, PlayDefaultMusic
	ret

RenameEvolvedMon:
; Renames the mon to its new, evolved form's standard name unless it had a
; nickname, in which case the nickname is kept.
	assert wCurSpecies == wNameListIndex ; save+restore wCurSpecies while using wNameListIndex
	ld a, [wCurSpecies]
	push af
	ld a, [wMonHIndex]
	ld [wNameListIndex], a
	call GetName
	pop af
	ld [wCurSpecies], a
	ld hl, wNameBuffer
	ld de, wStringBuffer
.compareNamesLoop
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	ret nz
	cp "@"
	jr nz, .compareNamesLoop
	ld a, [wWhichPokemon]
	ld bc, NAME_LENGTH
	ld hl, wPartyMonNicks
	call AddNTimes
	push hl
	call GetName
	ld hl, wNameBuffer
	pop de
	jp CopyData

CancelledEvolution:
	ld hl, StoppedEvolvingText
	rst _PrintText
	call ClearScreen
	pop hl
	call Evolution_ReloadTilesetTilePatterns
	jp Evolution_PartyMonLoop

EvolvedText:
	text_far _EvolvedText
	text_end

IntoText:
	text_far _IntoText
	text_end

StoppedEvolvingText:
	text_far _StoppedEvolvingText
	text_end

IsEvolvingText:
	text_far _IsEvolvingText
	text_end

Evolution_ReloadTilesetTilePatterns:
	ld a, [wLinkState]
	cp LINK_STATE_TRADING
	ret z
	jp ReloadTilesetTilePatterns

LearnMoveFromLevelUp:
	ld a, [wPokedexNum] ; species
	ld [wCurPartySpecies], a
	call GetMonLearnset
.learnSetLoop ; loop over the learn set until we reach a move that is learnt at the current level or the end of the list
	ld a, [hli]
	and a ; have we reached the end of the learn set?
	jr z, .done ; if we've reached the end of the learn set, jump
	ld b, a ; level the move is learnt at
	ld a, [wCurEnemyLevel]
	cp b ; is the move learnt at the mon's current level?
	ld a, [hli] ; move ID
	jr nz, .learnSetLoop

.confirmlearnmove
	push hl
	ld d, a ; ID of move to learn
	ld a, [wMonDataLocation]
	and a
	jr nz, .next
; If [wMonDataLocation] is 0 (PLAYER_PARTY_DATA), get the address of the mon's
; current moves in party data. Every call to this function sets
; [wMonDataLocation] to 0 because other data locations are not supported.
; If it is not 0, this function will not work properly.
	ld hl, wPartyMon1Moves
	ld a, [wWhichPokemon]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
.next
	ld b, NUM_MOVES
.checkCurrentMovesLoop ; check if the move to learn is already known
	ld a, [hli]
	cp d
	jr z, .movesloop_done ; if already known, jump
	dec b
	jr nz, .checkCurrentMovesLoop
	ld a, d
	ld [wMoveNum], a
	ld [wNamedObjectIndex], a
	call GetMoveName
	call CopyToStringBuffer
	predef LearnMove
	ld a, b
	and a
	jr z, .movesloop_done
	callfar IsThisPartymonStarterPikachu_Party
	jr nc, .movesloop_done
	ld a, [wMoveNum]
	cp THUNDERBOLT
	jr z, .foundThunderOrThunderbolt
	cp THUNDER
	jr nz, .movesloop_done
.foundThunderOrThunderbolt
	ld a, $5
	ld [wd49c], a
	ld a, $85
	ld [wPikachuMood], a
.movesloop_done
	pop hl
	jr .learnSetLoop
.done
	ld a, [wCurPartySpecies]
	ld [wPokedexNum], a
	ret

Func_3b079:
	ld a, [wCurPartySpecies]
	push af
	call Func_3b0a2
	jr c, .asm_3b09c

	call Func_3b10f
	jr nc, .asm_3b096

	call Func_3b0a2
	jr c, .asm_3b09c

	call Func_3b10f
	jr nc, .asm_3b096

	call Func_3b0a2
	jr c, .asm_3b09c
.asm_3b096
	pop af
	ld [wCurPartySpecies], a
	and a
	ret
.asm_3b09c
	pop af
	ld [wCurPartySpecies], a
	scf
	ret

Func_3b0a2:
	ld a, [wTempTMHM]
	ld [wMoveNum], a
	predef CanLearnTM
	ld a, c
	and a
	jr nz, .asm_3b0ec
	ld hl, Pointer_3b0ee
	ld a, [wCurPartySpecies]
	ld de, $1
	call IsInArray
	jr c, .asm_3b0d2
	ld a, $ff
	ld [wMonHGrowthRate], a
	ld a, [wTempTMHM]
	ld hl, wMonHMoves
	ld de, $1
	call IsInArray
	jr c, .asm_3b0ec
.asm_3b0d2
	ld a, [wTempTMHM]
	ld d, a
	call GetMonLearnset
.loop
	ld a, [hli]
	and a
	jr z, .asm_3b0ea
	ld b, a
	ld a, [wCurEnemyLevel]
	cp b
	jr c, .asm_3b0ea
	ld a, [hli]
	cp d
	jr z, .asm_3b0ec
	jr .loop
.asm_3b0ea
	and a
	ret
.asm_3b0ec
	scf
	ret

INCLUDE "data/pokemon/unknown_list.asm"

Func_3b10f:
	ld c, $0
.asm_3b111
	ld hl, EvosMovesPointerTable
	ld b, $0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.asm_3b11b
	ld a, [hli]
	and a
	jr z, .asm_3b130
	cp $2
	jr nz, .asm_3b124
	inc hl
.asm_3b124
	inc hl
	ld a, [wCurPartySpecies]
	cp [hl]
	jr z, .asm_3b138
	inc hl
	ld a, [hl]
	and a
	jr nz, .asm_3b11b
.asm_3b130
	inc c
	ld a, c
	cp VICTREEBEL
	jr c, .asm_3b111
	and a
	ret
.asm_3b138
	inc c
	ld a, c
	ld [wCurPartySpecies], a
	scf
	ret

; writes the moves a mon has at level [wCurEnemyLevel] to [de]
; move slots are being filled up sequentially and shifted if all slots are full
WriteMonMoves:
	call GetPredefRegisters
	push hl
	push de
	push bc
	call GetMonLearnset
	jr .firstMove
.nextMove
	pop de
.nextMove2
	inc hl
.firstMove
	ld a, [hli]       ; read level of next move in learnset
	and a
	jp z, .done       ; end of list
	ld b, a
	ld a, [wCurEnemyLevel]
	cp b
	jp c, .done       ; mon level < move level (assumption: learnset is sorted by level)
	ld a, [wLearningMovesFromDayCare]
	and a
	jr z, .skipMinLevelCheck
	ld a, [wDayCareStartLevel]
	cp b
	jr nc, .nextMove2 ; min level >= move level

.skipMinLevelCheck

; check if the move is already known
	push de
	ld c, NUM_MOVES
.alreadyKnowsCheckLoop
	ld a, [de]
	inc de
	cp [hl]
	jr z, .nextMove
	dec c
	jr nz, .alreadyKnowsCheckLoop

; try to find an empty move slot
	pop de
	push de
	ld c, NUM_MOVES
.findEmptySlotLoop
	ld a, [de]
	and a
	jr z, .writeMoveToSlot2
	inc de
	dec c
	jr nz, .findEmptySlotLoop

; no empty move slots found
	pop de
	push de
	push hl
	ld h, d
	ld l, e
	call WriteMonMoves_ShiftMoveData ; shift all moves one up (deleting move 1)
	ld a, [wLearningMovesFromDayCare]
	and a
	jr z, .writeMoveToSlot

; shift PP as well if learning moves from day care
	push de
	ld bc, wPartyMon1PP - (wPartyMon1Moves + 3)
	add hl, bc
	ld d, h
	ld e, l
	call WriteMonMoves_ShiftMoveData ; shift all move PP data one up
	pop de

.writeMoveToSlot
	pop hl
.writeMoveToSlot2
	ld a, [hl]
	ld [de], a
	ld a, [wLearningMovesFromDayCare]
	and a
	jr z, .nextMove

; write move PP value if learning moves from day care
	push hl
	ld a, [hl]
	ld hl, wPartyMon1PP - wPartyMon1Moves
	add hl, de
	push hl
	dec a
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld de, wBuffer
	ld a, BANK(Moves)
	call FarCopyData
	ld a, [wBuffer + 5]
	pop hl
	ld [hl], a
	pop hl
	jr .nextMove

.done
	pop bc
	pop de
	pop hl
	ret

; shifts all move data one up (freeing 4th move slot)
WriteMonMoves_ShiftMoveData:
	ld c, NUM_MOVES - 1
.loop
	inc de
	ld a, [de]
	ld [hli], a
	dec c
	jr nz, .loop
	ret

Evolution_FlagAction:
	predef_jump FlagActionPredef

GetMonLearnset:
	ld hl, EvosMovesPointerTable
	ld b, 0
	ld a, [wCurPartySpecies]
	dec a
	ld c, a
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.skipEvolutionDataLoop ; loop to skip past the evolution data, which comes before the move data
	ld a, [hli]
	and a ; have we reached the end of the evolution data?
	jr nz, .skipEvolutionDataLoop ; if not, jump back up
	ret

; From here, Move Relearner-related code -PvK
;joenote - custom function by Mateo for move relearner
PrepareRelearnableMoveList:: ; I don't know how the fuck you're a single colon in shin pokered but it sure as shit doesn't work here - PvK
; Loads relearnable move list to wRelearnableMoves.
; Input: party mon index = [wWhichPokemon]
	; Get mon id.
	ld a, [wWhichPokemon]
	ld c, a
	ld b, 0
	ld hl, wPartySpecies
	add hl, bc
	ld a, [hl] ; a = mon id
	ld [wCurSpecies], a	;joenote - put mon id into wram for potential later usage of GetMonHeader
	; Get pointer to evos moves data.
	dec a
	ld c, a
	ld b, 0
	ld hl, EvosMovesPointerTable
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a  ; hl = pointer to evos moves data for our mon
	push hl
	; Get pointer to mon's currently-known moves.
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Level
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hl]
	ld b, a
	push bc
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1Moves
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	pop bc
	ld d, h
	ld e, l
	pop hl
	; Skip over evolution data.
.skipEvoEntriesLoop
	ld a, [hli]
	and a
	jr nz, .skipEvoEntriesLoop
	; Write list of relearnable moves, while keeping count along the way.
	; de = pointer to mon's currently-known moves
	; hl = pointer to moves data for our mon
	;  b = mon's level
	ld c, 0 ; c = count of relearnable moves
.loop
	ld a, [hli]
	and a
	jr z, .done
	cp b
	jr c, .addMove
	jr nz, .done
.addMove
	push bc
	ld a, [hli] ; move id
	ld b, a
	; Check if move is already known by our mon.
	push de
	ld a, [de]
	cp b
	jr z, .knowsMove
	inc de
	ld a, [de]
	cp b
	jr z, .knowsMove
	inc de
	ld a, [de]
	cp b
	jr z, .knowsMove
	inc de
	ld a, [de]
	cp b
	jr z, .knowsMove
.relearnableMove
	pop de
	push hl
	; Add move to the list, and update the running count.
	ld a, b
	ld b, 0
	ld hl, wMoveBuffer + 1
	add hl, bc
	ld [hl], a
	pop hl
	pop bc
	inc c
	jr .loop
.knowsMove
	pop de
	pop bc
	jr .loop
.done	


;joenote - start checking for level-0 moves
	xor a
	ld b, a	;b will act as a counter, as there can only be up to 4 level-0 moves
	call GetMonHeader ;mon id already stored earlier in wd0b5
	ld hl, wMonHMoves
.loop2
	ld a, b	;get the current loop counter into a
	cp $4
	jr nc, .done2	;if gone through 4 moves already, reached the end of the list. move to done2.
	ld a, [hl]	;load move
	and a
	jr z, .done2	;if move has id 0, list has reached the end early. move to done2.
	
	;check if the move is already in the learnable move list
	push bc
	push hl
	;c = buffer length
.buffer_loop
	ld hl, wMoveBuffer
	ld b, 0
	add hl, bc	;move to buffer at current c value
	ld b, a	;b = move id
	ld a, [hl] ; move id at buffer point
	cp b
	ld a, b	;a = move id
	jr z, .move_in_buffer
	inc c
	dec c
	jr z, .end_buffer_loop	;jump out if start of buffer is reached
	dec c	;else decrement c and loop again
	jr .buffer_loop
.move_in_buffer
	pop hl
	pop bc
	inc hl	;increment to the next level-0 move
	inc b	;increment the loop counter
	jr .loop2
.end_buffer_loop
	pop hl
	pop bc
	
	;Check if move is already known by our mon.
	push bc
	ld a, [hl] ; move id
	ld b, a
	push de
	ld a, [de]
	cp b
	jr z, .knowsMove2
	inc de
	ld a, [de]
	cp b
	jr z, .knowsMove2
	inc de
	ld a, [de]
	cp b
	jr z, .knowsMove2
	inc de
	ld a, [de]
	cp b
	jr z, .knowsMove2

	;if the move is not already known, add it to the learnable move list
	pop de
	push hl
	; Add move to the list, and update the running count.
	ld a, b
	ld b, 0
	ld hl, wMoveBuffer + 1
	add hl, bc
	ld [hl], a
	pop hl
	pop bc
	inc c
	inc hl	;increment to the next level-0 move
	inc b	;increment the loop counter
	jr .loop2
	
.knowsMove2
	pop de
	pop bc
	inc hl	;increment to the next level-0 move
	inc b	;increment the loop counter
	jr .loop2
	
.done2
	ld b, 0
	ld hl, wMoveBuffer + 1
	add hl, bc
	ld a, $ff
	ld [hl], a
	ld hl, wMoveBuffer
	ld [hl], c
	ret

PrepareEvolutionData::
	ld a, [wWhichPokemon]
	ld a, [wNameListIndex]
	ld de, wPokedexDataBuffer
	ld c, 0 ; c = count of evolution methods
	xor a
	push bc
	; Get pointer to evos moves data.
	ld a, [wWhichPokemon]
	dec a
	ld c, a
	ld b, 0
	ld hl, EvosMovesPointerTable
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a  ; hl = pointer to evos moves data for our mon
	pop bc
.loopEvoData
	ld a, [hli]
	cp 0
	jp z, .done
	cp EVOLVE_ITEM
	jp z, .loadItemData
.loadLevelUpTradeData
	ld [de], a
	inc de
	ld a, $FF ; no item
	ld [de], a
	inc de
	ld a, [hli] ; level
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc c
	inc de
	jr .loopEvoData
.loadItemData
	ld [de], a
	inc de
	ld a, [hli]; item
	ld [de], a
	inc de
	ld a, [hli] ; level
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc c
	inc de
	jr .loopEvoData
.done
	ld a, c
	ld [wMoveListCounter], a
	ret 

PrepareLevelUpMoveList:: ; I don't know how the fuck you're a single colon in shin pokered but it sure as shit doesn't work here - PvK
; Loads relearnable move list to wRelearnableMoves.
; Input: party mon index = [wWhichPokemon]
	; Get mon id.
	ld a, [wWhichPokemon]
	ld [wCurSpecies], a	;joenote - put mon id into wram for potential later usage of GetMonHeader

	ld de, wRelearnableMoves ; de = moves list
	ld c, 0 ; c = count of relearnable moves

	;joenote - start checking for level-0 moves
	xor a
	ld b, a	;b will act as a counter, as there can only be up to 4 level-0 moves
	call GetMonHeader ;mon id already stored earlier in wd0b5
	ld hl, wMonHMoves
.loop2
	ld a, b	;get the current loop counter into a
	cp $4
	jr nc, .done2	;if gone through 4 moves already, reached the end of the list. move to done2.
	ld a, [hl]	;load move
	and a
	jr z, .done2	;if move has id 0, list has reached the end early. move to done2.

	; Add move to the list, and update the running count.
	ld a, 1
	ld [de], a
	inc de

	ld a, [hl]	;load move
	ld [de], a
	inc de
	inc c
	inc hl	;increment to the next level-0 move
	inc b	;increment the loop counter
	jr .loop2
.done2
	
	push bc
	; Get pointer to evos moves data.
	ld a, [wWhichPokemon]
	dec a
	ld c, a
	ld b, 0
	ld hl, EvosMovesPointerTable
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a  ; hl = pointer to evos moves data for our mon
	pop bc

	; Skip over evolution data.
.skipEvoEntriesLoop
	ld a, [hli]
	and a
	jr nz, .skipEvoEntriesLoop
	; Write list of relearnable moves, while keeping count along the way.
	ld b, 100 ;  b = mon's level

.loop
	ld a, [hli]
	and a
	jr z, .done

	cp b
	jr c, .addMove
	jr nz, .done
.addMove
	ld [de], a
	inc de

	ld a, [hli] ; move id
	; Add move to the list, and update the running count.
	ld [de], a
	inc de
	inc c
	jr .loop
.done
	ld a, c
	ld [wMoveListCounter], a ; number of moves in the list
.debug
	ret

; shinpokerednote: ADDED: Stores the player's pokemon levels into wStartBattleLevels. 
; Used to track the levels at the beginning of battle so when evolving pokemon their learnsets can factor in multiple level-ups.
StorePKMNLevels:
	push hl
	push de
	ld a, [wPartyCount]	;1 to 6
	and a
	jr z, .doneStorePKMNLevels
	ld b, a	;use b for countdown
	ld hl, wPartyMon1Level
	ld de, wStartBattleLevels
.loopStorePKMNLevels
	ld a, [hl]
	ld [de], a	
	dec b
	jr z, .doneStorePKMNLevels
	push bc
	ld bc, wPartyMon2 - wPartyMon1
	add hl, bc
	inc de
	pop bc
	jr .loopStorePKMNLevels
.doneStorePKMNLevels
	pop de
	pop hl
	ret

INCLUDE "data/pokemon/evos_moves.asm"

