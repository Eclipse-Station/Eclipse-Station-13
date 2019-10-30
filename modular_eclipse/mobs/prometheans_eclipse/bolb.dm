/mob/living/simple_animal/promethean_blob
	name = "promethean blob"
	desc = "It's so small and adorable!"
	tt_desc = "Macrolimus artificialis"
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey baby slime"
	icon_living = "grey baby slime"
	icon_dead = "grey baby slime dead"
	pass_flags = PASSTABLE
	faction = "slime"
	speed = 1
	no_vore = 1
	maxHealth = 75
	health = 60
	speed = 1

	ai_inactive = TRUE //Always off
	show_stat_health = FALSE //We will do it ourselves

	response_help = "pats the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 2
	melee_damage_lower = 5
	melee_damage_upper = 12
	attacktext = list("bonked", "chomped", "thunked", "angrily glomped", "pounced")

	var/obj/item/clothing/head/hat = null // The hat the slime may be wearing.

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 900

	speak_chance = 1
	speak = list("Blrb?","Sqrsh.","Glrsh!")
	speak_emote = list("chirps")
	emote_hear = list("squishes softly","spluts quietly","makes wet noises")
	emote_see = list("jiggles", "bounces in place")
	var/target_nutrition = 9999
	var/list/moods = list(":33", "pout", "angry", "sad", ":3", "mischevous")

	var/mood = ":33"

	var/mob/living/carbon/human/humanform
	var/mob/living/victim
	var/power_charge

	player_msg = "You are a small soft jelly thing. Smoothly rounded, with no limbs, with pulsing core your torso used to be. "


//Constructor allows passing the human to sync damages
/mob/living/simple_animal/promethean_blob/New(var/newloc, var/mob/living/carbon/human/H)
	..()
	overlays.Cut()
	if(H)
		nutrition = H.health/1.2
		target_nutrition = H.maxHealth * 1.5
		humanform = H
		updatehealth()
		verbs |= /mob/living/proc/ventcrawl
		verbs |= /mob/living/proc/hide
		color = rgb(min(H.r_skin + 40, 255), min(H.g_skin + 40, 255), min(H.b_skin + 40, 255))
		if(H.health > (H.maxHealth - H.maxHealth/1.25))
			overlays += "aslime-:33"
		else
			overlays += "aslime-pout"
			mood = "pout"
	else
		overlays += "aslime-:33"


/mob/living/simple_animal/promethean_blob/Destroy()
	humanform = null
	if(hat)
		drop_hat()
	return ..()

/mob/living/simple_animal/promethean_blob/init_vore()
	return //Don't make a random belly, don't waste your time

/mob/living/simple_animal/promethean_blob/Stat()
	..()
	if(humanform)
		humanform.species.Stat(humanform)


/mob/living/simple_animal/promethean_blob/updatehealth()
	if(humanform)
		//Set the max
		maxHealth = humanform.getMaxHealth()/1.75 //HUMANS, and their 'double health', bleh.
		//Set us to their health, but, human health ignores robolimbs so we do it 'the hard way'
		health = maxHealth - humanform.getOxyLoss() - humanform.getToxLoss() - humanform.getCloneLoss() - humanform.getActualFireLoss() - humanform.getActualBruteLoss()

		//Alive, becoming dead
		if((stat < DEAD) && (health <= 0))
			death()

		//Overhealth
		if(health > getMaxHealth())
			health = getMaxHealth()

	else
		..()

/mob/living/simple_animal/promethean_blob/adjustBruteLoss(var/amount)
	if(humanform)
		humanform.adjustBruteLoss(amount)
	else
		..()

/mob/living/simple_animal/promethean_blob/adjustFireLoss(var/amount)
	if(humanform)
		humanform.adjustFireLoss(amount)
	else
		..()

/mob/living/simple_animal/promethean_blob/death(gibbed, deathmessage = "splatters, leaving only its core!")
	if(humanform)
		humanform.death(gibbed = gibbed)
		for(var/organ in humanform.internal_organs)
			var/obj/item/organ/internal/O = organ
			O.removed()
			O.forceMove(drop_location())
		var/list/items = humanform.get_equipped_items()
		for(var/obj/object in items)
			object.forceMove(drop_location())
		QDEL_NULL(humanform) //Don't leave it just sitting in nullspace

	animate(src,alpha = 0,time = 2 SECONDS)
	sleep(2 SECONDS)
	qdel(src)

	..()

