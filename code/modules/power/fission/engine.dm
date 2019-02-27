#define REACTOR_OUTPUT_MULTIPLIER 3
#define REACTOR_COOLING_FACTOR 0.5
#define REACTOR_TEMPERATURE_CUTOFF 10000
#define REACTOR_RADS_TO_MJ 10000

/obj/machinery/power/fission
	icon = 'icons/obj/machines/power/fission.dmi'
	density = 1
	anchored = 0
	name = "fission core"
	icon_state = "engine"
	var/announce = 1
	var/decay_archived = 0
	var/exploded = 0
	var/envefficiency = 0.01
	var/gasefficiency = 0.5
	var/health = 3000
	var/max_health = 3000
	var/warning_point = 0.75
	var/warning_delay = 20
	var/meltwarned = 0
	var/lastwarning = 0
	var/rod_capacity = 9
	var/mapped_in = 0
	// Material properties from Tungsten Carbide, otherwise core'll be too weak.
	var/specific_heat = 40	// J/(mol*K)
	var/molar_mass = 0.196	// kg/mol
	var/mass = 2000 // kg
	var/max_temp = 3058
	var/temperature = T20C
	var/list/obj/item/weapon/fuelrod/rods
	var/list/obj/machinery/atmospherics/pipe/pipes
	var/obj/item/device/radio/radio

/obj/machinery/power/fission/New()
	. = ..()
	rods = new()
	pipes = new()
	radio = new /obj/item/device/radio{channels=list("Engineering")
		icon = 'icons/obj/robot_component.dmi'}(src)
	if (mapped_in)
		anchor()

/obj/machinery/power/fission/Destroy()
	for(var/i=1,i<=rods.len,i++)
		eject_rod(rods[i])
	rods = null
	pipes = null
	qdel(radio)
	. = ..()

/obj/machinery/power/fission/process()
	var/turf/L = loc

	if(isnull(L))		// We have a null turf...something is wrong, stop processing this entity.
		return PROCESS_KILL

	if(!istype(L)) 	//We are in a crate or somewhere that isn't turf, if we return to turf resume processing but stop for now.
		return

	//announce_warning()

	var/decay_heat = 0
	var/activerods = 0
	if(rods.len > 0)
		for(var/i=1,i<=rods.len,i++)
			var/obj/item/weapon/fuelrod/rod = rods[i]
			if(rod.life > 0)
				decay_heat += rod.tick_life(decay_archived > 0 ? 1 : 0)
				if(rod.reflective)
					activerods += rod.get_insertion()
				else
					activerods -= rod.get_insertion()

	decay_archived = decay_heat
	add_thermal_energy(decay_heat * activerods)
	equalize(loc.return_air(), envefficiency)
	equalize_all()

	if(rods.len > 0)
		for(var/i=1,i<=rods.len,i++)
			var/obj/item/weapon/fuelrod/rod = rods[i]
			rod.equalize(src, gasefficiency)

	if(temperature > max_temp && health > 0) // Overheating, reduce structural integrity, emit more rads.
		health -= health * ((temperature - max_temp) / (max_temp * 2))
		health = between(0, health, max_health)
		if (health < 1)
			go_nuclear()

	var/healthmul = (((health / max_health) - 1) / -1)
	var/power = (decay_heat / REACTOR_RADS_TO_MJ) * max(healthmul, 0.1)
	radiation_repository.radiate(src, max(power * 15, 0))

/obj/machinery/power/fission/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/power/fission/attack_robot(mob/user as mob)
	ui_interact(user)

/obj/machinery/power/fission/attack_ai(mob/user as mob)
	ui_interact(user)

