/datum/gear/uniform/voxcasual
	display_name = "casual wear (Vox)"
	path = /obj/item/clothing/under/vox/vox_casual
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/uniform/voxrobes
	display_name = "comfy robes (Vox)"
	path = /obj/item/clothing/under/vox/vox_robes
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/accessory/vox
	display_name = "storage vest (Vox)"
	path = /obj/item/clothing/accessory/storage/vox
	sort_category = "Xenowear"
	whitelisted = "Vox"


/datum/gear/gloves/vox
	display_name = "insulated gauntlets (Vox)"
	path = /obj/item/clothing/gloves/vox
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/shoes/vox
	display_name = "magclaws (Vox)"
	path = /obj/item/clothing/shoes/magboots/vox
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/mask/vox
	display_name = "alien mask (Vox)"
	path = /obj/item/clothing/mask/gas/swat/vox
	sort_category = "Xenowear"
	whitelisted = "Vox"

/datum/gear/uniform/loincloth
	display_name = "loincloth"
	path = /obj/item/clothing/suit/storage/fluff/loincloth
	sort_category = "Xenowear"

/datum/gear/uniform/ripped
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