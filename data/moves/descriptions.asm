MoveDescriptions::
; entries correspond to move ids (see constants/move_constants.asm)
	table_width 2, MoveDescriptions
	dw PoundDescription
	dw KarateChopDescription
	dw DoubleslapDescription
	dw CometPunchDescription
	dw MegaPunchDescription
	dw PayDayDescription
	dw FirePunchDescription
	dw IcePunchDescription
	dw ThunderpunchDescription
	dw ScratchDescription
	dw VicegripDescription
	dw GuillotineDescription
	dw RazorWindDescription
	dw SwordsDanceDescription
	dw CutDescription
	dw GustDescription
	dw WingAttackDescription
	dw WhirlwindDescription
	dw FlyDescription
	dw BindDescription
	dw SlamDescription
	dw VineWhipDescription
	dw StompDescription
	dw DoubleKickDescription
	dw MegaKickDescription
	dw JumpKickDescription
	dw RollingKickDescription
	dw SandAttackDescription
	dw HeadbuttDescription
	dw HornAttackDescription
	dw FuryAttackDescription
	dw HornDrillDescription
	dw TackleDescription
	dw BodySlamDescription
	dw WrapDescription
	dw TakeDownDescription
	dw ThrashDescription
	dw DoubleEdgeDescription
	dw TailWhipDescription
	dw PoisonStingDescription
	dw TwineedleDescription
	dw PinMissileDescription
	dw LeerDescription
	dw BiteDescription
	dw GrowlDescription
	dw RoarDescription
	dw SingDescription
	dw SupersonicDescription
	dw SonicboomDescription
	dw DisableDescription
	dw AcidDescription
	dw EmberDescription
	dw FlamethrowerDescription
	dw MistDescription
	dw WaterGunDescription
	dw HydroPumpDescription
	dw SurfDescription
	dw IceBeamDescription
	dw BlizzardDescription
	dw PsybeamDescription
	dw BubblebeamDescription
	dw AuroraBeamDescription
	dw HyperBeamDescription
	dw PeckDescription
	dw DrillPeckDescription
	dw SubmissionDescription
	dw LowKickDescription
	dw CounterDescription
	dw SeismicTossDescription
	dw StrengthDescription
	dw AbsorbDescription
	dw MegaDrainDescription
	dw LeechSeedDescription
	dw GrowthDescription
	dw RazorLeafDescription
	dw SolarbeamDescription
	dw PoisonpowderDescription
	dw StunSporeDescription
	dw SleepPowderDescription
	dw PetalDanceDescription
	dw StringShotDescription
	dw DragonRageDescription
	dw FireSpinDescription
	dw ThundershockDescription
	dw ThunderboltDescription
	dw ThunderWaveDescription
	dw ThunderDescription
	dw RockThrowDescription
	dw EarthquakeDescription
	dw FissureDescription
	dw DigDescription
	dw ToxicDescription
	dw ConfusionDescription
	dw PsychicMDescription
	dw HypnosisDescription
	dw MeditateDescription
	dw AgilityDescription
	dw QuickAttackDescription
	dw RageDescription
	dw TeleportDescription
	dw NightShadeDescription
	dw MimicDescription
	dw ScreechDescription
	dw DoubleTeamDescription
	dw RecoverDescription
	dw HardenDescription
	dw MinimizeDescription
	dw SmokescreenDescription
	dw ConfuseRayDescription
	dw WithdrawDescription
	dw DefenseCurlDescription
	dw BarrierDescription
	dw LightScreenDescription
	dw HazeDescription
	dw ReflectDescription
	dw FocusEnergyDescription
	dw BideDescription
	dw MetronomeDescription
	dw MirrorMoveDescription
	dw SelfdestructDescription
	dw EggBombDescription
	dw LickDescription
	dw SmogDescription
	dw SludgeDescription
	dw BoneClubDescription
	dw FireBlastDescription
	dw WaterfallDescription
	dw ClampDescription
	dw SwiftDescription
	dw SkullBashDescription
	dw SpikeCannonDescription
	dw ConstrictDescription
	dw AmnesiaDescription
	dw KinesisDescription
	dw SoftboiledDescription
	dw HiJumpKickDescription
	dw GlareDescription
	dw DreamEaterDescription
	dw PoisonGasDescription
	dw BarrageDescription
	dw LeechLifeDescription
	dw LovelyKissDescription
	dw SkyAttackDescription
	dw TransformDescription
	dw BubbleDescription
	dw DizzyPunchDescription
	dw SporeDescription
	dw FlashDescription
	dw PsywaveDescription
	dw SplashDescription
	dw AcidArmorDescription
	dw CrabhammerDescription
	dw ExplosionDescription
	dw FurySwipesDescription
	dw BonemerangDescription
	dw RestDescription
	dw RockSlideDescription
	dw HyperFangDescription
	dw SharpenDescription
	dw ConversionDescription
	dw TriAttackDescription
	dw SuperFangDescription
	dw SlashDescription
	dw SubstituteDescription
	dw StruggleDescription
	assert_table_length NUM_ATTACKS
