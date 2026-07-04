DrawItemCountBox::
	hlcoord 4, 0
	lb bc, 1, 14
	call TextBoxBorder

	hlcoord 5, 1
	ld de, ItemsText
	call PlaceString

	ld a, [wNumBagItems]
	and $7f
	ld [wBuffer], a
	hlcoord 14, 1
	ld de, wBuffer
	lb bc, 1, 2
	call PrintNumber

	hlcoord 16, 1
	ld de, NumItemsText
	call PlaceString
	ret

ItemsText:
	db "ITEMs@"

NumItemsText:
	db "/60@"


DrawStoredItemCountBox::
	hlcoord 4, 0
	lb bc, 1, 14
	call TextBoxBorder

	hlcoord 5, 1
	ld de, PCItemsText
	call PlaceString

	ld a, [wNumBoxItems]
	and $7f
	ld [wBuffer], a
	hlcoord 14, 1
	ld de, wBuffer
	lb bc, 1, 2
	call PrintNumber

	hlcoord 16, 1
	ld de, NumStoredItemsText
	call PlaceString
	ret

PCItemsText:
	db "PC ITEMs@"

NumStoredItemsText:
	db "/50@"