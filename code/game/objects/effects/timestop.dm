/obj/effect/timestop
	anchored = 1
	name = "chronofield"
	desc = "ZA WARUDO"
	icon = 'icons/effects/160x160.dmi'
	icon_state = "time"
	layer = FLY_LAYER
	pixel_x = -64
	pixel_y = -64
	unacidable = 1
	mouse_opacity = 0
	var/mob/living/immune = list() // the one who creates the timestop is immune
	var/list/stopped_atoms = list()
	var/freezerange = 2
	var/duration = 250
	alpha = 125

/obj/effect/timestop/New()
	..()
	processing_objects |= src

/obj/effect/timestop/Destroy()
	playsound(get_turf(src), 'sound/magic/TIMEPARADOX2.ogg', 100, 1, -1) //reverse!
	processing_objects -= src
	return ..()



/obj/effect/timestop/process()
	for(var/obj/item/A in range(freezerange, loc))//projectile
		if(istype(A, /obj/item/)) //projectile
			var/obj/item/P = A //projectile/
			P.paused = TRUE
			stopped_atoms |= P
			processing_objects -= P

/obj/effect/timestop/proc/timestop()
	playsound(get_turf(src), 'sound/magic/TIMEPARADOX2.ogg', 100, 1, -1)
	for(var/i in 1 to duration-1)
		for(var/A in orange (freezerange, loc))
			if(isliving(A))
				var/mob/living/M = A
				if(M in immune)
					continue
				M.anchored = 1
				M.AdjustStunned(1)
				if(istype(M, /mob/living/simple_animal/hostile))
					var/mob/living/simple_animal/hostile/H = M
					H.ai_inactive = 1
					H.LoseTarget()

				stopped_atoms |= M
			else if(istype(A, /obj/item/projectile))
				var/obj/item/projectile/P = A
				P.paused = TRUE
				stopped_atoms |= P
				processing_objects -= P

		for(var/mob/living/M in stopped_atoms)
			if(get_dist(get_turf(M),get_turf(src)) > freezerange) //If they lagged/ran past the timestop somehow, just ignore them
				unfreeze_mob(M)
				stopped_atoms -= M
		sleep(1)

	//End
	for(var/mob/living/M in stopped_atoms)
		unfreeze_mob(M)

	for(var/obj/item/P in stopped_atoms) //projectile
		processing_objects |= P
		P.paused = FALSE
	qdel(src)
	return

/obj/effect/timestop/proc/unfreeze_mob(mob/living/M)
	M.anchored = 0
	M.AdjustStunned(-1.5 * duration)
	if(istype(M, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/H = M
		H.ai_inactive = 0


/obj/effect/timestop/wizard
	duration = 200

/obj/effect/timestop/wizard/New()
	..()
	timestop()

/obj/effect/timestop/stopwatch
	duration = 350

/obj/effect/timestop/stopwatch/New()
	..()
	timestop()
