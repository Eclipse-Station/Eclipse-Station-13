/* Eclipse replacement for the Secgun sprite. Based off the Ruger SR-series,
 * namely the SR9c that I currently own. Does not contain a loaded chamber
 * indicator.
 *
 * Comes in 2 slide finishes, 3 grip textures, and 2 magazine sprites:
 *
 * Slide: Brushed steel ("slide-steel") and blued steel ("slide-blued").
 *
 * Grips: Black synthetic ("grip-synth"), olive drab synthetic ("grip-odgreen"),
 *        and generic dark wood ("grip-wood").
 *
 * Magazine: Standard and extended + grip adapter (automatic; if the magazine is
 *           larger than 9 rounds, it uses the extended + grip adapter sprite)
 *
 * This uses overlays to be as modular as possible without requiring excessive
 * sprites for the various states of the gun. Done this way, we have a total of
 * 8 different sprites (1 base, 2 slides, 3 grips, 2 magazines) to represent the
 * (currently) 24 possible states, rather than 1 separate sprite per state.
 */

// code/modules/projectiles/guns/projectile/pistol.dm

/obj/item/weapon/gun/projectile/sec
	icon = 'modular_eclipse/secgun/sr9c.dmi'
	icon_state = "sr9c-base"
	var/eclipse_slide_finish = "slide-steel"		//finish on the slide. Prefix slide-
	var/eclipse_grip_finish = "grip-synth"		//Finish on the grips. Prefix grip-

/obj/item/weapon/gun/projectile/sec/update_icon()
	..()
	sr9c_update_icon()


/obj/item/weapon/gun/projectile/sec/wood
/* This inherits from the mainline files, so this redundancy is necessary else
 * the icons will not load or render properly.
 */
	icon = 'modular_eclipse/secgun/sr9c.dmi'
	icon_state = "sr9c-base"
	eclipse_slide_finish = "slide-blued"
	eclipse_grip_finish = "grip-wood"

/obj/item/weapon/gun/projectile/sec/wood/update_icon()
	..()
	sr9c_update_icon()

//Shared icon update proc
/obj/item/weapon/gun/projectile/sec/proc/sr9c_update_icon()		//shared code
	//cut all overlays. Inefficient, but it works.
	cut_overlays()

	//sadly, this HAS to be hardcoded else the pistols will inherit the sprite
	//settings from code/modules/projectiles/guns/projectile/pistol.dm
	icon_state = initial(icon_state)

	var/slide_adj = 0		//"Slide adjustment", or basically how far left it moves when empty
	if(!getAmmo())			//This is done because I couldn't get [x ? y : z] to work in the add_overlay()
		slide_adj = -4

	add_overlay(image("icon" = icon, "icon_state" = eclipse_slide_finish, "pixel_x" = slide_adj))

	//add the grips
	add_overlay(image("icon" = icon, "icon_state" = eclipse_grip_finish))

	// differentiate between larger and smaller mag
	// Not implemented, as the standard magazines for the M1911 also fit this,
	// and it would look wrong if I changed the base sprite.
	if(ammo_magazine)
		if(ammo_magazine.max_ammo > 9)
			add_overlay(image("icon" = icon, "icon_state" = "mag-17adapter"))
		else
			add_overlay(image("icon" = icon, "icon_state" = "mag-compact"))

	return		//Cave Johnson, we're done here.
