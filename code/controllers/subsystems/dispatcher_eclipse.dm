/datum/controller/subsystem
	// Metadata; you should define these.
	name = "Dispatch" //name of the subsystem
	var/init_order = INIT_ORDER_DEFAULT	//order of initialization. Higher numbers are initialized first, lower numbers later. Can be decimal and negative values.
	var/flags = SS_BACKGROUND
	var/runlevels = RUNLEVELS_DEFAULT

	//set to 0 to prevent fire() calls, mostly for admin use or subsystems that may be resumed later
	//	use the SS_NO_FIRE flag instead for systems that never fire to keep it from even being added to the list
	var/can_fire = TRUE