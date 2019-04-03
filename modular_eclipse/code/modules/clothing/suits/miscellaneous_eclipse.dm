/obj/item/clothing/suit/techpriest //Important to use the override otherwise the files don't properly work.
	name = "tech priest garb"
	desc = "May contain toasters and tentacles."
	icon_state = "adeptus"
	icon = 'modular_eclipse/icons/obj/clothing/suits_eclipse.dmi'
	icon_override = 'modular_eclipse/icons/mob/clothing/suits_eclipse.dmi'
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO
	siemens_coefficient = 3.0

/obj/item/clothing/head/gel_helm
	name = "adaptive gel"
	desc = "A membranous substance, capable of shielding its wearer from gaseous contaminants."
	item_state = "gel_helm"
	icon_override = 'modular_eclipse/icons/mob/clothing/onmob/lanius.dmi'
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	body_parts_covered = HEAD|FACE|EYES
	siemens_coefficient = 0.8
	item_flags = THICKMATERIAL | PHORONGUARD | AIRTIGHT

/obj/item/clothing/suit/gelsuit
	name = "adaptive gel suit"
	desc = "A membranous substance, capable of shielding its wearer from gaseous contaminants."
	icon = 'modular_eclipse/icons/mob/clothing/onmob/lanius.dmi'
	icon_state = "gelcore"
	icon_override = 'modular_eclipse/icons/mob/clothing/onmob/lanius.dmi'
	item_state = "adaptive_gel"
	var/obj/item/clothing/head/gel_helm
	var/helmtype = /obj/item/clothing/head/gel_helm
	var/Helm_up = FALSE
	var/toggleicon
	var/oxyheal = 0.25
	action_button_name = "Toggle Helmet"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	siemens_coefficient = 0.8
	item_flags = THICKMATERIAL | PHORONGUARD | AIRTIGHT

/obj/item/clothing/suit/gelsuit/New()
	processing_objects.Add(src)
	toggleicon = "[initial(icon_state)]"
	MakeHelm()
	..()

/obj/item/clothing/suit/gelsuit/equipped(var/mob/living/carbon/human/H)
	if(H && H.wear_suit == src)
		wearer = H
	..()


/obj/item/clothing/suit/gelsuit/dropped(var/mob/living/carbon/human/H)
	..()
	if(wearer)
		wearer = null

/obj/item/clothing/suit/gelsuit/process()
	if(!wearer || wearer.isSynthetic() || wearer.stat == DEAD || Helm_up)
		if(wearer.getOxyLoss())
			wearer.adjustOxyLoss(-oxyheal)

/obj/item/clothing/suit/gelsuit/Destroy()
	qdel(gel_helm)
	processing_objects.Remove(src)
	return ..()

/obj/item/clothing/suit/gelsuit/proc/MakeHelm()
	if(!gel_helm)
		var/obj/item/clothing/head/gel_helm/H = new helmtype(src)
		gel_helm = H

/obj/item/clothing/suit/gelsuit/ui_action_click()
	ToggleHelm()

/obj/item/clothing/suit/gelsuit/equipped(mob/user, slot)
	if(slot != slot_wear_suit)
		RemoveHelm()
	..()

/obj/item/clothing/suit/gelsuit/proc/RemoveHelm()
	icon_state = toggleicon
	Helm_up = FALSE
	gel_helm.canremove = TRUE // This shouldn't matter anyways but just incase.
	if(ishuman(gel_helm.loc))
		var/mob/living/carbon/H = gel_helm.loc
		H.unEquip(gel_helm, 1)
		H.update_inv_wear_suit()
	gel_helm.forceMove(src)

/obj/item/clothing/suit/gelsuit/dropped()
	RemoveHelm()

/obj/item/clothing/suit/gelsuit/proc/ToggleHelm()
	if(!Helm_up)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.wear_suit != src)
				to_chat(H, "<span class='warning'>You must be wearing [src] to put up the gel!</span>")
				return
			if(H.head)
				to_chat(H, "<span class='warning'>You're already wearing something on your head!</span>")
				return
			else
				H.equip_to_slot_if_possible(gel_helm,slot_head,0,0,1)
				Helm_up = TRUE
				gel_helm.canremove = FALSE
				H.update_inv_wear_suit()
	else
		RemoveHelm()

/obj/item/clothing/suit/gelsuit/deluxe
	name = "advanced adaptive gel suit"
	desc = "A membranous substance, capable of shielding its wearer from gaseous contaminants. This one seems to be extremely thick."
	icon = 'modular_eclipse/icons/mob/clothing/onmob/lanius.dmi'
	icon_state = "gelcore_deluxe"
	icon_override = 'modular_eclipse/icons/mob/clothing/onmob/lanius.dmi'
	item_state = "adaptive_gel_deluxe"
	oxyheal = 0.5
	helmtype = /obj/item/clothing/head/gel_helm/deluxe
	armor = list(melee = 15, bullet = 5, laser = 10,energy = 10, bomb = 5, bio = 100, rad = 50)
	siemens_coefficient = 0.4
	item_flags = THICKMATERIAL | PHORONGUARD | STOPPRESSUREDAMAGE | AIRTIGHT

/obj/item/clothing/head/gel_helm/deluxe
	name = "advanced adaptive gel"
	desc = "A membranous substance, capable of shielding its wearer from gaseous contaminants. This one seems to be extremely thick."
	item_state = "gel_helm_deluxe"
	icon_override = 'modular_eclipse/icons/mob/clothing/onmob/lanius.dmi'
	permeability_coefficient = 0.01
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 5, bomb = 5, bio = 100, rad = 50)
	body_parts_covered = HEAD|FACE|EYES
	siemens_coefficient = 0.4