// Organs.


// Alien organs
/datum/export/organ/alien/get_cost(O, contr = 0, emag = 0)
	. = ..()
	if(emag) // Syndicate really wants some new bio-weapons.
		. *= 2

/datum/export/organ/alien/acid
	cost = 5000
	unit_name = "alien acid gland"
	export_types = list(/obj/item/organ/internal/xenos/acidgland)

/datum/export/organ/alien/hivenode
	cost = 5000
	unit_name = "alien hive node"
	export_types = list(/obj/item/organ/internal/xenos/hivenode)


/datum/export/organ/alien/resinspinner
	cost = 5000
	unit_name = "alien resin spinner"

/datum/export/organ/alien/plasmavessel
	cost = 5000
	unit_name = "alien plasma vessel"
	export_types = list(/obj/item/organ/internal/xenos/plasmavessel)

/datum/export/organ/alien/plasmavessel/get_cost(obj/item/organ/internal/xenos/plasmavessel/P)
	return ..() + (P.max_plasma * 2)


/datum/export/organ/alien/embryo
	cost = 5000 // Allows buyer to set up his own alien farm.
	unit_name = "alien embryo"
	export_types = list(/obj/item/alien_embryo)

/datum/export/organ/alien/eggsac
	cost = 10000 // Even better than a single embryo.
	unit_name = "alien egg sac"
	export_types = list(/obj/item/organ/internal/xenos/eggsac)


// Human organs.

// Do not put human brains here, they are not sellable for a purpose.
// If they would be sellable, X-Porter cannon's finishing move (selling victim's organs) will be instakill with no revive.

/datum/export/organ/human
	contraband = TRUE
	include_subtypes = FALSE

/datum/export/organ/human/heart
	cost = 500
	unit_name = "heart"
	export_types = list(/obj/item/organ/internal/heart)

/datum/export/organ/human/lungs
	cost = 400
	unit_name = "pair"
	message = "of lungs"
	export_types = list(/obj/item/organ/internal/lungs)

/datum/export/organ/human/appendix
	cost = 50
	unit_name = "appendix"
	export_types = list(/obj/item/organ/internal/appendix)

/datum/export/organ/human/appendix/get_cost(obj/item/organ/internal/appendix/O)
	if(O.inflamed)
		return 0
	return ..()