/mob/living/simple_animal/promethean_blob/Life()
	. = ..()


/mob/living/simple_animal/promethean_blob/MouseEntered(location,control,params)
	if(resting)
		return
	..()

// Helpers - Unsafe, WILL perform change.
/mob/living/carbon/human/proc/blobify()
	handle_grasp() //It's possible to blob out before some key parts of the life loop. This results in things getting dropped at null. TODO: Fix the code so this can be done better.
	remove_micros(src, src) //Living things don't fare well in bolbs.
	if(buckled)
		buckled.unbuckle_mob()
	if(LAZYLEN(buckled_mobs))
		for(var/buckledmob in buckled_mobs)
			riding_datum.force_dismount(buckledmob)
	if(pulledby)
		pulledby.stop_pulling()
	stop_pulling()

	//Record where they should go
	var/atom/creation_spot = drop_location()

	//Create our new blob
	var/mob/living/simple_animal/promethean_blob/blob = new(creation_spot,src)

	//Drop all our things
	var/list/things_to_drop = contents.Copy()
	var/list/things_to_not_drop = list(nif,wear_id,l_ear,r_ear) //And whatever else we decide for balancing.


	things_to_drop -= things_to_not_drop //Crunch the lists
	things_to_drop -= organs //Mah armbs
	things_to_drop -= internal_organs //Mah sqeedily spooch

	for(var/obj/item/I in things_to_drop) //rip hoarders
		drop_from_inventory(I)

	if(w_uniform && istype(w_uniform,/obj/item/clothing)) //No webbings tho. We do this after in case a suit was in the way
		var/obj/item/clothing/uniform = w_uniform
		if(LAZYLEN(uniform.accessories))
			for(var/obj/item/clothing/accessory/A in uniform.accessories)
				uniform.remove_accessory(null,A) //First param is user, but adds fingerprints and messages

	//Size update
	blob.transform = matrix()*size_multiplier
	blob.size_multiplier = size_multiplier

	//Put our owner in it (don't transfer var/mind)
	blob.ckey = ckey
	temporary_form = blob

	//Mail them to nullspace
	forceMove(null)

	//Message
	blob.visible_message("<b>[src.name]</b> collapses into a gooey blob!")


	//Transfer vore organs
	blob.vore_organs = vore_organs
	blob.vore_selected = vore_selected
	for(var/belly in vore_organs)
		var/obj/belly/B = belly
		B.forceMove(blob)
		B.owner = blob

	//Return our blob in case someone wants it
	return blob


/mob/living/carbon/human/proc/unblobify(var/mob/living/simple_animal/promethean_blob/blob)
	if(!istype(blob))
		return
	if(buckled)
		buckled.unbuckle_mob()
	if(LAZYLEN(buckled_mobs))
		for(var/buckledmob in buckled_mobs)
			riding_datum.force_dismount(buckledmob)
	if(pulledby)
		pulledby.stop_pulling()
	stop_pulling()


	//Play the animation
	blob.icon_state = "from_puddle"

	//Message
	blob.visible_message("<b>[src.name]</b> reshapes into a humanoid appearance!")

	//Duration of above animation
	sleep(8)

	//Record where they should go
	var/atom/reform_spot = blob.drop_location()

	//Size update
	transform = matrix()*blob.size_multiplier
	size_multiplier = blob.size_multiplier

	//Move them back where the blob was
	forceMove(reform_spot)

	//Put our owner in it (don't transfer var/mind)
	ckey = blob.ckey
	temporary_form = null

	//Transfer vore organs
	vore_selected = blob.vore_selected
	for(var/belly in blob.vore_organs)
		var/obj/belly/B = belly
		B.forceMove(src)
		B.owner = src


	Life(1) //Fix my blindness right meow //Has to be moved up here, there exists a circumstance where blob could be deleted without vore organs moving right.

	//Get rid of friend blob
	qdel(blob)

	//Return ourselves in case someone wants it
	return src


