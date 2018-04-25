/*
//	AEIOU's general loadout items go here
*/

/datum/gear/tennis
	display_name = "tennisball selection"
	path = /obj/item/toy/tennis

/datum/gear/tennis/New()
	..()
	var/list/tennisballs = list()
	for(var/tennis in typesof(/obj/item/toy/tennis))
		var/obj/item/toy/tennis/tennis_type = tennis
		tennisballs[initial(tennis_type.name)] = tennis_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(tennisballs))