/obj/mecha/combat/durand
	desc = "An aging combat exosuit utilized by many corporations. Originally developed to combat hostile alien lifeforms."
	name = "Durand"
	icon_state = "durand"
	initial_icon = "durand"
	step_in = 4
	dir_in = 1 //Facing North.
	health = 400
	maxhealth = 400
	deflect_chance = 20
	damage_absorption = list("brute"=0.5,"fire"=1.1,"bullet"=0.65,"laser"=0.85,"energy"=0.9,"bomb"=0.8)
	max_temperature = 30000
	infra_luminosity = 8
	force = 40
	var/defence = 0
	var/defence_deflect = 35
	wreckage = /obj/effect/decal/mecha_wreckage/durand

	max_hull_equip = 2
	max_weapon_equip = 1
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 1

/*
/obj/mecha/combat/durand/New()
	..()
	weapons += new /datum/mecha_weapon/ballistic/lmg(src)
	weapons += new /datum/mecha_weapon/ballistic/scattershot(src)
	selected_weapon = weapons[1]
	return
*/

/obj/mecha/combat/durand/relaymove(mob/user,direction)
	if(defence)
		if(world.time - last_message > 20)
			src.occupant_message("<font color='red'>Unable to move while in defense mode</font>")
			last_message = world.time
		return 0
	. = ..()
	return


/obj/mecha/combat/durand/verb/engage_defence_mode()
	set category = "Exosuit Interface"
	set name = "Toggle defense mode"
	set src = usr.loc
	set popup_menu = 0
	defence_mode()

/obj/mecha/combat/durand/defence_mode()
	if(usr!=src.occupant)
		return
	defence = !defence
	playsound(src, 'sound/mecha/duranddefencemode.ogg', 50, 1)
	if(defence)
		deflect_chance = defence_deflect
		src.occupant_message("<font color='blue'>You enable [src] defense mode.</font>")
		defence_mode = 1
	else
		deflect_chance = initial(deflect_chance)
		src.occupant_message("<font color='red'>You disable [src] defense mode.</font>")
		defence_mode = 0
	src.log_message("Toggled defense mode.")

	return


/obj/mecha/combat/durand/get_stats_part()
	var/output = ..()
	output += "<b>Defence mode: [defence?"on":"off"]</b>"
	return output

/obj/mecha/combat/durand/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_defence_mode=1'>Toggle defense mode</a>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/mecha/combat/durand/Topic(href, href_list)
	..()
	if (href_list["toggle_defence_mode"])
		src.defence_mode()
	return

/obj/mecha/combat/durand/GrantActions(mob/living/user, human_occupant = 0)
	..()
	defense_action.Grant(user, src)

/obj/mecha/combat/durand/RemoveActions(mob/living/user, human_occupant = 0)
	..()
	defense_action.Remove(user, src)