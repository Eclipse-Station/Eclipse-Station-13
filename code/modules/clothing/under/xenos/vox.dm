/obj/item/clothing/under/vox
	has_sensor = 0
	species_restricted = list(SPECIES_VOX)
	starting_accessories = list(/obj/item/clothing/accessory/storage/vox)	// Dont' start with a backback, so free webbing
	flags = PHORONGUARD

/obj/item/clothing/under/vox/vox_casual
	name = "alien clothing"
	desc = "This doesn't look very comfortable."
	icon_state = "vox-casual-1"
	item_state = "vox-casual-1"
	body_parts_covered = LEGS

/obj/item/clothing/under/vox/vox_robes
	name = "alien robes"
	desc = "Weird and flowing!"
	icon_state = "vox-casual-2"
	item_state = "vox-casual-2"


//Vox Accessories
/obj/item/clothing/accessory/storage/vox
	name = "alien mesh"
	desc = "An alien mesh. Seems to be made up mostly of pockets and writhing flesh."
	icon_state = "webbing-vox"

	flags = PHORONGUARD

	slots = 3

/obj/item/clothing/accessory/storage/vox/New()
	..()
	hold.max_storage_space = slots * ITEMSIZE_COST_NORMAL
	hold.max_w_class = ITEMSIZE_NORMAL


/obj/item/clothing/under/vox/ripped
	name = "Grey Ripped Jumpsuit"
	desc = "A jumpsuit that looks like it's been shredded by some talons. Who could wear this now?"
	icon = 'icons/obj/clothing/species/vox/uniforms.dmi'
	icon_state = "vgrey"
	item_state = "vgrey"

/obj/item/clothing/under/vox/ripped/robotics
	name = "Vox Robotics Jumpsuit"
	desc = "A roboticist's jumpsuit ripped to better fit a vox."
	icon_state = "vrobotics"
	item_state = "vrobotics"

/obj/item/clothing/under/vox/ripped/toxins
	name = "Vox Toxins Jumpsuit"
	desc = "A Toxin Researcher's jumpsuit ripped to better fit a vox."
	icon_state = "vtoxinswhite"
	item_state = "vtoxinswhite"

/obj/item/clothing/under/vox/ripped/atmos
	name = "Vox Atmos Jumpsuit"
	desc = "An Atmos Tech's jumpsuit ripped to better fit a vox."
	icon_state = "vatmos"
	item_state = "vatmos"

/obj/item/clothing/under/vox/ripped/engi
	name = "Vox Engineer Jumpsuit"
	desc = "An Engineer's jumpsuit ripped to better fit a vox."
	icon_state = "vengine"
	item_state = "vengine"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 10)

/obj/item/clothing/under/vox/ripped/sec
	name = "Vox Security Jumpsuit"
	desc = "A Security officer's jumpsuit ripped to better fit a vox."
	icon_state = "vred"
	item_state = "vred"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/vox/ripped/chem
	name = "Vox Chemist Jumpsuit"
	desc = "A Chemist's jumpsuit ripped to better fit a vox."
	icon_state = "vchem"
	item_state = "vchem"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/vox/ripped/jani
	name = "Vox Janitor Jumpsuit"
	desc = "A Janitor's jumpsuit ripped to better fit a vox."
	icon_state = "vjani"
	item_state = "vjani"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)