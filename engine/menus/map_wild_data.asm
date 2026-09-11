DEF WILD_DATA_GRASS EQU 0
DEF WILD_DATA_WATER EQU 1
DEF WILD_DATA_SUPER_ROD EQU 2
DEF WILD_DATA_GOOD_ROD EQU 3
DEF WILD_DATA_OLD_ROD EQU 4

TownMapLocationHasWildData::
; d = selected Town Map map ID.
; Carry set if Grass, Surf, or Super Rod data exists. This routine never
; clears/reloads the Town Map display, so A on a no-data location is a true no-op.
	ld a, d
	ld [wCurTownMapWildDataMap], a
	ld [wCurTownMapInternalWildDataMap], a
	xor a
	ld [wCurTownMapWildDataFloorIndex], a
	ld [wCurTownMapMaxWildDataFloorIndex], a
	call NormalizeTownMapWildDataMap
	call GetWildDataMaxFloor
	call LoadCurrentWildDataFloorMap
	call LoadTownMapWildData
	call TownMapHasAnyWildData
	push af
	callfar LoadWildData
	pop af
	ret

ShowMapWildEncounters::
; d = map selected on the Town Map. D survives callfar/Bankswitch.
	ld a, d
	ld [wCurTownMapWildDataMap], a
	ld [wCurTownMapInternalWildDataMap], a
	xor a
	ld [wCurTownMapWildDataFloorIndex], a
	ld [wCurTownMapMaxWildDataFloorIndex], a
	call NormalizeTownMapWildDataMap
	call GetWildDataMaxFloor
	call LoadCurrentWildDataFloorMap
	call LoadTownMapWildData
	call TownMapHasAnyWildData
	jp nc, .noWildData

	xor a
	ld [wTownMapSpriteBlinkingEnabled], a
	call ClearSprites
	call ClearScreen
	call LoadFontTilePatterns
	ld de, PokeballTileGraphics
	ld hl, vChars2 tile $72
	lb bc, BANK(PokeballTileGraphics), 1
	call CopyVideoData
	ld hl, vSprites tile $D2
	ld de, BattleHudTiles1 + 1 * LEN_1BPP_TILE
	lb bc, BANK(BattleHudTiles1), 1
	call CopyVideoDataDouble
	; $D0 = up/down, $D1 = left/right.
	ld hl, vSprites tile $D0
	ld de, WildDataArrows
	lb bc, BANK(WildDataArrows), 2
	call CopyVideoDataDouble
	; Use the same red/yellow/black CGB palette as the Pokédex caught-ball
	farcall SendPokeballPal
	; wNameBuffer still contains the highlighted Town Map location name here.
	; Draw it once before GetMonName begins reusing wNameBuffer.
	hlcoord 1, 1
	ld de, wNameBuffer
	call PlaceString
	; Static control text never changes while this viewer is open.
	hlcoord 1, 17
	ld de, WildDataControlsText
	call PlaceString

	; Pick the first available encounter type only when the viewer initially opens.
	call ChooseInitialWildDataType
	jr .loopPrint

.loopReloadFloor
	; A floor change should preserve Grass/Surf/Super Rod when that encounter
	; type also exists on the new floor.
	call LoadTownMapWildData
	ld a, [wCurTownMapWildDataType]
	call FindSubsequentWildDataType
	jr c, .loopPrint
	; If the new floor lacks the current type, fall back to its first available one.
	call ChooseInitialWildDataType

