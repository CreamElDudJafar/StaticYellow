DrawItemCountBox::
	hlcoord 4, 0
	lb bc, 1, 14
	call TextBoxBorder
	hlcoord 5, 1
	ld de, ItemsText
	call PlaceString
	ld a, [wNumBagItems]
	and $7f
	cp 10
	jr c, .singleDigitCount
; two digit number
	cp 30
	jr c, .sub20DigitCount
	sub 30
	hlcoord 14, 1
	ld [hl], "3"
	add "0"
	jr .next2
.sub20DigitCount
	cp 20
	jr c, .sub10DigitCount
	sub 20
	hlcoord 14, 1
	ld [hl], "2"
	add "0"
	jr .next2
.sub10DigitCount
	sub 10
	hlcoord 14, 1
	ld [hl], "1"
	add "0"
	jr .next2
.singleDigitCount
	dec a
	add "1"
.next2
	ldcoord_a 15, 1
	hlcoord 16, 1
	ld de, NumItemsText
	call PlaceString
	ret

NumItemsText:
	db "/50@"

ItemsText:
	db "ITEMs@"


DrawStoredItemCountBox::
	hlcoord 4, 0
	lb bc, 1, 14
	call TextBoxBorder
	hlcoord 5, 1
	ld de, PCItemsText
	call PlaceString
	ld a, [wNumBoxItems]
	and $7f
	cp 10
	jr c, .singleDigitCount
; two digit number
	cp 50
	jr c, .sub40DigitCount
	sub 50
	hlcoord 14, 1
	ld [hl], "5"
	add "0"
	jr .next2
.sub40DigitCount
	cp 40
	jr c, .sub30DigitCount
	sub 40
	hlcoord 14, 1
	ld [hl], "4"
	add "0"
	jr .next2
.sub30DigitCount
	cp 30
	jr c, .sub20DigitCount
	sub 30
	hlcoord 14, 1
	ld [hl], "3"
	add "0"
	jr .next2
.sub20DigitCount
	cp 20
	jr c, .sub10DigitCount
	sub 20
	hlcoord 14, 1
	ld [hl], "2"
	add "0"
	jr .next2
.sub10DigitCount
	sub 10
	hlcoord 14, 1
	ld [hl], "1"
	add "0"
	jr .next2
.singleDigitCount
	dec a
	add "1"
.next2
	ldcoord_a 15, 1
	hlcoord 16, 1
	ld de, NumStoredItemsText
	call PlaceString
	ret

PCItemsText:
	db "PC ITEMs@"

NumStoredItemsText:
	db "/50@"