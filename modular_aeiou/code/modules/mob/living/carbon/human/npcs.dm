/mob/living/carbon/human/monkey/contrabandito/New()
		spawn(1)
				..()
				name = "Contrabandito"
				real_name = name
				default_language = "Galactic Common"
				
				can_enter_vent_with = list(
				/obj)
				regenerate_icons()
				
/mob/living/carbon/human/monkey/contrabandito/is_allowed_vent_crawl_item(var/obj/carried_item)
    return 1