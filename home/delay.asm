DelayFrames::
; wait c frames
	rst _DelayFrame
	dec c
	jr nz, DelayFrames
	ret

PlaySoundWaitForCurrent::
	push af
	call WaitForSoundToFinish
	pop af
	rst _PlaySound
	ret

; Wait for sound to finish playing
WaitForSoundToFinish::
;	ld a, [wLowHealthAlarm]
;	and $80
;joenote - more adjustments for the modified low HP alarm
	ld a, [wLowHealthTonePairs]
	bit BIT_LOW_HEALTH_ALARM, a

	ret nz
	push hl
.waitLoop
	ld hl, wChannelSoundIDs + CHAN5
	xor a
	or [hl]
	inc hl
	or [hl]
	inc hl
	inc hl
	or [hl]
	and a
	jr nz, .waitLoop
	pop hl
	ret
