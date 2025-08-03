SFX_Ball_Toss_Ch5:
	duty_cycle 2
	pitch_sweep 2, -7
	square_note 15, 15, 2, 1920
;	BUG: Someone forgot to close this out with pitchenvelope 0, 0
;		so the CH1 Sweep Register [ff10] will have the wrong audio settings
;		until something else plays to modify the pitch envelope.
;joenote - let's fix that
	pitch_sweep 0, 0
	sound_ret

SFX_Ball_Toss_Ch6:
	duty_cycle 2
	square_note 15, 12, 2, 1922
	sound_ret
