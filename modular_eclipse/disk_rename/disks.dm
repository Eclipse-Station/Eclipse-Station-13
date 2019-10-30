/obj/item/weapon/disk
	var/can_rename = TRUE

/obj/item/weapon/disk/attackby(P as obj, mob/user as mob)
	if (istype(P, /obj/item/weapon/pen))
		if(can_rename)
			var/t = input(user, "What would you like to write on the label?", text("[]", src.name), null)  as text
			if (user.get_active_hand() != P)
				return
			if ((!in_range(src, usr) && src.loc != user))
				return
			t = sanitizeSafe(t, MAX_NAME_LEN)
			if (t)
				src.name = text("[initial(name)]- '[]'", t)
			else
				src.name = initial(name)
		else
			to_chat(user, "<span class='warning'>The ink is just going to smear off the label if you try to write on it.</span>")
		src.add_fingerprint(user)
	else
		..()

/obj/item/weapon/disk/nuclear		//No hiding the nuke diskette!
	can_rename = FALSE

/obj/item/weapon/disk/nifsoft		//Probably would have those crappy laminate labels as well
	can_rename = FALSE

/obj/item/weapon/disk/transcore		//Nope.
	can_rename = FALSE