PrizeDifferentMenuPtrs:
	dw PrizeMenuMon1Entries, PrizeMenuMon1Cost
	dw PrizeMenuMon2Entries, PrizeMenuMon2Cost
	dw PrizeMenuTMsEntries,  PrizeMenuTMsCost
	dw PrizeMenuMon3Entries, PrizeMenuMon3Cost
	dw PrizeMenuMon4Entries, PrizeMenuMon4Cost
	

PrizeMenuMon1Entries:
	db MAGMAR
	db ELECTABUZZ
	db DRATINI
	db "@"

PrizeMenuMon1Cost:
	bcd2 6000
	bcd2 6000
	bcd2 6500
	db "@"

PrizeMenuMon2Entries:
	db SCYTHER
	db PINSIR
	db PORYGON
	db "@"

PrizeMenuMon2Cost:
	bcd2 6000
	bcd2 6000
	bcd2 6500
	db "@"

PrizeMenuTMsEntries:
	db TM_DRAGON_RAGE
	db TM_HYPER_BEAM
	db TM_SUBSTITUTE
	db "@"

PrizeMenuTMsCost:
	bcd2 3300
	bcd2 5500
	bcd2 7700
	db "@"

PrizeMenuMon3Entries:
	db CLEFAIRY
	db KANGASKHAN
	db TAUROS
	db "@"

PrizeMenuMon3Cost:
	bcd2 500
	bcd2 6000
	bcd2 6500
	db "@"

PrizeMenuMon4Entries:
	db MR_MIME
	db JYNX
	db CHANSEY
	db "@"

PrizeMenuMon4Cost:
	bcd2 6000
	bcd2 6000
	bcd2 6500
	db "@"
