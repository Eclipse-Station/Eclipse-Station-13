/mob/living/carbon/human/proc/turn_to_blob()
	set name = "Slimeform"
	set desc = "Allows you to give up cohesion and turn into a slime."
	set category = "Abilities"

	nutrition = nutrition * 0.5 //THERE NEEDS TO BE A PENALTY FOR THIS
	blobify()