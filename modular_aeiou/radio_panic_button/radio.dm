// code/game/objects/items/devices/radio/radio.dm
//TODO TODO TODO: Clean up activation code and forced toggle code.

/obj/item/device/radio
	action_button_name = "Toggle Emergency Function"		//helpful icon at top of screen.
	var/can_toggle_emergency_mode = TRUE		//Can the panic function be toggled?
	var/panic_enabled = FALSE
	var/panic_mode_will_turn_off_speaker = TRUE
	
	//Storage variables.
	var/panic_prev_frequency
	var/panic_speaker_state
	var/panic_mic_state
	var/panic_frequency_lock = FALSE		//Is the frequency locked because of us?

/obj/item/device/radio/ui_action_click()
	begin_panic_alarm_checks(usr)

/obj/item/device/radio/verb/emergency()
	set name = "Toggle Emergency Function"
	set category = "Object"
	set src in usr
	
	
	begin_panic_alarm_checks(usr)		//Whether or not we can activate it will be checked in the checks.



//Panic alarm proc. Called when someone toggles the emergency function on their radio.
/obj/item/device/radio/proc/begin_panic_alarm_checks(mob/user)
	//Null check - if the user doesn't exist, we've got problems.
	if(!user)
		user = usr
		
	//Null checks.
	ASSERT(user)	//null check, so if there wasn't a usr it doesn't break things.
	ASSERT(src)

	if(!can_toggle_emergency_mode)		//can we even toggle it?
		to_chat(user, "<span class='warning'>This radio does not have an emergency function you can activate.</span>")
		return FALSE

	if(!(ishuman(user) || issilicon(user)))		//ghosts, simplemobs, etc
		to_chat(user, "<span class='warning'>You lack the required dexterity to toggle \the [src]'s panic function.</span>")
		return FALSE

	if(user.stat != CONSCIOUS)		//are we unconscious or dead?
		to_chat(user, "<span class='warning'>You cannot activate \the [src]'s panic function in your current state.</span>")
		return FALSE

	if(user.incapacitated() & INCAPACITATION_DISABLED)		//If you are knocked down but conscious, stunned, or knocked out.
	// NOTE: Restraints (e.g. handcuffed) are intentionally left out of this check!
		to_chat(user, "<span class='warning'>You cannot activate \the [src]'s panic function in your current state.</span>")
		return FALSE

// All the checks have either passed or been bypassed so far, so we definitely CAN use the panic button.

	if(user.incapacitated() & INCAPACITATION_DEFAULT)	//if we are restrained or fully buckled, it'll be a little bit harder to use our panic button.
		user.visible_message("<span class='warning'>[user] begins to reach for [src].</span>","<span class='notice'>You begin reaching for the panic button on [src].</span>")		//Give the hostage taker a chance to stop us.
		if(do_after(user, 5 SECONDS, incapacitation_flags = INCAPACITATION_DISABLED))
			toggle_panic_alarm(user, TRUE, FALSE)
			return TRUE
		else		//you were moved, so sad...
			to_chat(user,"<span class='warning'>You fail to activate \the [src]'s emergency function.</span>")
			return null	//for proc feedback

	else		//we're not under arrest, so we get to go ahead and just press the damn thing.
		toggle_panic_alarm(user, TRUE, FALSE)
		return TRUE


