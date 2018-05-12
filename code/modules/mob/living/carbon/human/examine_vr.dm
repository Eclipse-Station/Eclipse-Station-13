/mob/living/carbon/human/proc/examine_weight()
	if(!show_pudge()) //Some clothing or equipment can hide this.
		return ""
	var/message = ""
	var/weight_examine = round(weight)
//	var/tone_examine = round(tone)
	var/t_He 	= "It" //capitalised for use at the start of each line.
	var/t_he	= "it"
	var/t_his 	= "its"
	var/t_His 	= "Its"
	var/t_is 	= "is"
	var/t_has 	= "has"
	var/t_heavy = "heavy"
	switch(identifying_gender) //Gender is their "real" gender. Identifying_gender is their "chosen" gender.
		if(MALE)
			t_He 	= "He"
			t_he 	= "he"
			t_His 	= "His"
			t_his 	= "his"
			t_heavy = "bulky"
		if(FEMALE)
			t_He 	= "She"
			t_he	= "she"
			t_His 	= "Her"
			t_his 	= "her"
			t_heavy = "curvy"
		if(PLURAL)
			t_He	= "They"
			t_he	= "they"
			t_His 	= "Their"
			t_his 	= "their"
			t_is 	= "are"
			t_has 	= "have"
		if(NEUTER)
			t_He 	= "It"
			t_he	= "it"
			t_His 	= "Its"
			t_his 	= "its"
		if(HERM)
			t_He 	= "Shi"
			t_he	= "shi"
			t_His 	= "Hir"
			t_his 	= "hir"
			t_heavy = "curvy"

	switch(weight_examine)
		if(0 to 74)
			message = "<span class='warning'>[t_He] [t_is] terribly lithe and frail!</span>\n"
		if(75 to 99)
			message = "[t_He] [t_has] a very slender frame.\n"
		if(100 to 124)
			message = "[t_He] [t_has] a lightweight, athletic build.\n"
		if(125 to 174)
			message = "[t_He] [t_has] a healthy, average body.\n"
		if(175 to 224)
			message = "[t_He] [t_has] a thick, [t_heavy] physique.\n"
		if(225 to 274)
			message = "[t_He] [t_has] a plush, chubby figure.\n"
		if(275 to 325)
			message = "[t_He] [t_has] an especially plump body with a round potbelly and large hips.\n"
		if(325 to 374)
			message = "[t_He] [t_has] a very fat frame with a bulging potbelly, squishy rolls of pudge, very wide hips, and plump set of jiggling thighs.\n"
		if(375 to 474)
			message = "<span class='warning'>[t_He] [t_is] incredibly obese. [t_His] massive potbelly sags over [t_his] waistline while [t_his] fat ass would probably require two chairs to sit down comfortably!</span>\n"
		else
			message += "<span class='warning'>[t_He] [t_is] so morbidly obese, you wonder how [t_he] can even stand, let alone waddle around the station. [t_He] can't get any fatter without being immobilized.</span>\n"


	return message //Credit to Aronai for helping me actually get this working!

/*
/mob/living/carbon/human/proc/examine_tone()
	if(!show_tone()) //Some clothing or equipment can hide this.
		return ""
	var/message = ""
	var/tone_examine = round(tone)
	var/t_He 	= "It" //capitalised for use at the start of each line.
	var/t_he	= "it"
	var/t_his 	= "its"
	var/t_His 	= "Its"
	var/t_is 	= "is"
	var/t_has 	= "has"
	var/t_heavy = "heavy"

	switch(identifying_gender) //Gender is their "real" gender. Identifying_gender is their "chosen" gender.
		if(MALE)
			t_He 	= "He"
			t_he 	= "he"
			t_His 	= "His"
			t_his 	= "his"
			t_heavy = "bulky"
		if(FEMALE)
			t_He 	= "She"
			t_he	= "she"
			t_His 	= "Her"
			t_his 	= "her"
			t_heavy = "curvy"
		if(PLURAL)
			t_He	= "They"
			t_he	= "they"
			t_His 	= "Their"
			t_his 	= "their"
			t_is 	= "are"
			t_has 	= "have"
		if(NEUTER)
			t_He 	= "It"
			t_he	= "it"
			t_His 	= "Its"
			t_his 	= "its"

	switch(tone_examine)
		if(0 to 49)
			message = "[t_He] [t_has] very little muscle under their skin, they could barely lift an apple!\n"
		if(50 to 99)
			message = "[t_He] [t_has] a quite stringy looking frame.\n"
		if(100 to 149)
			message = "[t_He] [t_has] a healthy, average body.\n"
		if(150 to 200)
			message = "[t_He] [t_has] a svelte, vigorous looking body.\n"
		else
			message += "[t_He] [t_is] incredibly muscular. [t_His] massive muscles are impossible to hide even with loose clothing.\n"

	return message
*/

