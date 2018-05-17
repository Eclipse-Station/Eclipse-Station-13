/datum/supply_packs/med/medicalbiosuits
	contains = list(
			/obj/item/clothing/head/bio_hood/scientist = 3,
			/obj/item/clothing/suit/bio_suit/scientist = 3,
			/obj/item/clothing/suit/bio_suit/virology = 3,
			/obj/item/clothing/head/bio_hood/virology = 3,
			/obj/item/clothing/suit/bio_suit/cmo,
			/obj/item/clothing/head/bio_hood/cmo,
			/obj/item/clothing/shoes/white = 7,
			/obj/item/clothing/mask/gas = 7,
			/obj/item/weapon/tank/oxygen = 7,
			/obj/item/weapon/storage/box/masks,
			/obj/item/weapon/storage/box/gloves
			)
	cost = 40

/datum/supply_packs/med/virologybiosuits
	name = "Virology biohazard gear"
	contains = list(
			/obj/item/clothing/suit/bio_suit/virology = 3,
			/obj/item/clothing/head/bio_hood/virology = 3,
			/obj/item/clothing/mask/gas = 3,
			/obj/item/weapon/tank/oxygen = 3,
			/obj/item/weapon/storage/box/masks,
			/obj/item/weapon/storage/box/gloves
			)
	cost = 40
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Virology biohazard equipment"
	access = access_medical_equip

/datum/supply_packs/med/pillbottles
	name = "Pill bottles"
	contains = list(
			/obj/item/weapon/storage/box/pillbottles = 3
			)
	cost = 30
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Medical Pill bottles"
	access = access_medical_equip