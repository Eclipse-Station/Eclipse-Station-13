#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/dryingrack
	name = T_BOARD("dryingrack")
	build_path = /obj/machinery/smartfridge/drying_rack
	board_type = new /datum/frame/frame_types/machine
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	req_components = list(
							/obj/item/weapon/stock_parts/gear = 2,
							/obj/item/weapon/stock_parts/micro_laser = 1)
