PokemonMansionB1F_Script:
	call MansionB1FCheckReplaceSwitchDoorBlocks
	call EnableAutoTextBoxDrawing
	ld hl, Mansion4TrainerHeaders
	ld de, PokemonMansionB1F_ScriptPointers
	ld a, [wPokemonMansionB1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonMansionB1FCurScript], a
	ret

MansionB1FCheckReplaceSwitchDoorBlocks:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, .switchTurnedOn
	ld a, $e
	ld bc, $80d
	call Mansion2ReplaceBlock
	ld a, $e
	ld bc, $b06
	call Mansion2ReplaceBlock
	ld a, $5f
	ld bc, $304
	call Mansion2ReplaceBlock
	ld a, $54
	ld bc, $808
	call Mansion2ReplaceBlock
	ret
.switchTurnedOn
	ld a, $2d
	ld bc, $80d
	call Mansion2ReplaceBlock
	ld a, $5f
	ld bc, $b06
	call Mansion2ReplaceBlock
	ld a, $e
	ld bc, $304
	call Mansion2ReplaceBlock
	ld a, $e
	ld bc, $808
	call Mansion2ReplaceBlock
	ret

Mansion4Script_Switches::
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	xor a
	ldh [hJoyHeld], a
	ld a, TEXT_POKEMONMANSIONB1F_SWITCH
	ldh [hTextID], a
	jp DisplayTextID


PokemonMansionB1FResetScripts:
	CheckAndResetEvent EVENT_JESSIE_JAMES
	call nz, PokemonMansionB1FScript_HideJessieJames
	xor a
	ld [wJoyIgnore], a
PokemonMansionB1FSetScript:
	ld [wPokemonMansionB1FCurScript], a
	ld [wCurMapScript], a
	ret

PokemonMansionB1FScript_HideJessieJames:
	ld a, HS_POKEMON_MANSION_B1F_JAMES
	call PokemonMansionB1FScript_HideObject
	ld a, HS_POKEMON_MANSION_B1F_JESSIE
	call PokemonMansionB1FScript_HideObject
	ret

PokemonMansionB1F_ScriptPointers:
	def_script_pointers
	dw_const PokemonMansionB1FDefaultScript,         SCRIPT_POKEMONMANSIONB1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle,  SCRIPT_POKEMONMANSIONB1F_START_BATTLE
	dw_const EndTrainerBattle,                       SCRIPT_POKEMONMANSIONB1F_END_BATTLE
	dw_const PokemonMansionB1FScript4,               SCRIPT_POKEMONMANSIONB1F_SCRIPT4
	dw_const PokemonMansionB1FScript5,               SCRIPT_POKEMONMANSIONB1F_SCRIPT5
	dw_const PokemonMansionB1FScript6,               SCRIPT_POKEMONMANSIONB1F_SCRIPT6
	dw_const PokemonMansionB1FScript7,               SCRIPT_POKEMONMANSIONB1F_SCRIPT7
	dw_const PokemonMansionB1FScript8,               SCRIPT_POKEMONMANSIONB1F_SCRIPT8
	dw_const PokemonMansionB1FScript9,               SCRIPT_POKEMONMANSIONB1F_SCRIPT9
	dw_const PokemonMansionB1FScript10,              SCRIPT_POKEMONMANSIONB1F_SCRIPT10
	dw_const PokemonMansionB1FScript11,              SCRIPT_POKEMONMANSIONB1F_SCRIPT11
	dw_const PokemonMansionB1FScript12,              SCRIPT_POKEMONMANSIONB1F_SCRIPT12
	dw_const PokemonMansionB1FScript13,              SCRIPT_POKEMONMANSIONB1F_SCRIPT13

PokemonMansionB1FDefaultScript:
IF DEF(_DEBUG)
	call DebugPressedOrHeldB
	ret nz
ENDC
	CheckEvent EVENT_BEAT_MANSION_4_JESSIE_JAMES
	call z, PokemonMansionB1FScript_455a5
	CheckEvent EVENT_BEAT_MANSION_4_TRAINER_1
	call z, CheckFightingMapTrainers
	ret

PokemonMansionB1FScript_455a5:
	ld a, [wYCoord]
	cp $e
	ret nz
	ResetEvent EVENT_BEAT_MANSION_4_JESSIE_JAMES_ON_LEFT
	ld a, [wXCoord]
	cp $1a
	jr z, .asm_455c2
	ld a, [wXCoord]
	cp $1b
	ret nz
	SetEvent EVENT_BEAT_MANSION_4_JESSIE_JAMES_ON_LEFT
