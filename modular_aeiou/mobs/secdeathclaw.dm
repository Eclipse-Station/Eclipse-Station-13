/mob/living/simple_animal/hostile/deathclaw/security
	name = "Excessive Force"
	desc = "Yep, that's a deathclaw wearing security armor, you are NOT supposed to be here."
	icon = 'modular_aeiou/icons/mob/aeioumobs.dmi'
	icon_dead = "deathclaw-dead"
	icon_living = "security_deathclaw"
	icon_state = "security_deathclaw"

	attacktext = list("mauled")

	faction = "secdeathclaw"

	maxHealth = 200
	health = 200
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0) //This deathclaw is wearing specially refitted standard security armor
	taser_kill = 0		//This deathclaw has been conditioned against tasers and that's not necessarily a good thing
	
	melee_damage_lower = 30
	melee_damage_upper = 30
	
	attack_sharp = 1	//Not only will this kill you, it will hurt the entire time you are dying
	attack_edge = 1		//Flying a kite is hard when you're missing your hand
	
	wander = 1
	wander_distance = 1	//security deathclaw won't wander far from where it is deployed
	
	follow_until_time = 100	//it should stop chasing someone after ten seconds and attempt to go back to spawn
	returns_home = 1	//this tells it to go back to spawn
	intelligence_level = SA_HUMANOID
	
	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

// Activate Noms!
/mob/living/simple_animal/hostile/deathclaw
	vore_active = 0
	vore_capacity = 2
	vore_max_size = RESIZE_HUGE
	vore_min_size = RESIZE_SMALL
	vore_pounce_chance = 0 // Beat them into crit before eating.
	vore_icons = SA_ICON_LIVING
