//Items for nuke theft, supermatter theft traitor objective


// STEALING THE NUKE

//the nuke core - objective item
/obj/item/nuke_core
	name = "plutonium core"
	desc = "Extremely radioactive. Wear goggles."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "plutonium_core"
	item_state = "plutoniumcore"
//	resistance_flags = INDESTRUCTIBLE |  FIRE_PROOF | ACID_PROOF
	var/pulse = 0
	var/cooldown = 1
	var/pulseicon = "plutonium_core_pulse"
	var/power = 2



/obj/item/nuke_core/attackby(obj/item/nuke_core_container/container, mob/user)
	if(istype(container))
		container.load(src, user)
	else
		return ..()

/obj/item/nuke_core/process()
	if(prob(50))
		cooldown--
	if(cooldown < 100)
		flick(pulseicon, src)
		radiation_repository.radiate(src, max(3, 50) )


//nuke core box, for carrying the core
/obj/item/nuke_core_container
	name = "nuke core container"
	desc = "Solid container for radioactive objects."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "core_container_empty"
	item_state = "tile"
	var/obj/item/nuke_core/core

/obj/item/nuke_core_container/Destroy()
	qdel(core)
	return ..()

/obj/item/nuke_core_container/proc/load(obj/item/nuke_core/ncore, mob/user)
	if(core || !istype(ncore))
		return FALSE
	ncore.forceMove(src)
	core = ncore
	icon_state = "core_container_loaded"
	to_chat(user, "<span class='warning'>Container is sealing...</span>")
	seal()
	qdel(ncore)
	return TRUE

/obj/item/nuke_core_container/proc/seal()
	if(istype(core))
		icon_state = "core_container_sealed"
		playsound(src, 'sound/items/deconstruct.ogg', 60, 1)
		if(ismob(loc))
			to_chat(loc, "<span class='warning'>[src] is permanently sealed, [core]'s radiation is contained.</span>")

/obj/item/nuke_core_container/attackby(obj/item/nuke_core/core, mob/user)
	if(istype(core))
		load(core, user)
	else
		return ..()

//snowflake screwdriver, works as a key to start nuke theft, traitor only
/obj/item/screwdriver/nuke
	name = "screwdriver"
	desc = "A screwdriver with an ultra thin tip."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "screwdriver_nuke"
	item_state = "screwdriver_nuke"
	toolspeed = 0.5



// STEALING SUPERMATTER


/obj/item/nuke_core/supermatter_sliver
	name = "supermatter sliver"
	desc = "A tiny, highly volatile sliver of a supermatter crystal. Do not handle without protection!"
	icon_state = "supermatter_sliver"
	item_state = "supermattersliver"
	pulseicon = "supermatter_sliver_pulse"

/obj/item/nuke_core/supermatter_sliver/attack_tk() // no TK dusting memes
	return FALSE

/obj/item/nuke_core/supermatter_sliver/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/hemostat/supermatter))
		var/obj/item/hemostat/supermatter/tongs = W
		if (tongs.sliver)
			to_chat(user, "<span class='notice'>\The [tongs] is already holding a supermatter sliver!</span>")
			return FALSE
		forceMove(tongs)
		tongs.sliver = src
		tongs.update_icon()
		to_chat(user, "<span class='notice'>You carefully pick up [src] with [tongs].</span>")
	else if(istype(W, /obj/item/scalpel/supermatter) || istype(W, /obj/item/nuke_core_container/supermatter/)) // we don't want it to dust
		return
	else
		to_chat(user, "<span class='notice'>As it touches \the [src], both \the [src] and \the [W] burst into dust!</span>")
		radiation_repository.radiate(user, max(power * 1.5, 50) )
		playsound(src, 'sound/effects/supermatter.ogg', 50, 1)
		qdel(W)
		qdel(src)

/obj/item/nuke_core/supermatter_sliver/pickup(mob/living/user)
	..()
	if(!iscarbon(user))
		return FALSE
	var/mob/ded = user
	to_chat(user, "<span class='warning'>You reach for the supermatter sliver with your hands. That was dumb.</span>")
	radiation_repository.radiate(user, max(power * 1.5, 50) )
	playsound(get_turf(user), 'sound/effects/supermatter.ogg', 50, 1)
	ded.dust()

