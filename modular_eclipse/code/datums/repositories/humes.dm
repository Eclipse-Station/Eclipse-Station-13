//Entirely a copypaste of rad code
//TODO: Change features to reflect reality more
//-Nestor

var/global/repository/humes/humes_repository = new()

/repository/humes
	var/list/sources = list()			// all humes source datums
	var/list/sources_assoc = list()		// Sources indexed by turf for de-duplication.
	var/list/resistance_cache = list()	// Cache of turf's humes resistance.

// Describes a point source of humes.  Created either in response to a pulse of humes, or over an irhumesiated atom.
// Sources will decay over time, unless something is renewing their power!
/datum/humes_source
	var/turf/source_turf		// Location of the humes source.
	var/hume_power				// Strength of the humes being emitted.
	var/decay = TRUE			// True for automatic decay.  False if owner promises to handle it (i.e. supermatter)
	var/respect_maint = FALSE	// True for not affecting humes_SHIELDED areas.
	var/flat = FALSE			// True for power falloff with distance.
	var/range					// Cached maximum range, used for quick checks against mobs.

/datum/humes_source/Destroy()
	humes_repository.sources -= src
	if(humes_repository.sources_assoc[src.source_turf] == src)
		humes_repository.sources_assoc -= src.source_turf
	src.source_turf = null
	. = ..()

/datum/humes_source/proc/update_hume_power(var/new_power = null)
	if(new_power == null || new_power == hume_power)
		return // No change
	else if(new_power <= 0)
		qdel(src) // Decayed to nothing
	else
		hume_power = new_power
		if(!flat)
			range = min(round(sqrt(hume_power / config.humes_lower_limit)), 31)  // R = hume_power / dist**2 - Solve for dist

// Ray trace from all active humes sources to T and return the strongest effect.
/repository/humes/proc/get_humes_at_turf(var/turf/T)
	if(!istype(T)) return 0

	. = 0
	for(var/value in sources)
		var/datum/humes_source/source = value
		if(source.hume_power < .)
			continue // Already being affected by a stronger source
		if(source.source_turf.z != T.z)
			continue // humes is not multi-z
		var/dist = get_dist(source.source_turf, T)
		if(dist > source.range)
			continue // Too far to possibly affect
		if(source.respect_maint)
			var/atom/A = T.loc
			if(A.flags & HUME_SHIELDED)
				continue // In shielded area
		if(source.flat)
			. = max(., source.hume_power)
			continue // No need to ray trace for flat  field

		// Okay, now ray trace to find resistence!
		var/turf/origin = source.source_turf
		var/working = source.hume_power
		while(origin != T)
			origin = get_step_towards(origin, T) //Raytracing
			if(!(origin in resistance_cache)) //Only get the resistance if we don't already know it.
				origin.calc_humes_resistance()
			working = max((working - (origin.cached_humes_resistance * config.humes_resistance_multiplier)), 0)
			if(working <= .)
				break // Already affected by a stronger source (or its zero...)
		. = max((working * (1 / (dist ** 2))), .) //Butchered version of the inverse square law. Works for this purpose

// Add a humes source instance to the repository.  It will override any existing source on the same turf.
/repository/humes/proc/add_source(var/datum/humes_source/S)
	if(!isturf(S.source_turf))
		return
	var/datum/humes_source/existing = sources_assoc[S.source_turf]
	if(existing)
		qdel(existing)
	sources += S
	sources_assoc[S.source_turf] = S

// Creates a temporary humes source that will decay
/repository/humes/proc/humesiate(source, power) //Sends out a humes pulse, taking walls into account
	if(!(source && power)) //Sanity checking
		return
	var/datum/humes_source/S = new()
	S.source_turf = get_turf(source)
	S.update_hume_power(power)
	add_source(S)

// Sets the humes in a range to a constant value.
/repository/humes/proc/flat_humesiate(source, power, range, var/respect_maint = FALSE)
	if(!(source && power && range))
		return
	var/datum/humes_source/S = new()
	S.flat = TRUE
	S.range = range
	S.respect_maint = respect_maint
	S.source_turf = get_turf(source)
	S.update_hume_power(power)
	add_source(S)

// Irhumesiates a full Z-level. Hacky way of doing it, but not too expensive.
/repository/humes/proc/z_humesiate(var/atom/source, power, var/respect_maint = FALSE)
	if(!(power && source))
		return
	var/turf/epicentre = locate(round(world.maxx / 2), round(world.maxy / 2), source.z)
	flat_humesiate(epicentre, power, world.maxx, respect_maint)

/turf
	var/cached_humes_resistance = 0

/turf/proc/calc_humes_resistance()
/*	cached_humes_resistance = 0
	for(var/obj/O in src.contents)
		if(O.humes_resistance) //Override
			cached_humes_resistance += O.humes_resistance

		else if(O.density) //So open doors don't get counted
			var/material/M = O.get_material()
			if(!M)	continue
			cached_humes_resistance += M.weight + M.humes_resistance
	// Looks like storing the contents length is meant to be a basic check if the cache is stale due to items enter/exiting.  Better than nothing so I'm leaving it as is. ~Leshana
	humes_repository.resistance_cache[src] = (length(contents) + 1)*/
	return 0 //by now, we don't have anything that passively resists it

/turf/simulated/wall/calc_humes_resistance()
	return 0 //same as above
	/*humes_repository.resistance_cache[src] = (length(contents) + 1)
	cached_humes_resistance = (density ? material.weight + material.humes_resistance : 0)*/

/obj
	var/humes_resistance = 0  // Allow overriding humes resistance

// If people expand the system, this may be useful. Here as a placeholder until then
/atom/proc/humes_act(var/severity)
	return 1