/obj/item/ammo_magazine/m45usp/p12
	name = "handgun magazine (P12 Compact)"
	desc = "A special magazine designated to fit the P12 pistol. Uses .45 ammo."
	icon_state = "uspmag-12"
	icon = 'modular_aeiou/icons/obj/ammo_aeiou.dmi'
	ammo_type = /obj/item/ammo_casing/a45
	caliber = ".45"
	max_ammo = 12

/obj/item/ammo_magazine/m45usp/p12/empty
	initial_ammo = 0

/obj/item/ammo_magazine/s177bb
	name = "tube of BBs"
	icon = 'modular_aeiou/icons/obj/ammo_aeiou.dmi'
	desc = "A tube of zinc-plated steel airgun shot, for .177-calibre (4.5mm) airguns."
	icon_state = "bb-tube"
	caliber = "177pellet"
	ammo_type = /obj/item/ammo_casing/caseless/a177bb
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	max_ammo = 200
	multiple_sprites = FALSE

/obj/item/ammo_magazine/internal/minigun
	name = "gatling gun fusion core"
	ammo_type = /obj/item/ammo_casing/caseless/laser/gatling
	caliber = "gatling"
	max_ammo = 5000

/obj/item/ammo_magazine/m762AK
	name = "kalashnikov magazine"
	desc = "A special magazine designated to fit the P12 pistol. Uses .45 ammo."
	icon_state = "m545"
	matter = list(DEFAULT_WALL_MATERIAL = 4000)
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a762
	caliber = "7.62mm"
	max_ammo = 31
	multiple_sprites = 1

/obj/item/ammo_magazine/m762AK/empty
	initial_ammo = 0