//This is down here so I can neatly call it from above without some serious restructuring
/obj/item/device/radio/proc/toggle_panic_alarm(mob/user, sanity_checks_pass = FALSE, admin_called = TRUE)
	if(!sanity_checks_pass)
		/* 
		 *Okay, I'm going to go off on a tangent for a second here. This proc
		 * has NO sanity checks whatsoever. Therefore, we need to check and see
		 * if the proper sanity checks have already been performed. If they were
		 * not, then either the proc was called directly by admin intervention,
		 * or by a faulty passthrough. The admin_called parameter is only used 
		 * to tell if an adminstrator called the proc directly, and tell them
		 * not to do that.
		 */
		if(admin_called)		//This was never unset, so we assume admin intervention.
			//give feedback to the admin trying
			message_admins("[key_name_admin(usr)] - operating on \"[src]\" at ([loc.x], [loc.y], [loc.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>): it is dangerous to call toggle_panic_alarm() directly, use force_panic_alarm() instead")		//If you are reading this because you tried to call the proc directly: Please don't.


			//log to console.
			CRASH("[usr] attempted to call proc toggle_panic_alarm() directly")
		else
			CRASH("[src] at [loc.x], [loc.y], [loc.z]: Sanity checks did not complete before this proc was called")

	if(wires.IsIndexCut(WIRE_TRANSMIT) || wires.IsIndexCut(WIRE_SIGNAL) || wires.IsIndexCut(WIRE_RECEIVE))		//all our wires gotta be intact, yo.
		to_chat(user, "<span class='warning'>\icon[src] Nothing happens...</span>")
		return FALSE

	panic_enabled = !panic_enabled		//toggle panic alarm
	to_chat(user, "<span class='notice'>You [panic_enabled ? "activate" : "deactivate"] \the [src]'s emergency function.</span>")
	message_admins("[key_name_admin(user)] [panic_enabled ? "activated" : "deactivated"] radio panic alarm at ([loc.x],[loc.y],[loc.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)")
	log_game("[key_name(user)]: Radio panic alarm [panic_enabled ? "activated" : "deactivated"] at ([loc.x],[loc.y],[loc.z]) on radio (\ref[src] \"[src]\").")

	if(panic_enabled)		//We're now enabled.
		//First things first, let's store our old frequency, mic and speaker states so we can recall them later.
		panic_prev_frequency = frequency	//frequency
		panic_speaker_state = listening		//speaker state
		panic_mic_state = broadcasting		//mic state
		

		//now let's shut off our speaker, in case we're already on the panic alarm channel, so as not to tip off our assailants, and then broadcast a warning to those listening in that we're in trouble.
		if(panic_mode_will_turn_off_speaker)
			listening = FALSE
		
		//Now that our assailant can't hear us (even if we're not on the right channel), we tell everyone what's up.
		global_announcer.autosay("Radio emergency function activated by [user] in [get_area(src)]. Microphone is now hot.", "[src]", "Emergency")
		

		//We also want to check and see if the frequency is locked. If not, we should lock it and make a note somewhere that we were the ones to lock it.
		if(!freqlock)
			set_frequency(PANIC_FREQ)
			freqlock = TRUE
			panic_frequency_lock = TRUE
		else		//it's locked, so we need to unlock it, change it, and re-lock it
			freqlock = FALSE
			set_frequency(PANIC_FREQ)
			freqlock = TRUE
			panic_frequency_lock = FALSE	//a redundancy.
			
		broadcasting = TRUE			//Hotmike so emergency responders can hear what's going on around you, e.g. shouting

		return TRUE
	else		//We're now disabled.
		//Let everyone know the emergency has passed.

		global_announcer.autosay("Radio emergency function deactivated by [user].", "[src]", "Emergency")
		
		//recall our previous frequency, mic status, and speaker status.
		listening = panic_speaker_state
		broadcasting = panic_mic_state
		
		//Check if the frequency was locked because of us. If so, clear that flag and unlock it.
		if(freqlock)
			if(panic_frequency_lock)		//It's ours, unlock it.
				panic_frequency_lock = FALSE
				freqlock = FALSE
				set_frequency(panic_prev_frequency)
			else		//Not ours. Unlock, set back, and lock again.
				freqlock = FALSE
				set_frequency(panic_prev_frequency)
				freqlock = TRUE
		return TRUE
		


