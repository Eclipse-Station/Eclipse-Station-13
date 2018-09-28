/obj/item/projectile/bullet/shotgun/webley
	name = "webley slug"
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	damage = 16
	armor_penetration = 10
	agony = 40
	embed_chance = 80 //Just a pain in the ass really.


///For the beacon gun.
/obj/item/projectile/bullet/shotgun/beacon

/obj/item/projectile/bullet/shotgun/beacon/explosive
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	damage = 0

/obj/item/projectile/bullet/shotgun/beacon/explosive/on_hit(atom/target, blocked = FALSE)
	..()
	if(isliving(target))
		var/offset_target
		target.visible_message("<span class='danger'>The beacon starts flashing and beeping!")
		playsound(src.loc, 'sound/machines/buzzbeep.ogg', 80, 1)
		spawn(10)
			playsound(src.loc, 'sound/machines/buzzbeep.ogg', 80, 1)
		spawn(15)
			playsound(src.loc, 'sound/machines/buzzbeep.ogg', 80, 1)
		spawn(20)
			offset_target = get_offset_target_turf(target.loc, rand(2)-rand(2), rand(2)-rand(2))
			new/obj/effect/effect/sparks(offset_target)
			new/obj/effect/effect/smoke/illumination(offset_target, 5, range=30, power=30, color="#FFFFFF")
			explosion(offset_target, -1, 0, 1, 2)
		spawn(23)
			offset_target = get_offset_target_turf(target.loc, rand(2)-rand(2), rand(2)-rand(2))
			new/obj/effect/effect/sparks(offset_target)
			new/obj/effect/effect/smoke/illumination(offset_target, 5, range=30, power=30, color="#FFFFFF")
			explosion(offset_target, -1, 1, 2, 4)
		spawn(26)
			offset_target = get_offset_target_turf(target.loc, rand(2)-rand(2), rand(2)-rand(2))

			new/obj/effect/effect/sparks(offset_target)
			new/obj/effect/effect/smoke/illumination(offset_target, 5, range=30, power=30, color="#FFFFFF")
			explosion(offset_target, -1, 1, 1, 6)
		spawn(29)
			offset_target = get_offset_target_turf(target.loc, rand(2)-rand(2), rand(2)-rand(2))
			explosion(offset_target, -1, 1, 0, 2)
		spawn(35)
			explosion(src.loc, -1, 0, 0, 6)
		target.visible_message("<span class='danger'>[target] is struck by the bolt!</span>")
		qdel(src)