/mob/living/carbon/human/proc/examine_nutrition()
	if(!show_pudge()) //Some clothing or equipment can hide this.
		return ""
	var/message = ""
	var/nutrition_examine = round(nutrition)
	var/t_He 	= "It" //capitalised for use at the start of each line.
	var/t_His 	= "Its"
	var/t_his 	= "its"
	var/t_is 	= "is"
	var/t_has 	= "has"
	switch(identifying_gender)
		if(MALE)
			t_He 	= "He"
			t_his 	= "his"
			t_His 	= "His"
		if(FEMALE)
			t_He 	= "She"
			t_his 	= "her"
			t_His 	= "Her"
		if(PLURAL)
			t_He  	= "They"
			t_his 	= "their"
			t_His 	= "Their"
			t_is	= "are"
			t_has 	= "have"
		if(NEUTER)
			t_He 	= "It"
			t_his 	= "its"
			t_His	= "Its"
		if(HERM)
			t_He 	= "Shi"
			t_his 	= "hir"
			t_His 	= "Hir"
	switch(nutrition_examine)
		if(0 to 49)
			message = "<span class='warning'>[t_He] [t_is] starving! You can hear [t_his] stomach snarling from across the room!</span>\n"
		if(50 to 99)
			message = "<span class='warning'>[t_He] [t_is] extremely hungry. A deep growl occasionally rumbles from [t_his] empty stomach.</span>\n"
		if(100 to 499)
			return message //Well that's pretty normal, really.
		if(500 to 999) // Fat.
			message = "[t_He] [t_has] a stuffed belly, bloated fat and round from eating too much.\n"
		if(1000 to 1400)//fatter
			message = "[t_He] [t_has] a rotund, thick gut. It bulges from their body obscenely, close to sagging under its own weight.\n"
		if(1400 to 1934) // One person fully digested.
			message = "<span class='warning'>[t_He] [t_is] sporting a large, round, sagging stomach. It's contains at least their body weight worth of glorping slush.</span>\n"
		if(1935 to 3004) // Two people.
			message = "<span class='warning'>[t_He] [t_is] engorged with a huge stomach that sags and wobbles as they move. [t_He] must have consumed at least twice their body weight. It looks incredibly soft.</span>\n"
		if(3005 to 4074) // Three people.
			message = "<span class='warning'>[t_His] stomach is firmly packed with digesting slop. [t_He] must have eaten at least a few times worth their body weight! It looks hard for them to stand, and [t_his] gut jiggles when they move.</span>\n"
		if(4075 to 10000) // Four or more people.
			message = "<span class='warning'>[t_He] [t_is] so absolutely stuffed that you aren't sure how it's possible to move. [t_He] can't seem to swell any bigger. The surface of [t_his] belly looks sorely strained!</span>\n"
	return message


