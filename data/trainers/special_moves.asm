; Yellow entry format:
;	db trainerclass, trainerid
;	repeat { db partymon location, partymon move, move id }
;	db 0

SpecialTrainerMoves:
	db BUG_CATCHER, 15
	db 2, 2, TACKLE
	db 2, 3, STRING_SHOT
	db 0

	db YOUNGSTER, 14
	db 1, 4, FISSURE
	db 0

	db BROCK, 1
	db 1, 1, TACKLE
	db 1, 2, DEFENSE_CURL
	db 1, 3, ROCK_THROW
	db 2, 1, SUPERSONIC
	db 2, 2, GUST
	db 2, 3, CONFUSE_RAY
	db 3, 1, SCREECH
	db 3, 2, BIDE
	db 3, 3, BIND
	db 0

	db BROCK, 2 
	db 1, 1, EARTHQUAKE
	db 1, 2, BODY_SLAM
	db 1, 3, EXPLOSION
	db 2, 1, MEGA_DRAIN
	db 2, 2, DOUBLE_EDGE
	db 2, 3, DOUBLE_TEAM
	db 3, 1, ROCK_SLIDE
	db 3, 2, HYPER_BEAM
	db 3, 3, FLY
	db 4, 1, FIRE_BLAST
	db 4, 2, DIG
	db 4, 3, CONFUSE_RAY
	db 5, 1, BLIZZARD
	db 5, 2, HYDRO_PUMP
	db 5, 3, TOXIC
	db 6, 1, EARTHQUAKE
	db 6, 2, BIND
	db 6, 3, FISSURE
	db 0

	db MISTY, 1
	db 1, 1, DISABLE
	db 1, 2, CONFUSION
	db 1, 3, RAGE
	db 2, 1, TOXIC
	db 2, 2, WATER_GUN
	db 2, 3, REFLECT
	db 3, 1, DOUBLE_TEAM
	db 3, 2, THUNDER_WAVE
	db 3, 3, BUBBLEBEAM
	db 0

	db MISTY, 2
	db 1, 1, ICE_BEAM
	db 1, 2, PSYCHIC_M
	db 1, 3, HYDRO_PUMP
	db 2, 1, FIRE_BLAST
	db 2, 2, THUNDER
	db 2, 3, SURF
	db 3, 1, BLIZZARD
	db 3, 2, PSYCHIC_M
	db 3, 3, THUNDERBOLT
	db 4, 1, BLIZZARD
	db 4, 2, SLAM
	db 4, 3, DOUBLE_TEAM
	db 5, 1, PSYCHIC_M
	db 5, 2, THUNDER
	db 5, 3, BLIZZARD
	db 6, 1, EARTHQUAKE
	db 6, 2, MEGA_KICK
	db 6, 3, HYDRO_PUMP
	db 0

	db LT_SURGE, 1
	db 1, 1, RAGE
	db 1, 2, THUNDERPUNCH
	db 1, 3, SCREECH
	db 2, 1, DOUBLE_TEAM
	db 2, 2, REFLECT
	db 2, 3, SWIFT
	db 3, 1, AGILITY
	db 3, 2, QUICK_ATTACK
	db 3, 3, THUNDERSHOCK
	db 4, 1, THUNDER
	db 4, 2, THUNDER_WAVE
	db 4, 3, SURF
	db 0

	db LT_SURGE, 2
	db 1, 1, THUNDER_WAVE
	db 1, 2, THUNDER
	db 1, 3, EXPLOSION
	db 2, 1, HYPER_BEAM
	db 2, 2, RECOVER
	db 2, 3, BLIZZARD
	db 3, 1, DIG
	db 3, 2, THUNDER_WAVE
	db 3, 3, HEADBUTT
	db 4, 1, PSYCHIC_M
	db 4, 2, THUNDERBOLT
	db 4, 3, SKULL_BASH
	db 5, 1, DOUBLE_EDGE
	db 5, 2, SEISMIC_TOSS
	db 5, 3, TAKE_DOWN
	db 6, 1, THUNDER_WAVE
	db 6, 2, SURF
	db 6, 3, THUNDER
	db 0

	db ERIKA, 1
	db 1, 1, MEGA_DRAIN
	db 1, 2, LEECH_SEED
	db 1, 3, POISONPOWDER
	db 2, 1, ACID
	db 2, 2, STUN_SPORE
	db 2, 3, SLUDGE
	db 3, 1, SLEEP_POWDER
	db 3, 2, ABSORB
	db 3, 3, VINE_WHIP
	db 4, 1, PETAL_DANCE
	db 4, 2, CUT
	db 4, 3, MEGA_DRAIN
	db 0

	
	db ERIKA, 2
	db 1, 1, MEGA_DRAIN
	db 1, 2, EGG_BOMB
	db 1, 3, POISONPOWDER
	db 2, 1, ACID
	db 2, 2, STUN_SPORE
	db 2, 3, SLUDGE
	db 3, 1, SLEEP_POWDER
	db 3, 2, ABSORB
	db 3, 3, VINE_WHIP
	db 4, 1, SLUDGE
	db 4, 2, RAZOR_LEAF
	db 4, 3, LEECH_SEED
	db 5, 1, PETAL_DANCE
	db 5, 2, CUT
	db 5, 3, MEGA_DRAIN
	db 0

	
	db ERIKA, 3
	db 1, 1, MEGA_DRAIN
	db 1, 2, EGG_BOMB
	db 1, 3, POISONPOWDER
	db 2, 1, ACID
	db 2, 2, STUN_SPORE
	db 2, 3, SLUDGE
	db 3, 1, SLEEP_POWDER
	db 3, 2, ABSORB
	db 3, 3, VINE_WHIP
	db 4, 1, SLUDGE
	db 4, 2, RAZOR_LEAF
	db 4, 3, LEECH_SEED
	db 5, 1, PETAL_DANCE
	db 5, 2, CUT
	db 5, 3, MEGA_DRAIN
	db 0

	db ERIKA, 4
	db 1, 1, SLUDGE
	db 1, 2, RAZOR_LEAF
	db 1, 3, LEECH_SEED
	db 2, 1, BIND
	db 2, 2, MEGA_DRAIN
	db 2, 3, BODY_SLAM
	db 3, 1, ICE_BEAM
	db 3, 2, DOUBLE_EDGE
	db 3, 3, FIRE_BLAST
	db 4, 1, GROWTH
	db 4, 2, SLUDGE
	db 4, 3, STUN_SPORE
	db 5, 1, MEGA_DRAIN
	db 5, 2, PSYCHIC_M
	db 5, 3, SLEEP_POWDER
	db 6, 1, LEECH_SEED
	db 6, 2, SUBSTITUTE
	db 6, 3, MEGA_DRAIN
	db 0
	
	db KOGA, 1
	db 1, 1, TOXIC
	db 1, 2, DOUBLE_TEAM
	db 1, 3, CONFUSE_RAY
	db 2, 1, SLUDGE
	db 2, 2, MEGA_DRAIN
	db 2, 3, THUNDERBOLT
	db 3, 1, FIRE_BLAST
	db 3, 2, AMNESIA
	db 3, 3, EXPLOSION
	db 4, 1, GLARE
	db 4, 2, WRAP
	db 4, 3, EARTHQUAKE
	db 5, 1, DOUBLE_TEAM
	db 5, 2, PSYCHIC_M
	db 5, 3, CONFUSION
	db 0

	db KOGA, 2
	db 1, 1, TOXIC
	db 1, 2, DOUBLE_TEAM
	db 1, 3, CONFUSE_RAY
	db 2, 1, SLUDGE
	db 2, 2, MEGA_DRAIN
	db 2, 3, THUNDERBOLT
	db 3, 1, FIRE_BLAST
	db 3, 2, AMNESIA
	db 3, 3, EXPLOSION
	db 4, 1, GLARE
	db 4, 2, WRAP
	db 4, 3, EARTHQUAKE
	db 5, 1, DOUBLE_TEAM
	db 5, 2, PSYCHIC_M
	db 5, 3, CONFUSION
	db 0

	db KOGA, 3
	db 1, 1, GLARE
	db 1, 2, EARTHQUAKE
	db 1, 3, WRAP
	db 2, 1, CONFUSE_RAY
	db 2, 2, TOXIC
	db 2, 3, DOUBLE_TEAM
	db 3, 1, SLUDGE
	db 3, 2, SELFDESTRUCT
	db 3, 3, THUNDERBOLT
	db 4, 1, BLIZZARD
	db 4, 2, SURF
	db 4, 3, SKULL_BASH
	db 5, 1, EXPLOSION
	db 5, 2, TOXIC
	db 5, 3, MEGA_DRAIN
	db 6, 1, PSYCHIC_M
	db 6, 2, DOUBLE_TEAM
	db 6, 3, HYPER_BEAM
	db 0

	db BLAINE, 1
	db 1, 1, FIRE_SPIN
	db 1, 2, TAKE_DOWN
	db 1, 3, SWIFT
	db 2, 1, DIG
	db 2, 2, NIGHT_SHADE
	db 2, 3, REFLECT
	db 3, 1, BODY_SLAM
	db 3, 2, HORN_DRILL
	db 3, 3, FIRE_BLAST
	db 4, 1, FLAMETHROWER
	db 4, 2, AGILITY
	db 4, 3, DIG
	db 5, 1, FIRE_BLAST
	db 5, 2, CONFUSE_RAY
	db 5, 3, PSYCHIC_M
	db 0

	db BLAINE, 2
	db 1, 1, FIRE_BLAST
	db 1, 2, DIG
	db 1, 3, DOUBLE_EDGE
	db 2, 1, FLAMETHROWER
	db 2, 2, REFLECT
	db 2, 3, CONFUSE_RAY
	db 3, 1, SURF
	db 3, 2, THUNDERBOLT
	db 3, 3, TAKE_DOWN
	db 4, 1, FIRE_SPIN
	db 4, 2, GROWTH
	db 4, 3, BODY_SLAM
	db 5, 1, FIRE_BLAST
	db 5, 2, SWORDS_DANCE
	db 5, 3, EARTHQUAKE
	db 6, 1, PSYCHIC_M
	db 6, 2, CONFUSE_RAY
	db 6, 3, FIRE_BLAST
	db 0

	db SABRINA, 1 
	db 1, 1, PSYCHIC_M
	db 1, 2, SURF
	db 1, 3, THUNDER_WAVE
	db 2, 1, THUNDERBOLT
	db 2, 2, MIMIC
	db 2, 3, PSYCHIC_M
	db 3, 1, LOVELY_KISS
	db 3, 2, ICE_BEAM
	db 3, 3, METRONOME
	db 4, 1, HYPNOSIS
	db 4, 2, MEGA_PUNCH
	db 4, 3, PSYCHIC_M
	db 5, 1, THUNDER_WAVE
	db 5, 2, DIG
	db 5, 3, PSYCHIC_M
	db 0

	db SABRINA, 2
	db 1, 1, PSYCHIC_M
	db 1, 2, SURF
	db 1, 3, THUNDER_WAVE
	db 2, 1, THUNDERBOLT
	db 2, 2, MIMIC
	db 2, 3, PSYCHIC_M
	db 3, 1, LOVELY_KISS
	db 3, 2, ICE_BEAM
	db 3, 3, METRONOME
	db 4, 1, HYPNOSIS
	db 4, 2, MEGA_PUNCH
	db 4, 3, PSYCHIC_M
	db 5, 1, THUNDER_WAVE
	db 5, 2, DIG
	db 5, 3, PSYCHIC_M
	db 0

	db SABRINA, 3
	db 1, 1, PSYCHIC_M
	db 1, 2, NIGHT_SHADE
	db 1, 3, HYPNOSIS
	db 2, 1, SURF
	db 2, 2, BODY_SLAM
	db 2, 3, FLAMETHROWER
	db 3, 1, THUNDERBOLT
	db 3, 2, THUNDER_WAVE
	db 3, 3, PSYCHIC_M
	db 4, 1, LOVELY_KISS
	db 4, 2, BLIZZARD
	db 4, 3, PSYCHIC_M
	db 5, 1, PSYWAVE
	db 5, 2, HYPNOSIS
	db 5, 3, TRI_ATTACK
	db 6, 1, THUNDER_WAVE
	db 6, 2, PSYCHIC_M
	db 6, 3, DIG
	db 0

	db GIOVANNI, 1
	db 1, 1, ROCK_THROW
	db 1, 2, DIG
	db 1, 3, SCREECH
	db 2, 1, RAGE
	db 2, 2, FIRE_BLAST
	db 2, 3, HORN_DRILL
	db 3, 1, MEGA_PUNCH
	db 3, 2, SUBMISSION
	db 3, 3, DIZZY_PUNCH
	db 4, 1, TAKE_DOWN
	db 4, 2, THUNDERBOLT
	db 4, 3, BUBBLEBEAM
	db 0

	
	db GIOVANNI, 2
	db 1, 1, HARDEN
	db 1, 2, CRABHAMMER
	db 1, 3, GUILLOTINE
	db 2, 1, MEGA_PUNCH
	db 2, 2, SUBMISSION
	db 2, 3, DIZZY_PUNCH
	db 3, 1, TOXIC
	db 3, 2, COUNTER
	db 3, 3, EARTHQUAKE
	db 4, 1, DOUBLE_TEAM
	db 4, 2, SCREECH
	db 4, 3, EARTHQUAKE
	db 5, 1, THUNDERBOLT
	db 5, 2, ICE_BEAM
	db 5, 3, FIRE_BLAST
	db 0

	
	db GIOVANNI, 3
	db 1, 1, EARTHQUAKE
	db 1, 2, SELFDESTRUCT
	db 1, 3, EXPLOSION
	db 2, 1, SLASH
	db 2, 2, THUNDERBOLT
	db 2, 3, HYPER_BEAM
	db 3, 1, DOUBLE_EDGE
	db 3, 2, HYPER_BEAM
	db 3, 3, BODY_SLAM
	db 4, 1, BLIZZARD
	db 4, 2, THUNDER
	db 4, 3, SLUDGE
	db 5, 1, ICE_BEAM
	db 5, 2, THUNDER
	db 5, 3, BODY_SLAM
	db 6, 1, SUBMISSION
	db 6, 2, THUNDERBOLT
	db 6, 3, ROCK_SLIDE
	db 0

	
	db LORELEI, 1
	db 1, 1, SURF
	db 1, 2, REST
	db 1, 3, ICE_BEAM
	db 2, 1, THUNDER_WAVE
	db 2, 2, HYDRO_PUMP
	db 2, 3, PSYCHIC_M
	db 3, 1, EXPLOSION
	db 3, 2, BLIZZARD
	db 3, 3, SPIKE_CANNON
	db 4, 1, AMNESIA
	db 4, 2, PSYCHIC_M
	db 4, 3, EARTHQUAKE
	db 5, 1, LOVELY_KISS
	db 5, 2, BODY_SLAM
	db 5, 3, PSYCHIC_M
	db 6, 1, SING
	db 6, 2, THUNDERBOLT
	db 6, 3, BLIZZARD
	db 0

    	db LORELEI, 2 
    	db 1, 1, BODY_SLAM
    	db 1, 2, METRONOME
    	db 1, 3, LOVELY_KISS
    	db 1, 4, BLIZZARD
    	db 2, 1, THUNDER_WAVE
    	db 2, 2, PSYCHIC_M
    	db 2, 3, THUNDER
    	db 2, 4, SURF
    	db 3, 1, CLAMP
    	db 3, 2, ICE_BEAM
    	db 3, 3, TOXIC
    	db 3, 4, EXPLOSION
    	db 4, 1, BLIZZARD
    	db 4, 2, ROCK_SLIDE
    	db 4, 3, HORN_DRILL
    	db 4, 4, HYDRO_PUMP
    	db 5, 1, LEECH_SEED
    	db 5, 2, EGG_BOMB
    	db 5, 3, PSYCHIC_M
    	db 5, 4, HEADBUTT
    	db 6, 1, CONFUSE_RAY
    	db 6, 2, PSYCHIC_M
    	db 6, 3, SURF
    	db 6, 4, BLIZZARD
    	db 0

	
	db BRUNO, 1
	db 1, 1, ROCK_SLIDE
	db 1, 2, EXPLOSION
	db 1, 3, EARTHQUAKE
	db 2, 1, FISSURE
	db 2, 2, TAKE_DOWN
	db 2, 3, EXPLOSION
	db 3, 1, ICE_PUNCH
	db 3, 2, FIRE_PUNCH
	db 3, 3, THUNDERPUNCH
	db 4, 1, HI_JUMP_KICK
	db 4, 2, MEGA_KICK
	db 4, 3, STRENGTH
	db 5, 1, HYPNOSIS
	db 5, 2, AMNESIA
	db 5, 3, ICE_BEAM
	db 6, 1, EARTHQUAKE
	db 6, 2, KARATE_CHOP
	db 6, 3, HYPER_BEAM
	db 0
	
	db BRUNO, 2 
	db 1, 1, SOFTBOILED
        db 1, 2, PSYCHIC_M
    	db 1, 3, ICE_BEAM
   	db 1, 4, THUNDERBOLT
   	db 2, 1, SLUDGE
   	db 2, 2, BODY_SLAM
        db 2, 3, MINIMIZE
        db 2, 4, FIRE_BLAST
        db 3, 1, DOUBLE_TEAM
        db 3, 2, SURF
        db 3, 3, THUNDERBOLT
        db 3, 4, ICE_PUNCH
        db 4, 1, BODY_SLAM
        db 4, 2, JUMP_KICK
        db 4, 3, HI_JUMP_KICK
        db 4, 4, METRONOME
        db 5, 1, ROCK_SLIDE
        db 5, 2, EARTHQUAKE
        db 5, 3, BODY_SLAM
        db 5, 4, SURF
        db 6, 1, EARTHQUAKE
        db 6, 2, HYPER_BEAM
        db 6, 3, ROCK_SLIDE
        db 6, 4, KARATE_CHOP
	db 0

	
	db AGATHA, 1
	db 1, 1, FIRE_BLAST
	db 1, 2, MINIMIZE
	db 1, 3, BODY_SLAM
	db 2, 1, SWORDS_DANCE
	db 2, 2, WRAP
	db 2, 3, SURF
	db 3, 1, SLEEP_POWDER
	db 3, 2, DOUBLE_EDGE
	db 3, 3, LEECH_SEED
	db 4, 1, HYPNOSIS
	db 4, 2, DREAM_EATER
	db 4, 3, PSYWAVE
	db 5, 1, GLARE
	db 5, 2, WRAP
	db 5, 3, SLUDGE
	db 6, 1, PSYCHIC_M
	db 6, 2, MEGA_DRAIN
	db 6, 3, THUNDER
	db 0

	db AGATHA, 2 
    	db 1, 1, PSYCHIC_M
    	db 1, 2, LOVELY_KISS
    	db 1, 3, REFLECT
    	db 1, 4, BLIZZARD
    	db 2, 1, FIRE_BLAST
    	db 2, 2, THUNDERBOLT
    	db 2, 3, SURF
    	db 2, 4, HYPER_BEAM
    	db 3, 1, THUNDER_WAVE
    	db 3, 2, RECOVER
    	db 3, 3, PSYCHIC_M
    	db 3, 4, TRI_ATTACK
    	db 4, 1, SLEEP_POWDER
    	db 4, 2, DOUBLE_EDGE
    	db 4, 3, LEECH_SEED
    	db 4, 4, SOLARBEAM
    	db 5, 1, GLARE
    	db 5, 2, EARTHQUAKE
    	db 5, 3, SLUDGE
    	db 5, 4, WRAP
    	db 6, 1, CONFUSE_RAY
    	db 6, 2, NIGHT_SHADE
    	db 6, 3, FLAMETHROWER
    	db 6, 4, THUNDERBOLT
	db 0

	
	db LANCE, 1
	db 1, 1, FIRE_BLAST
	db 1, 2, THUNDERBOLT
	db 1, 3, SURF
	db 1, 4, DRAGON_RAGE
	db 2, 1, FLAMETHROWER
	db 2, 2, EARTHQUAKE
	db 2, 3, FLY
	db 2, 4, DOUBLE_TEAM
	db 3, 1, ICE_BEAM
	db 3, 2, SURF
	db 3, 3, HYDRO_PUMP
	db 3, 4, SLAM
	db 4, 1, THUNDERBOLT
	db 4, 2, LIGHT_SCREEN
	db 4, 3, THUNDERPUNCH
	db 4, 4, THUNDER_WAVE
	db 5, 1, SKY_ATTACK
	db 5, 2, ROCK_SLIDE
	db 5, 3, HYPER_BEAM
	db 5, 4, EARTHQUAKE
	db 6, 1, FIRE_BLAST
	db 6, 2, BLIZZARD
	db 6, 3, THUNDER_WAVE
	db 6, 4, HYPER_BEAM
	db 0

	db LANCE, 2 
	db 1, 1, DRAGON_RAGE
    	db 1, 2, FIRE_BLAST
    	db 1, 3, HYPER_BEAM
    	db 1, 4, DIG
    	db 2, 1, THUNDER_WAVE
    	db 2, 2, LIGHT_SCREEN
    	db 2, 3, THUNDER
    	db 2, 4, PSYCHIC_M
    	db 3, 1, SELFDESTRUCT
    	db 3, 2, EARTHQUAKE
    	db 3, 3, REFLECT
    	db 3, 4, HYPER_BEAM
    	db 4, 1, FLY
    	db 4, 2, FIRE_BLAST
    	db 4, 3, EARTHQUAKE
    	db 4, 4, FLAMETHROWER
    	db 5, 1, HYPER_BEAM
    	db 5, 2, SUBMISSION
    	db 5, 3, EARTHQUAKE
    	db 5, 4, ROCK_SLIDE
    	db 6, 1, HYDRO_PUMP
    	db 6, 2, THUNDER_WAVE
    	db 6, 3, BLIZZARD
    	db 6, 4, HYPER_BEAM
	db 0
	
	db RIVAL3, 1 
	db 1, 1, EARTHQUAKE
        db 1, 2, SLASH
	db 1, 3, SWORDS_DANCE
        db 1, 4, DIG
	db 2, 1, THUNDER_WAVE
    	db 2, 2, RECOVER
    	db 2, 3, PSYCHIC_M
    	db 2, 4, TRI_ATTACK
    	db 3, 1, PSYCHIC_M
	db 3, 2, SELFDESTRUCT
	db 3, 3, STUN_SPORE
	db 3, 4, MEGA_DRAIN
	db 4, 1, EXPLOSION
	db 4, 2, BLIZZARD
	db 4, 3, SPIKE_CANNON
	db 4, 4, ICE_BEAM
    	db 5, 1, PSYWAVE
    	db 5, 2, SOLARBEAM
    	db 5, 3, NIGHT_SHADE
    	db 5, 4, FIRE_SPIN
    	db 6, 1, THUNDER_WAVE
    	db 6, 2, THUNDERBOLT
    	db 6, 3, PIN_MISSILE
    	db 6, 4, HEADBUTT
	db 0

	db RIVAL3, 2
	db 1, 1, EARTHQUAKE
        db 1, 2, SLASH
	db 1, 3, SWORDS_DANCE
        db 1, 4, DIG
	db 2, 1, THUNDER_WAVE
    	db 2, 2, RECOVER
    	db 2, 3, PSYCHIC_M
    	db 2, 4, TRI_ATTACK
    	db 3, 1, PSYCHIC_M
	db 3, 2, SELFDESTRUCT
	db 3, 3, STUN_SPORE
	db 3, 4, MEGA_DRAIN
    	db 4, 1, THUNDER_WAVE
    	db 4, 2, THUNDERBOLT
    	db 4, 3, TRI_ATTACK
    	db 4, 4, SWIFT
	db 5, 1, EXPLOSION
	db 5, 2, BLIZZARD
	db 5, 3, SPIKE_CANNON
	db 5, 4, ICE_BEAM
    	db 6, 1, FIRE_BLAST
    	db 6, 2, BODY_SLAM
    	db 6, 3, FLAMETHROWER
    	db 6, 4, DIG
	db 0

	db RIVAL3, 3
	db 1, 1, EARTHQUAKE
        db 1, 2, SLASH
	db 1, 3, SWORDS_DANCE
        db 1, 4, DIG
	db 2, 1, THUNDER_WAVE
    	db 2, 2, RECOVER
    	db 2, 3, PSYCHIC_M
    	db 2, 4, TRI_ATTACK
    	db 3, 1, PSYCHIC_M
	db 3, 2, SELFDESTRUCT
	db 3, 3, STUN_SPORE
	db 3, 4, MEGA_DRAIN
	db 4, 1, PSYWAVE
    	db 4, 2, SOLARBEAM
    	db 4, 3, NIGHT_SHADE
    	db 4, 4, FIRE_SPIN
    	db 5, 1, THUNDER_WAVE
    	db 5, 2, THUNDERBOLT
    	db 5, 3, TRI_ATTACK
    	db 5, 4, SWIFT
    	db 6, 1, HYDRO_PUMP
    	db 6, 2, BLIZZARD
    	db 6, 3, SKULL_BASH
    	db 6, 4, ACID_ARMOR
	db 0

	db RIVAL3, 4 
	db 1, 1, THUNDER_WAVE
    	db 1, 2, RECOVER
    	db 1, 3, PSYCHIC_M
    	db 1, 4, TRI_ATTACK
    	db 2, 1, ROCK_SLIDE
    	db 2, 2, EARTHQUAKE
    	db 2, 3, BODY_SLAM
    	db 2, 4, KARATE_CHOP
    	db 3, 1, HYDRO_PUMP
    	db 3, 2, THUNDERBOLT
    	db 3, 3, BODY_SLAM
    	db 3, 4, BLIZZARD
    	db 4, 1, TOXIC
    	db 4, 2, HYPER_BEAM
    	db 4, 3, SKY_ATTACK
    	db 4, 4, FLY
    	db 5, 1, EGG_BOMB
    	db 5, 2, LEECH_SEED
    	db 5, 3, RAZOR_LEAF
    	db 5, 4, SOFTBOILED
    	db 6, 1, FIRE_BLAST
    	db 6, 2, BODY_SLAM
    	db 6, 3, FLAMETHROWER
    	db 6, 4, DIG
	db 0

	db PROF_OAK, 1 
    	db 1, 1, HYPER_BEAM
    	db 1, 2, EARTHQUAKE
    	db 1, 3, BLIZZARD
    	db 1, 4, FIRE_BLAST
    	db 2, 1, MEGA_DRAIN
    	db 2, 2, SOFTBOILED
    	db 2, 3, PSYCHIC_M
    	db 2, 4, SOLARBEAM
	db 3, 1, DIG
    	db 3, 2, FLAMETHROWER
    	db 3, 3, BODY_SLAM
	db 3, 4, FIRE_BLAST
    	db 4, 1, THUNDERBOLT
    	db 4, 2, AMNESIA
	db 4, 3, SELFDESTRUCT
	db 4, 4, PSYCHIC_M
	db 5, 1, DOUBLE_TEAM
	db 5, 2, HYDRO_PUMP
    	db 5, 3, THUNDERBOLT
    	db 5, 3, FIRE_BLAST
    	db 6, 1, ICE_BEAM
    	db 6, 2, EARTHQUAKE
    	db 6, 3, HORN_DRILL
    	db 6, 4, SUBSTITUTE
    	db 0

	db JOY, 1 
	db 1, 1, REST
   	db 1, 2, DOUBLE_TEAM
    	db 1, 3, FISSURE
    	db 1, 4, DOUBLE_EDGE
    	db 2, 1, REST
        db 2, 2, ICE_BEAM
    	db 2, 3, THUNDERPUNCH
    	db 2, 4, FIRE_PUNCH
    	db 3, 1, RECOVER
    	db 3, 2, SURF
    	db 3, 3, THUNDER_WAVE
    	db 3, 4, PSYCHIC_M
    	db 4, 1, TRI_ATTACK
    	db 4, 2, BLIZZARD
    	db 4, 3, RECOVER
    	db 4, 4, THUNDER_WAVE
    	db 5, 1, SOFTBOILED
    	db 5, 2, REFLECT
    	db 5, 3, DREAM_EATER
    	db 5, 4, EGG_BOMB
    	db 6, 1, SOFTBOILED
    	db 6, 2, REFLECT
    	db 6, 3, EGG_BOMB
    	db 6, 4, THUNDER_WAVE
	db 0

	db JENNY, 1 
	db 1, 1, TAKE_DOWN
    	db 1, 2, MIRROR_MOVE
    	db 1, 3, SKY_ATTACK
    	db 1, 4, TOXIC
    	db 2, 1, SURF
    	db 2, 2, EARTHQUAKE
    	db 2, 3, ICE_BEAM
        db 2, 4, BODY_SLAM
    	db 3, 1, MEGA_DRAIN
    	db 3, 2, SLEEP_POWDER
    	db 3, 3, MIMIC
    	db 3, 4, BIND
    	db 4, 1, PSYCHIC_M
    	db 4, 2, NIGHT_SHADE
    	db 4, 3, SELFDESTRUCT
    	db 4, 4, THUNDERBOLT
    	db 5, 1, SPORE
    	db 5, 2, MEGA_DRAIN
    	db 5, 3, RAZOR_LEAF
    	db 5, 4, LEECH_LIFE
    	db 6, 1, FIRE_SPIN
    	db 6, 2, FIRE_BLAST
    	db 6, 3, BODY_SLAM
    	db 6, 4, DIG
	db 0
	
	db -1 ; end