.loopPrint
	; Build the entire replacement page in wTileMap while automatic BG transfer
	; is disabled. Several helpers below (GetMonName, Pokédex flag checks, number
	; printing) take long enough to cross V-blanks; allowing the normal transfer
	; during those calls exposes a half-updated row for a frame when cycling
	; floors/types (most visibly the caught ball/name/level). Re-enable transfer
	; only after the complete page is ready, like the game's list menus do.
	xor a
	ldh [hAutoBGTransferEnabled], a

	; Do not blank all ten rows before drawing the replacement list. Keeping the
	; old rows in the WRAM tilemap until their replacements are ready also avoids
	; a full-list flash.
	hlcoord 1, 3
	ld de, WildPokemonText
	call PlaceString
	call PrintCurrentWildDataType
	call PrintCurrentFloor
	call GetWildMonDataSource
	; Update percentages first, then replace the corresponding encounter rows.
	call PrintWildProbabilities
	call GetWildMonDataSource
	call PrintWildMonNamesAndLevels
	call ClearUnusedTownMapWildRows
	ld a, 1
	ldh [hAutoBGTransferEnabled], a
	; Give the newly completed tilemap a chance to transfer before accepting
	; another floor/type input.
	call Delay3

.inputLoop
	call JoypadLowSensitivity
	ldh a, [hJoy5]
	bit BIT_B_BUTTON, a
	jr nz, .exit
	bit BIT_D_RIGHT, a
	jr nz, .right
	bit BIT_D_LEFT, a
	jr nz, .left
	bit BIT_D_DOWN, a
	jr nz, .down
	bit BIT_D_UP, a
	jr nz, .up
	jr .inputLoop

.right
	call CheckHasMultipleWildDataTypes
	jr z, .inputLoop
	ld a, SFX_LEDGE
	call PlaySound
	call FindNextWildDataType
	jr .loopPrint

.left
	call CheckHasMultipleWildDataTypes
	jr z, .inputLoop
	ld a, SFX_LEDGE
	call PlaySound
	call FindPrevWildDataType
	jr .loopPrint

.down
	call CheckMapHasMultipleFloors
	jr nc, .inputLoop
	ld a, SFX_TINK
	call PlaySound
	call FindNextWildDataFloor
	jp .loopReloadFloor

.up
	call CheckMapHasMultipleFloors
	jr nc, .inputLoop
	ld a, SFX_TINK
	call PlaySound
	call FindPrevWildDataFloor
	jp .loopReloadFloor

.exit
; Restore overworld encounter data. The Town Map caller restores the highlighted
; Town Map entry and rebuilds the Town Map screen.
	callfar LoadWildData
	ret

.noWildData
; Safety fallback. The Town Map caller normally filters these locations first.
	callfar LoadWildData
	ret

LoadCurrentMapWildDataFar:
	callfar LoadWildData
	ret

NormalizeTownMapWildDataMap:
; Keep TownMapOrder unchanged. Convert its representative indoor maps to
; the canonical map used by the encounter viewer's floor tables.
	ld a, [wCurTownMapWildDataMap]
	cp ROCK_TUNNEL_POKECENTER
	jr z, .rockTunnel
	cp POKEMON_TOWER_2F
	jr z, .pokemonTower
	cp SEAFOAM_ISLANDS_B1F
	jr z, .seafoam
	cp VICTORY_ROAD_3F
	jr nz, .store
	ld a, VICTORY_ROAD_1F
	jr .store
.rockTunnel
	ld a, ROCK_TUNNEL_1F
	jr .store
.pokemonTower
	ld a, POKEMON_TOWER_3F
	jr .store
.seafoam
	ld a, SEAFOAM_ISLANDS_1F
.store
	ld [wCurTownMapWildDataMap], a
	ld [wCurTownMapInternalWildDataMap], a
	ret

LoadTownMapWildData:
	; Clear encounter-presence state first so a previous map can never leak data.
	xor a
	ld [wGrassRate], a
	ld [wWaterRate], a
	ld [wTownMapRodCount], a
	ld a, [wCurTownMapInternalWildDataMap]
	ld d, a
	callfar LoadArbitraryWildData
	ret

TownMapHasAnyWildData:
	call MapHasGrassEncounters
	ret c
	call MapHasWaterEncounters
	ret c
	call MapHasSuperRodEncounters
	ret c
	call MapHasGoodRodEncounters
	ret c
	jp MapHasOldRodEncounters

