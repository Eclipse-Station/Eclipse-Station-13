/mob/living/simple_animal/redmob/
	name = "eerie presence"
	desc = "Your skin crawls."
	icon = 'icons/mob/ghost.dmi'
	mouse_opacity = 0


/mob/living/simple_animal/redmob/proc/bluespace_impact(var/atom/bluespace_src)
	visible_message("<span class='warning'>[src] implodes!</span>")
	qdel(src)