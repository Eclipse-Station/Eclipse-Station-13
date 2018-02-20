//////////////////////////////////////
//                                  //
//     ~*  E X A M P L E S  *~      //
//                                  //
//////////////////////////////////////

/datum/crafting_recipe/table/stunprod
	name = "Stunprod"
	result_path = /obj/item/weapon/melee/baton/cattleprod
	reqs = list(/obj/item/weapon/handcuffs/cable = 1,
	/obj/item/stack/rods = 1)
	time = 80
	tools = list(/obj/item/weapon/wirecutters)

/datum/crafting_recipe/upgrader/upgradetaser
	name = "Upgraded xenotaser"
	result_path = /obj/item/weapon/gun/energy/taser
	reqs = list(/obj/item/weapon/gun/energy/taser/xeno = 1,
	/obj/item/weapon/stock_parts/capacitor/adv = 1, /obj/item/weapon/stock_parts/micro_laser/high = 1)
	time = 40
	tools = list(/obj/item/weapon/screwdriver, /obj/item/crafting/blueprint/dexenotaser, /obj/item/device/integrated_electronics/wirer)


/datum/crafting_recipe/upgrader/overcharge
	name = "Overcharged sizegun"
	result_path = /obj/item/weapon/gun/energy/sizegun/overcharged
	reqs = list(/obj/item/weapon/gun/energy/sizegun = 1,
	/obj/item/weapon/cell = 1,
	/obj/item/weapon/ore/bluespace_crystal = 1, /obj/item/weapon/ore/bluespace_crystal = 1, /obj/item/weapon/ore/bluespace_crystal = 1)
	time = 40
	tools = list(/obj/item/weapon/screwdriver, /obj/item/crafting/blueprint/sizegunovercharge)


/////////////////////////////////////////////////////////