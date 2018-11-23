/obj/item/clothing
	var/obj/item/clothing/has_suit = null		//the suit the tie may be attached to
	var/image/inv_overlay = null	//overlay used when attached to clothing.
	var/image/mob_overlay = null
	var/overlay_state = null
	var/concealed_holster = 0
	var/mob/living/carbon/human/wearer = null //To check if the wearer changes, so species spritesheets change properly


/obj/item/clothing/proc/get_mob_overlay()
	if(!mob_overlay)
		var/tmp_icon_state = "[overlay_state? "[overlay_state]" : "[icon_state]"]"
		if(icon_override)
			if("[tmp_icon_state]_mob" in icon_states(icon_override))
				tmp_icon_state = "[tmp_icon_state]_mob"
			mob_overlay = image("icon" = icon_override, "icon_state" = "[tmp_icon_state]")
		else if(wearer && sprite_sheets[wearer.species.get_bodytype(wearer)]) //Teshari can finally into webbing, too!
			mob_overlay = image("icon" = sprite_sheets[wearer.species.get_bodytype(wearer)], "icon_state" = "[tmp_icon_state]")
		else
			mob_overlay = image("icon" = INV_ACCESSORIES_DEF_ICON, "icon_state" = "[tmp_icon_state]")
		if(addblends)
			var/icon/base = new/icon("icon" = mob_overlay.icon, "icon_state" = mob_overlay.icon_state)
			var/addblend_icon = new/icon("icon" = mob_overlay.icon, "icon_state" = src.addblends)
			if(color)
				base.Blend(src.color, ICON_MULTIPLY)
			base.Blend(addblend_icon, ICON_ADD)
			mob_overlay = image(base)
		else
			mob_overlay.color = src.color

	return mob_overlay
