/obj/item/weapon/melee/pan
	name = "pan"
	desc = "A long, heavy hammer meant to be used with both hands. Typically used for breaking rocks and driving posts, it can also be used for breaking bones or driving points home."
	icon_state = "sledgehammer0"
	force = 18
	hitsound = 'sound/weapons/pan_hit.ogg'
	icon = 'modular_aeiou/icons/obj/weapons_aeiou.dmi'
	w_class = ITEMSIZE_LARGE
	sharp = 0
	edge = 0
	attack_verb = list("attacked", "smashed", "crushed", "wacked", "pounded")
	var/pan_temp = 0
	var/obj/machinery/stove/stove_plate = null
	var/obj/item/weapon/reagent_containers/food/snacks/egg/pan_egg = null

/obj/item/weapon/melee/pan/proc/cooling()
	if(pan_temp>0)
		pan_temp = (pan_temp - 1)

/obj/item/weapon/melee/pan/proc/heating()
	if(stove_plate)
		if(stove_plate.heat_temp ==0)
			return
		if(stove_plate.heat_temp ==1)
			while(pan_temp>100)
				pan_temp = (pan_temp + 10)
		if(stove_plate.heat_temp ==2)
			while(pan_temp>200)
				pan_temp = (pan_temp + 10)
		if(stove_plate.heat_temp ==3)
			while(pan_temp>300)
				pan_temp = (pan_temp + 10)

/obj/item/weapon/melee/pan/process()
	if(!stove_plate)
		cooling()
	else
		cooking()
		heating()


/obj/item/weapon/melee/pan/proc/cooking()
	if(pan_temp == 0)
		pan_temp = (pan_temp + 10)


/obj/item/weapon/melee/pan/attack_self(mob/user)
	if(pan_egg.cooked)
		spawn()
		playsound(src.loc, 'sound/effects/ComputerMachinery.ogg', 75, 1)
		new /obj/item/weapon/research(loc)
		return
	if(pan_egg.cooked == 1)
		spawn()
		playsound(src.loc, 'sound/effects/ComputerMachinery.ogg', 75, 1)
		new /obj/item/weapon/research(loc)
		return


/obj/item/weapon/melee/pan/attackby(mob/user, obj/item/weapon/I)
	if(istype(I, /obj/item/weapon/reagent_containers))
		if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/egg))
			user << "<span class='notice'>You crack the egg on the [src].</span>"
		else
			user << "<span class='notice'>This produce doesn't fit the [src].</span>"
	else
		user << "<span class='warning'>This is not food!</span>"


/obj/item/weapon/melee/pan/examine(mob/user)
	if(!..(user, 1))
		return
	if(pan_egg)
		user <<"The pan has a [pan_egg]."
	user <<"The pan is at [pan_temp]."