ChooseInitialWildDataType:
	call MapHasGrassEncounters
	ld a, WILD_DATA_GRASS
	jr c, .got
	call MapHasWaterEncounters
	ld a, WILD_DATA_WATER
	jr c, .got
	call MapHasSuperRodEncounters
	ld a, WILD_DATA_SUPER_ROD
	jr c, .got
	call MapHasGoodRodEncounters
	ld a, WILD_DATA_GOOD_ROD
	jr c, .got
	call MapHasOldRodEncounters
	ld a, WILD_DATA_OLD_ROD
.got
	ld [wCurTownMapWildDataType], a
	ret

MapHasGrassEncounters:
	ld a, [wGrassRate]
	and a
	ret z
	scf
	ret

MapHasWaterEncounters:
	ld a, [wWaterRate]
	and a
	ret z
	scf
	ret

MapHasSuperRodEncounters:
	ld a, WILD_DATA_SUPER_ROD
	jr MapHasRodEncounters

MapHasGoodRodEncounters:
	ld a, WILD_DATA_GOOD_ROD
	jr MapHasRodEncounters

MapHasOldRodEncounters:
	ld a, WILD_DATA_OLD_ROD
MapHasRodEncounters:
; callfar/rst _Bankswitch does not preserve A: A becomes the destination bank
; before the far routine runs. Pass rod type in E and map ID in D instead.
	ld e, a
	ld a, [wCurTownMapInternalWildDataMap]
	ld d, a
	callfar TownMapRodTypeHasEncounters
	ret

CheckHasMultipleWildDataTypes:
; B counts the number of encounter types available on this map.
; The rod lookup uses IsInArray, which also uses B internally, so preserve BC
; around each rod check or every rod lookup would corrupt this count and make
; the left/right arrows appear on maps with only one encounter type.
	ld b, 0
	call MapHasGrassEncounters
	jr nc, .water
	inc b
.water
	call MapHasWaterEncounters
	jr nc, .superRod
	inc b
.superRod
	push bc
	call MapHasSuperRodEncounters
	pop bc
	jr nc, .goodRod
	inc b
.goodRod
	push bc
	call MapHasGoodRodEncounters
	pop bc
	jr nc, .oldRod
	inc b
.oldRod
	push bc
	call MapHasOldRodEncounters
	pop bc
	jr nc, .done
	inc b
.done
	dec b
	ret

FindNextWildDataType:
	ld a, [wCurTownMapWildDataType]
	inc a
	cp WILD_DATA_OLD_ROD + 1
	jr nz, .got
	xor a
.got
	call FindSubsequentWildDataType
	ret c
	jr FindNextWildDataType

FindPrevWildDataType:
	ld a, [wCurTownMapWildDataType]
	dec a
	cp $ff
	jr nz, .got
	ld a, WILD_DATA_OLD_ROD
.got
	call FindSubsequentWildDataType
	ret c
	jr FindPrevWildDataType

FindSubsequentWildDataType:
	; Store the candidate BEFORE checking it. MapHas* routines load rates/counts
	; into A, so the current type must already be saved.
	ld [wCurTownMapWildDataType], a
	cp WILD_DATA_GRASS
	jp z, MapHasGrassEncounters
	cp WILD_DATA_WATER
	jp z, MapHasWaterEncounters
	cp WILD_DATA_SUPER_ROD
	jp z, MapHasSuperRodEncounters
	cp WILD_DATA_GOOD_ROD
	jp z, MapHasGoodRodEncounters
	jp MapHasOldRodEncounters

GetWildMonDataSource:
	ld a, [wCurTownMapWildDataType]
	cp WILD_DATA_GRASS
	ld de, wGrassMons
	ret z
	cp WILD_DATA_WATER
	ld de, wWaterMons
	ret z
	; Rod data is copied on demand into one shared, safe scratch buffer.
	; Pass the type in E because callfar clobbers A while switching banks.
	ld e, a
	ld a, [wCurTownMapInternalWildDataMap]
	ld d, a
	callfar CopyTownMapCurrentRodEncounters
	ld de, wTownMapRodMons
	ret

