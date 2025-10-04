MtMoonB1F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, MtMoonB1TrainerHeaders
	ld de, MtMoonB1F_ScriptPointers
	ld a, [wMtMoonB1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wMtMoonB1FCurScript], a
	ret

MtMoonB1F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_MTMOONB1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_MTMOONB1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_MTMOONB1F_END_BATTLE

MtMoonB1F_TextPointers:
	def_text_pointers
;	dw_const MtMoonB1FUnusedText,                   TEXT_MTMOONB1F_UNUSED
	dw_const MtMoonB1FRocketText,                   TEXT_MTMOONB1F_ROCKET

MtMoonB1TrainerHeaders:
	def_trainers
MtMoonB1FTrainerHeader0:
	trainer EVENT_BEAT_MT_MOON_B1F_TRAINER_0, 3, MtMoonB1FRocketBattleText, MtMoonB1FRocketEndBattleText, MtMoonB1FRocketAfterBattleText
	db -1 ; end

MtMoonB1FRocketText:
	text_asm
	ld hl, MtMoonB1FTrainerHeader0
	call TalkToTrainer
	rst TextScriptEnd

MtMoonB1FRocketBattleText:
	text_far _MtMoonB1FRocketBattleText
	text_end

MtMoonB1FRocketEndBattleText:
	text_far _MtMoonB1FRocketEndBattleText
	text_end

MtMoonB1FRocketAfterBattleText:
	text_far _MtMoonB1FRocketAfterBattleText
	text_end

;MtMoonB1FUnusedText:
;	text_far _MtMoonB1FUnusedText
;	text_end