/obj/machinery/power/fission/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!src.powered())
		return

	var/data[0]

	data["integrity_percentage"] = round(get_integrity())
	var/datum/gas_mixture/env = null
	if(!isnull(src.loc) && !istype(src.loc, /turf/space))
		env = src.loc.return_air()

	if(!env)
		data["ambient_temp"] = 0
		data["ambient_pressure"] = 0
	else
		data["ambient_temp"] = round(env.temperature)
		data["ambient_pressure"] = round(env.return_pressure())

	data["core_temp"] = round(temperature)
	data["max_temp"] = round(max_temp)
	data["warn_point"] = round(warning_point * 100)

	data["rods"] = new /list(rods.len)
	for(var/i=1,i<=rods.len,i++)
		var/obj/item/weapon/fuelrod/rod = rods[i]
		var/roddata[0]
		roddata["rod"] = "\ref[rod]"
		roddata["name"] = rod.name
		roddata["integrity_percentage"] = round(between(0, rod.integrity, 100))
		roddata["life_percentage"] = round(between(0, rod.life, 100))
		roddata["heat"] = round(rod.temperature)
		roddata["melting_point"] = rod.melting_point
		roddata["insertion"] = round(rod.insertion * 100)
		data["rods"][i] = roddata

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "fission_engine.tmpl", "Nuclear Fission Core", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/power/fission/Topic(href,href_list)
	if(..()) return 1

	if(href_list["rod_eject"])
		var/obj/item/weapon/fuelrod/rod = locate(href_list["rod_eject"])
		if(istype(rod))
			eject_rod(rod)

	if(href_list["rod_insertion"])
		var/obj/item/weapon/fuelrod/rod = locate(href_list["rod_insertion"])
		if(istype(rod) && rod.loc == src)
			var/new_insersion = input(usr,"Enter new insertion (0-100)%","Insertion control",rod.insertion * 100) as num
			rod.insertion = between(0, new_insersion / 100, 1)

	if(href_list["warn_point"])
		var/new_warning = input(usr,"Enter new warning point (0-100)%","Warning point",warning_point * 100) as num
		warning_point = between(0, new_warning / 100, 1)
		if (warning_point == 0)
			message_admins("[key_name(usr)] switched off warning reports on [src]",0,1)
			log_game("[src] warnings were switched off by [key_name(usr)]")

	usr.set_machine(src)
	src.add_fingerprint(usr)

/obj/machinery/power/fission/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(!anchored)
		if(istype(W, /obj/item/weapon/tool/wrench))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user << "<span class='notice'>You fasten \the [src] into place</span>"
			anchor()
			return
		return ..()

	if(istype(W, /obj/item/device/multitool))
		user << "<span class='notice'>You connect \the [src] to \the [W].</span>"
		var/obj/item/device/multitool/M = W
		M.connectable = src
		return

	if(istype(W, /obj/item/weapon/fuelrod))
		if(rods.len >= rod_capacity)
			user << "<span class='notice'>Looks like \the [src] is full.</span>"
		else
			var/obj/item/weapon/fuelrod/rod = W
			if(rod.is_melted())
				user << "<span class='notice'>That's probably a bad idea.</span>"
				return
			user << "<span class='notice'>You carefully start loading \the [W] into to \the [src].</span>"
			if(do_after(user, 40))
				user.drop_from_inventory(rod)
				rod.loc = src
				rods += rod

				rod.insertion = 0
		return

	if(istype(W, /obj/item/weapon/tool/wirecutters)) // Wirecutters? Sort of like prongs, for removing a rod. Good luck getting a 20kg fuel rod out with wirecutters though.
		if(rods.len == 0)
			user << "<span class='notice'>There's nothing left to remove.</span>"
			return ..()
		for(var/i=1,i<=rods.len,i++)
			var/obj/item/weapon/fuelrod/rod = rods[i]
			if(rod.health == 0 || rod.life == 0)
				user << "<span class='notice'>You carefully start removing \the [rod] from \the [src].</span>"
				if(do_after(user, 40))
					eject_rod(rod)
				return
		var/obj/item/weapon/fuelrod/rod = rods[rods.len]
		user << "<span class='notice'>You carefully start removing \the [rod] from \the [src].</span>"
		if(do_after(user, 40))
			eject_rod(rod)
		return

	if(!istype(W, /obj/item/weapon/tool/wrench))
		return ..()

	add_fingerprint(user)

	if(rods.len > 0)
		user << "<span class='warning'>You cannot unwrench \the [src], while it contains fuel rods.</span>"
		return 1

	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	user << "<span class='notice'>You begin to unfasten \the [src]...</span>"
	if (do_after(user, 40))
		anchor()

