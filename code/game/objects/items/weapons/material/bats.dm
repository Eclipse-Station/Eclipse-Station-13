/obj/item/weapon/material/twohanded/baseballbat
	name = "bat"
	desc = "HOME RUN!"
	icon_state = "metalbat0"
	base_icon = "metalbat"
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	default_material = "wood"
	force_divisor = 1.1           // 22 when wielded with weight 20 (steel)
	unwielded_force_divisor = 0.7 // 15 when unwielded based on above.
	dulled_divisor = 0.75		  // A "dull" bat is still gonna hurt
	slot_flags = SLOT_BACK



//Predefined materials go here.
/obj/item/weapon/material/twohanded/baseballbat/metal/New(var/newloc)
	..(newloc,"steel")

/obj/item/weapon/material/twohanded/baseballbat/uranium/New(var/newloc)
	..(newloc,"uranium")

/obj/item/weapon/material/twohanded/baseballbat/gold/New(var/newloc)
	..(newloc,"gold")

/obj/item/weapon/material/twohanded/baseballbat/platinum/New(var/newloc)
	..(newloc,"platinum")

/obj/item/weapon/material/twohanded/baseballbat/diamond/New(var/newloc)
	..(newloc,"diamond")

/*
/obj/item/weapon/material/twohanded/baseballbat/rainbow
	name = "bat"
	desc = "HOME RUN!"
	icon_state = "rainbowbat0"
	base_icon = "rainbowbat"
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/homerun.ogg'
	default_material = "metal"
	force_divisor = 1.6
	unwielded_force_divisor = 0.7
	dulled_divisor = 0.85		  // A "dull" bat is still gonna hurt
	slot_flags = SLOT_BACK
*/

/obj/item/weapon/material/twohanded/baseballbat/homerun
	name = "home run bat"
	desc = "This thing looks dangerous... Dangerously good at baseball, that is."
	force = 10
	icon_state = "rainbowbat0"
	base_icon = "rainbowbat"
	var/homerun_ready = 0
	var/homerun_able = 0
	homerun_able = 1

/obj/item/weapon/material/twohanded/baseballbat/homerun/attack_self(mob/user)
	if(!homerun_able)
		..()
		return
	if(homerun_ready)
		to_chat(user, "<span class='notice'>You're already ready to do a home run!</span>")
		..()
		return
	to_chat(user, "<span class='warning'>You begin gathering strength...</span>")
	playsound(get_turf(src), 'sound/effects/lightning_chargeup.ogg', 65, 1)
	if(do_after(user, 90, target = src))
		to_chat(user, "<span class='userdanger'>You gather power! Time for a home run!</span>")
		homerun_ready = 1
	..()

/obj/item/weapon/material/twohanded/baseballbat/homerun/attack(mob/living/target, mob/living/user)
	. = ..()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(homerun_ready)
		force = 25
		user.visible_message("<span class='userdanger'>It's a home run!</span>")
		target.throw_at(throw_target, rand(8,10), 14, user)
		world << "<font size='5' color='red'><b>HOME RUN!</b></font>"
//		target.ex_act(EXPLODE_HEAVY)
		playsound(get_turf(src), 'sound/weapons/homerun.ogg', 100, 1)
		homerun_ready = 0
		return
	else if(!target.anchored)
		target.throw_at(throw_target, rand(1,2), 7, user)