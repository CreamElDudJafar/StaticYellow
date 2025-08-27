VermilionCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wd492
	res 7, [hl]
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_2, [hl]
	res BIT_CUR_MAP_LOADED_2, [hl]
	push hl
	call nz, VermilionCityLeftSSAnneCallbackScript
	pop hl
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	call nz, .setFirstLockTrashCanIndex
	ld hl, VermilionCity_ScriptPointers
	ld a, [wVermilionCityCurScript]
	call CallFunctionInTable
	call .vermilionCityScript_19869
	ret

.vermilionCityScript_19869
	CheckEventHL EVENT_LEFT_FANCLUB_AFTER_BIKE_VOUCHER
	ret nz
	CheckEventReuseHL EVENT_GOT_BIKE_VOUCHER
	ret z
	SetEventReuseHL EVENT_LEFT_FANCLUB_AFTER_BIKE_VOUCHER
	ret

.setFirstLockTrashCanIndex
	call Random
	ldh a, [hRandomAdd]
	ld b, a
	ldh a, [hRandomSub]
	adc b
	and $e
	ld [wFirstLockTrashCanIndex], a
	ret

VermilionCityLeftSSAnneCallbackScript:
	CheckEventHL EVENT_SS_ANNE_LEFT
	ret z
	CheckEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	SetEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	ret nz
	ld a, SCRIPT_VERMILIONCITY_PLAYER_EXIT_SHIP
	ld [wVermilionCityCurScript], a
	ret

VermilionCity_ScriptPointers:
	def_script_pointers
	dw_const VermilionCityDefaultScript,             SCRIPT_VERMILIONCITY_DEFAULT
	dw_const VermilionCityPlayerMovingUp1Script,     SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP1
	dw_const VermilionCityPlayerExitShipScript,      SCRIPT_VERMILIONCITY_PLAYER_EXIT_SHIP
	dw_const VermilionCityPlayerMovingUp2Script,     SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP2
	dw_const VermilionCityPlayerAllowedToPassScript, SCRIPT_VERMILIONCITY_PLAYER_ALLOWED_TO_PASS
	dw_const VermilionCityJennyPostBattleScript,     SCRIPT_VERMILIONCITY_JENNY_POST_BATTLE

VermilionCityDefaultScript:
	ld a, [wObtainedBadges]
	bit BIT_MARSHBADGE, a
	ret nz
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	jr nz, .return
	ld hl, SSAnneTicketCheckCoords
	call ArePlayerCoordsInArray
	jr nc, .return
	xor a
	ldh [hJoyHeld], a
	ld [wSavedCoordIndex], a ; unnecessary
	ld a, TEXT_VERMILIONCITY_SAILOR1
	ldh [hTextID], a
	call DisplayTextID
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .ship_departed
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ret nz
.ship_departed
	ld a, D_UP | B_BUTTON
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP1
	ld [wVermilionCityCurScript], a
	ret

.return
	ret

SSAnneTicketCheckCoords:
	dbmapcoord 18, 30
	db -1 ; end

VermilionCityPlayerAllowedToPassScript:
	ld hl, SSAnneTicketCheckCoords
	call ArePlayerCoordsInArray
	ret c
	ld a, SCRIPT_VERMILIONCITY_DEFAULT
	ld [wVermilionCityCurScript], a
	ret

VermilionCityPlayerExitShipScript:
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesEnd + 1], a
	ld a, 2
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, SCRIPT_VERMILIONCITY_PLAYER_MOVING_UP2
	ld [wVermilionCityCurScript], a
	ret

VermilionCityPlayerMovingUp2Script:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ldh [hJoyHeld], a
	ld a, SCRIPT_VERMILIONCITY_DEFAULT
	ld [wVermilionCityCurScript], a
	ret

VermilionCityPlayerMovingUp1Script:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld c, 10
	rst _DelayFrames
	ld a, SCRIPT_VERMILIONCITY_DEFAULT
	ld [wVermilionCityCurScript], a
	ret

VermilionCity_TextPointers:
	def_text_pointers
	dw_const VermilionCityBeautyText,             TEXT_VERMILIONCITY_BEAUTY
	dw_const VermilionCityGambler1Text,           TEXT_VERMILIONCITY_GAMBLER1
	dw_const VermilionCitySailor1Text,            TEXT_VERMILIONCITY_SAILOR1
	dw_const VermilionCityGambler2Text,           TEXT_VERMILIONCITY_GAMBLER2
	dw_const VermilionCityMachopText,             TEXT_VERMILIONCITY_MACHOP
	dw_const VermilionCitySailor2Text,            TEXT_VERMILIONCITY_SAILOR2
	dw_const VermilionCityOfficerJennyText,       TEXT_VERMILIONCITY_OFFICER_JENNY
	dw_const VermilionCitySignText,               TEXT_VERMILIONCITY_SIGN
	dw_const VermilionCityNoticeSignText,         TEXT_VERMILIONCITY_NOTICE_SIGN
	dw_const MartSignText,                        TEXT_VERMILIONCITY_MART_SIGN
	dw_const PokeCenterSignText,                  TEXT_VERMILIONCITY_POKECENTER_SIGN
	dw_const VermilionCityPokemonFanClubSignText, TEXT_VERMILIONCITY_POKEMON_FAN_CLUB_SIGN
	dw_const VermilionCityGymSignText,            TEXT_VERMILIONCITY_GYM_SIGN
	dw_const VermilionCityHarborSignText,         TEXT_VERMILIONCITY_HARBOR_SIGN
	dw_const VermilionCityJennyPostBattleText,    TEXT_VERMILION_CITY_JENNY_POST_BATTLE

