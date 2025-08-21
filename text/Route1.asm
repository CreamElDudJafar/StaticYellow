_Route1Youngster1MartSampleText::
	text "Hi! I work at a"
	line "#MON MART."

	para "It's a convenient"
	line "shop, so please"
	cont "visit us in"
	cont "VIRIDIAN CITY."

	para "I know, I'll give"
	line "you a sample!"
	cont "Here you go!"
	prompt

_Route1Youngster1GotPotionText::
	text "<PLAYER> got"
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_Route1Youngster1AlsoGotPokeballsText::
	text "We also carry"
	line "# BALLs for"
	cont "catching #MON!"
	done

_Route1Youngster1NoRoomText::
	text "You have too much"
	line "stuff with you!"
	done

_Route1Youngster2Text::
	text "See those ledges"
	line "along the road?"

	para "It's a bit scary,"
	line "but you can jump"
	cont "from them."

	para "You can get back"
	line "to PALLET TOWN"
	cont "quicker that way."
	done

_Route1SignText::
	text "ROUTE 1"
	line "PALLET TOWN -"
	cont "VIRIDIAN CITY"
	done

_OakBeforeBattleText::
	text "Now it is time to"
	line "show me why you"
	cont "are the CHAMPION!"

	para "Are You Ready?"
	done

_OakRealChallengeBattleText::
	text "I have a final"
	line "lesson for you!"
	done

_OakRefusedBattleText::
	text "Return when you"
	line "are ready!"
	done

_OakDefeatedText::
	text "Hmm..."

	para "Now you are the"
	line "true KANTO region"
	cont "Champion!!"
	prompt

_OakWonText::
	text "Back in"
	line "my day, I was a"
	cont "serious TRAINER!"
	prompt

_OakPostBattleText::
	text "Well done,"
	line "<PLAYER>!"

	para "You are the best"
	line "their ever was."

	para "Now I will return"
	line "to the lab. Come"
	cont "see me from time"
	cont "to time!" 
	done