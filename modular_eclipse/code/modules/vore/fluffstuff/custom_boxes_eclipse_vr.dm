/*// BEGIN - DO NOT EDIT PROTOTYPE
/obj/item/weapon/storage/box/fluff
	name = "Undefined Fluff Box"
	desc = "This should have a description. Tell an admin."
	storage_slots = 7
	var/list/has_items = list()

/obj/item/weapon/storage/box/fluff/New()
	storage_slots = has_items.len
	allowed = list()
	for(var/P in has_items)
		allowed += P
		new P(src)
	..()
	return
// END - DO NOT EDIT PROTOTYPE		//AEIOU Edit: Above section commented out to avoid duplicates, but it stays so you can read it without checking the other file over and over
*/
									//AEIOU Edit: This is where boxes of specific equipment should go to avoid desynchronization issues

/* TEMPLATE
// ckey:Character Name
/obj/item/weapon/storage/box/fluff/charactername
	name = ""
	desc = ""
	has_items = list(
		/obj/item/clothing/head/thing1,
		/obj/item/clothing/shoes/thing2,
		/obj/item/clothing/suit/thing3,
		/obj/item/clothing/under/thing4)
*/

// chatter:Sycamore Irons
/obj/item/weapon/storage/box/fluff/sycamore_irons
	name = "Sycamore's Kit"
	desc = "A box carrying Sycamore Irons' alloted self-defense weapon and permit."
	has_items = list(
		/obj/item/weapon/gun/energy/gun,
		/obj/item/clothing/accessory/permit/gun/fluff/sycamore_irons)