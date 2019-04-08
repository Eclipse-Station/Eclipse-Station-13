/decl/flooring/reinforced/eclipse
	name = "processing strata"
	icon = 'modular_eclipse/icons/turf/simulated/floor/grids.dmi'
	icon_base = "coff"
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	can_paint = 1

/decl/flooring/reinforced/eclipse/purplegrid
	name = "processing strata"
	icon_base = "cpurple"

/decl/flooring/reinforced/eclipse/redgrid
	name = "processing strata"
	icon_base = "cred"

/decl/flooring/reinforced/eclipse/whitegrid
	name = "processing strata"
	icon_base = "cwhite"

/decl/flooring/carpet/eclipse
	name = "office carpet"
	icon = 'modular_eclipse/icons/turf/simulated/floor/carpets.dmi'
	icon_base = "office_carpet"
	build_type = /obj/item/stack/tile/carpet/eclipse

/decl/flooring/carpet/eclipse/arcade
	name = "arcade carpet"
	icon_base = "arcade_carpet"
	build_type = /obj/item/stack/tile/carpet/eclipse/arcade

//tiles
/obj/item/stack/tile/carpet/eclipse
	icon_state = "tile-carpet"

/obj/item/stack/tile/carpet/eclipse/arcade
	icon_state = "tile-carpet"