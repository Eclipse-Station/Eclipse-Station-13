/obj/item/ammo_magazine/m45P12
    name = "handgun magazine (P12 Compact)"
    desc = "A special magazine designated to fit the P12 pistol. Uses .45 ammo."
    icon_state = "uspmag-12"
    icon = 'modular_aeiou/icons/obj/ammo_aeiou.dmi'
    ammo_type = /obj/item/ammo_casing/a45
    caliber = ".45"
    max_ammo = 12
    multiple_sprites = 1

/obj/item/ammo_magazine/mus45P12/empty
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