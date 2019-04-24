/obj/item/weapon/gun/projectile/modular/cz97
	name = "\improper ZKB-97"
	desc = "A large .45 handgun, a reproduction of an old Earth design imported and remanufactured by Nanotrasen."
	icon = 'modular_eclipse/modular_handgun_sprite/cz97.dmi'
	icon_state = "cz97-base"
	mod_identifier = "cz97"
	mod_slide_style = "blued"
	mod_grip_style = "synth"
	mod_mag_style_override = ""
	mod_accessory_style = ""
	mod_mag_standard_cap = 9
	mod_mag_has_multiple_styles = FALSE
	mod_slide_offset = -5
	mod_all_slide_styles = list("blued")
	mod_all_grip_styles = list("synth","wood")
	mod_all_accessory_styles = list("")
	
/obj/item/weapon/gun/projectile/modular/cz97/reset_skin_combos()
	mod_reskin_options = list()

	mod_reskin_options["synthetic grips"] = 1
	mod_reskin_options["wood grips"] = 2

	mod_total_skin_combinations = mod_reskin_options.len

/obj/item/weapon/gun/projectile/modular/cz97/wood
	mod_grip_style = "wood"

/obj/item/weapon/gun/projectile/modular/cz97/reset_skin(skin_number)		//Skin combinations.
	if(!skin_number)
		skin_number = rand(1,mod_total_skin_combinations)
	
	//alter skins as necessary.
	switch(skin_number)
		if(1)		//blued steel slide, synthetic grips
			mod_slide_style = "blued"
			mod_grip_style = "synth"
		else		//blued steel slide, wood grips
			mod_slide_style = "blued"
			mod_grip_style = "wood"
	update_icon()
