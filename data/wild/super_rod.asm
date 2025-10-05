; super rod encounters
SuperRodData::
	; map, fishing group
	dbw PALLET_TOWN,         .Group1
	dbw VIRIDIAN_CITY,       .Group1
	dbw CERULEAN_CITY,       .Group2
	dbw VERMILION_CITY,      .Group3
	dbw CELADON_CITY,        .Group3
	dbw FUCHSIA_CITY,        .Group4
	dbw CINNABAR_ISLAND,     .Group4
	dbw ROUTE_4,             .Group3
	dbw ROUTE_6,             .Group4
	dbw ROUTE_10,            .Group5
	dbw ROUTE_11,            .Group4
	dbw ROUTE_12,            .Group7
	dbw ROUTE_13,            .Group7
	dbw ROUTE_17,            .Group5
	dbw ROUTE_18,            .Group5
	dbw ROUTE_19,            .Group5
	dbw ROUTE_20,            .Group5
	dbw ROUTE_21,            .Group5
	dbw ROUTE_22,            .Group7
	dbw ROUTE_23,            .Group12
	dbw ROUTE_24,            .Group7
	dbw ROUTE_25,            .Group7
	dbw CERULEAN_GYM,        .Group11
	dbw VERMILION_DOCK,      .Group4
	dbw SEAFOAM_ISLANDS_B3F, .Group8
	dbw SEAFOAM_ISLANDS_B4F, .Group8
	dbw SAFARI_ZONE_EAST,    .Group6
	dbw SAFARI_ZONE_NORTH,   .Group6
	dbw SAFARI_ZONE_WEST,    .Group6
	dbw SAFARI_ZONE_CENTER,  .Group6
	dbw CERULEAN_CAVE_B1F,   .Group10
	dbw CERULEAN_CAVE_1F,    .Group9
	db -1 ; end

; fishing groups
; number of monsters, followed by level/monster pairs

.Group1:
	db 4 ; How Many Pokemon
	db 10, STARYU
	db 10, TENTACOOL
	db 10, STARYU
	db 20, SLOWPOKE

.Group2:
	db 4
	db 25, KRABBY
	db 30, PSYDUCK
	db 30, SEAKING
	db 40, SEAKING

.Group3:
	db 4
	db 20, SLOWPOKE
	db 30, STARYU
	db 30, SEEL
	db 35, GYARADOS

.Group4:
	db 4
	db 20, KRABBY
	db 20, SHELLDER
	db 30, SEADRA
	db 35, TENTACRUEL

.Group5:
	db 4
	db 25, TENTACOOL
	db 25, SLOWPOKE
	db 25, TENTACOOL
	db 25, SHELLDER

.Group6:
	db 4
	db 15, KRABBY
	db 20, SEEL
	db 20, DRATINI
	db 25, DRAGONAIR

.Group7:
	db 4
	db 20, SEEL
	db 30, GOLDUCK
	db 30, POLIWHIRL
	db 35, DEWGONG

.Group8:
	db 4
	db 35, KINGLER
	db 35, SEADRA
	db 35, DEWGONG
	db 40, STARMIE

.Group9:
	db 4
	db 45, OMANYTE
	db 45, KABUTO
	db 50, LAPRAS
	db 50, CLOYSTER

.Group10:
	db 4
	db 50, OMASTAR
	db 50, KABUTOPS
	db 50, CLOYSTER
	db 15, GYARADOS

.Group11:
	db 4
	db 20, PSYDUCK
	db 20, KRABBY
	db 25, SEEL
	db 30, GOLDUCK

.Group12:
	db 4
	db 40, GOLDUCK
	db 40, WARTORTLE
	db 40, STARMIE
	db 40, VAPOREON