PoundDescription:
	db   "Pounds with fore-"
	feed "legs or tail.@"
KarateChopDescription:
	db   "Has a high criti-"
	feed "cal hit ratio.@"
DoubleslapDescription:
	db   "Repeatedly slaps"
	feed "2-5 times.@"
CometPunchDescription:
	db   "Repeatedly punches"
	feed "2-5 times.@"
MegaPunchDescription:
	db   "A powerful punch"
	feed "thrown very hard.@"
PayDayDescription:
	db   "Throws coins. Gets"
	feed "them back later.@"
FirePunchDescription:
	db   "A fiery punch. May"
	feed "cause a burn.@"
IcePunchDescription:
	db   "An icy punch. May"
	feed "cause freezing.@"
ThunderpunchDescription:
	db   "An electric punch."
	feed "It may paralyze.@"
ScratchDescription:
	db   "Scratches with"
	feed "sharp claws.@"
VicegripDescription:
	db   "Grips with power-"
	feed "ful pincers.@"
GuillotineDescription:
	db   "A one-hit KO,"
	feed "pincer attack.@"
RazorWindDescription:
	db   "1st turn: Attack"
	feed "2nd turn: Rest@"
SwordsDanceDescription:
	db   "A dance that in-"
	feed "creases ATTACK.@"
CutDescription:
	db   "Cuts using claws,"
	feed "scythes, etc.@"
GustDescription:
	db   "Whips up a strong"
	feed "gust of wind.@"
WingAttackDescription:
	db   "Strikes the target"
	feed "with wings.@"
WhirlwindDescription:
	db   "Blows away the foe"
	feed "& ends battle.@"
FlyDescription:
	db   "1st turn: Fly"
	feed "2nd turn: Attack@"
BindDescription:
	db   "Binds the target"
	feed "for 2-5 turns.@"
SlamDescription:
	db   "Slams the foe with"
	feed "a tail, vine, etc.@"
VineWhipDescription:
	db   "Whips the foe with"
	feed "slender vines.@"
StompDescription:
	db   "An attack that may"
	feed "cause flinching.@"
DoubleKickDescription:
	db   "A double kicking"
	feed "attack.@"
MegaKickDescription:
	db   "A powerful kicking"
	feed "attack.@"
JumpKickDescription:
	db   "May miss, damaging"
	feed "the user.@"
RollingKickDescription:
	db   "A fast, spinning"
	feed "kick.@"
SandAttackDescription:
	db   "Reduces accuracy"
	feed "by throwing sand.@"
HeadbuttDescription:
	db   "An attack that may"
	feed "make foe flinch.@"
HornAttackDescription:
	db   "An attack using a"
	feed "horn to jab.@"
FuryAttackDescription:
	db   "Jabs the target"
	feed "2-5 times.@"
HornDrillDescription:
	db   "A one-hit KO,"
	feed "drill attack.@"
