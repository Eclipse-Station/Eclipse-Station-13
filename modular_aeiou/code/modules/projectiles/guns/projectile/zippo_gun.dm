/* The Zippo Gun, a concealed BrASS (break-action single shot) handgun. Can hold
 * a single round of ammo, intended to be clunky as hell to reload. Probably a
 * decent idea to leave it as like a holdout gun or a traitor weapon. You get a
 * single, strong shot... but only one shot, so make it count.
 */

/obj/item/weapon/gun/projectile/zippo_gun
	name = "\improper Zippo gun"
	desc = "The zippo, but it's a gun. Fires 9mm rounds."		//We Are Number One, but it's a shitty desc comment
	var/concealed_name = "\improper Zippo lighter"
	var/concealed_desc = "The zippo. Something feels off about this one, though..."
	var/name_override = FALSE		//prevents the name from changing when concealed/revealed.
	var/desc_override = FALSE
	icon = 'modular_aeiou/icons/obj/zippo_gun.dmi'
	icon_state = "zippogun"
	item_state = "zippo"
	var/finish = "steel"		//gold, silver, etc/ Future implementation.
	caliber = "9mm"
	handle_casings = CYCLE_CASINGS
	load_method = SINGLE_CASING
	accuracy = -15		//effectively 1 tile farther for accuracy calculations
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a9mm
	projectile_type = /obj/item/projectile/bullet/pistol/strong
	var/chamber_exposed = FALSE
	var/concealed = FALSE		//currently unused
	description_info = "This is a ballistic weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire. This is a break-action single-shot weapon. After you shoot, you will need to reload the gun by clicking on it \
	in your hand to expose the chamber and remove the round, insert another bullet, and click on it again in your hand to close the chamber and ready \
	it for firing."
	description_antag = "This can be concealed by using the 'Fold/Unfold Zippo' command in the 'Objects' tab."
	var/concealed_desc_info = null
	item_icons = list()		//This makes it look like a Zippo in your hands. (Caveat: Even when the gun is deployed)

/obj/item/weapon/gun/projectile/zippo_gun/New()
	. = ..()
	consume_next_projectile()
	
/obj/item/weapon/gun/projectile/zippo_gun/examine(mob/user)
	hide_ammo_count = concealed		//If we're concealed, we don't want to show the ammo left. That'd be a huge tell
	..(user)		//continue as planned.

	
/obj/item/weapon/gun/projectile/zippo_gun/verb/conceal()
	set name = "Fold/Unfold Zippo"
	set category = "Object"
	set src in usr
	toggle_concealed(usr)

/obj/item/weapon/gun/projectile/zippo_gun/update_icon()		//and name, and desc...
	if(concealed)
		icon_state = "[initial(icon_state)]-[finish]-concealed"
		description_info = concealed_desc_info
		
		if(!name_override)
			name = concealed_name
		if(!desc_override)
			desc = concealed_desc
	else
		icon_state = "[initial(icon_state)]-[finish]"
		description_info = initial(description_info)
		
		if(!name_override)
			name = initial(name)
		if(!desc_override)
			desc = initial(desc)

/obj/item/weapon/gun/projectile/zippo_gun/attack_self(mob/user as mob)
	if(!concealed)		//if the gun is unfolded, then open and close the breech
		if(!chamber_exposed)
			to_chat(user, "<span class='notice'>You open the breech on [src], [chambered ? "ejecting the casing and " : ""]allowing you to reload.</span>")
			if(chambered)
				chambered.loc = get_turf(src)
				chambered = null
			if(loaded.len)
				var/obj/item/shot = loaded[1]
				loaded -= shot
				shot.loc = get_turf(src)
			chamber_exposed = TRUE
			return 1
		else 
			if(loaded.len)
				to_chat(user, "<span class='notice'>You close the breech, allowing you to fire.</span>")
				var/obj/item/ammo_casing/C = loaded[1]
				chambered = C
				loaded -= C
			else
				to_chat(user, "<span class='notice'>You close the breech, leaving the gun empty.</span>")
			chamber_exposed = FALSE
	else	//if the gun is folded, unfold it.
		toggle_concealed()
	
	add_fingerprint(user)

/obj/item/weapon/gun/projectile/zippo_gun/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(concealed)
			user.put_in_hands(src)
		else if(!chamber_exposed)		//chamber will be exposed if it's concealed.
			to_chat(user, "<span class='warning'>You cannot unload the gun while the breech is closed.</span>")
		else
			return ..()
	else
		return ..()

/obj/item/weapon/gun/projectile/zippo_gun/proc/toggle_concealed(mob/living/user)
	if(!isliving(user))		//necessary for item_is_in_hands below
		to_chat(user, "<span class='notice'>You do not have the dexterity to fold or unfold [src].</span>")
		return FALSE
	else
		if(!user.item_is_in_hands(src))
			to_chat(user, "<span class='notice'>You need to have [src] in your hands to fold or unfold it.</span>")
			return FALSE
		if(user.incapacitated())
			to_chat(user, "<span class='notice'>You cannot fold or unfold [src] in your current state.</span>")
			return FALSE

		if(!concealed)		//gun is unfolded, so conceal it
			if(!chamber_exposed)
				to_chat(user, "<span class='notice'>You need to open the breech of [src] in order to be able to fold it.</span>")
				return FALSE
			else		//chamber is exposed, so start to conceal the weapon
				if (do_after(user, 40))
					concealed = TRUE
					to_chat(user, "<span class='notice'>You fold the [src], making it look like an ordinary lighter.</span>")
					update_icon()
					return TRUE
				else		//user moved or cancelled
					to_chat(user, "<span class='notice'>The pieces of [src] fall back into their original place.</span>")
					
		else	//gun is concealed, so unfold it.
			if(!chamber_exposed)		//somehow the chamber isn't exposed. log it as an error and fix it
				error("[src] held by [user] at location [x], [y], [z]: Attempted toggle_concealed() where concealed == TRUE but chamber_exposed == FALSE. Attempting to correct error.")
				log_error("[src] held by [user] at location [x], [y], [z]: Attempted toggle_concealed() where concealed == TRUE but chamber_exposed == FALSE. Attempting to correct...")
				chamber_exposed = TRUE
				ASSERT(chamber_exposed)	//If the chamber is still not exposed for some reason, crash the proc
				
/* Normally I would put more code here telling the previous check to run through
 * all the checks again. However, if the errored part of the proc gets this far,
 * this means the ASSERT(chamber_exposed) check did not evaluate to FALSE, and  
 * thus it did not crash. This means we can proceed as planned, since the error 
 * was able to correct itself properly.
 */
			if (do_after(user, 40))
				concealed = FALSE
				to_chat(user, "<span class='notice'>You unfold the [src], revealing the barrel and trigger.</span>")
				update_icon()
				return TRUE

/obj/item/weapon/gun/projectile/zippo_gun/special_check(mob/user)
	if(chamber_exposed)
		to_chat(user, "<span class='notice'>You can't fire [src] with the breech open!</span>")
		return 0
	if(concealed)
		to_chat(user, "<span class='notice'>You'll need to unfold [src] to fire it!</span>")
		return 0
	return ..()

/obj/item/weapon/gun/projectile/zippo_gun/load_ammo(var/obj/item/A, mob/user)
	if(!chamber_exposed)
		to_chat(user, "<span class='notice'>You can't load [src] without opening the breech.</span>")
		return
	..()