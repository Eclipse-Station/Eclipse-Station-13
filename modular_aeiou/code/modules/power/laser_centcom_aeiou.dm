/obj/machinery/power/laser_centcom
	name = "laser power selling device"
	desc = "A high draw power selling laser directed toward centcom. Don't stand in front of it!"
	icon_state = "smes"
	density = 1
	anchored = 1
	use_power = 0		//1 = idle, 2 = active
	icon = 'icons/obj/virology.dmi'
	icon_state = "analyser"
    
	idle_power_usage = 20
	active_power_usage = 300000

	var/active = 0
	var/state = 0
	var/on = 0
	var/powered = 0
	var/integrity = 130
	var/locked = 0
	var/credits = 0


/obj/machinery/power/laser_centcom/proc/activate(mob/user as mob)
	if(state == 2)
		if(!powernet)
			user << "\The [src] isn't connected to a wire."
			return 1
		if(!src.locked)
			if(src.active==1)
				src.active = 0
				user << "You turn off [src]."
			else
				src.active = 1
				user << "You turn on [src]."
			update_icon()
		else
			user << "<span class='warning'>The controls are locked!</span>"
	else
		user << "<span class='warning'>\The [src] needs to be firmly secured to the floor first.</span>"
		return 1

/obj/machinery/power/laser_centcom/process()
	if(on)
		return 1

	if(!(use_power || idle_power_usage || active_power_usage))
		return

	if(src.state != 2 || (!powernet && active_power_usage))
		src.active = 0
		spawn(50)
		playsound(src.loc, 'sound/effects/ComputerMachinery.ogg', 75, 1)
		new /obj/item/weapon/research(loc)
		return
	return
	
 /*       
	while(recharging)
		if(!do_after(user, 10, src))
			break
		playsound(get_turf(src),'sound/items/change_drill.ogg',25,1)
		if(power_supply.give(60) < 60)
			break
*/



/obj/machinery/power/laser_centcom/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/weapon/wrench))
		if(active)
			user << "Turn off [src] first."
			return
		switch(state)
			if(0)
				state = 1
				playsound(src, W.usesound, 75, 1)
				user.visible_message("[user.name] secures [src] to the floor.", \
					"You secure the external reinforcing bolts to the floor.", \
					"You hear a ratchet.")
				src.anchored = 1
			if(1)
				state = 0
				playsound(src, W.usesound, 75, 1)
				user.visible_message("[user.name] unsecures [src] reinforcing bolts from the floor.", \
					"You undo the external reinforcing bolts.", \
					"You hear a ratchet.")
				src.anchored = 0
				disconnect_from_network()
			if(2)
				user << "<span class='warning'>\The [src] needs to be unwelded from the floor.</span>"
		return

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(active)
			user << "Turn off [src] first."
			return
		switch(state)
			if(0)
				user << "<span class='warning'>\The [src] needs to be wrenched to the floor.</span>"
			if(1)
				if (WT.remove_fuel(0,user))
					playsound(loc, WT.usesound, 50, 1)
					user.visible_message("[user.name] starts to weld [src] to the floor.", \
						"You start to weld [src] to the floor.", \
						"You hear welding")
					if (do_after(user,20 * WT.toolspeed))
						if(!src || !WT.isOn()) return
						state = 2
						user << "You weld [src] to the floor."
						connect_to_network()
				else
					user << "<span class='warning'>You need more welding fuel to complete this task.</span>"
			if(2)
				if (WT.remove_fuel(0,user))
					playsound(loc, WT.usesound, 50, 1)
					user.visible_message("[user.name] starts to cut [src] free from the floor.", \
						"You start to cut [src] free from the floor.", \
						"You hear welding")
					if (do_after(user,20 * WT.toolspeed))
						if(!src || !WT.isOn()) return
						state = 1
						user << "You cut [src] free from the floor."
						disconnect_from_network()
				else
					user << "<span class='warning'>You need more welding fuel to complete this task.</span>"
		return


/obj/machinery/power/laser_centcom

/obj/machinery/power/laser_centcom
/obj/machinery/power/laser_centcom
/obj/machinery/power/laser_centcom
