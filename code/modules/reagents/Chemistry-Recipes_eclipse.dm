/datum/chemical_reaction/trichloramine
	name = "Trichloramine"
	id = "trichloramine"
	result = "liquid_trichlor"
	required_reagents = list("ammonia" = 1, "chlorine" = 1)
	result_amount = 0.4

/*                        BIG FAT DISCLAIMER
 * I have never mixed this, intentionally or not. I do not know what sound it'll
 * make, if any. All I have to go off of is this is "violently explosive".
 * DO NOT ATTEMPT THIS FOR MY INFORMATION. JUST DON'T. I DON'T NEED TO KNOW.
 * I HAVE ENOUGH REFERENCE MATERIAL FROM THE UNIVERSITY OF BRISTOL SCHOOL OF 
 * CHEMISTRY WITHOUT SOME MORON GOING OUT THERE KILLING THEMSELVES TO GET MORE.
 * DON'T BE THE MORON.
 * DON'T INTENTIONALLY MIX THIS.			^Spitzer
 */

	mix_message = "The solution makes a loud pop!"
	reaction_sound = 'sound/effects/snap.ogg'

/datum/chemical_reaction/trichloramine/on_reaction(var/datum/reagents/holder, var/created_volume)
	//deal humanoid damage first
	if(created_volume > 10)		//You can create less than 10u at a time safely. Not much more, though...
		var/datum/effect/effect/system/reagents_explosion/e = new()
		e.set_up(round (created_volume/2, 1), holder.my_atom, 0, 0)			//five times as strong as potassium per unit, but also a tenth of the units created.
		if(isliving(holder.my_atom))										//in reality, it's less of the explosion, but with added area denial.
			e.amount *= 0.5													//a 120 unit beaker will have an effective blast of 12.0, compared to potassium's 24
			var/mob/living/L = holder.my_atom
			if(L.stat != DEAD)
				e.amount *= 0.5
	/* //Removing this, as we actually do want the resulting liquid to be there.
		else
			holder.clear_reagents() //No more powergaming by creating a tiny amount of this
	*/
		e.start()

	//create toxic death cloud
	var/turf/location = get_turf(holder.my_atom.loc)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas("trichloramine", created_volume*4, 150+T0C)	//the remaining 80% of the reagent is turned into hot gas
//		spawn (0) target_tile.hotspot_expose(150+T0C, 125)		//let's not, for now
	return