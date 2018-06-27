/mob/living/carbon/human/monkey/contrabandito
	name = "Contrabandito"
	maxHealth = 150

	can_enter_vent_with = list(
    /obj)
/mob/living/carbon/human/monkey/contrabandito/New()
    spawn(1)
        ..()
        real_name = name
        regenerate_icons()

/mob/living/carbon/human/monkey/contrabandito/is_allowed_vent_crawl_item(var/obj/carried_item)
    return 1