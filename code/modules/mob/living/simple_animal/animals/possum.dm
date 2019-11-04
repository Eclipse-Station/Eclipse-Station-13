/mob/living/simple_animal/opossum
	name = "opossum"
	desc = "It's an opossum, a small scavenging marsupial."
	tt_desc = "E Didelphis virginiana"
	icon_state = "possum"
	item_state = "possum"
	icon_living = "possum"
	icon_dead = "possum_dead"
	intelligence_level = SA_ANIMAL
	icon = 'icons/mob/possum.dmi'
	speak = list("Hiss!","Aaa!","Aaa?")
	speak_emote = list("hisses")
	emote_hear = list("hisses")
	emote_see = list("forages for trash", "lounges")
	pass_flags = PASSTABLE
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	maxHealth = 50
	health = 50
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "stamps on"
	density = 0
	minbodytemp = 223
	maxbodytemp = 323
	universal_speak = FALSE
	universal_understand = TRUE
	mob_size = MOB_SMALL
	can_pull_mobs = MOB_PULL_SMALLER
	var/is_angry = FALSE

	var/obj/item/clothing/head/hat = null //Yes, I'm giving them hats. They deserve them.
	var/can_remove_hat = TRUE //Some possums are stingier of their hats than others

/mob/living/simple_animal/opossum/Life()
	. = ..()
	if(. && !ckey && stat != DEAD && prob(1))
		resting = (stat == UNCONSCIOUS)
		if(!resting)
			wander = initial(wander)
			speak_chance = initial(speak_chance)
			stat = CONSCIOUS
			if(prob(10))
				is_angry = TRUE
		else
			wander = FALSE
			speak_chance = 0
			stat = UNCONSCIOUS
			is_angry = FALSE
		update_icon()

/mob/living/simple_animal/opossum/death()
	. = ..()
	drop_hat()

/mob/living/simple_animal/opossum/adjustBruteLoss(damage)
	. = ..()
	if(damage >= 3)
		respond_to_damage()

/mob/living/simple_animal/opossum/adjustFireLoss(damage)
	. = ..()
	if(damage >= 3)
		respond_to_damage()

/mob/living/simple_animal/opossum/lay_down()
	. = ..()
	update_icon()

/mob/living/simple_animal/opossum/proc/respond_to_damage()
	if(!resting && stat == CONSCIOUS)
		if(!is_angry)
			is_angry = TRUE
			audible_emote("hisses!")
		else
			resting = TRUE
			visible_emote("dies!")
		update_icon()

/mob/living/simple_animal/opossum/Move()
	..()
	update_icon()

/mob/living/simple_animal/opossum/facedir()
	..()
	update_icon()

/mob/living/simple_animal/opossum/update_canmove()
	..()
	update_icon()

/mob/living/simple_animal/opossum/update_icon()

	if(stat == DEAD || (resting && is_angry))
		icon_state = icon_dead
	else if(resting || stat == UNCONSCIOUS)
		icon_state = "[icon_living]_sleep"
	else if(is_angry)
		icon_state = "[icon_living]_aaa"
	else
		icon_state = icon_living

	overlays.Cut()

	if(hat)
		var/hat_state = hat.item_state ? hat.item_state : hat.icon_state
		var/image/I = image('icons/mob/head.dmi', src, hat_state)
		switch(dir)
			if(EAST)
				I.pixel_y = -17 // poss are small.
				I.pixel_x = 10
			if(WEST)
				I.pixel_y = -17 // poss are small.
				I.pixel_x = -10
			if(NORTH)
				I.pixel_y = -17 // poss are small.
			if(SOUTH)
				I.pixel_x = 2
				I.pixel_y = -17 // poss are small.
		if(resting)
			I.pixel_y = I.pixel_y - 3
		I.appearance_flags = RESET_COLOR
		overlays += I


/mob/living/simple_animal/opossum/proc/give_hat(var/obj/item/clothing/head/new_hat, var/mob/living/user)
	if(!istype(new_hat))
		to_chat(user, "<span class='warning'>\The [new_hat] isn't a hat.</span>")
		return
	if(hat)
		to_chat(user, "<span class='warning'>\The [src] is already wearing \a [hat].</span>")
		return
	else
		user.drop_item(new_hat)
		hat = new_hat
		new_hat.forceMove(src)
		to_chat(user, "<span class='notice'>You place \a [new_hat] on \the [src]. How adorable!</span>")
		update_icon()
		return


/mob/living/simple_animal/opossum/proc/remove_hat(var/mob/living/user)
	if(!hat)
		to_chat(user, "<span class='warning'>\The [src] doesn't have a hat to remove.</span>")
	else if(can_remove_hat)
		hat.forceMove(get_turf(src))
		user.put_in_hands(hat)
		to_chat(user, "<span class='warning'>You take away \the [src]'s [hat.name]. How mean.</span>")
		hat = null
		update_icon()

/mob/living/simple_animal/opossum/proc/drop_hat()
	if(!hat)
		return
	hat.forceMove(get_turf(src))
	hat = null
	update_icon()

/mob/living/simple_animal/opossum/proc/wear_hat(var/obj/item/new_hat)
	if(hat)
		return
	hat = new_hat
	new_hat.loc = src
	updateicon()

/mob/living/simple_animal/opossum/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/clothing/head)) // Handle hat simulator.
		give_hat(W, user)
		return
	..()

/mob/living/simple_animal/opossum/attack_hand(mob/living/carbon/human/M as mob)
	if(M.a_intent == I_HELP)
		if(hat)
			remove_hat(M)
		else
			..()
	else
		..()

/mob/living/simple_animal/opossum/initialize()
	. = ..()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide


/mob/living/simple_animal/opossum/cargo
	name = "Barnaby Bossum"
	desc = "It's an opossum, a small scavenging marsupial. He's a trashman. He eats trash."
	speak_chance = 3
	can_remove_hat = FALSE

/mob/living/simple_animal/opossum/cargo/New()
	var/obj/item/clothing/head/poss_hat = new /obj/item/clothing/head/soft/yellow(loc)
	give_hat(poss_hat, src)
	updateicon()
	..()

/mob/living/simple_animal/opossum/janitor
	name = "Glenn"
	desc = "It's an opossum, a small scavenging marsupial. This one seems particularly independent, he did it all himself."
	speak_chance = 3
	can_remove_hat = FALSE

/mob/living/simple_animal/opossum/janitor/New()
	var/obj/item/clothing/head/poss_hat = new /obj/item/clothing/head/soft/purple(loc)
	give_hat(poss_hat, src)
	updateicon()
	..()
