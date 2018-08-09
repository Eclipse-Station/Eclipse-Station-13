
/*
*
*Sledgehammer
*Mjollnir
*
*/


/obj/item/weapon/material/twohanded/sledgehammer  // a SLEGDGEHAMMER
	icon_state = "sledgehammer0"
	base_icon = "sledgehammer"
	name = "sledgehammer"
	desc = "A long, heavy hammer meant to be used with both hands. Typically used for breaking rocks and driving posts, it can also be used for breaking bones or driving points home."
	description_info = "This weapon can cleave, striking nearby lesser, hostile enemies close to the primary target.  It must be held in both hands to do this."
	unwielded_force_divisor = 0.25
	force = 25
	force_divisor = 0.9 // 10/42 with hardness 60 (steel) and 0.25 unwielded divisor
	hitsound = 'sound/weapons/heavysmash.ogg'
	icon = 'modular_aeiou/icons/obj/weapons_aeiou.dmi'
	w_class = ITEMSIZE_HUGE
	slowdown = 1.5
	dulled_divisor = 0.95	//Still metal on a stick
	sharp = 0
	edge = 0
	force_wielded = 40
	attack_verb = list("attacked", "smashed", "crushed", "wacked", "pounded")
	applies_material_colour = 0

/obj/item/weapon/material/twohanded/sledgehammer/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && !issmall(M) && M.item_is_in_hands(src) && !M.hands_are_full())
		wielded = 1
		pry = 1
		force = force_wielded
		name = "[base_name] (wielded)"
		update_icon()
	else
		wielded = 0
		pry = 0
		force = force_unwielded
		name = "[base_name]"
	update_icon()
	..()

/obj/item/weapon/material/twohanded/sledgehammer/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A && wielded)
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.shatter()
		else if(istype(A,/obj/structure/grille))
			qdel(A)
		else if(istype(A,/obj/effect/plant))
			var/obj/effect/plant/P = A
			P.die_off()

// This cannot go into afterattack since some mobs delete themselves upon dying.
/obj/item/weapon/material/twohanded/sledgehammer/pre_attack(var/mob/living/target, var/mob/living/user)
	if(istype(target))
		cleave(user, target)

/obj/item/weapon/material/twohanded/sledgehammer/mjollnir
	icon_state = "mjollnir0"
	base_icon = "mjollnir"
	name = "Mjollnir"
	desc = "A long, heavy hammer. This weapons crackles with barely contained energy."
	force_divisor = 2
	hitsound = 'sound/effects/lightningbolt.ogg'
	force = 50
	throwforce = 15
	force_wielded = 75
	slowdown = 0

/*
/obj/item/weapon/material/twohanded/sledgehammer/mjollnir/afterattack(var/atom/impacted)
	if(isliving(impacted))
		var/mob/living/L = impacted
		if(L.mind)
			var/nif
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				nif = H.nif
			SStranscore.m_backup(L.mind,nif,one_time = TRUE)
		L.gib()
*/

/*
/obj/item/weapon/material/twohanded/sledgehammer/mjollnir/New()
	..()
	for(var/k in 1 to firemodes.len)
		harmmodes[k] = new /datum/harmmodes(src, harmmodes[k])

/obj/item/weapon/material/twohanded/sledgehammer/mjollnir/attack_self(mob/user as mob)
	switch_harmmodes(user)

/obj/item/weapon/material/twohanded/sledgehammer/mjollnir/proc/shock(mob/living/target)
	target.Stun(60)
	target.visible_message("<span class='danger'>[target.name] was shocked by [src]!</span>", \
		"<span class='userdanger'>You feel a powerful shock course through your body sending you flying!</span>", \
		"<span class='italics'>You hear a heavy electrical crack!</span>")
	var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
	target.throw_at(throw_target, 200, 4)
	return
*/

/obj/item/weapon/material/twohanded/sledgehammer/mjollnir/afterattack(mob/living/G, mob/user)
	..()

	if(wielded)
		if(prob(10))
			G.electrocute_act(500, src, def_zone = BP_TORSO)
			return
		if(prob(10))
			G.dust()
			return
		else
			G.stun_effect_act(10 , 50,def_zone = BP_TORSO, src)
			G.take_organ_damage(10)
			G.Paralyse(20)
			playsound(src.loc, "sparks", 50, 1)
			return

	//	/mob/living/proc/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)



/*
/obj/item/weapon/material/twohanded/sledgehammer/mjollnir/throw_impact(atom/target)
	. = ..()
	if(isliving(target))
//		target.shock()
		G.shock()
*/

/obj/item/weapon/material/twohanded/sledgehammer/mjollnir/update_icon()  //Currently only here to fuck with the on-mob icons.
	icon_state = "mjollnir[wielded]"
	return

