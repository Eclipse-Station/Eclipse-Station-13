/*
 * Reusable projectiles, mostly copied from a downstream of mid-2016 /tg/code.
 * Things such as harpoon guns, air rifles, or whatever you'd want to code in
 * that you'd want the end user to be able to recover the projectile fired.
 *
 * Basically, when someone is hit with the bullet and it runs the qdel, it'll
 * spawn a replacement projectile.
 */


/obj/item/projectile/bullet/reusable
	name = "reusable bullet"
	desc = "How do you even reuse a bullet?"
	embed_chance = 0				//CHANGE AT OWN RISK
	var/ammo_type = /obj/item/ammo_casing/caseless/
	var/dropped = 0

/obj/item/projectile/bullet/reusable/on_hit(atom/target, blocked = 0)
	. = ..()
	handle_drop()


/* //Apparently maximum bullet range is not a thing on this codebase?
/obj/item/projectile/bullet/reusable/on_range()
	handle_drop()
	..()
*/

/obj/item/projectile/bullet/reusable/proc/handle_drop()
	if(!dropped)
		new ammo_type(src.loc)
		dropped = 1


// 4.5mm BB
/obj/item/projectile/bullet/reusable/air_rifle_bb
	name = "\improper BB"
	desc = "A .177 (4.5mm) BB. You'll probably want to stop staring at it and put some eye protection on..."
	icon = 'modular_aeiou/icons/obj/projectile_aeiou.dmi'
	icon_state = "bb-steel"
	damage = 3
	agony = 15		//they sting to get hit by, even at post-ricochet velocities
	SA_bonus_damage = 32		//35 damage against simplemobs
	SA_vulnerability = SA_ANIMAL
	fire_sound = 'sound/weapons/gunshot_air_rifle.ogg'
	sharp = 0
	check_armour = "melee"
	combustion = FALSE
	ammo_type = /obj/item/ammo_casing/caseless/a177bb
	var/drop_chance = 20		//chance to get a functional reusable bullet


//Sadly, reinventing the wheel is a bit necessary here in order to suppress an
//extra 'this guy's been shot' message from appearing in chat. The sacrifices we
//make for a cheesy film reference...
/obj/item/projectile/bullet/reusable/air_rifle_bb/attack_mob(mob/living/target_mob, distance, miss_modifier=0)
	if(!istype(target_mob))
		return

	//roll to-hit
	miss_modifier = max(15*(distance-2) - accuracy + miss_modifier + target_mob.get_evasion(), 0)
	var/hit_zone = get_zone_with_miss_chance(def_zone, target_mob, miss_modifier, ranged_attack=(distance > 1 || original != target_mob)) //if the projectile hits a target we weren't originally aiming at then retain the chance to miss

	var/result = PROJECTILE_FORCE_MISS
	if(hit_zone)
		def_zone = hit_zone //set def_zone, so if the projectile ends up hitting someone else later (to be implemented), it is more likely to hit the same part
		result = target_mob.bullet_act(src, def_zone)

	if(result == PROJECTILE_FORCE_MISS)
		if(!silenced)
			visible_message("<span class='notice'>\The [src] misses [target_mob] narrowly!</span>")
		return 0

// // // // // BEGIN EDIT FOR SHOT-IN-EYE CHECK // // // // //
	var/message_already_sent = FALSE		//have we printed a message already?
	if(istype(target_mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/target = target_mob


		if(hit_zone == "head" && prob(20))		//shoot their eye out, kid!
			if(target.glasses || target.wear_mask || target.head)
				var/eye_protection = null
				if (target.head && !eye_protection)		//helmets and the like
					if (target.head.body_parts_covered & EYES)
						eye_protection = target.head
				if (target.wear_mask && !eye_protection)		//If they're wearing a mask
					if (target.wear_mask.body_parts_covered & EYES)
						eye_protection = target.wear_mask
				if(target.glasses && !eye_protection) //TODO TODO TODO: Make their glasses actually fly off
					eye_protection = target.glasses

				if(eye_protection)
					if(silenced)
						to_chat(target_mob, "<span class='danger'>\The [src] bounces harmlessly off your [eye_protection]!</span>")
					
					else
						target.visible_message(
							"<span class='danger'>\The [src] bounces off \the [target]'s [eye_protection]!</span>",
							"<span class='danger'>\The [src] bounces harmlessly off your [eye_protection]!</span>",
							"You hear a loud, small impact."
							)
					message_already_sent = TRUE
					damage = 0		//deflected by the item, so no damage
					nodamage = TRUE
					agony = 5		//hurts a lot less, there's more area to spread the impact forces
					weaken = 5		//still hurts though

			else		//no eye protection? yeowza.
				var/obj/item/organ/internal/eyes/E = target.internal_organs_by_name[O_EYES]
				E.damage += 15
				if(silenced)
					to_chat(target_mob, "<span class='userdanger'>\The [src] hits you in the eye!</span>")
				else
					target.visible_message(
							"<span class='danger'>\The [src] hits \the [target] in the eye!</span>",
							"<span class='userdanger'>\The [src] hits you in the eye!</span>"
							)
							
				message_already_sent = TRUE
				agony = 75
				if(target.can_feel_pain())
					target.emote("scream")
				
				target.Blind(5)		//blind them for a few seconds
				target.eye_blurry = 5
				
				if(!(target.disabilities & NEARSIGHTED))	//a check to see if they're already nearsighted, so we don't accidentally cure their vision
					target.disabilities |= NEARSIGHTED
					spawn(300)		//30 seconds
						target.disabilities &= ~NEARSIGHTED
	
	if(!message_already_sent)
		if(silenced)
			to_chat(target_mob, "<span class='danger'>You've been hit in the [parse_zone(def_zone)] by \the [src]!</span>")
		else
			visible_message("<span class='danger'>\The [target_mob] is hit by \the [src] in the [parse_zone(def_zone)]!</span>")//X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter
		message_already_sent = TRUE
// // // // // END EDIT FOR SHOT-IN-EYE CHECK // // // // //
		
	//admin logs
	if(!no_attack_log)
		if(istype(firer, /mob) && istype(target_mob))
			add_attack_logs(firer,target_mob,"Shot with \a [src.type] projectile")

	//sometimes bullet_act() will want the projectile to continue flying
	if (result == PROJECTILE_CONTINUE)
		return 0

	return 1

/obj/item/projectile/bullet/reusable/air_rifle_bb/handle_drop()
	if(!dropped)
		if(prob(drop_chance))		//if you win the bullet lottery, have a new bullet
			new ammo_type(src.loc)
		else
			new /obj/item/ammo_casing/spent/mangled_bb(src.loc)		//defined below
		dropped = TRUE

//Mangled, non-reusable BB. Technically not a bullet, but here for ease of organization.
/obj/item/ammo_casing/spent/mangled_bb		
	name = "mangled BB"
	caliber = "unusable"
	desc = "A dented piece of zinc-coated steel airgun shot."
	description_info = "This won't reload into your air rifle, but it can be recycled at an autolathe for a tiny amount of metal."
	icon = 'modular_aeiou/icons/obj/projectile_aeiou.dmi'
	icon_state = "bb-steel"
	sharp = FALSE
	matter = list(DEFAULT_WALL_MATERIAL = 10)