.asm_455c2
	xor a
	ldh [hJoyHeld], a
	ld a, SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	call StopAllMusic
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic
	call UpdateSprites
	call Delay3
	call UpdateSprites
	call Delay3
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_POKEMONMANSIONB1F_TEXT12
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, HS_POKEMON_MANSION_B1F_JAMES
	call PokemonMansionB1FScript_ShowObject
	ld a, HS_POKEMON_MANSION_B1F_JESSIE
	call PokemonMansionB1FScript_ShowObject
	ld a, SCRIPT_POKEMONMANSIONB1F_SCRIPT4
	call PokemonMansionB1FSetScript
	ret

PokemonMansionB1FJessieJamesMovementData_45605:
	db $4
PokemonMansionB1FJessieJamesMovementData_45606:
	db $4
	db $4
	db $4
	db $ff

PokemonMansionB1FScript4:
	ld de, PokemonMansionB1FJessieJamesMovementData_45605
	CheckEvent EVENT_BEAT_MANSION_4_JESSIE_JAMES_ON_LEFT
	jr z, .asm_45617
	ld de, PokemonMansionB1FJessieJamesMovementData_45606
.asm_45617
	ld a, POKEMONMANSIONB1F_JAMES
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, SCRIPT_POKEMONMANSIONB1F_SCRIPT5
	call PokemonMansionB1FSetScript
	ret

PokemonMansionB1FScript5:
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
PokemonMansionB1FScript6:
	ld a, SPRITE_FACING_LEFT
	ld [wSprite01StateData1FacingDirection], a
	CheckEvent EVENT_BEAT_MANSION_4_JESSIE_JAMES_ON_LEFT
	jr z, .asm_4564a
	ld a, SPRITE_FACING_DOWN
	ld [wSprite01StateData1FacingDirection], a
.asm_4564a
	ld a, $2
	ld [wSprite01StateData1MovementStatus], a
PokemonMansionB1FScript7:
	ld de, PokemonMansionB1FJessieJamesMovementData_45606
	CheckEvent EVENT_BEAT_MANSION_4_JESSIE_JAMES_ON_LEFT
	jr z, .asm_4565f
	ld de, PokemonMansionB1FJessieJamesMovementData_45605
.asm_4565f
	ld a, POKEMONMANSIONB1F_JESSIE
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, SCRIPT_POKEMONMANSIONB1F_SCRIPT8
	call PokemonMansionB1FSetScript
	ret

PokemonMansionB1FScript8:
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, [wStatusFlags5]
	bit BIT_SCRIPTED_NPC_MOVEMENT, a
	ret nz
PokemonMansionB1FScript9:
	ld a, $2
	ld [wSprite02StateData1MovementStatus], a
	ld a, SPRITE_FACING_DOWN
	ld [wSprite02StateData1FacingDirection], a
	CheckEvent EVENT_BEAT_MANSION_4_JESSIE_JAMES_ON_LEFT
	jr z, .asm_45697
	ld a, SPRITE_FACING_RIGHT
	ld [wSprite02StateData1FacingDirection], a
.asm_45697
	call Delay3
	ld a, ~(A_BUTTON | B_BUTTON)
	ld [wJoyIgnore], a
	ld a, TEXT_POKEMONMANSIONB1F_TEXT13
	ldh [hTextID], a
	call DisplayTextID
PokemonMansionB1FScript10:
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, PokemonMansionB1FJessieJamesEndBattleText
	ld de, PokemonMansionB1FJessieJamesEndBattleText
	call SaveEndBattleTextPointers
	ld a, OPP_ROCKET
	ld [wCurOpponent], a
	ld a, $2e
	ld [wTrainerNo], a
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	SetEvent EVENT_JESSIE_JAMES
	ld a, SCRIPT_POKEMONMANSIONB1F_SCRIPT11
	call PokemonMansionB1FSetScript
	ret

PokemonMansionB1FScript11:
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, [wIsInBattle]
	cp $ff
	jp z, PokemonMansionB1FResetScripts
	ld a, $2
	ld [wSprite02StateData1MovementStatus], a
	ld [wSprite03StateData1MovementStatus], a
	xor a
	ld [wSprite01StateData1FacingDirection], a
	ld [wSprite02StateData1FacingDirection], a
	ld a, SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, TEXT_POKEMONMANSIONB1F_TEXT14
	ldh [hTextID], a
	call DisplayTextID
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call StopAllMusic
	ld c, BANK(Music_MeetJessieJames)
	ld a, MUSIC_MEET_JESSIE_JAMES
	call PlayMusic
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	ld a, SCRIPT_POKEMONMANSIONB1F_SCRIPT12
	call PokemonMansionB1FSetScript
	ret

PokemonMansionB1FScript12:
	ld a, A_BUTTON | B_BUTTON | SELECT | START | D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a
	call GBFadeOutToBlack
	ld a, HS_POKEMON_MANSION_B1F_JAMES
	call PokemonMansionB1FScript_HideObject
	ld a, HS_POKEMON_MANSION_B1F_JESSIE
	call PokemonMansionB1FScript_HideObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	ld a, SCRIPT_POKEMONMANSIONB1F_SCRIPT13
	call PokemonMansionB1FSetScript
	ret

