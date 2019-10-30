/mob/living/carbon/human/proc/turn_to_blob()
	set name = "Slimeform"
	set desc = "Allows you to give up cohesion and turn into a slime."
	set category = "Abilities"

	if(stat)
		to_chat(src,"<span class='warning'>You must be awake to perform this action!</span>")
		return

	else
		nutrition = nutrition/1.5 //THERE NEEDS TO BE A PENALTY FOR THIS
		blobify()

