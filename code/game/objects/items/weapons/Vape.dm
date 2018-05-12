///////////////
//VAPE NATION//
///////////////
/obj/item/clothing/mask/vape
	name = "\improper E-Cigarette"
	desc = "A classy and highly sophisticated electronic cigarette, for classy and dignified gentlemen. A warning label reads \"Warning: Do not fill with flammable materials.\""//<<< i'd vape to that.
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = null
	item_state = null
	flags = CONDUCT
	w_class = ITEMSIZE_TINY
	var/chem_volume = 100
	var/vapetime = 0 //this so it won't puff out clouds every tick
	var/screw = 0 // kinky
	var/super = 0 //for the fattest vapes dude.
	var/emagged = 0


/*
/mob/proc/custom_emote(var/m_type=1,var/message = null,var/range=world.view)
	if(stat || !use_me && usr == src)
		src << "You are unable to emote."
		return

	var/muzzled = is_muzzled()
	if(m_type == 2 && muzzled) return
*/


/obj/item/clothing/mask/vape/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is puffin hard on dat vape, [user] is trying to join the vape life on a whole notha plane!</span>")//it doesn't give you cancer, it is cancer
	return (TOXLOSS|OXYLOSS)


/obj/item/clothing/mask/vape/proc/Initialize(mapload, param_color)
	. = ..()
	create_reagents(chem_volume)
	flags |= NOREACT // so it doesn't react until you light it
	reagents.add_reagent("nicotine", 50)
	if(!icon_state)
		if(!param_color)
			param_color = pick("red","blue","black","white","green","purple","yellow","orange")
		icon_state = "[param_color]_vape"
		item_state = "[param_color]_vape"

/obj/item/clothing/mask/vape/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/weapon/reagent_containers))
		if(reagents.total_volume < chem_volume)
			if(O.reagents.total_volume > 0)
				O.reagents.trans_to(src,25)
				to_chat(user, "<span class='notice'>You add the contents of [O] to [src].</span>")
			else
				to_chat(user, "<span class='warning'>[O] is empty!</span>")
		else
			to_chat(user, "<span class='warning'>[src] can't hold anymore reagents!</span>")

	if(istype(O, /obj/item/screwdriver))
		if(!screw)
			screw = 1
			to_chat(user, "<span class='notice'>You open the cap on [src].</span>")
			if(super)
				add_overlay("vapeopen_med")
			else
				add_overlay("vapeopen_low")
		else
			screw = 0
			to_chat(user, "<span class='notice'>You close the cap on [src].</span>")
			cut_overlays()

	if(istype(O, /obj/item/device/multitool))
		if(screw && !emagged)//also kinky
			if(!super)
				cut_overlays()
				super = 1
				to_chat(user, "<span class='notice'>You increase the voltage of [src].</span>")
				add_overlay("vapeopen_med")
			else
				cut_overlays()
				super = 0
				to_chat(user, "<span class='notice'>You decrease the voltage of [src].</span>")
				add_overlay("vapeopen_low")

		if(screw && emagged)
			to_chat(user, "<span class='notice'>[src] can't be modified!</span>")


/obj/item/clothing/mask/vape/emag_act(mob/user)// I WON'T REGRET WRITTING THIS, SURLY.
	if(screw)
		if(!emagged)
			cut_overlays()
			emagged = TRUE
			super = 0
			to_chat(user, "<span class='warning'>You maximize the voltage of [src].</span>")
			add_overlay("vapeopen_high")
			var/datum/effect/effect/system/spark_spread/sparks/sp = new /datum/effect/effect/system/spark_spread //for effect
		else
			to_chat(user, "<span class='warning'>[src] is already emagged!</span>")
	else
		to_chat(user, "<span class='notice'>You need to open the cap to do that.</span>")

/obj/item/clothing/mask/vape/attack_self(mob/user)
	if(reagents.total_volume > 0)
		to_chat(user, "<span class='notice'>You empty [src] of all reagents.</span>")
		reagents.clear_reagents()
	return

