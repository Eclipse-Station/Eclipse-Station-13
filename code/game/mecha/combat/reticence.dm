/obj/mecha/combat/reticence //This is a (bad) port of the reticence from TG.
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
	opacity = 0 //Let light in
	unacidable = 1
	alpha = 35
	anchored = 1
	lights_power = 20
	silent_step = 1
	var/silence = 0 //Can people hear the footsteps
	var/visibility = 0 //Are we visible 

/obj/mecha/combat/reticence/loaded/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/silenced
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/rcd //HAHA IT MAKES WALLS GET IT
	ME.attach(src)
	return

/obj/mecha/combat/reticence/verb/silent_mode() //I'll be real this is jus defence mode copied over.
	set category = "Exosuit Interface"
	set name = "Toggle silent mode"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	silent_step = !silent_step
	if(silent_step)
		src.occupant_message("<font color='blue'>You enable [src] silent mode.</font>")
	else
		src.occupant_message("<font color='red'>You disable [src] silent mode.</font>")
	src.log_message("Toggled silent mode.")
	return


/obj/mecha/combat/reticence/get_stats_part()
	var/output = ..()
	output += "<b>silent mode: [silence?"on":"off"]</b>"
	return output

/obj/mecha/combat/reticence/get_commands() 
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_silent_mode=1'>Toggle silent mode</a>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/mecha/combat/reticence/Topic(href, href_list)
	..()
	if (href_list["toggle_silent_mode"])
		src.silent_mode()
	return

/obj/mecha/combat/reticence/verb/visibility() //I'll be real this is jus defence mode copied over.
	set category = "Exosuit Interface"
	set name = "Toggle visibility"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	visibility = !visibility
	if(visibility)
		src.occupant_message("<font color='blue'>You enable [src] invisiblity.</font>")
		alpha = 35
	else
		alpha = 255
		src.occupant_message("<font color='red'>You disable [src] invisiblity.</font>")
	src.log_message("Toggled invisiblity.")
	src.occupant << sound('sound/effects/phasein.ogg',volume=50)
	return