/*
/mob/living/carbon/human/proc/examine_weight()
	if(!show_pudge()) //Some clothing or equipment can hide this.
		return ""
	var/message = ""
	var/weight_examine = round(weight)
	var/tone_examine = round(tone)
	var/t_He 	= "It" //capitalised for use at the start of each line.
	var/t_he	= "it"
	var/t_his 	= "its"
	var/t_His 	= "Its"
	var/t_is 	= "is"
	var/t_has 	= "has"
	var/t_heavy = "heavy"
	if(identifying_gender) //Gender is their "real" gender. Identifying_gender is their "chosen" gender.
		if(MALE)
			t_He 	= "He"
			t_he 	= "he"
			t_His 	= "His"
			t_his 	= "his"
			t_heavy = "bulky"
		if(FEMALE)
			t_He 	= "She"
			t_he	= "she"
			t_His 	= "Her"
			t_his 	= "her"
			t_heavy = "curvy"
		if(PLURAL)
			t_He	= "They"
			t_he	= "they"
			t_His 	= "Their"
			t_his 	= "their"
			t_is 	= "are"
			t_has 	= "have"
		if(NEUTER)
			t_He 	= "It"
			t_he	= "it"
			t_His 	= "Its"
			t_his 	= "its"

appearance_boxes[first_list][second_list]

	if(weight_examine && tone_examine) //First list selects dependant on the fatness. The one within selects on the tone aka muscle level.
	var/list/appearance_boxes[10][10] = list(
		1 = list(
			1000 = message = "<span class='warning'>[t_He] [t_is] terribly lithe and frail!</span>\n",
			1010 = message = ""
			1020 = message = ""
			1030 = message = ""
			1040 = message = ""
			1050 = message = ""
			1060 = message = ""
			1070 = message = ""
			1080 = message = ""
			1090 = message = ""
			1100 = message = ""
		)

		2 = list(
			2000 = message = "<span class='warning'>[t_He] [t_is] terribly lithe and frail!</span>\n",
			2010 = message = ""
			2020 = message = ""
			2030 = message = ""
			2040 = message = ""
			2050 = message = ""
			2060 = message = ""
			2070 = message = ""
			2080 = message = ""
			2090 = message = ""
			2100 = message = ""
		)

		3 = list(
			3000 = message = "<span class='warning'>[t_He] [t_is] terribly lithe and frail!</span>\n",
			3010 = message = ""
			3020 = message = ""
			3030 = message = ""
			3040 = message = ""
			3050 = message = ""
			3060 = message = ""
			3070 = message = ""
			3080 = message = ""
			3090 = message = ""
			3100 = message = ""
		)

		4 = list(
			4000 = message = "<span class='warning'>[t_He] [t_is] terribly lithe and frail!</span>\n",
			4010 = message = ""
			4020 = message = ""
			4030 = message = ""
			4040 = message = ""
			4050 = message = ""
			4060 = message = ""
			4070 = message = ""
			4080 = message = ""
			4090 = message = ""
			4100 = message = ""
		)

		5 = list(
			5400 = message = "<span class='warning'>[t_He] [t_is] terribly lithe and frail!</span>\n",
			5010 = message = ""
			5020 = message = ""
			5030 = message = ""
			5040 = message = ""
			5050 = message = ""
			5060 = message = ""
			5070 = message = ""
			5080 = message = ""
			5090 = message = ""
			5100 = message = ""
		)

		6 = list(
			6000 = message = "<span class='warning'>[t_He] [t_is] terribly lithe and frail!</span>\n",
			6010 = message = ""
			6020 = message = ""
			6030 = message = ""
			6040 = message = ""
			6050 = message = ""
			6060 = message = ""
			6070 = message = ""
			6080 = message = ""
			6090 = message = ""
			6100 = message = ""
		)

		7 = list(
			7000 = message = "<span class='warning'>[t_He] [t_is] terribly lithe and frail!</span>\n",
			7010 = message = ""
			7020 = message = ""
			7030 = message = ""
			7040 = message = ""
			7050 = message = ""
			7060 = message = ""
			7070 = message = ""
			7080 = message = ""
			7090 = message = ""
			7100 = message = ""
		)

		8 = list(
			8000 = message = "<span class='warning'>[t_He] [t_is] terribly lithe and frail!</span>\n",
			8010 = message = ""
			8020 = message = ""
			8030 = message = ""
			8040 = message = ""
			8050 = message = ""
			8060 = message = ""
			8070 = message = ""
			8080 = message = ""
			8090 = message = ""
			8100 = message = ""
		)

		9 = list(
			9000 = message = "<span class='warning'>[t_He] [t_is] terribly lithe and frail!</span>\n",
			9010 = message = ""
			9020 = message = ""
			9030 = message = ""
			9040 = message = ""
			9050 = message = ""
			9060 = message = ""
			9070 = message = ""
			9080 = message = ""
			9090 = message = ""
			9100 = message = ""
		)

		10 = list(
			10000 = message = "<span class='warning'>[t_He] [t_is] terribly lithe and frail!</span>\n",
			10010 = message = ""
			10020 = message = ""
			10030 = message = ""
			10040 = message = ""
			10050 = message = ""
			10060 = message = ""
			10070 = message = ""
			10080 = message = ""
			10090 = message = ""
			10010 = message = ""
		)
	return message


var/weight_message_index = 1
switch(weight_examine)
	if(0 to 74)
        nutrition_message_index = 1
    if(75 to 99) //Start with the highest one
        nutrition_message_index = 2
    if(100 to 124)
        nutrition_message_index = 3
    if(125 to 174)
        nutrition_message_index = 4
    if(175 to 224)
        nutrition_message_index = 5
	if(225 to 274)
        nutrition_message_index = 6
	if(275 to 325)
        nutrition_message_index = 7
	if(325 to 374)
        nutrition_message_index = 8
	if(375 to 474)
        nutrition_message_index = 9
	if(475 to INFINITY)
        nutrition_message_index = 10


var/tone_message_index = 1

switch(tone_examine)
    if(0 to 74)
        tone_message_index = 1
    if(75 to 99)
        tone_message_index = 2
    if(100 to 124)
        tone_message_index = 3
    if(125 to 174)
        tone_message_index = 4
	if(175 to 224)
        tone_message_index = 5
	if(225 to 274)
        tone_message_index = 6
	if(275 to 324)
        tone_message_index = 7
	if(325 to 374)
        tone_message_index = 8
	if(375 to 474)
        tone_message_index = 9
	if(475 to INFINITY)
        tone_message_index = 10

var/my_message = messages[3][2] //Will set my_message to "boxes"

var/type = pick(viables)
viables.Remove(type)
        construction[button_desc] = type


*/


