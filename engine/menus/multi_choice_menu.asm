; PureRGBnote: ADDED: this code lets you bring up selection lists of 2-6 entries without relying on item menu code.
; INPUT:
; [wListPointer] = address of the text list (2 bytes) (expected to be defined within this bank)
; [wMenuWatchedKeys] = which buttons should exit the menu (like A button for selecting an option)
; Should only be used to display up to 6 options
; OUTPUT: 
; [wCurrentMenuItem] = what was chosen from the menu
DisplayMultiChoiceMenu::
	xor a
	ldh [hAutoBGTransferEnabled], a ; disable auto-transfer
	ld a, 1
	ldh [hJoy7], a ; joypad state update flag
	ld a, [wStatusFlags5]
	push af
	set BIT_NO_TEXT_DELAY, a ; turn off letter printing delay
	ld [wStatusFlags5], a
	hl_deref wListPointer ; hl = address of the list
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a ; de = address of the text box drawing function to call
	push hl ; address of the start of the text we will draw later
	xor a
	ldh [hAutoBGTransferEnabled], a ; disable transfer
	ld h, d
	ld l, e
	jp hl ; function that draws the textbox

DoneDrawFunc:
	push hl
	call UpdateSprites ; disable sprites behind the text box
	xor a
	ld [wMenuWatchMovingOutOfBounds], a ; enable menu wrapping
	pop hl ; hl = coordinate of the list
	pop de ; de = address of the start of text
	call PlaceString
	ld a, 1
	ldh [hAutoBGTransferEnabled], a ; enable transfer
	call Delay3
	CheckAndResetEvent FLAG_SKIP_MULTI_CHOICE_LOADGBPAL ; todo: is this flag needed? Check if removing LoadGBPal entirely is okay.
	call z, LoadGBPal
	call HandleMenuInput
	xor a
	ldh [hJoy7], a ; joypad state update flag
	pop af
	ld [wStatusFlags5], a ; reset letter printing delay to what it was before calling this function
	ret

; multi-option menus can have 2-6 options, visually set up by the below functions

TwoOptionMenu::
	ld a, 1 ; 2-item menu (0 counts)
	ld [wListCount], a
	ld [wMaxMenuItem], a

	ld a, 8
	ld [wTopMenuItemY], a
	ld a, 5
	ld [wTopMenuItemX], a

	hlcoord 4, 7
	lb bc, 3, 14  ; height, width
	call TextBoxBorder

	hlcoord 6, 8 ; where the list will be drawn at
	jp DoneDrawFunc

TwoOptionSmallMenu::
	ld a, 1 ; 2-item menu (0 counts)
	ld [wListCount], a
	ld [wMaxMenuItem], a

	ld a, 8
	ld [wTopMenuItemY], a
	ld a, 14
	ld [wTopMenuItemX], a

	hlcoord 13, 7
	lb bc, 3, 5  ; height, width
	call TextBoxBorder

	hlcoord 15, 8 ; where the list will be drawn at
	jp DoneDrawFunc

ThreeOptionMenu::
	ld a, 2 ; 3-item menu (0 counts)
	ld [wListCount], a
	ld [wMaxMenuItem], a

	ld a, 6
	ld [wTopMenuItemY], a
	ld a, 5
	ld [wTopMenuItemX], a

	hlcoord 4, 5
	lb bc, 5, 13  ; height, width
	call TextBoxBorder

	hlcoord 6, 6 ; where the list will be drawn at
	jp DoneDrawFunc

InitThreeOptionMenuSmall::
	ld [wTopMenuItemY], a
	ld a, 2 ; 3-item menu (0 counts)
	ld [wListCount], a
	ld [wMaxMenuItem], a
	ld a, 12
	ld [wTopMenuItemX], a
	lb bc, 5, 7 ; height, width
	ret

SafariTypeOptions::
	dw TwoOptionMenu
	db "CLASSIC"
	next "FREE ROAM@"

ClassicText:
	db "CLASSIC@"

TitleText:
	db "TITLE@"
