// Caseless Ammunition

/obj/item/ammo_casing/caseless
	desc = "A caseless bullet casing."
//	firing_effect_type = null
//	heavy_metal = FALSE

/*
/obj/item/ammo_casing/caseless/fire_casing(atom/target, mob/living/user, params, distro, quiet, zone_override, spread)
	if (..()) //successfully firing
		moveToNullspace()
		return 1
	else
		return 0
*/

/obj/item/ammo_casing/caseless/laser
 	name = "laser casing"
 	desc = "You shouldn't be seeing this."
 	caliber = "laser"
 	icon_state = "s-casing-live"
 	projectile_type = /obj/item/projectile/beam
// 	fire_sound = 'sound/weapons/laser.ogg'
// 	firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect/energy


/obj/item/ammo_casing/caseless/laser/gatling
	projectile_type = /obj/item/projectile/beam/smalllaser
//	variance = 0.8
//	click_cooldown_override = 1

