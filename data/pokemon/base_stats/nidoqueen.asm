	db DEX_NIDOQUEEN ; pokedex id

	db  90,  82,  87,  76,  75
	;   hp  atk  def  spd  spc

	db POISON, GROUND ; type
	db 45 ; catch rate
	db 194 ; base exp

	INCBIN "gfx/pokemon/front/nidoqueen.pic", 0, 1 ; sprite dimensions
	dw NidoqueenPicFront, NidoqueenPicBack

	db TACKLE, SCRATCH, DIG, BODY_SLAM ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,  MEGA_KICK, TOXIC, HORN_DRILL, BODY_SLAM,   REST, \
	     TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     \
	     BLIZZARD,     HYPER_BEAM,   PAY_DAY,      SUBMISSION,   COUNTER,      \
	     SEISMIC_TOSS, RAGE,         THUNDERBOLT,  THUNDER,      EARTHQUAKE,   \
	     FISSURE,      MIMIC,        DIG,          DOUBLE_TEAM,  REFLECT,       \
	     BIDE,        FIRE_BLAST,   SKULL_BASH,   ROCK_SLIDE,   SUBSTITUTE,    \
	     FLAMETHROWER, SURF,        STRENGTH
	; end

	db BANK(NidoqueenPicFront)
