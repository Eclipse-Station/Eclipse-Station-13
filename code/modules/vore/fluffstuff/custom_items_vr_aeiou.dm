/* TUTORIAL
	"icon" is the file with the HUD/ground icon for the item
	"icon_state" is the iconstate in this file for the item
	"icon_override" is the file with the on-mob icons, can be the same file (Except for glasses, shoes, and masks.)
	"item_state" is the iconstate for the on-mob icons:
		item_state_s is used for worn uniforms on mobs
		item_state_r and item_state_l are for being held in each hand

	"item_state_slots" can replace "item_state", it is a list:
		item_state_slots["slotname1"] = "item state for that slot"
		item_state_slots["slotname2"] = "item state for that slot"
*/

/* TEMPLATE
//ckey:Character Name
/obj/item/weapon/fluff/charactername
	name = ""
	desc = ""

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "myicon"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "myicon"

*/
//AEIOU Edit: This .dm and the respective .dmi are to be used for items specific to AEIOUStation to avoid confusion and synchronization issues.

//Pixelexip:Casey Hall
/obj/item/clothing/glasses/sunglasses/fluff/clout
	name = "clout goggles"
	desc = "These ain't glasses, baby. These CLOUT GOGGLES."
	icon = 'modular_aeiou/icons/obj/custom_items_vr_aeiou.dmi'
	icon_state = "clout_goggles"

	icon_override = 'modular_aeiou/icons/obj/custom_clothes_vr_aeiou.dmi'
	item_state = "clout_goggles"
	item_state_slots = list(slot_r_hand_str = "sun", slot_l_hand_str = "sun")

//Amenity Kitten: Valere
/obj/item/weapon/reagent_containers/food/drinks/flask/infinite
    name = "infinite coffee thermos"
    desc = "For when you really, really enjoy coffee."
    icon = 'modular_aeiou/icons/obj/custom_items_vr_aeiou.dmi'
    icon_state = "coffeetherm"
    var/spawning_id


/obj/item/weapon/reagent_containers/food/drinks/flask/infinite/New()
    ..()
    processing_objects.Add(src)

/obj/item/weapon/reagent_containers/food/drinks/flask/infinite/process()
    reagents.add_reagent("coffee", 1)
