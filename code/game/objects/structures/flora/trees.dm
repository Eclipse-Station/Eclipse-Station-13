//trees
/obj/structure/flora/tree
	name = "tree"
	anchored = 1
	density = 1
	pixel_x = -16
	plane = MOB_PLANE // You know what, let's play it safe.
	layer = ABOVE_MOB_LAYER
	var/base_state = null	// Used for stumps.
	var/health = 200		// Used for chopping down trees.
	var/max_health = 200
	var/shake_animation_degrees = 4	// How much to shake the tree when struck.  Larger trees should have smaller numbers or it looks weird.
	var/obj/item/stack/material/product = null	// What you get when chopping this tree down.  Generally it will be a type of wood.
	var/product_amount = 10 // How much of a stack you get, if the above is defined.
	var/is_stump = FALSE // If true, suspends damage tracking and most other effects.

/obj/structure/flora/tree/attackby(var/obj/item/weapon/W, var/mob/living/user)
	if(!istype(W))
		return ..()

	if(is_stump)
		if(istype(W,/obj/item/weapon/shovel))
			if(do_after(user, 5 SECONDS))
				visible_message("<span class='notice'>\The [user] digs up \the [src] stump with \the [W].</span>")
				qdel(src)
		return

	visible_message("<span class='danger'>\The [user] hits \the [src] with \the [W]!</span>")

	var/damage_to_do = W.force
	if(!W.sharp && !W.edge)
		damage_to_do = round(damage_to_do / 4)
	if(damage_to_do > 0)
		if(W.sharp && W.edge)
			playsound(get_turf(src), 'sound/effects/woodcutting.ogg', 50, 1)
		else
			playsound(get_turf(src), W.hitsound, 50, 1)
		if(damage_to_do > 5)
			adjust_health(-damage_to_do)
		else
			to_chat(user, "<span class='warning'>\The [W] is ineffective at harming \the [src].</span>")

	hit_animation()
	user.setClickCooldown(user.get_attack_speed(W))
	user.do_attack_animation(src)

// Shakes the tree slightly, more or less stolen from lockers.
/obj/structure/flora/tree/proc/hit_animation()
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	animate(src, transform=turn(matrix(), shake_animation_degrees * shake_dir), pixel_x=init_px + 2*shake_dir, time=1)
	animate(transform=null, pixel_x=init_px, time=6, easing=ELASTIC_EASING)

// Used when the tree gets hurt.
/obj/structure/flora/tree/proc/adjust_health(var/amount, var/damage_wood = FALSE)
	if(is_stump)
		return

	// Bullets and lasers ruin some of the wood
	if(damage_wood && product_amount > 0)
		var/wood = initial(product_amount)
		product_amount -= round(wood * (abs(amount)/max_health))

	health = between(0, health + amount, max_health)
	if(health <= 0)
		die()
		return

// Called when the tree loses all health, for whatever reason.
/obj/structure/flora/tree/proc/die()
	if(is_stump)
		return

	if(product && product_amount) // Make wooden logs.
		var/obj/item/stack/material/M = new product(get_turf(src))
		M.amount = product_amount
		M.update_icon()
	visible_message("<span class='danger'>\The [src] is felled!</span>")
	stump()

// Makes the tree into a mostly non-interactive stump.
/obj/structure/flora/tree/proc/stump()
	if(is_stump)
		return

	is_stump = TRUE
	density = FALSE
	icon_state = "[base_state]_stump"
	overlays.Cut() // For the Sif tree and other future glowy trees.
	set_light(0)

/obj/structure/flora/tree/ex_act(var/severity)
	adjust_health(-(max_health / severity), TRUE)

/obj/structure/flora/tree/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		adjust_health(-Proj.get_structure_damage(), TRUE)

/obj/structure/flora/tree/tesla_act(power, explosive)
	adjust_health(-power / 100, TRUE) // Kills most trees in one lightning strike.
	..()

/obj/structure/flora/tree/get_description_interaction()
	var/list/results = list()

	if(!is_stump)
		results += "[desc_panel_image("hatchet")]to cut down this tree into logs.  Any sharp and strong weapon will do."

	results += ..()

	return results

// Subtypes.

// Pine trees

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	base_state = "pine"
	product = /obj/item/stack/material/log
	shake_animation_degrees = 3

