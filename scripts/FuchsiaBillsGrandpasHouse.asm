FuchsiaBillsGrandpasHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

FuchsiaBillsGrandpasHouse_TextPointers:
	def_text_pointers
	dw_const FuchsiaBillsGrandpasHouseMiddleAgedWomanText, TEXT_FUCHSIABILLSGRANDPASHOUSE_MIDDLE_AGED_WOMAN
	dw_const FuchsiaBillsGrandpasHouseBillsGrandpaText,    TEXT_FUCHSIABILLSGRANDPASHOUSE_BILLS_GRANDPA
	dw_const FuchsiaBillsGrandpasHouseYoungsterText,       TEXT_FUCHSIABILLSGRANDPASHOUSE_YOUNGSTER
	dw_const FuchsiaBillsGrandpasHouseTraderText,          TEXT_FUCHSIABILLSGRANDPASHOUSE_TRADER

FuchsiaBillsGrandpasHouseMiddleAgedWomanText:
	text_far _FuchsiaBillsGrandpasHouseMiddleAgedWomanText
	text_end

FuchsiaBillsGrandpasHouseBillsGrandpaText:
	text_far _FuchsiaBillsGrandpasHouseBillsGrandpaText
	text_end

FuchsiaBillsGrandpasHouseYoungsterText:
	text_far _FuchsiaBillsGrandpasHouseYoungsterText
	text_end

FuchsiaBillsGrandpasHouseTraderText:
	text_asm
	ld a, TRADE_WITH_SELF
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	rst TextScriptEnd
