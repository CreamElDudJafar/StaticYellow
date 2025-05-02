; Boolean checks
DEF FALSE EQU 0
DEF TRUE  EQU 1

; flag operations
	const_def
	const FLAG_RESET ; 0
	const FLAG_SET   ; 1
	const FLAG_TEST  ; 2

;;;;;;;;;; PureRGBnote: constants for indicating which type of safari game the player is currently playing
DEF SAFARI_TYPE_CLASSIC EQU 0
DEF SAFARI_TYPE_FREE_ROAM EQU 1
;;;;;;;;;;

	const_def
	const WALKING ; 0
	const BIKING  ; 1
	const SURFING ; 2
;;;;;;;;;;

;;;;;;;;;; PureRGBnote: ADDED: pokedex flags

	const_def
	const BIT_POKEDEX_DATA_DISPLAY_TYPE    ; 0
	const BIT_POKEDEX_WHICH_SPRITE_SHOWING ; 1 
	const BIT_VIEWING_POKEDEX              ; 2
;;;;;;;;;;
