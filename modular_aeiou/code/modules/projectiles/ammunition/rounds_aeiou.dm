/obj/item/ammo_casing/a12g/webley
	name = "webley shell"
	desc = "A webley shell."
	icon_state = "bshell"
	projectile_type = /obj/item/projectile/bullet/shotgun/webley
	matter = list(DEFAULT_WALL_MATERIAL = 180)

/obj/item/ammo_casing/a12g/airstrike //The default will call down just gunfire.
	name = "beacon shell"
	desc = "A beacon shell."
	icon_state = "bshell"
	projectile_type = /obj/item/projectile/bullet/shotgun/beacon/explosive
	matter = list(DEFAULT_WALL_MATERIAL = 180,"glass" = 90)