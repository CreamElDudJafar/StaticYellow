; old rod encounters
OldRodData:
	; map, fishing group
	dbw PALLET_TOWN,         .Group1
	dbw VIRIDIAN_CITY,       .Group1
	dbw CERULEAN_CITY,       .Group1
	dbw VERMILION_CITY,      .Group1
	dbw CELADON_CITY,        .Group1
	dbw FUCHSIA_CITY,        .Group1
	dbw CINNABAR_ISLAND,     .Group1
	dbw ROUTE_4,             .Group1
	dbw ROUTE_6,             .Group1
	dbw ROUTE_10,            .Group1
	dbw ROUTE_11,            .Group1
	dbw ROUTE_12,            .Group1
	dbw ROUTE_13,            .Group1
	dbw ROUTE_17,            .Group1
	dbw ROUTE_18,            .Group1
	dbw ROUTE_19,            .Group1
	dbw ROUTE_20,            .Group1
	dbw ROUTE_21,            .Group1
	dbw ROUTE_22,            .Group1
	dbw ROUTE_23,            .Group1
	dbw ROUTE_24,            .Group1
	dbw ROUTE_25,            .Group1
	dbw CERULEAN_GYM,        .Group1
	dbw VERMILION_DOCK,      .Group1
	dbw SEAFOAM_ISLANDS_B3F, .Group1
	dbw SEAFOAM_ISLANDS_B4F, .Group1
	dbw SAFARI_ZONE_EAST,    .Group1
	dbw SAFARI_ZONE_NORTH,   .Group1
	dbw SAFARI_ZONE_WEST,    .Group1
	dbw SAFARI_ZONE_CENTER,  .Group1
	dbw CERULEAN_CAVE_2F,    .Group1
	dbw CERULEAN_CAVE_B1F,   .Group1
	dbw CERULEAN_CAVE_1F,    .Group1
	db -1 ; end

; fishing groups
; number of monsters, followed by level/monster pairs

.Group1:
	db 2 ; How Many Pokemon
	db 5, MAGIKARP
	db 5, POLIWAG