/obj/structure/flora/tree/pine/New()
	..()
	icon_state = "[base_state]_[rand(1, 3)]"


/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/pine/xmas/New()
	..()
	icon_state = "pine_c"

// Palm trees

/obj/structure/flora/tree/palm
	icon = 'icons/obj/flora/palmtrees.dmi'
	icon_state = "palm1"
	base_state = "palm"
	product = /obj/item/stack/material/log
	product_amount = 5
	health = 200
	max_health = 200
	pixel_x = 0

/obj/structure/flora/tree/palm/New()
	..()
	icon_state = "[base_state][rand(1, 2)]"


// Dead trees

/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"
	base_state = "tree"
	product = /obj/item/stack/material/log
	product_amount = 5
	health = 200
	max_health = 200

/obj/structure/flora/tree/dead/New()
	..()
	icon_state = "[base_state]_[rand(1, 6)]"

// Small jungle trees

/obj/structure/flora/tree/jungle_small
	icon = 'icons/obj/flora/jungletreesmall.dmi'
	icon_state = "tree"
	base_state = "tree"
	product = /obj/item/stack/material/log
	product_amount = 10
	health = 400
	max_health = 400
	pixel_x = -32

/obj/structure/flora/tree/jungle_small/New()
	..()
	icon_state = "[base_state][rand(1, 6)]"

// Big jungle trees

/obj/structure/flora/tree/jungle
	icon = 'icons/obj/flora/jungletree.dmi'
	icon_state = "tree"
	base_state = "tree"
	product = /obj/item/stack/material/log
	product_amount = 20
	health = 800
	max_health = 800
	pixel_x = -48
	pixel_y = -16
	shake_animation_degrees = 2

/obj/structure/flora/tree/jungle/New()
	..()
	icon_state = "[base_state][rand(1, 6)]"

// Sif trees

/obj/structure/flora/tree/sif //AEIOU edit. The tree gives you tap.
	name = "glowing tree"
	desc = "It's a tree, except this one seems quite alien.  It glows a deep blue."
	icon = 'modular_aeiou/icons/obj/flora/deadtrees_aeiou.dmi'
//	icon_state = "tree_sif1"
//	base_state = "tree_sif1"
	product = /obj/item/stack/material/log/sif
	var/obj/item/weapon/t_t = null
	var/tap = 0 //Actually a variable used to start production or stop it. - AEIOU
	var/sap = 1 //The actual liquid. Trees aren't reagents containers so i hacked this quickly.
	var/max_sap = 15
	var/sap_amount = 0 //placeholder
	var/sap_type = 1//this is a sort of variable used for appearance and reagent selection.
	var/debug_glow = 0//to remove