/obj/item/clothing/mask/vape/equipped(mob/user, slot)
	if(slot == slot_wear_mask)
		if(!screw)
			to_chat(user, "<span class='notice'>You start puffing on the vape.</span>")
			reagents.set_reacting(TRUE)
			flags &= ~NOREACT
		else //it will not start if the vape is opened.
			to_chat(user, "<span class='warning'>You need to close the cap first!</span>")

/obj/item/clothing/mask/vape/dropped(mob/user)
	var/mob/living/carbon/C = user
	if(C.get_item_by_slot(slot_wear_mask) == src)
		reagents.set_reacting(FALSE)
//		STOP_PROCESSING(SSobj, src)
		flags |= NOREACT



/obj/item/clothing/mask/vape/proc/hand_reagents()//had to rename to avoid duplicate error
	if(reagents.total_volume)
		if(iscarbon(loc))
			var/mob/living/carbon/C = loc
			if (src == C.wear_mask) // if it's in the human/monkey mouth, transfer reagents to the mob
				var/fraction = min(REAGENTS_METABOLISM/reagents.total_volume, 1) //this will react instantly, making them a little more dangerous than cigarettes
				reagents.reaction(C, CHEM_INGEST, fraction)
				if (src == C.wear_mask && C.check_has_mouth()) // if it's in the human/monkey mouth, transfer reagents to the mob
					reagents.trans_to_mob(C, REM, CHEM_INGEST, 0.4)
				if(reagents.get_reagent_amount("welding_fuel"))
					//HOT STUFF
					C.fire_stacks = 2
					C.IgniteMob()
				if(reagents.get_reagent_amount("plasma")) // the plasma explodes when exposed to fire
					var/datum/effect/effect/system/reagents_explosion/e = new()
					e.set_up(round(reagents.get_reagent_amount("plasma") / 2.5, 1), get_turf(src), 0, 0)
					e.start()
					qdel(src)
				return
		reagents.remove_any(REAGENTS_METABOLISM)
//		reagents.trans_to_mob(C, REM, CHEM_INGEST)

/obj/item/clothing/mask/vape/process()
	var/mob/living/M = loc

	if(isliving(loc))
		M.IgniteMob()

	vapetime++

	if(!reagents.total_volume)
		if(ismob(loc))
			to_chat(M, "<span class='notice'>[src] is empty!</span>")
		return
	//open flame removed because vapes are a closed system, they wont light anything on fire

	if(super && vapetime > 3)//Time to start puffing those fat vapes, yo.
		var/datum/effect_system/smoke_spread/chem/s = new
		s.set_up(reagents, 1, loc, silent=TRUE)
		spark_system.start()
		vapetime = 0




	if(emagged && vapetime > 3)
//		var/datum/effect_system/smoke_spread/chem/s = new
//		s.set_up(reagents, 4, loc, silent=TRUE)
//		spark_system.start()
		vapetime = 0
		if(prob(5))//small chance for the vape to break and deal damage if it's emagged
			playsound(get_turf(src), 'sound/effects/pop_expl1.ogg', 50, 0)
			M.apply_damage(20, BURN, "head")
			M.Weaken(300, 1, 0)
//			var/datum/effect/effect/system/spark_spreadsp = new /datum/effect/effect/system/spark_spread
			var/datum/effect/effect/system/spark_spread/g = new /datum/effect/effect/system/spark_spread
			g.set_up(3, 1, src)
			g.start()
			new /obj/effect/decal/cleanable/ash(src.loc)
			src.visible_message("<span class='warning'>The [src.name] explodes!</span>","<span class='warning'>You hear a snap!</span>")
//			playsound(src, 'sound/effects/snap.ogg', 50, 1)
			qdel(src)
//			sp.set_up(5, 1, src)
//			spark_system.start()
			to_chat(M, "<span class='userdanger'>[src] suddenly explodes in your mouth!</span>")
//			qdel(src)
			return

	if(reagents && reagents.total_volume)
		hand_reagents()


/*
var/datum/effect/effect/system/spark_spread/spark_system = new ()
				spark_system.set_up(5, 0, src)
				spark_system.attach(src)
				spark_system.start()
				spawn(10)
					qdel(spark_system)
					*/