PewterPokecenter_Script:
	ld hl, wd492
	set 7, [hl]
	call SetLastBlackoutMap
	call Serial_TryEstablishingExternallyClockedConnection
	call EnableAutoTextBoxDrawing
	ret

PewterPokecenter_TextPointers:
	def_text_pointers
	dw_const PewterPokecenterNurseText,            TEXT_PEWTERPOKECENTER_NURSE
	dw_const PewterPokecenterGentlemanText,        TEXT_PEWTERPOKECENTER_GENTLEMAN
	dw_const PewterPokecenterJigglypuffText,       TEXT_PEWTERPOKECENTER_JIGGLYPUFF
	dw_const PewterPokecenterLinkReceptionistText, TEXT_PEWTERPOKECENTER_LINK_RECEPTIONIST
	dw_const PewterPokecenterCooltrainerFText,     TEXT_PEWTERPOKECENTER_COOLTRAINER_F
	dw_const PewterPokecenterChanseyText,          TEXT_PEWTERPOKECENTER_CHANSEY

PewterPokecenterNurseText:
	script_pokecenter_nurse

PewterPokecenterGentlemanText:
	text_far _PewterPokecenterGentlemanText
	text_end

PewterPokecenterJigglypuffText:
	text_asm
	farcall PewterJigglypuff
	rst TextScriptEnd

PewterPokecenterLinkReceptionistText:
	script_cable_club_receptionist

PewterPokecenterCooltrainerFText:
	text_asm
	farcall PewterPokecenterPrintCooltrainerFText
	rst TextScriptEnd

PewterPokecenterChanseyText:
	text_asm
	callfar PokecenterChanseyText
	rst TextScriptEnd
