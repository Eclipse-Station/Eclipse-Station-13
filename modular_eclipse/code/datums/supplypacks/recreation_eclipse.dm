/datum/supply_packs/recreation/air_rifle	//Crate of two air rifles, and a tube of BBs
	name = "Air Rifle Crate"
	contains = list(
			/obj/random/projectile/shotgun/airrifle = 2,
			/obj/item/ammo_magazine/s177bb = 1
			)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "air rifle crate"


//random air rifle, used above.
/obj/random/projectile/shotgun/airrifle
	name = "Random Air Rifle"
	desc = "This is a random air rifle, for PoIs/cargo."
	icon = 'icons/obj/gun.dmi'
	icon_state = "shotgun"

/obj/random/projectile/shotgun/airrifle/item_to_spawn()
	return pick(prob(20);/obj/item/weapon/gun/projectile/shotgun/pump/air_rifle,		//weighted 20-to-1
			prob(1);/obj/item/weapon/gun/projectile/shotgun/pump/air_rifle/le)
