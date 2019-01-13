/mob/living/simple_animal/redmob/screamer
	name = "your reflection"
	desc = "Is that..?"
	icon = 'icons/mob/ghost.dmi'
	icon_state = "ghost"
	tt_desc = "$!@%#!"
	alpha = 5
	health = 9999
	var/smudgecolor = "#8b0000"
	var/mob/living/victim
	var/dormant = 0 //for future use with Humes