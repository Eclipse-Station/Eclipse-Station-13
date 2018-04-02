/obj/item/weapon/material/sword
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	slot_flags = SLOT_BELT
	force_divisor = 0.7 // 42 when wielded with hardnes 60 (steel)
	thrown_force_divisor = 0.5 // 10 when thrown with weight 20 (steel)
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/weapon/material/sword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	if(default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/weapon/material/sword/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	viewers(user) << "<span class='danger'>[user] is falling on the [src.name]! It looks like [TU.he] [TU.is] trying to commit suicide.</span>"
	return(BRUTELOSS)

/obj/item/weapon/material/sword/katana
	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	icon_state = "katana"
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/weapon/material/sword/katana/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	visible_message(span("danger", "[user] is slitting [TU.his] stomach open with \the [src.name]! It looks like [TU.hes] trying to commit seppuku."), span("danger", "You slit your stomach open with \the [src.name]!"), span("danger", "You hear the sound of flesh tearing open.")) // gory, but it gets the point across
	return(BRUTELOSS)


// Commented out for sprite reasons

/obj/item/weapon/material/sword/wood
	name = "Wood Sword"
	desc = "A wooden training sword. Not very sharp but could hurt if used as a club. Doesn't look too sturdy however."
	icon_state = "wood_sword"
	icon = 'icons/obj/trainingswords.dmi'
	slot_flags = SLOT_BELT | SLOT_BACK
	health = 10
	default_material = MAT_WOOD
	hitsound = 'sound/effects/woodhit.ogg'
	gender = NEUTER
	throw_speed = 3
	force = 3
	throw_range = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered","whacked")
	w_class = ITEMSIZE_NORMAL
	sharp = 0
	edge = 0
	dulled_divisor = 0.5
	thrown_force_divisor = 0.5
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_material.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_material.dmi',
			)

/obj/item/weapon/material/sword/wood_katana
	name = "Wood Katana"
	desc = "A wooden training katana. Not very sharp but could hurt if used as a club. Doesn't look too sturdy however."
	icon_state = "wood_katana"
	icon = 'icons/obj/trainingswords.dmi'
	slot_flags = SLOT_BELT | SLOT_BACK
	default_material = MAT_WOOD
	health = 10
	hitsound = 'sound/effects/woodhit.ogg'
	gender = NEUTER
	throw_speed = 3
	throw_range = 7
	force = 3
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered","whacked")
	w_class = ITEMSIZE_NORMAL
	sharp = 0
	var/base_block_chance = 50
	edge = 0
	dulled_divisor = 0.5
	thrown_force_divisor = 0.5
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_material.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_material.dmi',
			)

