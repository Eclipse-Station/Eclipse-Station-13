/obj/machinery/pdapainter
	name = "\improper PDA painter"
	desc = "A PDA painting machine. To use, simply insert your PDA and choose the desired preset paint scheme."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pdapainter"
	density = 1
	var/obj/item/device/pda/storedpda = null
	var/list/colorlist = list()


/obj/machinery/pdapainter/update_icon()
	cut_overlays()

	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
		return

	if(storedpda)
		add_overlay("[initial(icon_state)]-closed")

	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

	return

/obj/machinery/pdapainter/initialize()
	. = ..()
	var/list/blocked = list(
		/obj/item/device/pda/heads,
		/obj/item/device/pda/clear,
		/obj/item/device/pda/syndicate)

	for(var/P in typesof(/obj/item/device/pda) - blocked)
		var/obj/item/device/pda/D = new P

		//D.name = "PDA Style [colorlist.len+1]" //Gotta set the name, otherwise it all comes up as "PDA"
		D.name = D.icon_state //PDAs don't have unique names, but using the sprite names works.

		src.colorlist += D

/obj/machinery/pdapainter/Destroy()
	if(storedpda)
		storedpda.forceMove(loc)
		storedpda = null
	qdel_null(storedpda)
	return ..()

/obj/machinery/pdapainter/attackby(obj/item/O, mob/user, params)
	if(default_unfasten_wrench(user, O))
		power_change()
		return

	else if(istype(O, /obj/item/device/pda))
		if(storedpda)
			to_chat(user, "<span class='warning'>There is already a PDA inside!</span>")
			return
		storedpda = O
		O.add_fingerprint(user)
		update_icon()

	else
		return ..()

/obj/machinery/pdapainter/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	if(storedpda)
		var/obj/item/device/pda/P
		P = input(user, "Select your color!", "PDA Painting") as null|anything in colorlist
		if(!P)
			return
		if(!in_range(src, user))
			return
		if(!storedpda)//is the pda still there?
			return
		storedpda.icon_state = P.icon_state
		storedpda.desc = P.desc
		ejectpda()

	else
		to_chat(user, "<span class='notice'>[src] is empty.</span>")


/obj/machinery/pdapainter/verb/ejectpda()
	set name = "Eject PDA"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || usr.restrained() || !usr.canmove)
		return

	if(storedpda)
		storedpda.forceMove(drop_location())
		storedpda = null
		update_icon()
	else
		to_chat(usr, "<span class='notice'>[src] is empty.</span>")


/obj/machinery/pdapainter/power_change()
	..()
	update_icon()
