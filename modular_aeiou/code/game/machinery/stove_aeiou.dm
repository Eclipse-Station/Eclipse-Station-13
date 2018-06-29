/obj/machinery/stove
	name = "gas stove"
	desc = "An old looking gas stove. It looks like something out of a grandmother home."
	icon_state = "fryer_off"
	var/on_icon = "fryer_on"
	var/off_icon = "fryer_off"
	var/cooking_start_sound ='sound/machines/stove.ogg'
	var/cooked_sound = 'sound/machines/ding.ogg'

	var/heat_temp = 0				// What is the temperature. It can be off, low, medium or high. 0 1 2 3
	var/cooking						// Whether or not the machine is currently operating.
	var/obj/item/pan				// Holder for the currently cooking object.
	var/list/stove_temperature_setting = list("low", "medium" ,"high")


/obj/machinery/stove/examine()
	..()
	if(pan && Adjacent(usr))
		usr << "You can see \a [pan] inside."

/obj/machinery/stove/verb/turn_on()
	set name = "Turn on the stove."
	set category = "Object"
	set src in oview(1)

	playsound(usr.loc, 'sound/machines/stove.ogg', 75, 1)
	heat_temp = 0

/obj/machinery/stove/verb/turn_off()
	set name = "Turn off the stove."
	set category = "Object"
	set src in oview(1)

	heat_temp = 0 //off

/obj/machinery/stove/verb/change_heat()
    set name = "Set Temperature"
    set category = "Object"
    set src in view(1)
    var/N = input(usr, "Current Stove temp: [heat_temp]") as null|anything in stove_temperature_setting
    if (N)
        heat_temp = N
        to_chat(usr, "The shower has been turned to [heat_temp]")
        return
    else
        return