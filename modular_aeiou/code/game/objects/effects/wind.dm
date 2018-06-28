/obj/lowpressurepoint //stolen from grav_pull effect
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	name = "the great succ" //those things are invisible don't taze me
	unacidable = 1
	anchored = 1.0
	invisibility = 101
	mouse_opacity = 0
	var/delay = 1 //amount of ticks until next succ
	var/timer = 0
	var/pull_radius = 3 //default range of which it sucks things closer
	var/pull_anchored = 0 //a fucking hurricane
	var/break_windows = 0
	var/activated = 1
	var/location = null

/obj/lowpressurepoint/New()
	location = location = get_turf(loc)
	processing_objects |= src

/obj/lowpressurepoint/Destroy()
	processing_objects -= src
	return ..()

/obj/lowpressurepoint/process()
	if (timer < 1)
		do_pull()
		timer = delay
	else
		timer--

/obj/lowpressurepoint/proc/do_pull()
	//following is adapted from supermatter and singulo code
	if(defer_powernet_rebuild != 2)
		defer_powernet_rebuild = 1

	// Let's just make this one loop.
	for(var/atom/X in orange(pull_radius, location))
		// Movable atoms only
		if(istype(X, /atom/movable))
			if(istype(X, /obj/effect/overlay)) continue
			if(X && !istype(X, /mob/living/carbon/human))
				if(break_windows && istype(X, /obj/structure/window)) //shatter windows
					var/obj/structure/window/W = X
					W.ex_act(2.0)

				if(istype(X, /obj))
					var/obj/O = X
					if(O.anchored)
						if (!pull_anchored) continue // Don't pull anchored stuff unless configured
						step_towards(X, location)  // step just once if anchored
						continue

				step_towards(X, location) // Step twice

			else if(istype(X,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = X
				if(istype(H.shoes,/obj/item/clothing/shoes/magboots))
					var/obj/item/clothing/shoes/magboots/M = H.shoes
					if(M.magpulse)
						step_towards(H, location) //step just once with magboots
						continue
				step_towards(H, location) //step twice

	if(defer_powernet_rebuild != 2)
		defer_powernet_rebuild = 0
	return



/obj/windcurrent //no need to use effect system, since this thing is not supposed to go away, like effects do
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	name = "blowhard"
	unacidable = 1
	anchored = 1.0
	mouse_opacity = 0
	invisibility = 101
	var/strength = 2//for how much tiles does the wind push
	var/activated = 1
	var/length = 10 //default range of which wind blows things away
	var/pull_anchored = 0 //a fucking hurricane
	var/break_windows = 0
	var/delay = 1 //amount of ticks until next blowjob
	var/timer = 0
	var/affected = list()
	var/direction
	var/location //the default one has no direction, use the ones marked below


/obj/windcurrent/New()
	location = get_turf(loc)
	processing_objects |= src
	var/i
	var/newturf = location
	for(i=0; i<=length; i++)
		newturf = get_step(newturf, direction)
		affected += newturf
	direction = newturf //swap the letter direction with an actual turf
	affected = reverseRange(affected)

/obj/windcurrent/process()
	if (timer < 1)
		do_push()
		timer = delay
	else
		timer--


/obj/windcurrent/Destroy()
	processing_objects -= src
	return ..()

/obj/windcurrent/proc/do_push()
	//following is adapted from supermatter and singulo code
	if(defer_powernet_rebuild != 2)
		defer_powernet_rebuild = 1

	// Let's just make this one loop.
	var/push
	for(var/turf/T in affected)
		sleep(2)
		for(var/atom/X in T.contents)
			// Movable atoms only
			if(istype(X, /atom/movable))
				if(istype(X, /obj/effect/overlay)) continue
				if(X && !istype(X, /mob/living/carbon/human))
					if(break_windows && istype(X, /obj/structure/window)) //shatter windows
						var/obj/structure/window/W = X
						W.ex_act(2.0)

					if(istype(X, /obj))
						var/obj/O = X
						if(O.anchored)
							if (!pull_anchored) continue // Don't pull anchored stuff unless configured
							step_towards(X, direction)  // step just once if anchored
							continue
					for(push = 1; push<=strength; push++)
						step_towards(X, direction)

				else if(istype(X,/mob/living/carbon/human))
					var/mob/living/carbon/human/H = X
					if(istype(H.shoes,/obj/item/clothing/shoes/magboots))
						var/obj/item/clothing/shoes/magboots/M = H.shoes
						if(M.magpulse)
							step_towards(H, direction) //step just once with magboots
							continue
					for(push = 1; push<=strength; push++)
						step_towards(H, direction)

	if(defer_powernet_rebuild != 2)
		defer_powernet_rebuild = 0
	return



/obj/windcurrent/north
	direction = NORTH

/obj/windcurrent/south
	direction = SOUTH

/obj/windcurrent/west
	direction = WEST

/obj/windcurrent/east
	direction = EAST