/obj/item/nuke_core_container/supermatter
	name = "supermatter bin"
	desc = "A tiny receptacle that releases an inert hyper-noblium mix upon sealing, allowing a sliver of a supermatter crystal to be safely stored.."
	var/obj/item/nuke_core/supermatter_sliver/sliver

/obj/item/nuke_core_container/supermatter/Destroy()
	qdel(sliver)
	return ..()

/obj/item/nuke_core_container/supermatter/load(obj/item/hemostat/supermatter/T, mob/user)
	if(!istype(T) || !T.sliver)
		return FALSE
	T.sliver.forceMove(src)
	sliver = T.sliver
	T.sliver = null
	T.icon_state = "supermatter_tongs"
	icon_state = "core_container_loaded"
	to_chat(user, "<span class='warning'>Container is sealing...</span>")
	seal()
	return TRUE

/obj/item/nuke_core_container/supermatter/seal()
	if(istype(sliver))
		icon_state = "core_container_sealed"
		playsound(src, 'sound/items/Deconstruct.ogg', 60, 1)
		if(ismob(loc))
			to_chat(loc, "<span class='warning'>[src] is permanently sealed, [sliver] is safely contained.</span>")

/obj/item/nuke_core_container/supermatter/attackby(obj/item/hemostat/supermatter/tongs, mob/user)
	if(istype(tongs))
		//try to load shard into core
		load(tongs, user)
	else
		return ..()

/obj/item/scalpel/supermatter
	name = "supermatter scalpel"
	desc = "A scalpel with a tip of condensed hyper-noblium gas, searingly cold to the touch, that can safely shave a sliver off a supermatter crystal."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "supermatter_scalpel"
	toolspeed = 0.5
	damtype = "fire"
	usesound = 'sound/weapons/bladeslice.ogg'
	var/usesLeft

/obj/item/scalpel/supermatter/New()
	. = ..()
	usesLeft = rand(2, 4)

/obj/item/hemostat/supermatter
	name = "supermatter extraction tongs"
	desc = "A pair of tongs made from condensed hyper-noblium gas, searingly cold to the touch, that can safely grip a supermatter sliver."
	icon = 'icons/obj/nuke_tools.dmi'
	icon_state = "supermatter_tongs"
	toolspeed = 0.75
	damtype = "fire"
	var/obj/item/nuke_core/supermatter_sliver/sliver

/obj/item/hemostat/supermatter/Destroy()
	qdel(sliver)
	return ..()

/obj/item/hemostat/supermatter/update_icon()
	if(sliver)
		icon_state = "supermatter_tongs_loaded"
	else
		icon_state = "supermatter_tongs"

/obj/item/hemostat/supermatter/afterattack(atom/O, mob/user, proximity)
	if(!sliver)
		return
	if(O != sliver)
		Consume(O, user)

/obj/item/hemostat/supermatter/throw_impact(atom/hit_atom) // no instakill supermatter javelins
	if(sliver)
		sliver.forceMove(loc)
		to_chat(usr, "<span class='notice'>\The [sliver] falls out of \the [src] as you throw them.</span>")
		sliver = null
		update_icon()
	..()

/obj/item/hemostat/supermatter/proc/Consume(atom/movable/AM, mob/user)
	if(ismob(AM))
		var/mob/victim = AM
		victim.dust()
		investigate_log("has consumed [key_name(victim)].", "supermatter")
	else
		investigate_log("has consumed [AM].", "supermatter")
		qdel(AM)
	if (user)
		user.visible_message("<span class='danger'>As [user] touches [AM] with \a [src], silence fills the room...</span>",\
			"<span class='userdanger'>You touch [AM] with [src], and everything suddenly goes silent.</span>\n<span class='notice'>[AM] and [sliver] flash into dust, and soon as you can register this, you do as well.</span>",\
			"<span class='italics'>Everything suddenly goes silent.</span>")
		user.dust()
	radiation_repository.radiate(src, max(2, 50) )
	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)
	qdel(sliver)
	update_icon()