/mob/living/simple_animal/promethean_blob/verb/evolve()
	set category = "Slime"
	set name = "Evolve"
	set desc = "This will let you evolve from a slime into a promethean."

	if(stat)
		to_chat(src, "<span class='notice'>You must be conscious to do this.</span>")
		return


	if(nutrition >= target_nutrition)
		to_chat(src, "<span class='notice'>You begin to reform...</span>")
		if(do_after(src, 50))
			for(var/obj/item/organ/I in humanform.internal_organs)
				if(I.damage > 0)
					I.damage = max(I.damage - 30, 0) //Repair functionally half of a dead internal organ.
			// Replace completely missing limbs.
			for(var/limb_type in humanform.species.has_limbs)
				var/obj/item/organ/external/E = humanform.organs_by_name[limb_type]
				if(E && E.disfigured)
					E.disfigured = 0
				if(E && (E.is_stump() || (E.status & (ORGAN_DESTROYED|ORGAN_DEAD|ORGAN_MUTATED))))
					E.removed()
					qdel(E)
					E = null
				if(!E)
					var/list/organ_data = humanform.species.has_limbs[limb_type]
					var/limb_path = organ_data["path"]
					var/obj/item/organ/O = new limb_path(humanform)
					organ_data["descriptor"] = O.name
			humanform.regenerate_icons()
			humanform.unblobify(src)
		else
			to_chat(src, "<span class='notice'>Your evolution is interrupted!</span>")
	else
		to_chat(src, "<span class='notice'>You're too hungry to evolve!</span>")

/mob/living/simple_animal/promethean_blob/verb/set_mood()
	set category = "Slime"
	set name = "Set Mood"
	set desc = "the mood will be big."

	var/chosen_mood = input(usr, "Choose a mood (to be displayed as your face)","Big Mood") as null|anything in moods
	if(!chosen_mood)
		return
	else
		mood = chosen_mood
		update_icon()

/mob/living/simple_animal/promethean_blob/proc/can_consume(var/mob/living/L)
	if(!L || !istype(L))
		to_chat(src, "This subject is incomparable...")
		return FALSE
	if(L.isSynthetic())
		to_chat(src, "This subject is not biological...")
		return FALSE
	if((L.getarmor(null, "bio") >= 75))
		to_chat(src, "I cannot reach this subject's biological matter...")
		return FALSE
	if(istype(L, /mob/living/simple_animal/slime))
		to_chat(src, "I cannot feed on other slimes...")
		return FALSE
	if(!Adjacent(L))
		to_chat(src, "This subject is too far away...")
		return FALSE
	if(istype(L, /mob/living/carbon) && L.getCloneLoss() >= L.getMaxHealth() * 1.2 || istype(L, /mob/living/simple_animal) && L.stat == DEAD)
		to_chat(src, "This subject does not have an edible life energy...")
		return FALSE
	if(L.has_buckled_mobs())
		for(var/A in L.buckled_mobs)
			if(istype(A, /mob/living/simple_animal/slime))
				if(A != src)
					to_chat(src, "\The [A] is already feeding on this subject...")
					return FALSE
	return TRUE

/mob/living/simple_animal/promethean_blob/proc/start_consuming(var/mob/living/L)
	if(!can_consume(L))
		return
	if(!Adjacent(L))
		return
	step_towards(src, L) // Get on top of them to feed.
	if(loc != L.loc)
		return
	if(L.buckle_mob(src, forced = TRUE))
		victim = L
		update_icon()
		victim.visible_message("<span class='danger'>\The [src] latches onto [victim]!</span>",
		"<span class='danger'>\The [src] latches onto you!</span>")

/mob/living/simple_animal/promethean_blob/proc/stop_consumption()
	if(!victim)
		return
	victim.unbuckle_mob()
	victim.visible_message("<span class='notice'>\The [src] slides off of [victim]!</span>",
	"<span class='notice'>\The [src] slides off of you!</span>")
	victim = null
	update_icon()

