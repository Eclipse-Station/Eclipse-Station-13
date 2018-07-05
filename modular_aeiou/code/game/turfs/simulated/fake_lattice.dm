/*
/turf/simulated/floor/water
	name = "shallow water"
	desc = "A body of water.  It seems shallow enough to walk through, if needed."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "seashallow" // So it shows up in the map editor as water.
	var/water_state = "water_shallow"
	var/under_state = "rock"
	edge_blending_priority = -1
	movement_cost = 4
	outdoors = TRUE
	var/depth = 1 // Higher numbers indicates deeper water.

/turf/simulated/floor/water/initialize()
	. = ..()
	update_icon()

// /obj/structure/lattice
*/