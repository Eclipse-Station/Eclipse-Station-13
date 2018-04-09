

/obj/item/clothing/suit/taur/cloak
	name = "taur specific cloak"
	desc = "A breezey cloak to distinguish your tauric body from the common beast. It has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits Drakes."
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET


	species_restricted = null
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/drake))
				icon = 'icons/mob/taurunder_vr.dmi'
				icon_override = 'icons/mob/taurunder_vr.dmi'
				icon_state = "cloakred-drake"
				item_state = "cloakred-drake"
				pixel_x = -16
				worn_layer = 30
				return 1
			else
				H << "<span class='warning'>You need to have a drake half to wear this.</span>"
				return 0







/*
/obj/item/clothing/under/rank/head_of_personnel/taur/dress
	name = "taur specific head of personnel dress"
	desc = "It's a jumpsuit worn by someone who works in the position of \"Head of Personnel\". It has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits wolves taurs."
	w_class = ITEMSIZE_LARGE//bulky item
	icon = 'icons/mob/taurunder_vr.dmi'
	icon_override = 'icons/mob/taurunder_vr.dmi'
	icon_state = "dress_hop_wolf_s"

	species_restricted = null
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon_state = "dress_hop_wolf_s"
				item_state = "dress_hop_wolf"
				pixel_x = -16
				worn_layer = 20
				return 1
*/

/* Here for reference
/obj/item/clothing/under/rank/head_of_personnel
	desc = "It's a jumpsuit worn by someone who works in the position of \"Head of Personnel\"."
	name = "head of personnel's jumpsuit"
	icon_state = "hop"
	rolled_sleeves = 0

/obj/item/clothing/under/dress/dress_hop
	name = "head of personnel dress uniform"
	desc = "Feminine fashion for the style conscious HoP."
	icon_state = "dress_hop"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/radiation/taur
	name = "taur specific radiation suit"
	desc = "A suit that protects against radiation. Label: Made with lead, do not eat insulation. It has a sticker saying one size fits all taurs on it. Below the sticker, it states that it only fits horses, wolves, and naga taurs."
	w_class = ITEMSIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen,/obj/item/clothing/head/radiation,/obj/item/clothing/mask/gas)
	slowdown = 1.5
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 100)
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER

	species_restricted = null
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/horse))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "radsuit-horse"
				item_state = "radsuit-horse"
				pixel_x = -16
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "radsuit-wolf"
				item_state = "radsuit-wolf"
				pixel_x = -16
				return 1
			else if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/naga))
				icon = 'icons/mob/taursuits_vr.dmi'
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "radsuit-naga"
				item_state = "radsuit-naga"
				pixel_x = -16
				return 1
			else
				H << "<span class='warning'>You need to have a horse, wolf, or naga half to wear this.</span>"
				return 0
*/