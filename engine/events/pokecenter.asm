DisplayPokemonCenterDialogue_::
	ld a, [wCurMap]
	cp PEWTER_POKECENTER
	jr nz, .checkRouteCenters ; edited
	call CheckPikachuFollowingPlayer
	jr z, .regularCenter
	ld hl, LooksContentText ; if pikachu is sleeping, don't heal
	rst _PrintText
	ret
; new, for setting Route 4 and Route 10 Pokecenters fly locations
.checkRouteCenters
	cp MT_MOON_POKECENTER
	jr nz, .checkRockTunnelPokecenter
	lb bc, FLAG_SET, FLYLOC_ROUTE_4_CENTER
	ld hl, wTownVisitedFlag   ; mark town as visited (for flying)
	predef FlagActionPredef
	jr .regularCenter
.checkRockTunnelPokecenter
	cp ROCK_TUNNEL_POKECENTER
	jr nz, .regularCenter
	lb bc, FLAG_SET, FLYLOC_ROUTE_10_CENTER
	ld hl, wTownVisitedFlag   ; mark town as visited (for flying)
	predef FlagActionPredef
.regularCenter
; back to vanilla
	call SaveScreenTilesToBuffer1 ; save screen
	CheckEvent EVENT_FIRST_POKECENTER
	jr nz, .skiptext1
	ld hl, PokemonCenterWelcomeText
	rst _PrintText
	ld a, [wPartyCount]
	and a
	jp z, .naotenho
	ld hl, wStatusFlags4
	bit BIT_USED_POKECENTER, [hl]
	set BIT_UNKNOWN_4_1, [hl]
	set BIT_USED_POKECENTER, [hl]
	jr nz, .skipShallWeHealYourPokemon
	ld hl, ShallWeHealYourPokemonText
	rst _PrintText
.skipShallWeHealYourPokemon
	call YesNoChoicePokeCenter ; yes/no menu
	call UpdateSprites
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .declinedHealing ; if the player chose No
	jp .skipHealingText
.skiptext1
	ld hl, ShallWeHealYourPokemonFastText
	rst _PrintText
.skipHealingText
;	call SetLastBlackoutMap
	callfar IsStarterPikachuInOurParty
	jr nc, .notHealingPlayerPikachu
	call CheckPikachuFollowingPlayer
	jr nz, .notHealingPlayerPikachu
	call LoadCurrentMapView
	call Delay3
	call UpdateSprites
	callfar PikachuWalksToNurseJoy
.notHealingPlayerPikachu
	CheckEvent EVENT_FIRST_POKECENTER
	jr nz, .skiptext2
	ld hl, NeedYourPokemonText
	rst _PrintText
.skiptext2
	ld c, 64
	rst _DelayFrames
	call CheckPikachuFollowingPlayer
	jr nz, .playerPikachuNotOnScreen
	call DisablePikachuOverworldSpriteDrawing
	callfar IsStarterPikachuInOurParty
	call c, Func_6eaa
.playerPikachuNotOnScreen
	lb bc, 1, 8
	call Func_6ebb
	ld c, 30
	rst _DelayFrames
	farcall AnimateHealingMachine ; do the healing machine animation
	predef HealParty
	xor a
	ld [wAudioFadeOutControl], a
	ld a, [wAudioSavedROMBank]
	ld [wAudioROMBank], a
	ld a, [wMapMusicSoundID]
	ld [wLastMusicSoundID], a
	ld [wNewSoundID], a
	rst _PlaySound
	call CheckPikachuFollowingPlayer
	jr nz, .doNotReturnPikachu
	callfar IsStarterPikachuInOurParty
	call c, Func_6eaa
	ld a, $5
	ld [wPikachuSpawnState], a
	call EnablePikachuOverworldSpriteDrawing
.doNotReturnPikachu
	lb bc, 1, 0
	call Func_6ebb
	CheckEvent EVENT_FIRST_POKECENTER
	jr nz, .FightingFitShort
	ld hl, PokemonFightingFitText
	rst _PrintText
.FightingFitShort
	callfar IsStarterPikachuInOurParty
	jr nc, .notInParty
	lb bc, 15, 0
	call Func_6ebb
.notInParty
	call LoadCurrentMapView
	call Delay3
	call UpdateSprites
	callfar ReloadWalkingTilePatterns
	ld a, $1
	ldh [hSpriteIndex], a
	ld a, $1
	ldh [hSpriteImageIndex], a
	call SpriteFunc_34a1
	ld c, 40
	rst _DelayFrames
	call UpdateSprites
	call LoadFontTilePatterns
	jr .done
.declinedHealing
	call LoadScreenTilesFromBuffer1 ; restore screen
	jp .skipEventFirstPokecenter
.done
	SetEvent EVENT_FIRST_POKECENTER
.skipEventFirstPokecenter
	ld hl, PokemonCenterFarewellText
	rst _PrintText
	call UpdateSprites
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ret

.naotenho
	ld hl, TemPokemonOuNao
	jp PrintText

TemPokemonOuNao:
	text_far _TemPokemonOuNao
	text_end

Func_6eaa:
	ld a, $1
	ldh [hSpriteIndex], a
	ld a, $4
	ldh [hSpriteImageIndex], a
	call SpriteFunc_34a1
	ld c, 64
	rst _DelayFrames
	ret

Func_6ebb:
	ld a, b
	ldh [hSpriteIndex], a
	ld a, c
	ldh [hSpriteImageIndex], a
	push bc
	call SetSpriteFacingDirectionAndDelay
	pop bc
	ld a, b
	ldh [hSpriteIndex], a
	ld a, c
	ldh [hSpriteImageIndex], a
	call SpriteFunc_34a1
	ret

PokemonCenterWelcomeText:
	text_far _PokemonCenterWelcomeText
	text_end

ShallWeHealYourPokemonText:
	text_pause
	text_far _ShallWeHealYourPokemonText
	text_end

ShallWeHealYourPokemonFastText:
	text_far _ShallWeHealYourPokemonText
	text_pause
	text_end

NeedYourPokemonText:
	text_far _NeedYourPokemonText
	text_end

PokemonFightingFitText:
	text_far _PokemonFightingFitText
	text_end

PokemonCenterFarewellText:
;	text_pause
	text_far _PokemonCenterFarewellText
	text_end

LooksContentText:
	text_far _LooksContentText
	text_end
