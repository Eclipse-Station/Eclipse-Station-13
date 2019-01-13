/obj/item/weapon/ore/bluespace_crystal/redspace_crystal
	name = "red bluespace crystal"
	desc = "Doesn't that mean it's a redspace crystal now..? Nah. Either way, you feel like picking that up with your bare hands is a bad idea."
	color = "#990000"
	blink_range = 20//oh boy
	origin_tech = list(TECH_BLUESPACE = 7, TECH_MATERIAL = 5, TECH_PHORON = 6)//oh boy


/obj/item/weapon/ore/bluespace_crystal/redspace_crystal/blink_mob(mob/living/L)
	..()
	L.adjustBruteLoss(15)//IT BURNS!
	sleep(1)
	..()
	L.adjustFireLoss(15)//IT BURNS!!!
	sleep(1)
	..()
	//teleports three times

/obj/item/weapon/ore/bluespace_crystal/redspace_crystal/pickup(mob/living/user)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/victim = user
	var/used_hand = victim.hand?"l_hand":"r_hand"
	victim.adjustFireLossByPart(rand(5, 25), used_hand)
	victim.Weaken(1)
	to_chat(victim, "<span class='warning'>[src] burns your hand badly!</span>")
	playsound(get_turf(victim), 'sound/effects/supermatter.ogg', 50, 1)
	victim.drop_item()
	..()