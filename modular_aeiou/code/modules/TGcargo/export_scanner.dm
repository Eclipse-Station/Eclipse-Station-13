/obj/item/device/export_scanner
	name = "export scanner"
	desc = "A device used to check objects against Nanotrasen exports database."
	icon_state = "export_scanner"
	item_state = "radio"
	icon = 'modular_aeiou/icons/obj/TGcargo.dmi'
//	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
//	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	flags = NOBLUDGEON
	w_class =  ITEMSIZE_SMALL
	siemens_coefficient = 1
//	var/obj/machinery/computer/cargo/cargo_console = null
	var/obj/machinery/computer/supplycomp/cargo_console = null

/obj/item/device/export_scanner/examine(user)
	..()
	if(!cargo_console)
		to_chat(user, "<span class='notice'>[src] is not currently linked to a cargo console.</span>")

/obj/item/device/export_scanner/afterattack(obj/O, mob/user, proximity)
	if(!istype(O) || !proximity)
		return

	if(istype(O, /obj/machinery/computer/supplycomp))
		var/obj/machinery/computer/supplycomp/C = O
		cargo_console = C
		to_chat(user, "<span class='notice'>Scanner linked to [O].</span>")
	else if(!istype(cargo_console))
		to_chat(user, "<span class='warning'>You must link [src] to a cargo console first!</span>")
	else
		// Before you fix it:
		// yes, checking manifests is a part of intended functionality.
		//var/price = export_item_and_contents(O, cargo_console.contraband, cargo_console.emagged, dry_run=TRUE)
		var/price = export_item_and_contents(O, cargo_console.contraband, dry_run=TRUE)

		if(price)
			to_chat(user, "<span class='notice'>Scanned [O], value: <b>[price]</b> credits[O.contents.len ? " (contents included)" : ""].</span>")
		else
			to_chat(user, "<span class='warning'>Scanned [O], no export value.</span>")