/obj/machinery/power/fission/proc/equalize(datum/gas_mixture/env, var/efficiency)
	var/datum/gas_mixture/sharer = env.remove(efficiency * env.total_moles)
	var/our_heatcap = heat_capacity()
	var/share_heatcap = sharer.heat_capacity()

	if((abs(temperature-sharer.temperature)>MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER) && our_heatcap + share_heatcap)
		var/new_temperature = ((temperature * our_heatcap) + (sharer.temperature * share_heatcap)) / (our_heatcap + share_heatcap)
		temperature += (new_temperature - temperature)
		temperature = between(0, temperature, REACTOR_TEMPERATURE_CUTOFF)
		sharer.temperature += (new_temperature - sharer.temperature)
		sharer.temperature = between(0, sharer.temperature, REACTOR_TEMPERATURE_CUTOFF)

	env.merge(sharer)

/obj/machinery/power/fission/proc/equalize_all()
	var/our_heatcap = heat_capacity()
	var/total_heatcap = our_heatcap
	var/total_energy = temperature * our_heatcap
	for(var/i=1,i<=pipes.len,i++)
		var/obj/machinery/atmospherics/pipe/pipe = pipes[i]
		if (istype(pipe, /obj/machinery/atmospherics/pipe))
			var/datum/gas_mixture/env = pipe.return_air()
			if (!isnull(env))
				var/datum/gas_mixture/removed = env.remove(gasefficiency * env.total_moles)
				var/env_heatcap = env.heat_capacity()
				total_heatcap += env_heatcap
				total_energy += (env.temperature * env_heatcap)
				env.merge(removed)

	if(!total_heatcap)
		return
	var/new_temperature = total_energy / total_heatcap
	temperature += (new_temperature - temperature) * gasefficiency // Add efficiency here, since there's no gas.remove for non-gas objects.
	temperature = between(0, temperature, REACTOR_TEMPERATURE_CUTOFF)

	for(var/i=1,i<=pipes.len,i++)
		var/obj/machinery/atmospherics/pipe/pipe = pipes[i]
		if (istype(pipe, /obj/machinery/atmospherics/pipe))
			var/datum/gas_mixture/env = pipe.return_air()
			if (!isnull(env))
				var/datum/gas_mixture/removed = env.remove(gasefficiency * env.total_moles)
				if (!isnull(removed))
					removed.temperature += (new_temperature - removed.temperature)
					removed.temperature = between(0, removed.temperature, REACTOR_TEMPERATURE_CUTOFF)
				env.merge(removed)

/obj/machinery/power/fission/proc/add_thermal_energy(var/thermal_energy)
	if(mass < 1)
		return 0

	var/heat_capacity = heat_capacity()
	if(thermal_energy < 0)
		if(temperature < TCMB)
			return 0
		var/thermal_energy_limit = -(temperature - TCMB)*heat_capacity	//ensure temperature does not go below TCMB
		thermal_energy = max(thermal_energy, thermal_energy_limit)	//thermal_energy and thermal_energy_limit are negative here.
	temperature += thermal_energy/heat_capacity
	return thermal_energy

/obj/machinery/power/fission/proc/heat_capacity()
	. = specific_heat * (mass / molar_mass)

/obj/machinery/power/fission/proc/get_integrity()
	var/integrity = round(health / max_health * 100)
	integrity = integrity < 0 ? 0 : integrity
	return integrity

/obj/machinery/power/fission/proc/eject_rod(var/obj/item/weapon/fuelrod/rod)
	if(!istype(rod) || rod.loc != src)
		return
	rods -= rod
	rod.loc = src.loc
	rod.insertion = 0

	if(meltwarned)
		var/melted = 0
		for(var/i=1,i<=rods.len,i++)
			melted += rods[i].is_melted()
		if(melted == 0)
			meltwarned = 0

/obj/machinery/power/fission/proc/anchor()
	if(!anchored)
		anchored = 1
		for(var/obj/machinery/atmospherics/pipe/simple/pipe in loc)
			pipes += pipe
		for(var/obj/machinery/atmospherics/pipe/manifold/pipe in loc)
			pipes += pipe
		for(var/obj/machinery/atmospherics/pipe/manifold4w/pipe in loc)
			pipes += pipe
		for(var/obj/machinery/atmospherics/pipe/cap/pipe in loc)
			pipes += pipe
	else
		anchored = 0
		pipes = new()

