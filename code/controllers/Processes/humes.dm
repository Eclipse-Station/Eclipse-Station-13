/datum/controller/process/humes
	var/repository/humes/linked = null

/datum/controller/process/humes/setup()
	name = "humes controller"
	schedule_interval = 20 // every 2 seconds
	linked = humes_repository

/datum/controller/process/humes/doWork()
	sources_decay()
	cache_expires()
	irhumeiate_targets()

// Step 1 - Sources Decay
/datum/controller/process/humes/proc/sources_decay()
	var/list/sources = linked.sources
	for(var/thing in sources)
		var/datum/humes_source/S = thing
		if(QDELETED(S))
			sources.Remove(S)
			continue
		if(S.decay)
			S.update_hume_power(S.hume_power - config.humes_decay_rate)
		if(S.hume_power <= config.humes_lower_limit)
			sources.Remove(S)
		SCHECK // This scheck probably just wastes resources, but better safe than sorry in this case.

// Step 2 - Cache Expires
/datum/controller/process/humes/proc/cache_expires()
	var/list/resistance_cache = linked.resistance_cache
	for(var/thing in resistance_cache)
		var/turf/T = thing
		if(QDELETED(T))
			resistance_cache.Remove(T)
			continue
		if((length(T.contents) + 1) != resistance_cache[T])
			resistance_cache.Remove(T) // If its stale REMOVE it! It will get added if its needed.
		SCHECK

// Step 3 - Registered irhumeiatable things are checked for humes
/datum/controller/process/humes/proc/irhumeiate_targets()
	var/list/registered_listeners = living_mob_list // For now just use this. Nothing else is interested anyway.
	if(length(linked.sources) > 0)
		for(var/thing in registered_listeners)
			var/atom/A = thing
			if(QDELETED(A))
				continue
			var/turf/T = get_turf(thing)
			var/humes = linked.get_humes_at_turf(T)
			if(humes)
				A.humes_act(humes)
		SCHECK

/datum/controller/process/humes/statProcess()
	..()
	stat(null, "[linked.sources.len] sources, [linked.resistance_cache.len] cached turfs")
