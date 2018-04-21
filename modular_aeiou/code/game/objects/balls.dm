/*
//	BALLS - GLORIOUS BALLS
//
//	All sorts of balls exclusive to AEIOU go here!
*/

/obj/item/toy/tennis
	name = "classic tennis ball"
	desc = "A classic tennis ball. It appears to have faint bite marks scattered all over its surface."
	icon = 'modular_aeiou/icons/obj/balls.dmi'
	icon_state = "tennis_classic"
	item_icons = list(
		slot_l_hand_str = 'modular_aeiou/icons/mob/inhands/balls_left.dmi',
		slot_r_hand_str = 'modular_aeiou/icons/mob/inhands/balls_right.dmi'
		)
	item_state_slots = list(slot_r_hand_str = "tennis_classic", slot_l_hand_str = "tennis_classic")
	item_state = "tennis_classic"
	slot_flags = SLOT_MASK | SLOT_HEAD | SLOT_EARS	//FLUFF ITEM - Doesn't matter where it goes
	icon_override = 'modular_aeiou/icons/mob/mouthball.dmi'
	w_class = ITEMSIZE_SMALL
	attack_verb = list("squished", "squashed", "hit")

/obj/item/toy/tennis/rainbow	//admemespawn only
	name = "pseudo-euclidean interdimensional tennis sphere"
	desc = "A tennis ball from another plane of existance. Really groovy."
	icon_state = "tennis_rainbow"
	item_state = "tennis_rainbow"
	hitsound = 'sound/items/bikehorn.ogg'
	var/spam_flag = 0

/obj/item/toy/tennis/rainbow/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

/obj/item/toy/tennis/red	//da red wuns go fasta
	name = "red tennis ball"
	desc = "A red tennis ball. It goes three times faster!"
	icon_state = "tennis_red"
	item_state = "tennis_red"
	item_state_slots = list(slot_r_hand_str = "tennis_red", slot_l_hand_str = "tennis_red")
	throw_speed = 12

/obj/item/toy/tennis/yellow	//because yellow is hot I guess
	name = "yellow tennis ball"
	desc = "A yellow tennis ball. It seems to have an ablative coating."
	icon_state = "tennis_yellow"
	item_state = "tennis_yellow"
	item_state_slots = list(slot_r_hand_str = "tennis_yellow", slot_l_hand_str = "tennis_yellow")
	pressure_resistance = 10

/obj/item/toy/tennis/green	//pestilence
	name = "green tennis ball"
	desc = "A green tennis ball. It seems to have an impermeable coating."
	icon_state = "tennis_green"
	item_state = "tennis_green"
	item_state_slots = list(slot_r_hand_str = "tennis_green", slot_l_hand_str = "tennis_green")
	permeability_coefficient = 0.9

/obj/item/toy/tennis/cyan	//electric
	name = "cyan tennis ball"
	desc = "A cyan tennis ball. It seems to have odd electrical properties."
	icon_state = "tennis_cyan"
	item_state = "tennis_cyan"
	item_state_slots = list(slot_r_hand_str = "tennis_cyan", slot_l_hand_str = "tennis_cyan")
	siemens_coefficient = 0.9

/obj/item/toy/tennis/blue	//reliability
	name = "blue tennis ball"
	desc = "A blue tennis ball. It seems ever so slightly more capable than regular balls."
	icon_state = "tennis_blue"
	item_state = "tennis_blue"
	item_state_slots = list(slot_r_hand_str = "tennis_blue", slot_l_hand_str = "tennis_blue")
	throw_range = 40

/obj/item/toy/tennis/purple	//because purple does... things
	name = "purple tennis ball"
	desc = "A purple tennis ball. It seems to have an acid-resistant coating."
	icon_state = "tennis_purple"
	item_state = "tennis_purple"
	item_state_slots = list(slot_r_hand_str = "tennis_purple", slot_l_hand_str = "tennis_purple")
	gas_transfer_coefficient = 0.9