//Admin event-based panic alarm toggling.
/obj/item/device/radio/proc/force_panic_alarm(fake_name = "", fake_area = "")

	if(!fake_name)		//Prompt for a fake name.
		var/null_handler		//how do we want to handle a null fake_name?
		null_handler = alert(usr,"WARNING: You have not entered a parameter for the name of the person activating the panic alarm.\n\n How do you wish to handle this?",,"Use 'Unknown'","Enter a Name","Cancel")
		
		switch(null_handler)
			if("Cancel")
				to_chat(usr, "<span class='warning'>Proc force_panic_alarm() aborted: Cancelled by user.</span>")
				return FALSE
			if("Enter a Name")
				var/new_name = sanitize(input(usr,"Enter a name to be shown in the panic alarm functionality.","Input Name","John Doe") as text|null)
				if(!new_name)
					to_chat(usr, "<span class='warning'>Proc force_panic_alarm() aborted: Invalid name or cancelled by user.</span>")
					return FALSE
				else
					fake_name = new_name
			if("Use 'Unknown'")
				fake_name = "Unknown"
			else			//sanity check
				message_admins("[key_name_admin(usr)] - operating on \"[src]\" at ([loc.x], [loc.y], [loc.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>): invalid response to switch statement line 163. Expected: <\"Cancel\" | \"Enter a Name\" | \"Use 'Unknown'\">, got \"[null_handler]\"; crashing proc")		
				CRASH("Invalid response to switch statement. Expected: <\"Cancel\" | \"Enter a Name\" | \"Use 'Unknown'\">, got \"[null_handler]\".")

		
	if(!fake_area)
		var/area_handler		//How do we want to handle a null fake_area?
		area_handler = alert(usr,"WARNING: You have not entered a parameter for the area the panic alarm was activated at.\n\n How do you wish to handle this?",,"Use current location","Enter a Name","Cancel")
		switch(area_handler)
			if("Use current location")
				fake_area = get_area(src)
			if("Enter a Name")
				var/new_area = sanitize(input(usr,"Enter an area name to be shown in the panic alarm functionality.","Input Name","Space") as text|null)
				if(!new_area)
					to_chat(usr, "<span class='warning'>Proc force_panic_alarm() aborted: Invalid area name or cancelled by user.</span>")
					return FALSE
				else
					fake_area = new_area
			if("Cancel")
				to_chat(usr, "<span class='warning'>Proc force_panic_alarm() aborted: Cancelled by user.</span>")
				return FALSE
			else	//another sanity check
				message_admins("[key_name_admin(usr)] - operating on \"[src]\" at ([loc.x], [loc.y], [loc.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>): invalid response to switch statement line 184. Expected: <\"Cancel\" | \"Enter a Name\" | \"Use current location\">, got \"[area_handler]\"; crashing proc")		
				CRASH("Invalid response to switch statement. Expected: <\"Cancel\" | \"Enter a Name\" | \"Use current location\">, got \"[area_handler]\".")

	//at this point we should have a fake area and a fake person hitting the button.
	ASSERT(fake_name)
	ASSERT(fake_area)
	
	if(!can_toggle_emergency_mode)
		var/alarm_handler
		alarm_handler = alert(usr,"The radio you are attempting to force a panic alarm on cannot toggle the emergency function. Toggle anyway? Players will be unable to shut it off without admin interaction or varediting if you do not select 'Yes & Enable Toggle'.",,"Yes & Enable Toggle","Yes","No")
		switch(alarm_handler)
			if("No")
				to_chat(usr, "<span class='warning'>Proc force_panic_alarm() aborted: Cancelled by user.</span>")
			if("Yes & Enable Toggle")
				can_toggle_emergency_mode = TRUE
				action_button_name = "Toggle Emergency Function"

	//Now we actually toggle the fucker.
	panic_enabled = !panic_enabled		//toggle panic alarm

	message_admins("[key_name_admin(usr)] force-toggled (now [panic_enabled ? "ON" : "OFF"]) radio panic alarm at ([loc.x],[loc.y],[loc.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)")
	log_game("[key_name(usr)]: Force-toggled (now [panic_enabled ? "enabled" : "disabled"] panic alarm at ([loc.x],[loc.y],[loc.z]) on radio (\ref[src] \"[src]\").")


// // // // BEGIN COPY PASTE OF ABOVE

	if(panic_enabled)		//We're now enabled.
		//First things first, let's store our old frequency, mic and speaker states so we can recall them later.
		panic_prev_frequency = frequency	//frequency
		panic_speaker_state = listening		//speaker state
		panic_mic_state = broadcasting		//mic state
		

		//now let's shut off our speaker, in case we're already on the panic alarm channel, so as not to tip off our assailants, and then broadcast a warning to those listening in that we're in trouble.
		if(panic_mode_will_turn_off_speaker)
			listening = FALSE
		
		//Now that our assailant can't hear us (even if we're not on the right channel), we tell everyone what's up.
		global_announcer.autosay("Radio emergency function activated by [fake_name] in [fake_area]. Microphone is now hot.", "[src]", "Emergency")

		//We also want to check and see if the frequency is locked. If not, we should lock it and make a note somewhere that we were the ones to lock it.
		if(!freqlock)
			set_frequency(PANIC_FREQ)
			freqlock = TRUE
			panic_frequency_lock = TRUE
		else		//it's locked, so we need to unlock it, change it, and re-lock it
			freqlock = FALSE
			set_frequency(PANIC_FREQ)
			freqlock = TRUE
			panic_frequency_lock = FALSE	//a redundancy.
			
		broadcasting = TRUE			//Hotmike so emergency responders can hear what's going on around you, e.g. shouting
		return TRUE

	else		//We're now disabled.
		//Let everyone know the emergency has passed.

		global_announcer.autosay("Radio emergency function deactivated by [fake_name].", "[src]", "Emergency")
		
		//recall our previous frequency, mic status, and speaker status.
		listening = panic_speaker_state
		broadcasting = panic_mic_state
		
		//Check if the frequency was locked because of us. If so, clear that flag and unlock it.
		if(freqlock)
			if(panic_frequency_lock)		//It's ours, unlock it.
				panic_frequency_lock = FALSE
				freqlock = FALSE
				set_frequency(panic_prev_frequency)
			else		//Not ours. Unlock, set back, and lock again.
				freqlock = FALSE
				set_frequency(panic_prev_frequency)
				freqlock = TRUE
		return TRUE
		


