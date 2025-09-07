_CeladonHotelGrannyText::
	text "#MON? No, this"
	line "is a hotel for"
	cont "people."

	para "We're full up."
	done

_CeladonHotelBeautyText::
	text "I'm on vacation"
	line "with my brother"
	cont "and boy friend."

	para "CELADON is such a"
	line "pretty city!"
	done

_CeladonHotelSuperNerdText::
	text "Why did she bring"
	line "her brother?"
	done

_CeladonHotelCoinGuyText_Intro::
	text "I'm flushed with"
	line "COINS, yet seeing"
	cont "#MON is what I"
	cont "covet."
	
	para "Show me a fine"
	line "@"
	text_ram wNameBuffer
	text_start
	cont "and I will give a" 
	cont "nice reward."
	prompt

_CeladonHotelCoinGuyText_Needcase::
	text "Oh, remember to"
	line "bring a COIN CASE."
	done

_CeladonHotelCoinGuyText_Recieved::
	text "Oh, I see that you"
	line "have one!"
	
	para "I'll give you"
	line "@"
	text_bcd hCoins, 2 | LEADING_ZEROES | LEFT_ALIGN
	text " coins!"
	done
	
_CeladonHotelCoinGuyText_PC::
	text "Use the PC over in"
	line "the corner if you"
	cont "need it."
	done