ClearTownMapWildDataArea:
	; Clear only the encounter rows. Keep the title/header and B:BACK row intact
	; while cycling types/floors so they do not visibly flash.
	hlcoord 0, 6
	lb bc, 10, 20
	jp ClearScreenArea

PrintCurrentWildDataType:
	; Clear just the type prompt line without disturbing the encounter rows.
	hlcoord 0, 4
	lb bc, 1, 12
	call ClearScreenArea

	call CheckHasMultipleWildDataTypes
	hlcoord 0, 4
	jr z, .noArrows
	ld [hl], $D1 ; left/right arrows
.noArrows

	hlcoord 2, 4
	ld a, [wCurTownMapWildDataType]
	cp WILD_DATA_GRASS
	jr nz, .notGrass
	ld de, WildDataGrassText
	ld a, [wCurTownMapWildDataMap]
	cp FIRST_INDOOR_MAP
	jr c, .print
	cp SAFARI_ZONE_EAST
	jr z, .print
	cp VIRIDIAN_FOREST
	jr z, .print
	ld de, WildDataWalkingText
	jr .print
.notGrass
	ld a, [wCurTownMapWildDataType]
	cp WILD_DATA_WATER
	ld de, WildDataSurfText
	jr z, .print
	cp WILD_DATA_SUPER_ROD
	ld de, WildDataSuperRodText
	jr z, .print
	cp WILD_DATA_GOOD_ROD
	ld de, WildDataGoodRodText
	jr z, .print
	ld de, WildDataOldRodText
.print
	jp PlaceString

PrintWildMonNamesAndLevels:
	; col 0 caught ball, col 2 name, col 12 compact Lv tile,
	; cols 13-15 level, col 16 blank, cols 17-19 probability.
	hlcoord 0, 6
	ld a, [wCurTownMapWildDataType]
	cp WILD_DATA_SUPER_ROD
	jr nc, .rodCount
	ld b, 10
	jr .loop
.rodCount
	ld a, [wTownMapRodCount]
	ld b, a
.loop
	push bc
	push hl

	; Read level/species pair. Do not blank the whole row first: overwrite the
	; replacement data in place so the old row remains visible until each new
	; field is ready.
	ld a, [de]
	push af ; preserve level across owned/name routines
	inc de
	ld a, [de]

	; Reset only the caught-icon cell, then draw the ball if this species is owned.
	ld [hl], " "
	; Do not preserve the species with PUSH/POP AF here: POP AF would restore
	; the old flags and destroy the carry result returned by the owned check.
	call IsTownMapWildMonCaught
	jr nc, .notCaught
	ld [hl], $72
.notCaught

	; Reload the species byte after the flag check. DE is preserved by
	; IsTownMapWildMonCaught.
	ld a, [de]

	; Name begins two columns in. GetMonName must run before the seen/owned
	; checks convert the named-object/Pokédex working byte.
	inc hl
	inc hl
	ld [wNamedObjectIndex], a
	push de
	push bc
	call GetMonName
	pop bc
	; Town Map encounter names are always visible, whether seen or unseen.
	; Pad wNameBuffer itself to a fixed 10-character field before printing.
	; This overwrites any leftover letters from a previous longer species name
	; without relying on PlaceString register side effects.
	call PadTownMapMonName
	ld de, wNameBuffer
	call PlaceString
	pop de
	pop af ; restore the original encounter level
	ld [wTownMapWildDataPrintValue], a
	pop hl
	push hl
	ld bc, 12
	add hl, bc
	ld [hl], $D2
	inc hl
	; Clear all three level digit cells first so shorter levels never inherit
	; stale digits from L100/L80.
	ld [hl], " "
	inc hl
	ld [hl], " "
	inc hl
	ld [hl], " "
	dec hl
	dec hl

	push de
	ld de, wTownMapWildDataPrintValue
	lb bc, 1, 3
	call PrintNumber
	pop de