TackleDescription:
	db   "A full-body charge"
	feed "attack.@"
BodySlamDescription:
	db   "An attack that may"
	feed "cause paralysis.@"
WrapDescription:
	db   "Squeezes the foe"
	feed "for 2-5 turns.@"
TakeDownDescription:
	db   "A tackle that also"
	feed "hurts the user.@"
ThrashDescription:
	db   "Works 2-3 turns"
	feed "and confuses user.@"
DoubleEdgeDescription:
	db   "A tackle that also"
	feed "hurts the user.@"
TailWhipDescription:
	db   "Lowers the foe's"
	feed "DEFENSE.@"
PoisonStingDescription:
	db   "An attack that may"
	feed "poison the target.@"
TwineedleDescription:
	db   "Jabs the foe twice"
	feed "using stingers.@"
PinMissileDescription:
	db   "Fires pins that"
	feed "strike 2-5 times.@"
LeerDescription:
	db   "Reduces the foe's"
	feed "DEFENSE.@"
BiteDescription:
	db   "An attack that may"
	feed "cause flinching.@"
GrowlDescription:
	db   "Reduces the foe's"
	feed "ATTACK.@"
RoarDescription:
	db   "Scares wild foes"
	feed "to end battle.@"
SingDescription:
	db   "May cause the foe"
	feed "to fall asleep.@"
SupersonicDescription:
	db   "Sound waves that"
	feed "cause confusion.@"
SonicboomDescription:
	db   "Always inflicts"
	feed "20HP damage.@"
DisableDescription:
	db   "Disables the foe's"
	feed "most recent move.@"
AcidDescription:
	db   "An attack that may"
	feed "lower DEFENSE.@"
EmberDescription:
	db   "An attack that may"
	feed "inflict a burn.@"
FlamethrowerDescription:
	db   "An attack that may"
	feed "inflict a burn.@"
MistDescription:
	db   "Prevents stat"
	feed "reduction.@"
WaterGunDescription:
	db   "Squirts water to"
	feed "attack.@"
HydroPumpDescription:
	db   "A powerful water-"
	feed "type attack.@"
SurfDescription:
	db   "A strong water-"
	feed "type attack.@"
IceBeamDescription:
	db   "An attack that may"
	feed "freeze the foe.@"
BlizzardDescription:
	db   "An attack that may"
	feed "freeze the foe.@"
PsybeamDescription:
	db   "An attack that may"
	feed "confuse the foe.@"
BubblebeamDescription:
	db   "An attack that may"
	feed "lower SPEED.@"
AuroraBeamDescription:
	db   "An attack that may"
	feed "lower ATTACK.@"
HyperBeamDescription:
	db   "1st turn: Attack"
	feed "2nd turn: Rest@"
PeckDescription:
	db   "Jabs the foe with"
	feed "a beak, etc.@"
DrillPeckDescription:
	db   "A strong, spin-"
	feed "ning-peck attack.@"
SubmissionDescription:
	db   "An attack that al-"
	feed "so hurts the user.@"
LowKickDescription:
	db   "An attack that may"
	feed "cause flinching.@"
CounterDescription:
	db   "Returns a physical"
	feed "blow double.@"
SeismicTossDescription:
	db   "The user's level"
	feed "equals damage HP.@"
StrengthDescription:
	db   "A powerful physi-"
	feed "cal attack.@"
AbsorbDescription:
	db   "Steals 1/2 of the"
	feed "damage inflicted.@"
MegaDrainDescription:
	db   "Steals 1/2 of the"
	feed "damage inflicted.@"
LeechSeedDescription:
	db   "Steals HP from the"
	feed "foe on every turn.@"
GrowthDescription:
	db   "Raises SPECIAL and"
	feed "ATTACK rating.@"
RazorLeafDescription:
	db   "Has a high criti-"
	feed "cal hit ratio.@"
SolarbeamDescription:
	db   "1st turn: Prepare"
	feed "2nd turn: Attack@"
PoisonpowderDescription:
	db   "A move that may"
	feed "poison the foe.@"
