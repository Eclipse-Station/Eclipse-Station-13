//Stolen from baystation for AEIOU like the dirty pirate i am. Code is from thasc. -Kates.
//haha I did it first - Nestor

/obj/effect/temporary/item_pickup_ghost
	var/lifetime = 0.1 SECONDS

/obj/effect/temporary/item_pickup_ghost/initialize(var/mapload, var/obj/item/picked_up)
	. = ..(mapload, lifetime, picked_up.icon, picked_up.icon_state)
	pixel_x = picked_up.pixel_x
	pixel_y = picked_up.pixel_y
	color = picked_up.color

/obj/effect/temporary/item_pickup_ghost/proc/animate_towards(var/atom/target)
	var/new_pixel_x = pixel_x + (target.x - src.x) * 32
	var/new_pixel_y = pixel_y + (target.y - src.y) * 32
	animate(src, pixel_x = new_pixel_x, pixel_y = new_pixel_y, transform = matrix()*0, time = lifetime)
