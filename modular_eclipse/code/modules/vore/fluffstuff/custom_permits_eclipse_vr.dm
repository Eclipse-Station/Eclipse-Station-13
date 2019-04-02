/*/obj/item/clothing/accessory/permit/gun/fluff
	owner = 1 // These permits already have owners.
	desc = "A card indicating that the owner is allowed to carry a firearm/sidearm. It is issued by CentCom, so it is valid until it expires. This one is just a sample, so it belongs to no one."

/obj/item/clothing/accessory/permit/gun/fluff/emag_act(var/remaining_charges, var/mob/user)
	to_chat(user, "You cannot reset the naming locks on [src]. It's issued by CentCom and totally tamper-proof!")
	return
	*/				//AEIOU Edit: Commented out to avoid duplicates while allowing easy template access
// chatter:Sycamore Irons
/obj/item/clothing/accessory/permit/gun/fluff/sycamore_irons
	name = "Sycamore Irons' Sidearm Permit"
	desc = "A card indicating that the owner is allowed to carry a sidearm. It is issued by CentCom, so it is valid until it expires on February 16th, 2564."