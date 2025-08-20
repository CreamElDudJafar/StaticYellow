; This function is used to wait a short period after printing a letter to the
; screen unless the player presses the A/B button or the delay is turned off
; through the [wStatusFlags5] or [wLetterPrintingDelayFlags] flags.
PrintLetterDelay::
	ld a, [wStatusFlags5]
	bit BIT_NO_TEXT_DELAY, a
	ret nz
	ld a, [wLetterPrintingDelayFlags]
	bit BIT_TEXT_DELAY, a
	ret z
	push hl
	push de
	push bc
	push af
	callfar PrintLetterDelay_
	pop af
	pop bc
	pop de
	pop hl
	ret
