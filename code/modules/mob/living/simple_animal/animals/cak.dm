/mob/living/simple_animal/cat/cak //I have no excuse and I don't need one. :3
	name = "Keeki"
	desc = "It's a cat made out of cake."
	icon_state = "cak"
	icon_living = "cak"
	icon_dead = "cak_dead"
	health = 100
	maxHealth = 250
	gender = FEMALE
	harm_intent_damage = 5
	response_harm = "takes a bite out of"
	hostile = 0


	meat_amount = 4
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/slice/birthdaycake/filled

/*
/mob/living/simple_animal/cat/cak/CheckParts(list/parts)
	..()
	var/obj/item/organ/internal/brain/B = locate(/obj/item/organ/internal/brain) in contents
	if(!B || !B.brainmob || !B.brainmob.mind)
		return
	B.brainmob.mind.transfer_to(src)
	to_chat(src, "<span class='big bold'>You are a cak!</span><b> You're a harmless cat/cake hybrid that everyone loves. People can take bites out of you if they're hungry, but you regenerate health \
	so quickly that it generally doesn't matter. You're remarkably resilient to any damage besides this and it's hard for you to really die at all. You should go around and bring happiness and \
	free cake to the station!</b>")
	var/new_name = sanitizeSafe(input(src, "Enter your name, or press \"Cancel\" to stick with Keeki.", "Name Change", ""	) as text, MAX_NAME_LEN)
	if(new_name)
		to_chat(src, "<span class='notice'>Your name is now <b>\"new_name\"</b>!</span>")
		name = new_name
*/
		//remake this after powdercak chem


/mob/living/simple_animal/cat/cak/Life()
	..()
	if(stat)
		return
	if(health < maxHealth)
		adjustBruteLoss(-8) //Fast life regen
	for(var/obj/item/weapon/reagent_containers/food/snacks/donut/normal/D in range(1, src)) //Frosts nearby donuts!
		if(D.icon_state != "donut2")
			D.name = "frosted donut"
			D.icon_state = "donut2"
			D.reagents.add_reagent("sprinkles", 2)
			D.filling_color = "#FF69B4"
			if(prob(30))
				D.reagents.add_reagent("sprinkles", 2)
				D.reagents.add_reagent("sugar	", 2)


/mob/living/simple_animal/cat/cak/attack_hand(mob/living/L)
	..()
	if(L.a_intent == I_HURT)
		L.nutrition += 25