.levelDone
	pop hl

	ld bc, SCREEN_WIDTH
	add hl, bc
	inc de
	pop bc
	dec b
	jr nz, .loop
	ret


PadTownMapMonName:
; Pokemon names are at most 10 characters plus '@'. Replace the terminator
; with spaces through character 10, then terminate at byte 11. This makes
; every displayed name field exactly 10 tiles wide and prevents stale tails.
	push hl
	push bc
	ld hl, wNameBuffer
	ld b, 10
.findEnd
	ld a, [hl]
	cp "@"
	jr z, .pad
	inc hl
	dec b
	jr nz, .findEnd
	; A full 10-character name already has its terminator in byte 11.
	jr .done
.pad
	ld [hl], " "
	inc hl
	dec b
	jr nz, .pad
	ld [hl], "@"
.done
	pop bc
	pop hl
	ret


ClearUnusedTownMapWildRows:
	call GetCurrentWildDataRowCount
	cp 10
	ret nc
	ld b, a

	; Move HL to the first unused encounter row.
	hlcoord 0, 6
	ld de, SCREEN_WIDTH
.skipUsed
	ld a, b
	and a
	jr z, .clear
	add hl, de
	dec b
	jr .skipUsed

.clear
	call GetCurrentWildDataRowCount
	ld b, a
	ld a, 10
	sub b
	ld b, a
	ld c, SCREEN_WIDTH
	jp ClearScreenArea

GetCurrentWildDataRowCount:
	ld a, [wCurTownMapWildDataType]
	cp WILD_DATA_GRASS
	jr z, .normal
	cp WILD_DATA_WATER
	jr z, .normal
	cp WILD_DATA_SUPER_ROD
	jr c, .normal
	ld a, [wTownMapRodCount]
	ret
.normal
	ld a, 10
	ret


IsTownMapWildMonCaught:
	push hl
	ld hl, wPokedexOwned
	; fall through
TownMapWildMonFlagCheck:
	push de
	push bc
	push hl
	ld [wPokedexNum], a
	farcall IndexToPokedex
	ld a, [wPokedexNum]
	pop hl
	dec a
	ld c, a
	ld b, FLAG_TEST
	predef FlagActionPredef
	ld a, c
	and a
	jr z, .notSet
	scf
.notSet
	pop bc
	pop de
	pop hl
	ret


PrintWildProbabilities:
	ld a, [wCurTownMapWildDataType]
	cp WILD_DATA_GRASS
	jr z, .normal
	cp WILD_DATA_WATER
	jr z, .normal

	call GetCurrentWildDataRowCount
	ld b, a
	cp 1
	ld de, Rod1ProbabilityText
	jr z, .loop
	cp 2
	ld de, Rod2ProbabilityText
	jr z, .loop
	cp 3
	ld de, Rod3ProbabilityText
	jr z, .loop
	ld de, Rod4ProbabilityText
	jr .loop

.normal
	ld de, NormalWildProbabilityText
	ld b, 10

.loop
	; Each entry is exactly 4 tiles wide.
	hlcoord 16, 6
.rowLoop
	push bc
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hl], a
	ld bc, SCREEN_WIDTH - 3
	add hl, bc
	pop bc
	dec b
	jr nz, .rowLoop
	ret


NormalWildProbabilityText:
	db " 20%"
	db " 20%"
	db " 15%"
	db " 10%"
	db " 10%"
	db " 10%"
	db "  5%"
	db "  5%"
	db "  4%"
	db "  1%"

Rod1ProbabilityText:
	db "100%"

Rod2ProbabilityText:
	db " 50%"
	db " 50%"

