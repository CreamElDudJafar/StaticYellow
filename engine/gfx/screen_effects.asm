; inverts the BGP for 4 (6 on CGB due to lag) frames
ChangeBGPalColor0_4Frames:
	call GetPredefRegisters ; leftover of red/blue, has no use here
	ldh a, [rBGP]
	xor $ff
	ldh [rBGP], a
	call UpdateGBCPal_BGP
	ld c, 4
	rst _DelayFrames
	ldh a, [rBGP]
	xor $ff
	ldh [rBGP], a
	call UpdateGBCPal_BGP
	ret

PredefShakeScreenVertically:
; Moves the window down and then back in a sequence of progressively smaller
; numbers of pixels, starting at b.
	call GetPredefRegisters
	ld a, 1
	ld [wDisableVBlankWYUpdate], a
	xor a
.loop
	ldh [hMutateWY], a
	call .MutateWY
	call .MutateWY
	dec b
	ld a, b
	jr nz, .loop
	xor a
	ld [wDisableVBlankWYUpdate], a
	ret

.MutateWY
	ldh a, [hMutateWY]
	xor b
	ldh [hMutateWY], a
	ldh [rWY], a
	ld c, 3
	jp DelayFrames

PredefShakeScreenHorizontally:
; Moves the window right and then back in a sequence of progressively smaller
; numbers of pixels, starting at b.
	call GetPredefRegisters
	xor a
.loop
	ldh [hMutateWX], a
	call .MutateWX
	ld c, 1
	rst _DelayFrames
	call .MutateWX
	dec b
	ld a, b
	jr nz, .loop

; restore normal WX
	ld a, 7
	ldh [rWX], a
	ret

.MutateWX
	ldh a, [hMutateWX]
	xor b
	ldh [hMutateWX], a
	bit 7, a ; negative?
	jr z, .skipZeroing
	xor a ; zero a if it's negative
.skipZeroing
	add 7
	ldh [rWX], a
	ld c, 4
	jp DelayFrames
