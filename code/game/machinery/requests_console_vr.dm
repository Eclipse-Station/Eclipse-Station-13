// Request Console Presets!  Make mapping 400% easier!
// By using these presets we can rename the departments easily.

//Request Console Department Types
// #define RC_ASSIST 1		//Request Assistance
// #define RC_SUPPLY 2		//Request Supplies
// #define RC_INFO   4		//Relay Info

// // // BEGIN ECLIPSE EDITS // // //
// Adjustments for our codebase needs.
// // // ECLIPSE EDITS CONTINUE TO #EOF!

/obj/machinery/requests_console/preset
	name = ""
	department = ""
	departmentType = ""
	announcementConsole = 0

// Departments
/obj/machinery/requests_console/preset/cargo
	name = "Cargo RC"
	department = "Cargo Bay"
	departmentType = RC_SUPPLY
	
/obj/machinery/requests_console/preset/cargo/mining
	name = "Mining RC"
	department = "Mining"
	departmentType = RC_SUPPLY		//redundancy

/obj/machinery/requests_console/preset/security
	name = "Security RC"
	department = "Security"
	departmentType = RC_ASSIST|RC_INFO

/obj/machinery/requests_console/preset/engineering
	name = "Engineering RC"
	department = "Engineering"
	departmentType = RC_ASSIST|RC_SUPPLY

/obj/machinery/requests_console/preset/atmos
	name = "Atmospherics RC"
	department = "Atmospherics"
	departmentType = RC_ASSIST|RC_SUPPLY

/obj/machinery/requests_console/preset/medical
	name = "Medical RC"
	department = "Medical Department"
	departmentType = RC_ASSIST|RC_SUPPLY

/obj/machinery/requests_console/preset/research
	name = "Research RC"
	department = "Research Department"
	departmentType = RC_ASSIST|RC_SUPPLY

/obj/machinery/requests_console/preset/janitor
	name = "Janitor RC"
	department = "Janitorial"
	departmentType = RC_ASSIST

/obj/machinery/requests_console/preset/bridge
	name = "Bridge RC"
	department = "Bridge"
	departmentType = RC_ASSIST|RC_INFO
	announcementConsole = 1

//Base Head-of-staff define
/obj/machinery/requests_console/preset/heads
	departmentType = RC_INFO
	announcementConsole = 1

//Heads of staff

/obj/machinery/requests_console/preset/heads/ce
	name = "Chief Engineer RC"
	department = "Chief Engineer's Desk"

/obj/machinery/requests_console/preset/heads/cmo
	name = "Chief Medical Officer RC"
	department = "Chief Medical Officer's Desk"

/obj/machinery/requests_console/preset/heads/hos
	name = "Head of Security RC"
	department = "Head of Security's Desk"

/obj/machinery/requests_console/preset/heads/rd
	name = "Research Director RC"
	department = "Research Director's Desk"

/obj/machinery/requests_console/preset/heads/hop
	name = "Head of Personnel RC"
	department = "Head of Personnel's Desk"

/obj/machinery/requests_console/preset/heads/captain
	name = "Station Director RC"
	department = "Station Director's Desk"

/obj/machinery/requests_console/preset/ai
	name = "AI RC"
	department = "AI"
	departmentType = RC_INFO
