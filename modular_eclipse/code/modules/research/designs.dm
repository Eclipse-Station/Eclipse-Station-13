/datum/design/item/medical/gelsuit
	name = "Adaptive gel suit design"
	desc = "Based on Carnifex technology, this membranous substance envelops the wearer's body and drastically lowers oxygen intake, while also providing protection from airborne hazards."
	id = "gelsuit"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 3, TECH_DATA = 3) //relatively easy to aquire in case a crewmember loses their. Somehow.
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 4000)
	build_path = /obj/item/clothing/suit/gelsuit
	sort_string = "Eclipse"

/datum/design/item/medical/gelsuit_deluxe
	name = "Advanced adaptive gel suit design"
	desc = "Based on suits, worn by Carnifex ambassadors, this substance provides far more protection from enviromental hazards, than its standard counterpart, while reducing oxygen intake even more."
	id = "gelsuit_deluxe"
	req_tech = list(TECH_BIO = 6, TECH_MATERIAL = 5, TECH_DATA = 5, TECH_ENGINEERING = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000, "uranium" = 4000, "diamond" = 2000)
	build_path = /obj/item/clothing/suit/gelsuit/deluxe
	sort_string = "AEIOV"