/mob/living/simple_animal/promethean_blob/update_icon()
	if(stat == DEAD)
		icon_state = icon_dead
		set_light(0)
	overlays.Cut()

	if(stat != DEAD)
		var/image/I
		I = image(icon, src, "aslime-[mood]")
		overlays += I


	if(hat)
		var/hat_state = hat.item_state ? hat.item_state : hat.icon_state
		var/image/I = image('icons/mob/head.dmi', src, hat_state)
		I.pixel_y = -7 // Slimes are small.
		I.appearance_flags = RESET_COLOR
		overlays += I


/mob/living/simple_animal/promethean_blob/proc/handle_consumption()
	if(victim && can_consume(victim) && !stat)

		var/armor_modifier = abs((victim.getarmor(null, "bio") / 100) - 1)
		if(istype(victim, /mob/living/carbon))
			victim.adjustCloneLoss(rand(2,4) * armor_modifier)
			victim.adjustToxLoss(rand(1,2) * armor_modifier)
			if(victim.health <= 0)
				victim.adjustToxLoss(rand(1,3) * armor_modifier)
			adjust_nutrition(2 * armor_modifier)

		else
			to_chat(src, "<span class='warning'>[pick("This subject is incompatable", \
			"This subject does not have a life energy", "This subject is empty", "I am not satisified", \
			"I can not feed from this subject", "I do not feel nourished", "This subject is not food")]...</span>")
			stop_consumption()


		adjustOxyLoss(-2)
		adjustBruteLoss(-2)
		adjustFireLoss(-2)
		adjustCloneLoss(-2)
		updatehealth()
		if(victim)
			victim.updatehealth()
	else
		stop_consumption()

/mob/living/simple_animal/promethean_blob/proc/adjust_nutrition(input)
	nutrition = between(0, nutrition + input, get_max_nutrition())

	if(input > 0)
		if(prob(input * 2)) // Gain around one level per 50 nutrition
			power_charge = min(power_charge++, 10)
			if(power_charge == 10)
				adjustToxLoss(-10)
				power_charge--


/mob/living/simple_animal/promethean_blob/proc/get_max_nutrition() // Can't go above it
	return 1000

/mob/living/simple_animal/promethean_blob/proc/get_grow_nutrition() // Above it we grow, below it we can eat
	return 800

/mob/living/simple_animal/promethean_blob/proc/get_hunger_nutrition() // Below it we will always eat
	return 500

/mob/living/simple_animal/promethean_blob/proc/get_starve_nutrition() // Below it we will eat before everything else
	return 200



/mob/living/simple_animal/promethean_blob/UnarmedAttack(var/mob/living/L)
	if(!Adjacent(L)) // Might've moved away in the meantime.
		return

	if(istype(L))

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			// Slime attacks can be blocked with shields.
			if(H.check_shields(damage = 0, damage_source = null, attacker = src, def_zone = null, attack_text = "the attack"))
				return

		switch(a_intent)
			if(I_HELP)
				ai_log("DoPunch() against [L], helping.",2)
				L.visible_message("<span class='notice'>[src] gently pokes [L]!</span>",
				"<span class='notice'>[src] gently pokes you!</span>")
			//	do_attack_animation(L) -

			if(I_DISARM)
				ai_log("DoPunch() against [L], disarming.",2)
				var/stun_power = between(0, power_charge + rand(0, 3), 10)

				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					stun_power *= max(H.species.siemens_coefficient,0)


				if(prob(stun_power * 10))
					power_charge = max(0, power_charge - 3)
					L.visible_message("<span class='danger'>[src] has shocked [L]!</span>", "<span class='danger'>[src] has shocked you!</span>")
					playsound(src, 'sound/weapons/Egloves.ogg', 75, 1)
					L.Weaken(3)
					L.Stun(3)
					do_attack_animation(L)
					if(L.buckled)
						L.buckled.unbuckle_mob() // To prevent an exploit where being buckled prevents slimes from jumping on you.
					L.stuttering = max(L.stuttering, stun_power)

					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, L)
					s.start()

					if(prob(stun_power * 10) && stun_power >= 8)
						L.adjustFireLoss(power_charge / rand(1, 1.5))

				else if(prob(40))
					L.visible_message("<span class='danger'>[src] has pounced at [L]!</span>", "<span class='danger'>[src] has pounced at you!</span>")
					playsound(src, 'sound/weapons/thudswoosh.ogg', 75, 1)
					L.Weaken(2)
					do_attack_animation(L)
					if(L.buckled)
						L.buckled.unbuckle_mob() // To prevent an exploit where being buckled prevents slimes from jumping on you.
				else
					L.visible_message("<span class='danger'>[src] has tried to pounce at [L]!</span>", "<span class='danger'>[src] has tried to pounce at you!</span>")
					playsound(src, 'sound/weapons/punchmiss.ogg', 75, 1)
					do_attack_animation(L)
				L.updatehealth()
				return L

			if(I_GRAB)
				ai_log("DoPunch() against [L], grabbing.",2)
				start_consuming(L)

			if(I_HURT)
				ai_log("DoPunch() against [L], hurting.",2)
				var/damage_to_do = rand(melee_damage_lower, melee_damage_upper)
				var/armor_modifier = abs((L.getarmor(null, "bio") / 100) - 1)

				L.attack_generic(src, damage_to_do, pick(attacktext))
				playsound(src, 'sound/weapons/bite.ogg', 75, 1)

				// Give the slime some nutrition, if applicable.
				if(!L.isSynthetic())
					if(ishuman(L))
						if(L.getCloneLoss() < L.getMaxHealth() * 1.5)
							adjust_nutrition(damage_to_do * armor_modifier)

					else if(istype(L, /mob/living/simple_animal))
						if(!isslime(L))
							var/mob/living/simple_animal/SA = L
							if(!SA.stat)
								adjust_nutrition(damage_to_do)


	if(istype(L,/obj/mecha))
		var/obj/mecha/M = L
		M.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), pick(attacktext))