VermilionCityBeautyText:
	text_far _VermilionCityBeautyText
	text_end

VermilionCityGambler1Text:
	text_asm
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .ship_departed
	ld hl, .DidYouSeeText
	rst _PrintText
	jr .text_script_end
.ship_departed
	ld hl, .SSAnneDepartedText
	rst _PrintText
.text_script_end
	rst TextScriptEnd

.DidYouSeeText:
	text_far _VermilionCityGambler1DidYouSeeText
	text_end

.SSAnneDepartedText:
	text_far _VermilionCityGambler1SSAnneDepartedText
	text_end

VermilionCitySailor1Text:
	text_asm
	ld a, [wObtainedBadges]
	bit BIT_MARSHBADGE, a
	jr nz, .default
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .ship_departed
.default
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_RIGHT
	jr z, .greet_player
	ld hl, .inFrontOfOrBehindGuardCoords
	call ArePlayerCoordsInArray
	jr nc, .greet_player_and_check_ticket
.greet_player
	ld hl, .WelcomeToSSAnneText
	rst _PrintText
	jr .end
.greet_player_and_check_ticket
	ld hl, .DoYouHaveATicketText
	rst _PrintText
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr nz, .player_has_ticket
	ld hl, .YouNeedATicketText
	rst _PrintText
	jr .end
.player_has_ticket
	ld hl, .FlashedTicketText
	rst _PrintText
	ld a, SCRIPT_VERMILIONCITY_PLAYER_ALLOWED_TO_PASS
	ld [wVermilionCityCurScript], a
	jr .end
.ship_departed
	ld hl, .ShipSetSailText
	rst _PrintText
.end
	rst TextScriptEnd

.inFrontOfOrBehindGuardCoords
	dbmapcoord 19, 29 ; in front of guard
	dbmapcoord 19, 31 ; behind guard
	db -1 ; end

.WelcomeToSSAnneText:
	text_far _VermilionCitySailor1WelcomeToSSAnneText
	text_end

.DoYouHaveATicketText:
	text_far _VermilionCitySailor1DoYouHaveATicketText
	text_end

.FlashedTicketText:
	text_far _VermilionCitySailor1FlashedTicketText
	text_end

.YouNeedATicketText:
	text_far _VermilionCitySailor1YouNeedATicketText
	text_end

.ShipSetSailText:
	text_far _VermilionCitySailor1ShipSetSailText
	text_end

VermilionCityGambler2Text:
	text_far _VermilionCityGambler2Text
	text_end

VermilionCityMachopText:
	text_far _VermilionCityMachopText
	text_asm
	ld a, MACHOP
	call PlayCry
	call WaitForSoundToFinish
	ld hl, .StompingTheLandFlatText
	ret

.StompingTheLandFlatText:
	text_far _VermilionCityMachopStompingTheLandFlatText
	text_end

VermilionCitySailor2Text:
	text_asm
	ld a, [wObtainedBadges]
	bit BIT_MARSHBADGE, a
	jr z, .default
	ld hl, .ShipBackText
	ret
.default
	ld hl, .Text
	ret

.Text:
	text_far _VermilionCitySailor2Text
	text_end

.ShipBackText:
	text_far _VermillionCityText15
	text_end

VermilionCitySignText:
	text_asm
	farcall VermilionCityPrintSignText
	rst TextScriptEnd

VermilionCityNoticeSignText:
	text_asm
	farcall VermilionCityPrintNoticeSignText
	rst TextScriptEnd

VermilionCityPokemonFanClubSignText:
	text_asm
	farcall VermilionCityPrintPokemonFanClubSignText
	rst TextScriptEnd

VermilionCityGymSignText:
	text_asm
	farcall VermilionCityPrintGymSignText
	rst TextScriptEnd

VermilionCityHarborSignText:
	text_asm
	farcall VermilionCityPrintHarborSignText
	rst TextScriptEnd

VermilionCityOfficerJennyText:
	text_asm
	farcall VermilionCityPrintOfficerJennyText
	rst TextScriptEnd

VermilionCityJennyPostBattleScript:
	ld a, [wIsInBattle]
	inc a
	jr z, .skip	; Kick out if the player lost.
	ld a, TEXT_VERMILION_CITY_JENNY_POST_BATTLE
	ldh [hTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_JENNY
.skip
	ld a, $0
	ld [wVermilionCityCurScript], a
	ld [wCurMapScript], a
	ret
VermilionCityJennyPostBattleText:
	text_far _JennyAfterBattleText
	text_end