Rod3ProbabilityText:
	db " 34%"
	db " 33%"
	db " 33%"

Rod4ProbabilityText:
	db " 25%"
	db " 25%"
	db " 25%"
	db " 25%"


CheckMapHasMultipleFloors:
	ld a, [wCurTownMapWildDataMap]
	ld hl, MultiFloorWildDataMaps
	ld de, 3
	jp IsInArray

GetWildDataFloorList:
	ld a, [wCurTownMapWildDataMap]
	ld hl, MultiFloorWildDataMaps
	ld de, 3
	call IsInArray
	ret nc
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	scf
	ret

GetWildDataMaxFloor:
	call GetWildDataFloorList
	ret nc
	ld b, 0
.loop
	ld a, [hli]
	cp $ff
	jr z, .done
	inc hl ; floor-name pointer low
	inc hl ; floor-name pointer high
	inc b
	jr .loop
.done
	ld a, b
	ld [wCurTownMapMaxWildDataFloorIndex], a
	ret

GetCurrentWildDataFloor:
	call GetWildDataFloorList
	ret nc
	ld a, [wCurTownMapWildDataFloorIndex]
	ld bc, 3
	call AddNTimes
	scf
	ret

FindNextWildDataFloor:
	ld a, [wCurTownMapWildDataFloorIndex]
	inc a
	ld b, a
	ld a, [wCurTownMapMaxWildDataFloorIndex]
	cp b
	ld a, b
	jr nz, .store
	xor a
.store
	ld [wCurTownMapWildDataFloorIndex], a
	jr LoadCurrentWildDataFloorMap

FindPrevWildDataFloor:
	ld a, [wCurTownMapWildDataFloorIndex]
	and a
	jr nz, .decrement
	ld a, [wCurTownMapMaxWildDataFloorIndex]
.decrement
	dec a
	ld [wCurTownMapWildDataFloorIndex], a
LoadCurrentWildDataFloorMap:
	call GetCurrentWildDataFloor
	ret nc
	ld a, [hl]
	ld [wCurTownMapInternalWildDataMap], a
	ret

PrintCurrentFloor:
	; Clear only the floor/area header region.
	hlcoord 12, 3
	lb bc, 2, 8
	call ClearScreenArea
	call CheckMapHasMultipleFloors
	ret nc
	hlcoord 12, 3
	ld [hl], $D0
	hlcoord 14, 3
	ld a, [wCurTownMapWildDataMap]
	cp SAFARI_ZONE_EAST
	ld de, WildDataAreaText
	jr z, .printLabel
	ld de, WildDataFloorText
.printLabel
	call PlaceString

	call GetCurrentWildDataFloor
	ret nc
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld d, h
	ld e, l
	hlcoord 15, 4
	; "CENTER" is one character longer than the other Safari Zone area names.
	; Shift only CENTER one tile left so the final R stays on the same row.
	ld a, [wCurTownMapInternalWildDataMap]
	cp SAFARI_ZONE_CENTER
	jr nz, .placeFloorName
	dec hl
.placeFloorName
	jp PlaceString


MultiFloorWildDataMaps:
	dbw MT_MOON_1F, WildMonFloorsMtMoon
	dbw ROCK_TUNNEL_1F, WildMonFloorsRockTunnel
	dbw POKEMON_TOWER_3F, WildMonFloorsPokemonTower
	dbw SAFARI_ZONE_EAST, WildMonFloorsSafariZone
	dbw SEAFOAM_ISLANDS_1F, WildMonFloorsSeafoam
	dbw POKEMON_MANSION_1F, WildMonFloorsPokemonMansion
	dbw VICTORY_ROAD_1F, WildMonFloorsVictoryRoad
	dbw CERULEAN_CAVE_1F, WildMonFloorsCeruleanCave
	db -1

MACRO wild_floor
	dbw \1, \2
ENDM

