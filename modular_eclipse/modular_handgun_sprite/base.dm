/* Base code for modular handgun sprite code.
 * Spitzer, Apr. 2019
 * 
 * How it works: The system makes extensive use of the overlay system to update
 * gun sprites. This means you can reduce the number of different icon states
 * for various finishes, grips, accessories, magazine styles, and so on down to 
 * the total number of grips, slides, magazine styles, and accessories.
 *
 * The updating system calculates all the icons based on the weapon ID and the
 * variant ID. Magazines are intended to be either extended or standard, and are
 * automatically calculated which to be based on the mod_mag_standard_cap var.
 *
 * All icon update procs are their own separate proc, each of which is called
 * by rebuild_gun(). This allows users to tweak the update proc for specific
 * parts if their gun needs something other than the default behaviour.
 *
 * DO NOT ADD CODE TO THIS FILE. INSTEAD, MAKE A NEW FILE FOR THE GUN AND USE
 * THE TEMPLATE PROVIDED AT THE END OF THIS FILE.
 */

/obj/item/weapon/gun/projectile/modular		//base defines
	name = "modular handgun"
	desc = "A handgun, that is somehow modular."
	icon = 'modular_eclipse/modular_handgun_sprite/modular_example.dmi'
	icon_state = "sr9c-base"
	caliber = ".45"
	magazine_type = /obj/item/ammo_magazine/m45/rubber		//security stuff.
	allowed_magazines = list(/obj/item/ammo_magazine/m45)
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	load_method = MAGAZINE

	//All modular variables start 'mod'
	var/mod_identifier = "sr9c"
	var/mod_slide_style = "steel"
	var/mod_grip_style = "synth"
	var/mod_mag_style_override = ""
	var/mod_accessory_style = ""
	var/mod_mag_standard_cap = 9
	var/mod_mag_has_multiple_styles = TRUE
	var/mod_slide_offset = -4
	var/mod_all_slide_styles = list("steel","blued")
	var/mod_all_grip_styles = list("synth","wood","odgreen")
	var/mod_all_accessory_styles = list("")

/obj/item/weapon/gun/projectile/modular/New()
	..()
	update_icon()

/obj/item/weapon/gun/projectile/modular/proc/build_slide()
	if(!mod_slide_style)
		CRASH("Slide style required for [type] but none given")
	
	var/slide_adj = 0
	if(!getAmmo())
		slide_adj = mod_slide_offset
	
	add_overlay(image("icon" = icon, "icon_state" = "[mod_identifier]-slide-[mod_slide_style]", "pixel_x" = slide_adj))
	return TRUE

/obj/item/weapon/gun/projectile/modular/proc/build_grips()
	if(!mod_grip_style)
		CRASH("Grip style required for [type] but none given")
	
	add_overlay(image("icon" = icon, "icon_state" = "[mod_identifier]-grip-[mod_grip_style]"))
	return TRUE
	
/obj/item/weapon/gun/projectile/modular/proc/build_magazine()
	if(ammo_magazine)
		if(mod_mag_style_override)		//are we overriding the mag style?
			add_overlay(image("icon" = icon, "icon_state" = mod_mag_style_override))
		else
			if(mod_mag_has_multiple_styles)	//is there an extended mag sprite?
				if(ammo_magazine.max_ammo > mod_mag_standard_cap)
					add_overlay(image("icon" = icon, "icon_state" = "[mod_identifier]-mag-ext"))
				else
					add_overlay(image("icon" = icon, "icon_state" = "[mod_identifier]-mag-st"))
			else	//if no extended sprite, we'll just assume the standard will work.
				add_overlay(image("icon" = icon, "icon_state" = "[mod_identifier]-mag-st"))
	return TRUE

/obj/item/weapon/gun/projectile/modular/proc/build_accessory()
	if(!mod_accessory_style)
		return TRUE		//no accessory to build

	add_overlay(image("icon" = icon, "icon_state" = "[mod_identifier]-acc-[mod_accessory_style]"))
	return TRUE
	
/obj/item/weapon/gun/projectile/modular/proc/rebuild_gun()
	//destroy all overlays
	cut_overlays()
	
	build_slide()
	build_grips()
	build_magazine()
	build_accessory()
	
	return TRUE

/obj/item/weapon/gun/projectile/modular/update_icon()
	icon_state = "[mod_identifier]-base"
	return rebuild_gun()


//TEMPLATE
//You'll still need to edit calibre and all that, but you should have no problem
//doing that if you know enough of what you're doing to be doing this sort of
//thing.

/*

/obj/item/weapon/gun/projectile/modular/GUN_NAME_HERE
	name = ""										//the name as it appears in-game
	desc = ""										//Examine text.
	icon = ''										//Icon file. It is IMPORTANT that you have ALL your parts in one file (slides, accessories, etc)
	icon_state = ""									//Icon. You should make this your base icon sprite, for mapmakers. It will be overwritten by New().
	mod_identifier = ""								//The unique identifier for your gun, in case you decide to throw more than one gun in one file.
	mod_slide_style = ""							//The default finish on the slide.		[mod_identifier]-slide-[mod_slide_style]
	mod_grip_style = ""								//The default style of grips. 			[mod_identifier]-grip-[mod_grip_style]
	mod_mag_style_override = ""						//If set, a specific magazine style will be used. DOES NOT AUTOMATICALLY PARSE STATES.
	mod_accessory_style = ""						//If set, this accessory will be added to your gun.
	mod_mag_has_multiple_styles = TRUE				//If you do not have multiple sprites for the mag, set this to false.
	mod_mag_standard_cap = 9						//If your magazine has more than this many bullets, use extended ([mod_identifier]-mag-ext)
	mod_slide_offset = -4							//Slide offset when weapon is emptied.
	mod_all_slide_styles = list("")					//String list of all available  slide styles.
	mod_all_grip_styles = list("")					//String list of all available grip styles.
	mod_all_accessory_styles = list("")				//String list of all available accessories.

*/