/obj/mecha/combat/reticence
	desc = "A silent, fast, and nigh-invisible miming exosuit. Popular among mimes and mime assassins."
	name = "\improper reticence"
	icon_state = "mime"
	initial_icon = "mime"
	step_in = 2
	dir_in = 1 //Facing North.
	health = 80
	deflect_chance = 3
	damage_absorption = list("brute"=0.7,"fire"=0.7,"bullet"=0.7,"laser"=0.7,"energy"=0.7,"bomb"=0.7)
	max_temperature = 15000
	infra_luminosity = 6
	wreckage = /obj/effect/decal/mecha_wreckage/mime
	internal_damage_threshold = 25
	max_equip = 3
	step_energy_drain = 3
	force = 15
	opacity = 1
	unacidable = 1
	alpha = 50
	anchored = 1
	lights_power = 20

/obj/mecha/combat/reticence/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/silenced
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/rcd //HAHA IT MAKES WALLS GET IT
	ME.attach(src)
	return
