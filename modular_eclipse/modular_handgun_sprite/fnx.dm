/obj/item/weapon/gun/projectile/modular/fnx
	name = "\improper PBX pistol"
	desc = "A rugged, tactical .45 handgun. The only thing missing is a threaded barrel."
	icon = 'modular_eclipse/modular_handgun_sprite/fnx.dmi'
	icon_state = "fnx-base"
	mod_identifier = "fnx"
	mod_slide_style = "blued"
	mod_grip_style = "synth"
	mod_mag_style_override = ""
	mod_accessory_style = ""
	mod_mag_has_multiple_styles = FALSE
	mod_mag_standard_cap = 9
	mod_slide_offset = -5
	mod_all_slide_styles = list("blued","nickel","tan")
	mod_all_grip_styles = list("synth","tan")
	mod_all_accessory_styles = list("")

/obj/item/weapon/gun/projectile/modular/fnx/reset_skin_combos()
	mod_reskin_options = list()

	mod_reskin_options["black grips, blued slide"] = 1
	mod_reskin_options["black grips, nickel slide"] = 2
	mod_reskin_options["tan grips, blued slide"] = 3
	mod_reskin_options["tan grips, parkerised tan slide"] = 4

	mod_total_skin_combinations = mod_reskin_options.len


/obj/item/weapon/gun/projectile/modular/fnx/random_skin/New()
	..()
	reset_skin(0)

/obj/item/weapon/gun/projectile/modular/fnx/reset_skin(skin_number)
	if(!skin_number)
		skin_number = rand(1,mod_total_skin_combinations)
	
	switch(skin_number)
		if(1)		//blued steel slide, synthetic grips
			mod_slide_style = "blued"
			mod_grip_style = "synth"
		if(2)		//nickel slide, synthetic grips
			mod_slide_style = "nickel"
			mod_grip_style = "synth"
		if(3)		//blued steel slide, tan grips
			mod_slide_style = "blued"
			mod_grip_style = "tan"
		else		//parkerised tan slide, tan grips. Unknown numbers default to this.
			mod_slide_style = "tan"
			mod_grip_style = "tan"
	update_icon()

