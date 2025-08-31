CinnabarPokecenter_Script:
	call SetLastBlackoutMap
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing

CinnabarPokecenter_TextPointers:
	def_text_pointers
	dw_const CinnabarPokecenterNurseText,            TEXT_CINNABARPOKECENTER_NURSE
	dw_const CinnabarPokecenterCooltrainerFText,     TEXT_CINNABARPOKECENTER_COOLTRAINER_F
	dw_const CinnabarPokecenterGentlemanText,        TEXT_CINNABARPOKECENTER_GENTLEMAN
	dw_const CinnabarPokecenterLinkReceptionistText, TEXT_CINNABARPOKECENTER_LINK_RECEPTIONIST
	dw_const CinnabarPokecenterSurfinDudeText,       TEXT_CINNABARPOKECENTER_SURFINDUDE
	dw_const CinnabarPokecenterChanseyText,          TEXT_CINNABARPOKECENTER_CHANSEY

CinnabarPokecenterNurseText:
	script_pokecenter_nurse

CinnabarPokecenterCooltrainerFText:
	text_far _CinnabarPokecenterCooltrainerFText
	text_end

CinnabarPokecenterGentlemanText:
	text_far _CinnabarPokecenterGentlemanText
	text_end

CinnabarPokecenterLinkReceptionistText:
	script_cable_club_receptionist

CinnabarPokecenterChanseyText:
	text_asm
	callfar PokecenterChanseyText
	rst TextScriptEnd

CinnabarPokecenterSurfinDudeText:
	text_asm
	CheckEvent EVENT_GOT_SURFBOARD
	jr nz, .got_item
	ld hl, .SurfboardText
	rst _PrintText
	lb bc, SURFBOARD, 1
	call GiveItem
	jr nc, .bag_full
	SetEvent EVENT_GOT_SURFBOARD
	ld hl, .GotSurfboardText
	rst _PrintText
	jr .done
.bag_full
	ld hl, .NoRoomText
	rst _PrintText
	jr .done
.got_item
	ld hl, .EnjoySurfingText
	rst _PrintText
.done
	rst TextScriptEnd

.SurfboardText:
	text_far _CinnabarPokecenterSurfboardText
	text_end

.GotSurfboardText:
	text_far _CinnabarPokecenterGotSurfboardText
	sound_get_item_1
	text_end

.EnjoySurfingText:
	text_far _CinnabarPokecenterEnjoySurfingText
	text_end

.NoRoomText:
	text_far _CinnabarPokecenterNoRoomText
	text_end
