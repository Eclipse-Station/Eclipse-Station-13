////////////////////LAVA///////////////////////////////////////
/obj/machinery/lavatile_aeiou
	name = "lava"
	desc = "A"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0
	anchored = 1
	gender = PLURAL //"That's some lava."
	var/obj/item/weapon/cell/cell
	var/cell_type = /obj/item/weapon/cell/high
	var/set_temperature = T0C + 370	//K
	var/heating_power = 40000

/obj/machinery/lavatile/update_icon()
	set_light(7, 2, "#ff2c00")




/*
/obj/machinery/space_heater/process()
	var/datum/gas_mixture/env = loc.return_air()
	if(env && abs(env.temperature - set_temperature) > 0.1)
		var/transfer_moles = 0.25 * env.total_moles
		var/datum/gas_mixture/removed = env.remove(transfer_moles)
		if(removed)
			var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
			if(heat_transfer > 0)	//heating air
				heat_transfer = min(heat_transfer , heating_power) //limit by the power rating of the heater
				removed.add_thermal_energy(heat_transfer)
		env.merge(removed)
*/

