BluesHouse1F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, BluesHouse1F_ScriptPointers
	xor a
	call CallFunctionInTable
	ret

BluesHouse1F_ScriptPointers:
	def_script_pointers
	dw_const BluesHouse1FDefaultScript, SCRIPT_BLUESHOUSE1F_DEFAULT
	dw_const DoRet,                   SCRIPT_BLUESHOUSE1F_NOOP

BluesHouse1FDefaultScript:
	SetEvent EVENT_ENTERED_BLUES_HOUSE
	ld a, SCRIPT_BLUESHOUSE1F_NOOP
	ld [wBluesHouse1FCurScript], a
	ret

BluesHouse1F_TextPointers:
	def_text_pointers
	dw_const BluesHouseDaisySittingText, TEXT_BLUESHOUSE1F_DAISY_SITTING
	dw_const BluesHouseDaisyWalkingText, TEXT_BLUESHOUSE1F_DAISY_WALKING
	dw_const BluesHouseTownMapText,      TEXT_BLUESHOUSE1F_TOWN_MAP

BluesHouseDaisySittingText:
	text_asm
	CheckEvent EVENT_GOT_TOWN_MAP
	jr nz, .got_town_map
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .give_town_map
	ld hl, BluesHouseDaisyRivalAtLabText
	rst _PrintText
	jr .done

.give_town_map
	ld hl, BluesHouseDaisyOfferMapText
	rst _PrintText
;	lb bc, TOWN_MAP, 1
;	call GiveItem
;	jr nc, .bag_full
	ld a, HS_TOWN_MAP
	ld [wMissableObjectIndex], a
	predef HideObject
	ld hl, GotMapText
	rst _PrintText
	SetEvent EVENT_GOT_TOWN_MAP
	jr .done

.got_town_map
	ld hl, BluesHouseDaisyUseMapText
	rst _PrintText
	jr .done

;.bag_full
;	ld hl, BluesHouseDaisyBagFullText
;	rst _PrintText
.done
	rst TextScriptEnd

BluesHouseDaisyRivalAtLabText:
	text_far _BluesHouseDaisyRivalAtLabText
	text_end

BluesHouseDaisyOfferMapText:
	text_far _BluesHouseDaisyOfferMapText
	text_end

GotMapText:
	text_far _GotMapText
	sound_get_key_item
	text_end

;BluesHouseDaisyBagFullText:
;	text_far _BluesHouseDaisyBagFullText
;	text_end

BluesHouseDaisyUseMapText:
	text_far _BluesHouseDaisyUseMapText
	text_end

BluesHouseDaisyWalkingText:
	text_far _BluesHouseDaisyWalkingText
	text_end

BluesHouseTownMapText:
	text_far _BluesHouseTownMapText
	text_end
