LoadWildData::
	ld a, [wCurMap]
	jr LoadWildDataCommon

LoadArbitraryWildData::
; d = map ID. D survives callfar/Bankswitch.
	ld a, d

LoadWildDataCommon:
	ld hl, WildDataPointers

	; get wild data for map in a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a       ; hl now points to wild data for current map
	ld a, [hli]
	ld [wGrassRate], a
	and a
	jr z, .NoGrassData ; if no grass data, skip to surfing data
	push hl
	ld de, wGrassMons ; otherwise, load grass data
	ld bc, $14
	rst _CopyData
	pop hl
	ld bc, $14
	add hl, bc
.NoGrassData
	ld a, [hli]
	ld [wWaterRate], a
	and a
	ret z        ; if no water data, we're done
	ld de, wWaterMons  ; otherwise, load surfing data
	ld bc, $14
	jp CopyData

INCLUDE "data/wild/grass_water.asm"