StunSporeDescription:
	db   "A move that may"
	feed "paralyze the foe.@"
SleepPowderDescription:
	db   "May cause the foe"
	feed "to fall asleep.@"
PetalDanceDescription:
	db   "Works 2-3 turns"
	feed "and confuses user.@"
StringShotDescription:
	db   "A move that lowers"
	feed "the foe's SPEED.@"
DragonRageDescription:
	db   "Always inflicts"
	feed "40HP damage.@"
FireSpinDescription:
	db   "Traps foe in fire"
	feed "for 2-5 turns.@"
ThundershockDescription:
	db   "An attack that may"
	feed "cause paralysis.@"
ThunderboltDescription:
	db   "An attack that may"
	feed "cause paralysis.@"
ThunderWaveDescription:
	db   "A move that may"
	feed "cause paralysis.@"
ThunderDescription:
	db   "An attack that may"
	feed "cause paralysis.@"
RockThrowDescription:
	db   "Drops rocks on the"
	feed "enemy.@"
EarthquakeDescription:
	db   "Tough but useless"
	feed "vs. flying foes.@"
FissureDescription:
	db   "A ground-type,"
	feed "one-hit KO attack.@"
DigDescription:
	db   "1st turn: Burrow"
	feed "2nd turn: Attack@"
ToxicDescription:
	db   "A poison move with"
	feed "increasing damage.@"
ConfusionDescription:
	db   "An attack that may"
	feed "cause confusion.@"
PsychicMDescription:
	db   "An attack that may"
	feed "lower SPECIAL.@"
HypnosisDescription:
	db   "May put the foe to"
	feed "sleep.@"
MeditateDescription:
	db   "Raises the user's"
	feed "ATTACK.@"
AgilityDescription:
	db   "Sharply increases"
	feed "the user's SPEED.@"
QuickAttackDescription:
	db   "Lets the user get"
	feed "in the first hit.@"
RageDescription:
	db   "Raises ATTACK if"
	feed "the user is hit.@"
TeleportDescription:
	db   "A move for fleeing"
	feed "from battle.@"
NightShadeDescription:
	db   "The user's level"
	feed "equals damage HP.@"
MimicDescription:
	db   "Copies a move used"
	feed "by the foe.@"
ScreechDescription:
	db   "Sharply reduces"
	feed "the foe's DEFENSE.@"
DoubleTeamDescription:
	db   "Heightens evasive-"
	feed "ness.@"
RecoverDescription:
	db   "Restores HP by 1/2"
	feed "the max HP.@"
HardenDescription:
	db   "Raises the user's"
	feed "DEFENSE.@"
MinimizeDescription:
	db   "Heightens evasive-"
	feed "ness.@"
SmokescreenDescription:
	db   "Lowers the foe's"
	feed "accuracy.@"
ConfuseRayDescription:
	db   "A move that causes"
	feed "confusion.@"
WithdrawDescription:
	db   "Heightens the"
	feed "user's DEFENSE.@"
DefenseCurlDescription:
	db   "Heightens the"
	feed "user's DEFENSE.@"
BarrierDescription:
	db   "Sharply increases"
	feed "user's DEFENSE.@"
LightScreenDescription:
	db   "Ups SPECIAL with"
	feed "a wall of light.@"
HazeDescription:
	db   "Eliminates all"
	feed "stat changes.@"
ReflectDescription:
	db   "Raises DEFENSE"
	feed "with a barrier.@"
FocusEnergyDescription:
	db   "Raises the criti-"
	feed "cal hit ratio.@"
BideDescription:
	db   "Waits 2-3 turns &"
	feed "hits back double.@"
MetronomeDescription:
	db   "Randomly uses any"
	feed "#MON move.@"
MirrorMoveDescription:
	db   "Counters with the"
	feed "same move.@"
SelfdestructDescription:
	db   "Powerful but makes"
	feed "the user faint.@"
EggBombDescription:
	db   "Eggs are hurled at"
	feed "the foe.@"
