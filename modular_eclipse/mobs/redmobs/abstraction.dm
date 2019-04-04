/mob/living/simple_animal/redmob/abstraction
	name = "your reflection"
	desc = "Is that..?"
	icon = 'icons/mob/ghost.dmi'
	icon_state = "ghost"
	tt_desc = "$!@%#!"
	alpha = 5
	health = 9999
	var/smudgecolor = "#8b0000"
	var/ghost_overlays = list()
	mouse_opacity = 0
	anchored = 1 //so you can't move it by breaking floor under it
	wander = 0
	density = 0
	a_intent = I_HURT
	var/list/sane = list(
	"judges you silently","stands perfectly still","doesn't break eye contact","cries","stares at you", "mumbles", "whispers"
	) //texts that go [x] looks at you
	var/list/insane = list(
	"judges you silently","draws a finger across its... no, your neck","twists its face into a terrifying grimace","stares at you","weeps blood", "laughs at you"
	)
	var/list/scares =list(
	"Look at what you've become.", "You hate yourself.", "Submit unto your madness.", "Ashes to ashes. Bones to paste.", "There is no way back.", "Don't lie to yourself.",
	"Everyone hates you.", "You want to end it all.", "Empty. Empty. Empty. Empty.", "Choke on your teeth.", "They talk behind your back.", "You're full of regrets.",
	"Pain will never go away.", "Help me! Help me! Help me!"
	)
/mob/living/simple_animal/redmob/abstraction/Life()
	..()
	if(prob(10))
		humes_repository.humesiate(src, 25)
	for(var/mob/living/L in oviewers(world.view, src))
		if(L.insanity > 25)
			update_overlays(L)
		if(prob(50))
			if(L.insanity > 75)
				continue
			else
				L.insanity += 1
		if(prob(8))
			message_victim(L)


/mob/living/simple_animal/redmob/abstraction/proc/update_overlays(var/mob/victim)
	for(var/obj/effect/overlay/redspace/O in ghost_overlays)
		if(O.tormented == victim)
			ghost_overlays -= O
			qdel(O)
	abstract(victim)

/mob/living/simple_animal/redmob/abstraction/proc/message_victim(var/mob/living/victim)
	if(victim.insanity > 25)
		if(victim.insanity < 50)
			victim.show_message("<font color='red'><B>Your reflection [pick(sane)].</B></font>", 1)
			return
		else
			if(prob(50))
				victim.show_message("<font color='red'><B>Your reflection [pick(insane)].</B></font>", 1)
				return
			else
				victim.show_message("<font color='red'><B>Your reflection whispers, \"[pick(scares)]\"</B></font>", 1)

/mob/living/simple_animal/redmob/abstraction/hitby()//Nope. It's not real.
	return

/mob/living/simple_animal/redmob/abstraction/death()
	for(var/obj/effect/overlay/redspace/O in ghost_overlays)
		O.tormentor = null
		ghost_overlays -= O
		qdel(O)
	explosion(get_turf(src), 0, 0, 0, 1)
	qdel(src)
	return ..()

/mob/living/simple_animal/redmob/bluespace_impact(atom/bluespace_src)
	if(istype(bluespace_src, /obj/item/weapon/ore/bluespace_crystal))
		src.visible_message("<span class='warning'>Anomaly implodes on collision with [bluespace_src]!</span>")
		if(prob(20))
			new/obj/item/weapon/ore/bluespace_crystal/redspace_crystal(get_turf(loc))
		death()
		return 1

/mob/living/simple_animal/redmob/abstraction/handle_stance()//Main purpose of abstractions is to induce insanity and be genuinely creepy, giving opportunities for other redmobs to manifest
	a_intent = I_HURT //so you can't push past them
	return

/mob/living/simple_animal/redmob/abstraction/proc/abstract(var/mob/living/victim)
	var/obj/effect/overlay/redspace/O = new/obj/effect/overlay/redspace(loc)
	O.name = "abstraction"
	O.tormented = victim
	O.tormentor = src
	ghost_overlays += O
	var/stare_direction = NORTH
	stare_direction = get_dir(src.loc, victim.loc)
	var/image/A = new/image(victim, dir = stare_direction)
//	O.dir = EAST
	A.alpha = 55 + victim.insanity*2 //don't starve shadow monsters WOOO
	A.color = smudgecolor
	var/image/I = image(A,O,get_turf(loc),O.dir,1, dir = stare_direction)
	victim << I

/obj/effect/overlay/redspace
	mouse_opacity = 0
	var/mob/tormented //person that sees the overlay
	var/mob/tormentor //abstraction, controlling the overlay
/*
/obj/effect/overlay/redspace/New()
	..()
	sleep(1)
	processing_objects += src


/obj/effect/overlay/redspace/Destroy()
	processing_objects -= src
	..()

/obj/effect/overlay/redspace/process()
	if(!tormentor)
		qdel(src)
	*/


