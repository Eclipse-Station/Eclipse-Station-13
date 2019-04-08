/obj/machinery/redspace_crystal
	name = "Crystal"
	desc = "A large solid clump of bluespace crystals. Which are red, for some reason."
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal"
	color = "#990000"
	density = TRUE
	anchored = TRUE

/obj/machinery/redspace_crystal/New()
	processing_objects += src
	..()


/obj/machinery/redspace_crystal/Destroy()
	processing_objects -= src
	..()

/obj/machinery/redspace_crystal/process()
	if(prob(20))
		humes_repository.humesiate(src, 35)