AlreadyOnThatFloor:
	ld hl, AlreadyOnThatFloorText
	rst _PrintText
	jr DisplayElevatorFloorMenu.menuDisplayLoop

DisplayElevatorFloorMenu:
	ld a, [wListScrollOffset]
	push af ; preserve the list scroll offset so our item list offset is remembered
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	ld [wPrintItemPrices], a
.menuDisplayLoop:
	ld hl, WhichFloorText
	rst _PrintText
; draw box for current elevator floor
	call .printCurrentFloor
	ld hl, wItemList
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	ld a, SPECIALLISTMENU
	ld [wListMenuID], a
	call DisplayListMenuID
	jr c, .done ; if cancel was selected
	ld hl, wElevatorWarpMaps
	ld a, [wWhichPokemon]
	add a
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
;;;;;;;;;; PureRGBnote: CHANGED: elevators will tell you if you selected the floor you are currently on and will track how far you will travel
	ld a, [wWarpedFromWhichMap] ; map you were on before entering the elevator
	cp c
	jr z, AlreadyOnThatFloor

	push bc
	ld hl, wElevatorWarpMaps + 1
	ld de, 2
	call IsInArray
	ld a, [wWhichPokemon] ; which index did we pick in the list
	ld c, a
	sub b
	jr nc, .goingUp
	; going down
	ld a, b ; which index we are on currently
	sub c
.goingUp
	ld [wElevatorTravelDistance], a
	pop bc
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_USED_ELEVATOR, [hl]

	ld hl, wWarpEntries
	call .UpdateWarp
	call .UpdateWarp

	ld a, c
	ld [wWarpedFromWhichMap], a
	ld a, b ; destination warp id
	ld [wWarpedFromWhichWarp], a
.done
	xor a
	ld [wCurrentMenuItem], a
	pop af
	ld [wListScrollOffset], a ; restore list scroll offset so item list index is remembered
	ret
	; fall through
.UpdateWarp
	inc hl
	inc hl
	ld a, b
	ld [hli], a ; destination warp ID
	ld a, c
	ld [hli], a ; destination map ID
	ret

.printCurrentFloor
	hlcoord 4, 0
	lb bc, 1, 14
	call TextBoxBorder

	hlcoord 5, 1
	ld de, CurrentFloorText
	call PlaceString

	ld hl, wElevatorWarpMaps + 1
	ld a, [wItemList]
	ld b, a
	ld c, 0
	ld a, [wWarpedFromWhichMap]
	ld d, a

.loopFindFloor
	ld a, [hli]
	inc hl
	cp d
	jr z, .foundMap
	inc c
	dec b
	jr nz, .loopFindFloor

	xor a
	ld c, a

.foundMap
	ld b, 0
	ld hl, wItemList + 1
	add hl, bc
	ld a, [hl]
	ld [wNamedObjectIndex], a
	call GetFloorName
	hlcoord 14, 1
	ld de, wNameBuffer
	call PlaceString
	ret


WhichFloorText:
	text_far _WhichFloorText
	text_end

AlreadyOnThatFloorText:
	text_far _AlreadyOnThatFloor
	text_end

CurrentFloorText:
	db "Current: @"


GetFloorName::
	ld a, [wNamedObjectIndex]
	sub FLOOR_B2F
	ld hl, FloorNames
	ld bc, 4
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wNameBuffer
	push hl
	call CopyString
	pop de
	ret

FloorNames:
	table_width 4
	db "B2F@"
	db "B1F@"
	db "1F@@"
	db "2F@@"
	db "3F@@"
	db "4F@@"
	db "5F@@"
	db "6F@@"
	db "7F@@"
	db "8F@@"
	db "9F@@"
	db "10F@"
	db "11F@"
	db "B4F@"
	assert_table_length NUM_FLOORS