/* /obj/machinery/power/fission/proc/announce_warning()
	lastwarning = world.timeofday
	var/integrity = get_integrity()
	var/alert_msg = " Integrity at [integrity]%"

	if((world.timeofday - lastwarning) >= warning_delay * 10)
		lastwarning = world.timeofday
		if(src.powered())

	if(temperature > (max_temp * warning_point))
		alert_msg = emergency_alert + alert_msg
		lastwarning = world.timeofday - WARNING_DELAY * 4
	else if(health < health_archived) // Losing health.
		alert_msg = warning_alert + alert_msg
	else
		alert_msg = null
	if(alert_msg)
		radio.autosay(alert_msg, "Nuclear Monitor", "Engineering")
		//Public alerts
		if((damage > emergency_point) && !public_alert)
			radio.autosay("WARNING: SUPERMATTER CRYSTAL DELAMINATION IMMINENT!", "Nuclear Monitor")
			public_alert = 1
		else if(public_alert)
			radio.autosay(alert_msg, "Nuclear Monitor")
			public_alert = 0*/

/obj/machinery/power/fission/proc/go_nuclear()
	if (health < 1 && !exploded)
		var/turf/L = get_turf(src)
		if(!istype(L))
			return
		message_admins("[name] exploding in 15 seconds at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
		log_game("[name] exploded at ([x],[y],[z])")
		exploded = 1
		var/decaying_rods = 0
		var/decay_heat = 0
		for(var/i=1,i<=rods.len,i++)
			var/obj/item/weapon/fuelrod/rod = rods[i]
			if(rod.life > 0 && rod.decay_heat > 0)
				decay_heat += rod.tick_life()
				decaying_rods++
			rod.meltdown()
		var/rad_power = decay_heat / REACTOR_RADS_TO_MJ
		if(announce)
			world << sound('sound/effects/carter_alarm_cut.ogg')
			spawn(1 SECONDS)
				world << "<font size='15' color='red'><b>DUCK AND COVER</b></font>"

		// Give the alarm time to play. Then... FLASH! AH-AH!
		spawn(15 SECONDS)
			for(var/mob/living/mob in living_mob_list)
				var/turf/T = get_turf(mob)
				if(T && (loc.z == T.z))
					var/root_distance = sqrt( 1 / (get_dist(mob, src) + 1) )
					var/rads = rad_power * root_distance
					var/eye_safety = 0
					if(iscarbon(mob))
						var/mob/living/carbon/M = mob
						eye_safety = M.eyecheck()
					if (eye_safety < 3) // You've got a welding helmet over sunglasses? Congratulations, you're not blind.
						mob.Stun(2)
						mob.Weaken(10)
						mob.flash_eyes()
					if(istype(mob, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = mob
						if (eye_safety < 2)
							var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
							if(istype(E))
								E.damage += root_distance * 100
								if (E.damage >= E.min_broken_damage)
									H << "<span class='danger'>You are blinded by the flash!</span>"
									H.sdisabilities |= BLIND
								else if (E.damage >= E.min_bruised_damage)
									H << "<span class='danger'>You are blinded by the flash!</span>"
									H.eye_blind = 5
									H.eye_blurry = 5
									H.disabilities |= NEARSIGHTED
									spawn(60 SECONDS)
										H.disabilities &= ~NEARSIGHTED
								else if(E.damage > 10)
									H << "<span class='warning'>Your eyes burn.</span>"
						if (!H.isSynthetic())
							H.apply_damage(max((rads / 10) * H.species.radiation_mod, 0), BURN)
					mob.apply_effect(rads, IRRADIATE)
					mob.radiation += max(rads / 10, 0) // Not even a radsuit can save you now.

		// Some engines just want to see the world burn.
		spawn(17 SECONDS)
			for(var/i=1,i<=rods.len,i++)
				var/obj/item/weapon/fuelrod/rod = rods[i]
				rod.loc = L
				rods = new()
				pipes = new()
			empulse(src, decaying_rods * 10, decaying_rods * 100)
			var/explosion_power = 4 * decaying_rods
			explosion(L, explosion_power, explosion_power * 2, explosion_power * 3, explosion_power * 4, 1)