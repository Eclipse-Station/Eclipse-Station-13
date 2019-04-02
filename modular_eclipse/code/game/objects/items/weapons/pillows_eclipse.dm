/obj/item/weapon/pillow
	name = "pillow"
	desc = "A white fluffy pillow."
	icon_state = "mop"
	force = 0
	throwforce = 0
	throw_speed = 1
	throw_range = 1
	sharp = 0
	edge = 0
	slowdown = 1
	var/weakenforce = 15
	attack_verb = list("pomfed", "socked", "smacked", "thump")
	w_class = ITEMSIZE_LARGE//So you can't hide it in your pocket or some such.

/obj/item/weapon/pillow/attack(mob/M, mob/user)
	M.Weaken(weakenforce)
//I don't know how to have multiple sounds.
	if (prob(50))
		playsound(loc, 'sound/weapons/pillow_hit1.ogg', 50, 1, -1)
	if (prob(50))
		playsound(loc, 'sound/weapons/pillow_hit2.ogg', 50, 1, -1)


/obj/item/weapon/pillow/large
	desc = "A white fluffy pillow. This one looks pretty big and heavy."
	slowdown = 2
	weakenforce = 30
	attackspeed

/obj/item/weapon/pillow/small
	desc = "A white fluffy pillow. It is quite small, you probably could swing it fast."
	slowdown = 0
	weakenforce = 8
	attackspeed = 3