/obj/structure/flora/tree/sif/attackby(var/obj/item/weapon/I, var/mob/user)
	if(istype(I, /obj/item/weapon/reagent_containers/))
		if(!tap)
			user << "<span class='notice'>There is no tap in \the [src].</span>"
			return
		if(!sap && tap)
			user << "<span class='notice'>There is no sap in \the [src].</span>"
			return
		if(sap && tap)
			if(sap_type == 1)
				var/obj/item/weapon/reagent_containers/G = I//phoron and myelamine internal bleeding sap.
				var/transferred = min(G.reagents.maximum_volume - G.reagents.total_volume, sap)
				sap -= transferred
				G.reagents.add_reagent("phoron", transferred)//badly done yeah. Ideally, you would have a list of reagents to pull from then to add.
				G.reagents.add_reagent("bluesap", transferred)
				sap_amount = transferred * 2
				user.visible_message("<span class='notice'>[user] collects [sap_amount] from \the [src] into \the [G].</span>", "<span class='notice'>You collect [sap_amount] units of sap from \the [src] into \the [G].</span>")
				return 1
			if(sap_type == 2)
				var/obj/item/weapon/reagent_containers/G = I //Long lasting brute healer.
				var/transferred = min(G.reagents.maximum_volume - G.reagents.total_volume, sap)
				sap -= transferred
				G.reagents.add_reagent("phoron", transferred)
				G.reagents.add_reagent("purplesap", transferred)
				sap_amount = transferred * 2
				user.visible_message("<span class='notice'>[user] collects [sap_amount] from \the [src] into \the [G].</span>", "<span class='notice'>You collect [sap_amount] units of sap from \the [src] into \the [G].</span>")
				return 1
			if(sap_type == 3)
				var/obj/item/weapon/reagent_containers/G = I
				var/transferred = min(G.reagents.maximum_volume - G.reagents.total_volume, sap)
				sap -= transferred
				G.reagents.add_reagent("phoron", transferred)
				G.reagents.add_reagent("orangesap", transferred)
				sap_amount = transferred * 2
				user.visible_message("<span class='notice'>[user] collects [sap_amount] from \the [src] into \the [G].</span>", "<span class='notice'>You collect [sap_amount] units of sap from \the [src] into \the [G].</span>")
				return 1

	if(istype(I, /obj/item/weapon/tree_tap))
		if(!tap)
			user.drop_item()
			I.loc = src
			t_t = I
			user << "<span class='notice'>You install a tap in [src].</span>"
			tap = 1
			produce_sap()
		else
			user << "<span class='notice'>[src] already has a tap.</span>"
		return 1

	visible_message("<span class='danger'>\The [user] hits \the [src] with \the [I]!</span>")

	var/damage_to_do = I.force
	if(!I.sharp && !I.edge)
		damage_to_do = round(damage_to_do / 4)
	if(damage_to_do > 0)
		if(I.sharp && I.edge)
			playsound(get_turf(src), 'sound/effects/woodcutting.ogg', 50, 1)
		else
			playsound(get_turf(src), I.hitsound, 50, 1)
		if(damage_to_do > 5)
			adjust_health(-damage_to_do)
		else
			to_chat(user, "<span class='warning'>\The [I] is ineffective at harming \the [src].</span>")

	hit_animation()
	user.setClickCooldown(user.get_attack_speed(I))
	user.do_attack_animation(src)

/obj/structure/flora/tree/sif/attack_hand(mob/user as mob)
	if(tap == 1)
		user.put_in_hands(t_t)
		t_t = null
		user << "<span class='notice'>You remove the tap from [src].</span>"
		tap = 0
		return

/obj/structure/flora/tree/sif/proc/produce_sap()
	if(tap)
		sap = (sap + 0.05)
		return

/obj/structure/flora/tree/sif/process()
	produce_sap()

/obj/structure/flora/tree/sif/examine(mob/user)
	if(!..(user, 1))
		return
	if(tap)
		user <<"<span class='notice'>[src] has a tap wedged in.</span>"
	if(!tap)
		user <<"<span class='notice'>[src] looks health and normal.</span>"

/*	if(sap_type == 1)//Debug stuff. Don't turn on.
		user <<"<span class='notice'>[src] 1</span>"
	if(sap_type == 2)
		user <<"<span class='notice'>[src] 2</span>"
	if(sap_type == 3)
		user <<"<span class='notice'>[src] 3</span>"
*/


/*
/obj/structure/flora/tree/sif/New()
	update_icon()
	..()
	processing_objects |= src
*/

/obj/structure/flora/tree/sif/New()
	sap_type = rand(1,3)
//	..()
//	processing_objects |= src
	if(sap_type == 1)//Phoron & Alien sap for myelamine
		icon_state = "tree_sif1"
		desc = "It's a tree, except this one seems quite alien.  It glows a deep blue."
	if(sap_type == 2)//purple sap
		icon_state = "tree_sif2"
		desc = "It's a tree, except this one seems quite alien.  It glows a deep violet."
	if(sap_type == 3)//third sap
		icon_state = "tree_sif3"
		desc = "It's a tree, except this one seems quite alien.  It glows a low brownish orange."
//	else
//		icon_state = "tree_sif"
	update_icon()
	processing_objects |= src
	

/obj/structure/flora/tree/sif/update_icon()
	if(sap_type == 1)
		set_light(5, 1, "#33ccff")//basic sap
	if(sap_type == 2)
		set_light(5, 1, "#7a48a0")//Purple sap
	if(sap_type == 3)
		set_light(5, 1, "#e9955c")//third sap
	var/image/glow = image(icon = 'modular_aeiou/icons/obj/flora/deadtrees_aeiou.dmi', icon_state = "[icon_state]_glow")
	glow.plane = PLANE_LIGHTING_ABOVE
	debug_glow = glow
	overlays = list(glow)
