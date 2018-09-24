/obj/machinery/power/potato_aeiou //Same concept as the centcom laser. Reward engineering for good power management. Here it's science, other one is stuff.
	name = "Potato machine"
	desc = "A specialised, complex scanner getting super good research and shit."
	anchored = 1
	density = 1
	icon = 'icons/obj/virology.dmi'
	icon_state = "analyser"

	use_power = 0		//1 = idle, 2 = active
	idle_power_usage = 20
	active_power_usage = 300000

	var/active = 0
	var/state = 0
	var/on = 0
	var/powered = 0
	var/integrity = 130
	var/locked = 0

/obj/machinery/power/potato_aeiou/initialize()
	. = ..()
	if(state == 2 && anchored)
		connect_to_network()

/obj/machinery/power/potato_aeiou/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	activate(user)

	user.visible_message("<span class='notice'>[user] toggles the [src] switch.</span>","<span class='notice'>You toggle the [src] switch.</span>")

/obj/machinery/power/potato_aeiou/proc/activate(mob/user as mob)
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


/obj/machinery/power/potato_aeiou/process()
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

/obj/machinery/power/potato_aeiou/attackby(obj/item/W, mob/user)

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


/*
/obj/machinery/power/emitter/process()
	if(stat & (BROKEN))
		return
	if(src.state != 2 || (!powernet && active_power_usage))
		src.active = 0
		update_icon()
		return
	if(((src.last_shot + src.fire_delay) <= world.time) && (src.active == 1))

		var/actual_load = draw_power(active_power_usage)
		if(actual_load >= active_power_usage) //does the laser have enough power to shoot?
			if(!powered)
				powered = 1
				update_icon()
				log_game("EMITTER([x],[y],[z]) Regained power and is ON.")
				investigate_log("regained power and turned <font color='green'>on</font>","singulo")
		else
			if(powered)
				powered = 0
				update_icon()
				log_game("EMITTER([x],[y],[z]) Lost power and was ON.")
				investigate_log("lost power and turned <font color='red'>off</font>","singulo")
			return

		src.last_shot = world.time
		if(src.shot_number < burst_shots)
			src.fire_delay = get_burst_delay() //R-UST port
			src.shot_number ++
		else
			src.fire_delay = get_rand_burst_delay() //R-UST port
			src.shot_number = 0

		//need to calculate the power per shot as the emitter doesn't fire continuously.
		var/burst_time = (min_burst_delay + max_burst_delay)/2 + 2*(burst_shots-1)
		var/power_per_shot = active_power_usage * (burst_time/10) / burst_shots

		playsound(src.loc, 'sound/weapons/emitter.ogg', 25, 1)
		if(prob(35))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, src)
			s.start()

		var/obj/item/projectile/beam/emitter/A = get_emitter_beam()
		A.damage = round(power_per_shot/EMITTER_DAMAGE_POWER_TRANSFER)
		A.launch( get_step(src.loc, src.dir) )
*/