// Headsets
// code/game/objects/items/devices/radio/headset.dm

/obj/item/device/radio/headset
	can_toggle_emergency_mode = FALSE		//regular headsets don't get a panic function.
	action_button_name = ""		//no panic alarm, so no helpful icon.
	panic_mode_will_turn_off_speaker = FALSE		//These get to hear what they broadcast, since they don't broadcast over many tiles.

/obj/item/device/radio/headset/heads/ai_integrated
	can_toggle_emergency_mode = FALSE		//AI has tons of channels it can scream on.
	action_button_name = ""

/obj/item/device/radio/intercom
	can_toggle_emergency_mode = FALSE		//Intercoms get no panic function, since players can be dragged away.
	action_button_name = ""		//See above.
	
// Borgs do not get a panic function.
/obj/item/device/radio/borg
	can_toggle_emergency_mode = FALSE
	action_button_name = ""// code/game/objects/items/devices/radio/radio.dm

// Headsets are a special case here. They can enable the panic alarm should they
// need to, but they lose the common channel since there's currently not a way
// to broadcast just to the panic channel without changing the frequency. So, we
// do just that. However, we don't lock out their speaker settings since they do
// not broadcast over distance like shortwave radios do. They'll be able to hear
// their own cries for help.


// Due to the nature of their job, sec officers, HoP, and CDir should have a
// panic function on their radios.

// Sec chases down criminals and are at risk of ambush. They are a higher-value
// target because they have (some) access to weaponry - mostly LTL.
/obj/item/device/radio/headset/headset_sec		//Rank-and-file officers
	can_toggle_emergency_mode = TRUE
	action_button_name = "Toggle Emergency Function"

/obj/item/device/radio/headset/heads/hos		//Head of Security
	can_toggle_emergency_mode = TRUE
	action_button_name = "Toggle Emergency Function"

// CDir is a high value target due to the nature of his job. His headset has
// access to all channels, his ID has access to the entire station, his room has
// a very powerful recharging gun capable of firing lethals.
/obj/item/device/radio/headset/heads/captain
	can_toggle_emergency_mode = TRUE
	action_button_name = "Toggle Emergency Function"

// HoP is a high value target due to the nature of his job. His ID console can 
// create IDs with CDir access, and he becomes the acting CDir should a need for
// one arise. He is also responsible for Ian's protection.
/obj/item/device/radio/headset/heads/hop
	can_toggle_emergency_mode = TRUE
	action_button_name = "Toggle Emergency Function"

// Admin spawned

// This is the admin spawned one. It can access every channel. Therefore, to 
// give the admins as much room to do what they need for story-telling, we'll 
// give it a panic alarm anyway. It acts like a regular panic alarm, though, and
// will still lock out the frequency adjusting.
/obj/item/device/radio/headset/omni
	can_toggle_emergency_mode = TRUE
	action_button_name = "Toggle Emergency Function"

// ERT and Centcomm headsets. They probably don't need it since they're checking
// on or saving your crew, but since they're admin spawned, we'll give 'em it
// anyways, just in case.
/obj/item/device/radio/headset/centcom
	can_toggle_emergency_mode = TRUE
	action_button_name = "Toggle Emergency Function"

// Nanotrasen representatives. They're a high value target, due to the fact that
// they're supposed to be corporate executives, and kidnapping or killing one
// would be a high-profile event that NT's competitors would love to capitalise
// on. Plus, admin spawned, so we'll give 'em one.
/obj/item/device/radio/headset/nanotrasen
	can_toggle_emergency_mode = TRUE
	action_button_name = "Toggle Emergency Function"
