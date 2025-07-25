RockTunnelPokecenter_Script:
	call .markAsVisited
	call SetLastBlackoutMap
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing
.markAsVisited
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	lb bc, FLAG_SET, FLYLOC_ROUTE_10_CENTER
	ld hl, wTownVisitedFlag
	predef_jump FlagActionPredef

RockTunnelPokecenter_TextPointers:
	def_text_pointers
	dw_const RockTunnelPokecenterNurseText,            TEXT_ROCKTUNNELPOKECENTER_NURSE
	dw_const RockTunnelPokecenterGentlemanText,        TEXT_ROCKTUNNELPOKECENTER_GENTLEMAN
	dw_const RockTunnelPokecenterFisherText,           TEXT_ROCKTUNNELPOKECENTER_FISHER
	dw_const RockTunnelPokecenterLinkReceptionistText, TEXT_ROCKTUNNELPOKECENTER_LINK_RECEPTIONIST
	dw_const RockTunnelPokecenterChanseyText,          TEXT_ROCKTUNNELPOKECENTER_CHANSEY

RockTunnelPokecenterNurseText:
	script_pokecenter_nurse

RockTunnelPokecenterGentlemanText:
	text_far _RockTunnelPokecenterGentlemanText
	text_end

RockTunnelPokecenterFisherText:
	text_far _RockTunnelPokecenterFisherText
	text_end

RockTunnelPokecenterLinkReceptionistText:
	script_cable_club_receptionist

RockTunnelPokecenterChanseyText:
	text_asm
	callfar PokecenterChanseyText
	rst TextScriptEnd
