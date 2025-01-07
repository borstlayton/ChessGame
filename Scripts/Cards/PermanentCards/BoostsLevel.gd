extends Node

#buzzer_beater = 1
#modless = 2
#no enemies = 3
#pawn promotion = 4
#safe and sound = 5
#timely king = 6

var level_boosts = [
	[1.25,1.3,1.35,1.45,1.5,1.6,1.7,1.8,1.9,2.0], #buzzer_beater
	[1.2,1.25,1.3,1.35,1.4,1.5,1.6,1.7,1.8], #modless
	[1.5,1.65,1.8,1.95,2.1,2.3,2.5,2.7,3.0,3.25], #no_enemies
	[1.1,1.15,1.2,1.25,1.3,1.35,1.4,1.45,1.5,1.6], #pawn_promotion
	[1.5,1.65,1.8,1.95,2.1,2.3,2.5,2.7,3.0,3.25], #safe_and_sound
	[1.25,1.3,1.35,1.45,1.5,1.6,1.7,1.8,1.9,2.0] #timely_king
]
