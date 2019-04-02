/datum/gear/uniform/ripped //This is Crak ripped suits
	display_name = "Ripped jumpsuits (Vox)"
	path = /obj/item/clothing/under/vox/ripped
	whitelisted = "Vox"
	sort_category = "Xenowear"

/datum/gear/uniform/ripped/New()
	..()
	var/list/rippeds = list()
	for(var/ripped in typesof(/obj/item/clothing/under/vox/ripped))
		var/obj/item/clothing/under/vox/ripped/ripped_type = ripped
		rippeds[initial(ripped_type.name)] = ripped_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(rippeds))