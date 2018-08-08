/mob/living/carbon/human/proc/handle_emote_vr(var/act,var/m_type=1,var/message = null)

	var/datum/gender/T = gender_datums[get_visible_gender()] //We could go ahead and replace every single 'their' with this. - HTG

	switch(act)
		if ("vwag")
			if(toggle_tail_vr(message = 1))
				m_type = 1
				message = "[wagging ? "starts" : "stops"] wagging their tail."
			else
				return 1
		if ("vflap")
			if(toggle_wing_vr(message = 1))
				m_type = 1
				message = "[flapping ? "starts" : "stops"] flapping their wings."
			else
				return 1
		if ("mlem")
			message = "mlems [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] tongue up over [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] nose. Mlem."
			m_type = 1
		if ("awoo")
			message = "awoos loudly. AwoooOOOOoooo!"
			m_type = 2
		if ("nsay")
			nsay()
			return TRUE
		if ("nme")
			nme()
			return TRUE
		if ("flip", "flips") /* AEIOU EDIT - Added feature for naughty spammers - HTG */

			//Taurs are harder to flip (Sorry, but this is just un-needed code. - HTG)
			/*if(istype(tail_style, /datum/sprite_accessory/tail/taur))
				safe -= 1*/

			var/safe = 99 //We have a 1% chance to break our leg or foot.
			var/list/involved_parts = list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
			for(var/organ_name in involved_parts)
				var/obj/item/organ/external/E = get_organ(organ_name)
				if(!E || E.is_stump() || E.splinted || (E.status & ORGAN_BROKEN))
					involved_parts -= organ_name
					safe -= 4 //Add 4% to the chance for each injured leg/foot. (5% Chance to break our leg/foot in total.)

			//Check if they are physically capable
			if(src.sleeping || src.resting || src.buckled || src.weakened || src.restrained() || involved_parts.len < 2)
				src << "<span class='warning'>You can't *flip in your current state!</span>"
				return 1

			var/breaking = pick(involved_parts)
			var/obj/item/organ/external/E = get_organ(breaking)

			/* AEIOU EDIT - Added feature for naughty spammers - HTG */
			if(prob(safe))
				src.SpinAnimation(7,1)
				custom_emote(1, "does a flip!")
			else
				if(E.cannot_break)
					src.Weaken(5)
					E.droplimb(1,DROPLIMB_EDGE)
					custom_emote(1, "<span class='danger'>hits the ground and [T.his] limb suddenly snaps off! </span>") // I need ideas, dont let me forget! - HTG
					log_and_message_admins("lost [T.his] [breaking] with *flip, ahahah.", src)
				else
					src.Weaken(5)
					E.fracture()
					custom_emote(1, "<span class='danger'>hits the ground and [T.his] limb suddenly makes a sickening cracking noise!</span>") // I need ideas, dont let me forget! - HTG
					log_and_message_admins("broke [T.his] [breaking] with *flip, ahahah.", src)

			return 1

	if (message)
		custom_emote(m_type,message)
		return 1

	return 0

/mob/living/carbon/human/proc/toggle_tail_vr(var/setting,var/message = 0)
	if(!tail_style || !tail_style.ani_state)
		if(message)
			src << "<span class='warning'>You don't have a tail that supports this.</span>"
		return 0

	var/new_wagging = isnull(setting) ? !wagging : setting
	if(new_wagging != wagging)
		wagging = new_wagging
		update_tail_showing()
	return 1

/mob/living/carbon/human/proc/toggle_wing_vr(var/setting,var/message = 0)
	if(!wing_style || !wing_style.ani_state)
		if(message)
			src << "<span class='warning'>You don't have a tail that supports this.</span>"
		return 0

	var/new_flapping = isnull(setting) ? !flapping : setting
	if(new_flapping != flapping)
		flapping = setting
		update_wing_showing()
	return 1

/mob/living/carbon/human/verb/toggle_gender_identity_vr()
	set name = "Set Gender Identity"
	set desc = "Sets the pronouns when examined and performing an emote."
	set category = "IC"
	var/new_gender_identity = input("Please select a gender Identity.") as null|anything in list(FEMALE, MALE, NEUTER, PLURAL, HERM)
	if(!new_gender_identity)
		return 0
	change_gender_identity(new_gender_identity)
	return 1

/mob/living/carbon/human/verb/switch_tail_layer()
	set name = "Switch tail layer"
	set category = "IC"
	set desc = "Switch tail layer on top."
	tail_alt = !tail_alt
	update_tail_showing()