LickDescription:
	db   "An attack that may"
	feed "cause paralysis.@"
SmogDescription:
	db   "An attack that may"
	feed "poison the foe.@"
SludgeDescription:
	db   "An attack that may"
	feed "poison the foe.@"
BoneClubDescription:
	db   "An attack that may"
	feed "cause flinching.@"
FireBlastDescription:
	db   "An attack that"
	feed "may cause a burn.@"
WaterfallDescription:
	db   "An aquatic charge"
	feed "attack.@"
ClampDescription:
	db   "Traps the foe for"
	feed "2-5 turns.@"
SwiftDescription:
	db   "An attack that"
	feed "never misses.@"
SkullBashDescription:
	db   "1st turn: Attack"
	feed "2nd turn: Rest@"
SpikeCannonDescription:
	db   "Fires spikes to"
	feed "hit 2-5 times.@"
ConstrictDescription:
	db   "An attack that may"
	feed "lower SPEED.@"
AmnesiaDescription:
	db   "Sharply raises the"
	feed "user's SPECIAL.@"
KinesisDescription:
	db   "Reduces the foe's"
	feed "accuracy.@"
SoftboiledDescription:
	db   "Restores HP by 1/2"
	feed "the user's max HP.@"
HiJumpKickDescription:
	db   "May miss and hurt"
	feed "the user.@"
GlareDescription:
	db   "A move that may"
	feed "cause paralysis.@"
DreamEaterDescription:
	db   "Steals HP from a"
	feed "sleeping victim.@"
PoisonGasDescription:
	db   "A move that may"
	feed "poison the foe.@"
BarrageDescription:
	db   "Throws orbs to hit"
	feed "2-5 times.@"
LeechLifeDescription:
	db   "Steals 1/2 of the"
	feed "damage inflicted.@"
LovelyKissDescription:
	db   "May cause the foe"
	feed "to fall asleep.@"
SkyAttackDescription:
	db   "1st turn: Prepare"
	feed "2nd turn: Attack@"
TransformDescription:
	db   "The user assumes"
	feed "the foe's guise.@"
BubbleDescription:
	db   "An attack that may"
	feed "reduce SPEED.@"
DizzyPunchDescription:
	db   "An attack that may"
	feed "cause confusion.@"
SporeDescription:
	db   "A move that"
	feed "induces sleep.@"
FlashDescription:
	db   "Blinds the foe to"
	feed "reduce accuracy.@"
PsywaveDescription:
	db   "An attack with"
	feed "variable power.@"
SplashDescription:
	db   "Has no effect"
	feed "whatsoever.@"
AcidArmorDescription:
	db   "Sharply raises the"
	feed "user's DEFENSE.@"
CrabhammerDescription:
	db   "Has a high criti-"
	feed "cal hit ratio.@"
ExplosionDescription:
	db   "Very powerful but"
	feed "makes user faint.@"
FurySwipesDescription:
	db   "Quickly scratches"
	feed "2-5 times.@"
BonemerangDescription:
	db   "An attack that"
	feed "strikes twice.@"
RestDescription:
	db   "Sleep for 2 turns"
	feed "to fully recover.@"
RockSlideDescription:
	db   "An attack that may"
	feed "cause flinching.@"
HyperFangDescription:
	db   "An attack that may"
	feed "cause flinching.@"
SharpenDescription:
	db   "A move that raises"
	feed "the user's ATTACK.@"
ConversionDescription:
	db   "Change user's type"
	feed "to a move's type.@"
TriAttackDescription:
	db   "Fires three kinds"
	feed "of beams at once.@"
SuperFangDescription:
	db   "Cuts the foe's HP"
	feed "by 1/2.@"
SlashDescription:
	db   "Has a high criti-"
	feed "cal hit ratio.@"
SubstituteDescription:
	db   "Makes a decoy with"
	feed "1/4 user's max HP.@"
StruggleDescription:
	db   "Used only if your"
	feed "PP is exhausted.@"