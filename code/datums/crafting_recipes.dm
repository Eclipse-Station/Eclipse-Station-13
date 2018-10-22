//////////////////////////////////////
//                                  //
//     ~*  E X A M P L E S  *~      //
//                                  //
//////////////////////////////////////

/datum/crafting_recipe/table/stunprod
	name = "Stunprod"
	result_path = list(/obj/item/weapon/melee/baton/cattleprod)
	reqs = list(/obj/item/weapon/handcuffs/cable = 1,
	/obj/item/stack/rods = 1)
	time = 80
//	tools = list(/obj/item/weapon/wirecutters)



/datum/crafting_recipe/upgrader/upgradetaser
	name = "Upgraded xenotaser"
	result_path = list(/obj/item/weapon/gun/energy/taser)
	reqs = list(/obj/item/weapon/gun/energy/taser/xeno = 1,
	/obj/item/weapon/stock_parts/capacitor/adv = 1, /obj/item/weapon/stock_parts/micro_laser/high = 1)
	time = 40
//	tools = list(/obj/item/weapon/screwdriver, /obj/item/crafting/blueprint/dexenotaser, /obj/item/device/integrated_electronics/wirer)
	can_be_deconstructed = 1


/datum/crafting_recipe/upgrader/overcharge
	name = "Overcharged sizegun"
	result_path = list(/obj/item/weapon/gun/energy/sizegun/overcharged)
	reqs = list(/obj/item/weapon/gun/energy/sizegun = 1,
	/obj/item/weapon/cell = 1,
	/obj/item/weapon/ore/bluespace_crystal = 3)
	time = 40
//	tools = list(/obj/item/weapon/screwdriver, /obj/item/crafting/blueprint/sizegunovercharge)


//////////////////////////////////////////////////////	///
//FOOD//

/datum/crafting_recipe/table/food/sandwich
	name = "Finaly, some good fucking food"
	result_path = list(/obj/item/weapon/reagent_containers/food/snacks/sandwich)
	reqs = list(
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread = 2
	)
	time = 10
	tools = list(/obj/item/clothing/head/chefhat)






/////////////////////////////////////////////////////


//blueprints

/obj/item/crafting/blueprint
	name = "Crafting blueprint"
	desc = "This shouldn't be here. Nestor fucked up again."
	icon = 'icons/obj/items.dmi'
	icon_state = "blueprints"
	var/recipe = "Sugar, spice and everything nice."

/obj/item/crafting/blueprint/attack_self(mob/M as mob)
	if (!istype(M,/mob/living/carbon/human))
		M << "This stack of blue paper means nothing to you." //monkeys cannot into crafting
		return
	M << "[recipe]"
	return

/obj/item/crafting/blueprint/sizegunovercharge
	name = "overcharged sizegun blueprint"
	desc = "You have a bad feeling about this."
	recipe = "3 bluespace crystals, 1 sizegun, 1 power cell. Tools: screwdriver."

/obj/item/crafting/blueprint/dexenotaser
	name = "xeno taser upgrade schematics"
	desc = "Now we're talking."
	recipe = "1 xeno taser, 1 advanced capacitor, 1 high-power microlaser. Tools: screwdriver, circuit wirer."