PokemonMansionB1FScript13:
	call PlayDefaultMusic
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_MANSION_4_JESSIE_JAMES
	ld a, SCRIPT_POKEMONMANSIONB1F_DEFAULT
	call PokemonMansionB1FSetScript
	ret

PokemonMansionB1FScript_ShowObject:
	ld [wMissableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	ret

PokemonMansionB1FScript_HideObject:
	ld [wMissableObjectIndex], a
	predef HideObject
	ret

PokemonMansionB1F_TextPointers:
	def_text_pointers
	dw_const PokemonMansionB1FJessieJamesText, TEXT_POKEMONMANSIONB1F_JAMES
	dw_const PokemonMansionB1FJessieJamesText, TEXT_POKEMONMANSIONB1F_JESSIE
	dw_const PokemonMansionB1FBurglarText,   TEXT_POKEMONMANSIONB1F_BURGLAR
	dw_const PokemonMansionB1FScientistText, TEXT_POKEMONMANSIONB1F_SCIENTIST
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_RARE_CANDY
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_FULL_RESTORE
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_TM_BLIZZARD
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_TM_SOLARBEAM
	dw_const PokemonMansionB1FDiaryText,     TEXT_POKEMONMANSIONB1F_DIARY
	dw_const PickUpItemText,                 TEXT_POKEMONMANSIONB1F_SECRET_KEY
	dw_const PokemonMansion2FSwitchText,     TEXT_POKEMONMANSIONB1F_SWITCH ; This switch uses the text script from the 2F.
	dw_const PokemonMansionB1FText12,        TEXT_POKEMONMANSIONB1F_TEXT12
	dw_const PokemonMansionB1FText13,        TEXT_POKEMONMANSIONB1F_TEXT13
	dw_const PokemonMansionB1FText14,        TEXT_POKEMONMANSIONB1F_TEXT14

Mansion4TrainerHeaders:
	def_trainers
Mansion4TrainerHeader0:
	trainer EVENT_BEAT_MANSION_4_TRAINER_0, 0, PokemonMansionB1FBurglarBattleText, PokemonMansionB1FBurglarEndBattleText, PokemonMansionB1FBurglarAfterBattleText
Mansion4TrainerHeader1:
	trainer EVENT_BEAT_MANSION_4_TRAINER_1, 3, PokemonMansionB1FScientistBattleText, PokemonMansionB1FScientistEndBattleText, PokemonMansionB1FScientistAfterBattleText
	db -1 ; end

PokemonMansionB1FJessieJamesText:
	text_end

PokemonMansionB1FText12:
	text_far _PokemonMansionJessieJamesText1
	text_asm
	ld c, 10
	rst _DelayFrames
	ld a, $8
	ld [wPlayerMovingDirection], a
	ld a, $0
	ld [wEmotionBubbleSpriteIndex], a
	ld a, EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld c, 20
	rst _DelayFrames
	rst TextScriptEnd

PokemonMansionB1FText13:
	text_far _PokemonMansionJessieJamesText2
	text_end

PokemonMansionB1FJessieJamesEndBattleText:
	text_far _PokemonMansionJessieJamesText3
	text_end

PokemonMansionB1FText14:
	text_far _PokemonMansionJessieJamesText4
	text_asm
	ld c, 64
	rst _DelayFrames
	rst TextScriptEnd

PokemonMansionB1FBurglarText:
	text_asm
	ld hl, Mansion4TrainerHeader0
	call TalkToTrainer
	rst TextScriptEnd

PokemonMansionB1FScientistText:
	text_asm
	ld hl, Mansion4TrainerHeader1
	call TalkToTrainer
	rst TextScriptEnd

PokemonMansionB1FBurglarBattleText:
	text_far _PokemonMansionB1FBurglarBattleText
	text_end

PokemonMansionB1FBurglarEndBattleText:
	text_far _PokemonMansionB1FBurglarEndBattleText
	text_end

PokemonMansionB1FBurglarAfterBattleText:
	text_far _PokemonMansionB1FBurglarAfterBattleText
	text_end

PokemonMansionB1FScientistBattleText:
	text_far _PokemonMansionB1FScientistBattleText
	text_end

PokemonMansionB1FScientistEndBattleText:
	text_far _PokemonMansionB1FScientistEndBattleText
	text_end

PokemonMansionB1FScientistAfterBattleText:
	text_far _PokemonMansionB1FScientistAfterBattleText
	text_end

PokemonMansionB1FDiaryText:
	text_far _PokemonMansionB1FDiaryText
	text_end
