/obj/item/weapon/storage/briefcase/fission
	icon = 'icons/obj/machines/power/fission.dmi'
	name = "lead lined carrying case"
	desc = "It's made of AUTHENTIC sealed lead and has a trifoil tag attached. Should probably handle this one with care."
	icon_state = "carrycase"
	item_state_slots = list(slot_r_hand_str = "case", slot_l_hand_str = "case")

/obj/item/weapon/storage/briefcase/fission/uranium
	icon_state = "carrycaserad"
	starts_with = list(
		/obj/item/weapon/fuelrod/uranium,
		/obj/item/weapon/fuelrod/uranium,
		/obj/item/weapon/fuelrod/uranium,
		/obj/item/weapon/fuelrod/uranium
	)

/obj/item/weapon/storage/briefcase/fission/plutonium
	icon_state = "carrycaserad"
	starts_with = list(
		/obj/item/weapon/fuelrod/plutonium,
		/obj/item/weapon/fuelrod/plutonium,
		/obj/item/weapon/fuelrod/plutonium,
		/obj/item/weapon/fuelrod/plutonium
	)

/obj/item/weapon/storage/briefcase/fission/beryllium
	starts_with = list(
		/obj/item/weapon/fuelrod/beryllium,
		/obj/item/weapon/fuelrod/beryllium,
		/obj/item/weapon/fuelrod/beryllium,
		/obj/item/weapon/fuelrod/beryllium
	)

/obj/item/weapon/storage/briefcase/fission/tungstencarbide
	starts_with = list(
		/obj/item/weapon/fuelrod/tungstencarbide,
		/obj/item/weapon/fuelrod/tungstencarbide,
		/obj/item/weapon/fuelrod/tungstencarbide,
		/obj/item/weapon/fuelrod/tungstencarbide
	)

/obj/item/weapon/storage/briefcase/fission/silver
	starts_with = list(
		/obj/item/weapon/fuelrod/silver,
		/obj/item/weapon/fuelrod/silver,
		/obj/item/weapon/fuelrod/silver,
		/obj/item/weapon/fuelrod/silver
	)

/obj/item/weapon/storage/briefcase/fission/boron
	starts_with = list(
		/obj/item/weapon/fuelrod/boron,
		/obj/item/weapon/fuelrod/boron,
		/obj/item/weapon/fuelrod/boron,
		/obj/item/weapon/fuelrod/boron
	)