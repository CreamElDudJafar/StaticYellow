ViridianSchoolHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

ViridianSchoolHouse_TextPointers:
	def_text_pointers
	dw_const ViridianSchoolHouseBrunetteGirlText, TEXT_VIRIDIANSCHOOLHOUSE_BRUNETTE_GIRL
	dw_const ViridianSchoolHouseCooltrainerFText, TEXT_VIRIDIANSCHOOLHOUSE_COOLTRAINER_F
	dw_const ViridianSchoolHouseLittleGirlText,   TEXT_VIRIDIANSCHOOLHOUSE_LITTLE_GIRL

ViridianSchoolHouseBrunetteGirlText:
	text_far _ViridianSchoolHouseBrunetteGirlText
	text_end

ViridianSchoolHouseCooltrainerFText:
	text_asm
	farcall ViridianSchoolHousePrintCooltrainerFText
	rst TextScriptEnd

ViridianSchoolHouseLittleGirlText:
	text_asm
	farcall ViridianSchoolHousePrintLittleGirlText
	rst TextScriptEnd