//For OmniHUD records access for appropriate models
/proc/hasHUD_vr(mob/living/carbon/human/H, hudtype)
	if(H.nif)
		switch(hudtype)
			if("security")
				if(H.nif.flag_check(NIF_V_AR_SECURITY,NIF_FLAGS_VISION))
					return TRUE
			if("medical")
				if(H.nif.flag_check(NIF_V_AR_MEDICAL,NIF_FLAGS_VISION))
					return TRUE

	if(istype(H.glasses, /obj/item/clothing/glasses/omnihud))
		var/obj/item/clothing/glasses/omnihud/omni = H.glasses
		switch(hudtype)
			if("security")
				if(omni.mode == "sec" || omni.mode == "best")
					return TRUE
			if("medical")
				if(omni.mode == "med" || omni.mode == "best")
					return TRUE

	return FALSE

/mob/living/carbon/human/proc/examine_pickup_size(mob/living/H)
	var/message = ""
	if(istype(H) && (H.get_effective_size() - src.get_effective_size()) >= 0.50)
		message = "<font color='blue'>They are small enough that you could easily pick them up!</font>\n"
	return message

/mob/living/carbon/human/proc/examine_step_size(mob/living/H)
	var/message = ""
	if(istype(H) && (H.get_effective_size() - src.get_effective_size()) >= 0.75)
		message = "<font color='red'>They are small enough that you could easily trample them!</font>\n"
	return message

/mob/living/carbon/human/proc/examine_nif(mob/living/carbon/human/H)
	if(nif && nif.examine_msg) //If you have one set, anyway.
		return "<span class='notice'>[nif.examine_msg]</span>\n"
