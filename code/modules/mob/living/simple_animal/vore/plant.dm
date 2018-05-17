/mob/living/simple_animal/retaliate/plant
	name = "corrupt hound"
	desc = "Good boy machine broke. This is definitely no good news for the organic lifeforms in vicinity."
	icon = 'icons/mob/vore64x32.dmi'
	icon_state = "plant"
	icon_living = "plant"
	icon_dead = "plant-dead"
	icon_rest = "plant_rest"
	faction = "vegetable"
	tt_desc = "Uncataloged Life Form"

	maxHealth = 80
	health = 80

	wander = 0
	view_range = 7
	run_at_them = 0
	stop_automated_movement = 1

	melee_damage_lower = 0
	melee_damage_upper = 0
	grab_resist = 100

	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("ravaged")

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 150
	maxbodytemp = 900

	vore_active = TRUE
	vore_capacity = 3
	vore_pounce_chance = 30
	vore_ignores_undigestable = 1
	vore_standing_too = 1
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_stomach_name = "fuel processor"
	vore_stomach_flavor = "You have ended up in the fuel processor of this corrupted machine. This place was definitely not designed with safety and comfort in mind. The heated and cramped surroundings oozing potent fluids all over your form, eager to do nothing less than breaking you apart to fuel its rampage for the next few days... hours... minutes? Oh dear..."
	vore_default_mode = DM_HOLD
	vore_icons = 1

	loot_list = list(/obj/item/borg/upgrade/syndicate = 6, /obj/item/borg/upgrade/vtec = 6, /obj/item/weapon/material/knife/ritual = 6, /obj/item/weapon/disk/nifsoft/compliance = 6)


/mob/living/simple_animal/retaliate/plant/PunchTarget()
	if(istype(target_mob,/mob/living/simple_animal/mouse))
		return EatTarget()
	else ..()

/mob/living/simple_animal/retaliate/plant/death(gibbed, deathmessage = "shudders and collapses!")
	.=..()
	resting = 0
	icon_state = icon_dead
