//Shiv
/obj/item/weapon/glassshiv
	name = "glass shiv"
	desc = "A poorly crafted shiv."
	icon = 'modular_aeiou/icons/obj/weapons_aeiou.dmi'
	icon_state = "glass_shiv"
	force = 7 //Small but not nothing
	embed_chance = 100 //this should go in everytime
	throwforce = 2
	w_class = ITEMSIZE_SMALL
	attack_verb = list("attacked", "stabbed", "poked", "stabbed", "pierced")

/obj/item/weapon/glassshiv/afterattack
	force = 1
	embed_chance = 15

/* //Disabled for testing.
/obj/item/weapon/glassshiv/afterattack(atom/A as mob|obj|turf|area, mob/user as mob)
	var/turf/T = get_turf(src)
	T.visible_message("<span class='danger'>\The [src] shatters!</span>")
	if(istype(loc, /mob/living))
		var/mob/living/M = loc
		M.drop_from_inventory(src)
	var/obj/item/stack/material/algae/Y = new(loc)
	Y.amount = 4 //VOREStation Edit End
	playsound(src, "shatter", 70, 1)
	qdel(src)
*/