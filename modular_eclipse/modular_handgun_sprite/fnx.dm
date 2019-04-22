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

/obj/item/weapon/gun/projectile/modular/fnx/random_skin/New()
	..()
	reset_skin()

/obj/item/weapon/gun/projectile/modular/fnx/proc/reset_skin(var/skin_number = 0)
	if(!skin_number)
		skin_number = rand(1,4)
	
	switch(skin_number)
		if(1)		//blued steel slide, synthetic grips
			mod_slide_style = "blued"
			mod_grip_style = "synth"
		else if(2)		//nickel slide, synthetic grips
			mod_slide_style = "nickel"
			mod_grip_style = "synth"
		else if(3)		//blued steel slide, tan grips
			mod_slide_style = "blued"
			mod_grip_style = "tan"
		else		//parkerised tan slide, tan grips. Unknown numbers default to this.
			mod_slide_style = "tan"
			mod_grip_style = "tan"

/obj/item/weapon/gun/projectile/modular/fnx/verb/reskin_gun()		//reskin the gun
	set name = "Resprite gun"
	set category = "Object"
	set desc = "Click to choose a sprite for your gun."

	var/mob/M = usr
	var/list/options = list()
	options["black grips, blued slide"] = 1
	options["black grips, nickel slide"] = 2
	options["tan grips, blued slide"] = 3
	options["tan grips, tan slide"] = 4
	var/choice = input(M,"Choose your sprite!","Resprite Gun") in options
	if(src && choice && !M.stat && in_range(M,src))
		reset_skin(choice)
		M << "Your gun is now sprited with [choice]. Say hello to your new friend."
		return 1