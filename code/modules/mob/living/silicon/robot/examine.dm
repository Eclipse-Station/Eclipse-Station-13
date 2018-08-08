// // // BEGIN AEIOU EDIT // // //
// ..(user, infix = custom_infix) was causing runtiming because there's no infix in mob/living/examine()
//this is moved down to the actual examine bits.
/mob/living/silicon/robot/examine(mob/user)
	var/custom_infix = ""
	if(custom_name)
		custom_infix = ", [modtype] [braintype]"
	..(user)

	var/msg = ""
	
	// Prints borg name and icon to chat. Stolen from /code/modules/mob/living/carbon/human/examine.dm
	msg += "<span class='info'>*---------*<br>This is "
	if(icon)
		msg += "\icon[icon] " //fucking BYOND: this should stop dreamseeker crashing if we -somehow- examine somebody before their icon is generated

	msg += "<EM>[src.name]</EM>"
	if(custom_name)
		msg += custom_infix
	msg += ".<br>"	//newline before we do the damage texts. 
	// // // END AEIOU EDIT // // //

	
	msg += "<span class='warning'>"
	if (src.getBruteLoss())
		if (src.getBruteLoss() < 75)
			msg += "It looks slightly dented.\n"
		else
			msg += "<B>It looks severely dented!</B>\n"
	if (src.getFireLoss())
		if (src.getFireLoss() < 75)
			msg += "It looks slightly charred.\n"
		else
			msg += "<B>It looks severely burnt and heat-warped!</B>\n"
	msg += "</span>"

	if(opened)
		msg += "<span class='warning'>Its cover is open and the power cell is [cell ? "installed" : "missing"].</span>\n"
	else
		msg += "Its cover is closed.\n"

	if(!has_power)
		msg += "<span class='warning'>It appears to be running on backup power.</span>\n"

	switch(src.stat)
		if(CONSCIOUS)
			if(!src.client)	
				msg += "It appears to be in stand-by mode.\n" //afk
		if(UNCONSCIOUS)		
			msg += "<span class='warning'>It doesn't seem to be responding.</span>\n"
		if(DEAD)			
			msg += "<span class='deadsay'>It looks completely unsalvageable.</span>\n"
	msg += attempt_vr(src,"examine_bellies_borg",args) //VOREStation Edit

	// VOREStation Edit: Start
	if(ooc_notes)
		msg += "<span class = 'deptradio'>OOC Notes:</span> <a href='?src=\ref[src];ooc_notes=1'>\[View\]</a>\n"
	// VOREStation Edit: End

	msg += "*---------*"
	msg += "</span>"		//AEIOU Edit: Ends the info span above, where the borg name stuff is

	if(print_flavor_text()) msg += "\n[print_flavor_text()]\n"

	if (pose)
		if( findtext(pose,".",lentext(pose)) == 0 && findtext(pose,"!",lentext(pose)) == 0 && findtext(pose,"?",lentext(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\nIt is [pose]"

	user << msg
	user.showLaws(src)
	return