WildMonFloorsMtMoon:
	wild_floor MT_MOON_1F, Floor1FText
	wild_floor MT_MOON_B1F, FloorB1FText
	wild_floor MT_MOON_B2F, FloorB2FText
	db -1
WildMonFloorsRockTunnel:
	wild_floor ROCK_TUNNEL_1F, Floor1FText
	wild_floor ROCK_TUNNEL_B1F, FloorB1FText
	db -1
WildMonFloorsPokemonTower:
; 1F and 2F have a 0 encounter rate in Static Yellow, so they are omitted.
; The actual wild floors are 3F-8F.
	wild_floor POKEMON_TOWER_3F, Floor3FText
	wild_floor POKEMON_TOWER_4F, Floor4FText
	wild_floor POKEMON_TOWER_5F, Floor5FText
	wild_floor POKEMON_TOWER_6F, Floor6FText
	wild_floor POKEMON_TOWER_7F, Floor7FText
	wild_floor POKEMON_TOWER_8F, Floor8FText
	db -1
WildMonFloorsSafariZone:
	wild_floor SAFARI_ZONE_EAST, SafariEastText
	wild_floor SAFARI_ZONE_CENTER, SafariCenterText
	wild_floor SAFARI_ZONE_NORTH, SafariNorthText
	wild_floor SAFARI_ZONE_WEST, SafariWestText
	db -1
WildMonFloorsSeafoam:
	wild_floor SEAFOAM_ISLANDS_1F, Floor1FText
	wild_floor SEAFOAM_ISLANDS_B1F, FloorB1FText
	wild_floor SEAFOAM_ISLANDS_B2F, FloorB2FText
	wild_floor SEAFOAM_ISLANDS_B3F, FloorB3FText
	wild_floor SEAFOAM_ISLANDS_B4F, FloorB4FText
	db -1
WildMonFloorsPokemonMansion:
	wild_floor POKEMON_MANSION_1F, Floor1FText
	wild_floor POKEMON_MANSION_2F, Floor2FText
	wild_floor POKEMON_MANSION_3F, Floor3FText
	wild_floor POKEMON_MANSION_B1F, FloorB1FText
	db -1
WildMonFloorsVictoryRoad:
	wild_floor VICTORY_ROAD_1F, Floor1FText
	wild_floor VICTORY_ROAD_2F, Floor2FText
	wild_floor VICTORY_ROAD_3F, Floor3FText
	db -1
WildMonFloorsCeruleanCave:
	wild_floor CERULEAN_CAVE_1F, Floor1FText
	wild_floor CERULEAN_CAVE_2F, Floor2FText
	wild_floor CERULEAN_CAVE_B1F, FloorB1FText
	db -1

WildPokemonText:
	db "WILD <PKMN>:@"
WildDataGrassText:
	db "GRASS@"
WildDataWalkingText:
	db "WALKING@"
WildDataSurfText:
	db "SURF@"
WildDataSuperRodText:
	db "SUPER ROD@"
WildDataGoodRodText:
	db "GOOD ROD@"
WildDataOldRodText:
	db "OLD ROD@"
WildDataFloorText:
	db "FLOOR:@"
WildDataAreaText:
	db "AREA:@"
WildDataControlsText:
	db "B:BACK@"
Floor1FText: db "1F@"
Floor2FText: db "2F@"
Floor3FText: db "3F@"
Floor4FText: db "4F@"
Floor5FText: db "5F@"
Floor6FText: db "6F@"
Floor7FText: db "7F@"
Floor8FText: db "8F@"
FloorB1FText: db "B1F@"
FloorB2FText: db "B2F@"
FloorB3FText: db "B3F@"
FloorB4FText: db "B4F@"
SafariEastText: db "EAST@"
SafariCenterText: db "CENTER@"
SafariNorthText: db "NORTH@"
SafariWestText: db "WEST@"


WildDataArrows:
	INCBIN "gfx/town_map/wild_data_arrows.1bpp"
