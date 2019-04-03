#define HM_LEVEL_LOW 5 //Reality starts shifting
#define HM_LEVEL_MODERATE 20 //Something is passively twisting the reality around it
#define HM_LEVEL_HIGH 50 //Something is actively twisting the reality around it
#define HM_LEVEL_VERY_HIGH 75 //GOOD GOOGLY MOOGLY IT'S ALL GONE TO SHIT

//Kant counter
//Rewritten version of TG's geiger counter
//I opted to show exact humes levels

/obj/item/device/kant
	name = "kant counter"
	desc = "A handheld device used for detecting and measuring reality stress levels in an area."
	icon_state = "geiger_off"
	item_state = "multitool"
	w_class = ITEMSIZE_SMALL
	var/scanning = 0
	var/humes_count = 0

/obj/item/device/kant/New()
	processing_objects |= src

/obj/item/device/kant/Destroy()
	processing_objects -= src
	return ..()

/obj/item/device/kant/process()
	get_humes()

/obj/item/device/kant/proc/get_humes()
	if(!scanning)
		return
	humes_count = humes_repository.get_humes_at_turf(get_turf(src))
	update_icon()

/obj/item/device/kant/examine(mob/user)
	..(user)
	get_humes()
	var/reality_level = humes_count + 100
	to_chat(user, "<span class='warning'>[scanning ? "Ambient" : "Stored"] reality stress level: [humes_count ? humes_count : "0"]Hm. (reality density: [reality_level ? reality_level : "0"]Hm.)</span>")

/obj/item/device/kant/rad_act(amount)
	if(!amount || !scanning)
		return FALSE

	if(amount > humes_count)
		humes_count = amount

	var/sound = "geiger"
	if(amount < 5)
		sound = "geiger_weak"
	playsound(src, sound, between(10, 10 + (humes_count * 4), 100), 0)
	if(sound == "geiger_weak") // A weak geiger sound every two seconds sounds too infrequent.
		spawn(1 SECOND)
			playsound(src, sound, between(10, 10 + (humes_count * 4), 100), 0)
	update_icon()

/obj/item/device/kant/attack_self(var/mob/user)
	toggle()

/obj/item/device/kant/AltClick()//ECLIPSE EDIT
	toggle()

/obj/item/device/kant/proc/toggle(var/mob/user)//Moved here to easy the alt click process
	if(!isliving(usr))
		return 0
	scanning = !scanning
	update_icon()
	to_chat(user, "<span class='notice'>\icon[src] You switch [scanning ? "on" : "off"] \the [src].</span>")

/obj/item/device/kant/update_icon()
	if(!scanning)
		icon_state = "geiger_off"
		return 1

	switch(humes_count)
		if(null)
			icon_state = "geiger_on_1"
		if(-INFINITY to HM_LEVEL_LOW)
			icon_state = "geiger_on_1"
		if(HM_LEVEL_LOW to HM_LEVEL_MODERATE)
			icon_state = "geiger_on_2"
		if(HM_LEVEL_MODERATE to HM_LEVEL_HIGH)
			icon_state = "geiger_on_3"
		if(HM_LEVEL_HIGH to HM_LEVEL_VERY_HIGH)
			icon_state = "geiger_on_4"
		if(HM_LEVEL_VERY_HIGH to INFINITY)
			icon_state = "geiger_on_5"

#undef HM_LEVEL_LOW
#undef HM_LEVEL_MODERATE
#undef HM_LEVEL_HIGH
#undef HM_LEVEL_VERY_HIGH