/mob/living/simple_animal/promethean_blob/PunchTarget()
	if(victim)
		return // Already eatting someone.
	if(!client) // AI controlled.
		if(can_consume(target_mob) && target_mob.lying)
			a_intent = I_GRAB // Then eat them.
		else
			a_intent = I_HURT // Otherwise robust them.
	ai_log("PunchTarget() will [a_intent] [target_mob]",2)
	..()

/mob/living/simple_animal/promethean_blob/handle_regular_status_updates()
	if(stat != DEAD)

		if(prob(5))
			adjustOxyLoss(-1)
			adjustToxLoss(-1)
			adjustFireLoss(-1)
			adjustCloneLoss(-1)
			adjustBruteLoss(-1)

		if(victim)
			handle_consumption()

		handle_stuttering()

	..()

/mob/living/simple_animal/promethean_blob/proc/give_hat(var/obj/item/clothing/head/new_hat, var/mob/living/user)
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

/mob/living/simple_animal/promethean_blob/proc/remove_hat(var/mob/living/user)
	if(!hat)
		to_chat(user, "<span class='warning'>\The [src] doesn't have a hat to remove.</span>")
	else
		hat.forceMove(get_turf(src))
		user.put_in_hands(hat)
		to_chat(user, "<span class='warning'>You take away \the [src]'s [hat.name]. How mean.</span>")
		hat = null
		update_icon()

/mob/living/simple_animal/promethean_blob/proc/drop_hat()
	if(!hat)
		return
	hat.forceMove(get_turf(src))
	hat = null
	update_icon()


/mob/living/simple_animal/promethean_blob/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/clothing/head)) // Handle hat simulator.
		give_hat(W, user)
		return

	// Otherwise they're probably fighting the slime.
	if(prob(25))
		visible_message("<span class='danger'>\The [user]'s [W] passes right through [src]!</span>")
		user.setClickCooldown(user.get_attack_speed(W))
		return
	..()


/mob/living/simple_animal/promethean_blob/attack_hand(mob/living/carbon/human/M as mob)
	if(victim) // Are we eating someone?
		var/fail_odds = 30
		if(victim == M) // Harder to get the slime off if its eating you right now.....
			fail_odds = 60

		if(prob(fail_odds))
			visible_message("<span class='warning'>[M] attempts to wrestle \the [name] off!</span>")
			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

		else
			visible_message("<span class='warning'> [M] manages to wrestle \the [name] off!</span>")
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

			stop_consumption()
			step_away(src,M)
	else
		if(M.a_intent == I_HELP)
			if(hat)
				remove_hat(M)
			else
				..()
		else
			..()