////Flickering Light tube////
/obj/machinery/light/flickering
	var/flickerchance = 1.5 //chance out of 100 that it will flicker every second or so. 1.5 is about one flicker per minute

/obj/machinery/light/flickering/New()
	..()
	processing_objects |= src

/obj/machinery/light/flickering/Destroy()
	processing_objects -= src
	return ..()

/obj/machinery/light/flickering/process()
	if(prob(flickerchance))
		flicker()
	return


////Flickering Lightbulb////
/obj/machinery/light/small/flickering
	var/flickerchance = 1.5 //chance out of 100 that it will flicker every second or so. 1.5 is about one flicker per minute

/obj/machinery/light/small/flickering/New()
	..()
	processing_objects |= src

/obj/machinery/light/small/flickering/Destroy()
	processing_objects -= src
	return ..()

/obj/machinery/light/small/flickering/process()
	if(prob(flickerchance))
		flicker()
	return