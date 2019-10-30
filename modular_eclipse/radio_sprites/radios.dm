// code/game/objects/items/devices/radio/radio.dm

//First, let's start out by defining the radio sprite to use the new sprite.
/obj/item/device/radio
	icon = 'modular_eclipse/radio_sprites/radios.dmi'		//This is overridden for intercoms and borg radios in another define, so we're good sticking this here.
	icon_state = "xpr-basic"
	desc = "A basic two-way radio."
	description_info = "Shortwave radios and intercoms can be used to communicate via the radio system when part or all of the telecommunications system is down. To talk into an intercom, you can turn on the intercom and talk like normal, or prefix your message with \":i\" to talk over it without turning on the microphone. To use a shortwave radio, you can turn on the microphone and talk like normal, or hold it in your hand and use \":l\" (if it's in your left hand) or \":r\" (if it's in your right hand) to talk over it without turning on the microphone.\
	<br>\
	<br>For most radios, you can change the channel the radio is transmitting on by using the radio in your hand, and clicking on the channel you wish to broadcast on. Some channels may be unavailable to you based on the access your ID has, and some radios and intercoms will not allow you to change the tuned frequency."

/obj/item/device/radio/color		//Accursed American English spellings...
	desc = "A basic two-way radio. This one in particular is a nondescript black."

	/* We are not adding pre-loaded channels here. Let them read from the user's
	 * ID card, or we'll probably run into weird channel access issues.
	 */

/obj/item/device/radio/color/interact(mob/user)		//calls for icon updating
	..()
	update_icon()

/obj/item/device/radio/color/ToggleBroadcast()
	..()
	update_icon()

/obj/item/device/radio/color/ToggleReception()
	..()
	update_icon()

/obj/item/device/radio/color/update_icon()		//Icon updating (for disabled radios)
	if(!(broadcasting || listening))		//if not broadcasting or listening
		icon_state = "[initial(icon_state)]-off"
	else
		icon_state = initial(icon_state)

//Now we define pre-colored radios.
/obj/item/device/radio/color/red		//Security
	icon_state = "xpr-sec"
	desc = "A basic two-way radio. This one in particular is robust red."

/obj/item/device/radio/color/brown		//Cargo and Supply
	icon_state = "xpr-cargo"
	desc = "A basic two-way radio. This one in particular is cardboard brown."

/obj/item/device/radio/color/yellow		//Engineering
	icon_state = "xpr-engi"
	desc = "A basic two-way radio. This one in particular is heavy-duty yellow."

/obj/item/device/radio/color/green		//CentComm
	icon_state = "xpr-centcomm"
	desc = "A basic two-way radio. This one in particular is a commanding green."

/obj/item/device/radio/color/navyblue		//Heads of Staff/CDir
	icon_state = "xpr-is"
	desc = "A basic two-way radio. This one in particular is royalty blue."

/obj/item/device/radio/color/lightblue		//Medical
	icon_state = "xpr-medic"
	desc = "A basic two-way radio. This one in particular is a sterile blue-and-white."

/obj/item/device/radio/color/lightblue/emergency		//Medbay emergency radio.
	name = "\improper Medbay Emergency Radio Link"
	icon = 'icons/obj/radio_vr.dmi' //We want to differentiate between the base radio and the emergency link, so we'll use the old sprite.
	icon_state = "med_walkietalkie"
	desc = "An emergency radio for quick, one-way contact with the medbay. This radio has been programmed with a frequency lock, which prevents it from changing channels."		//Short of admin intervention, anyway...
	frequency = 1487		//this is not defined anywhere, but it's the frequency the radios currently are set to use. Probably be a good idea to define them somewhere.
	freqlock = TRUE
	
/obj/item/device/radio/color/lightblue/emergency/update_icon()
	icon_state = initial(icon_state)		//No 'off' sprite. 

/obj/item/device/radio/color/purple		//Research
	icon_state = "xpr-sci"
	desc = "A basic two-way radio. This one in particular is an experimental purple."

// These are not redefined elsewhere, so we need to stick these here to prevent from breaking the sprites and giving out erroneous description information.
/obj/item/device/radio/headset
	icon = 'icons/obj/radio_vr.dmi'		//We redefined it above and it inherits in the file.
	description_info = "You can talk over the channel the radio is tuned to by prefixing your message with a semicolon. Usually, your radio is tuned to commons (145.9 GHz), but you can also tune to another channel for less-overt communications. Your radio may also have other channels if the proper encryption key is inserted. You can remove encryption keys by using a screwdriver on your headset.\
	<br>\
	→<br>Headsets rely on the telecommunications system being up in order to function, and will not function properly (or perhaps at all) when it's down. However, some radios have the ability to use ad-hoc fallback, allowing limited communications when telecommunications is down."		//It'll inherit the shortwave radio description info if we don't.