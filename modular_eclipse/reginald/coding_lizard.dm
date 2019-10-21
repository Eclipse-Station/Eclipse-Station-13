/mob/living/simple_animal/lizard/spitzer
	name = "coding reptile"
	desc = "He's the one responsible for coding."
	gender = MALE
	tt_desc = "Iguana borealis"
	speak_emote = list()
	emote_see = list("slaps the console indiscriminately","stares thoughtfully at the console screen","presses a few keys")
	var/list/possible_moods = list("happy"=25,"tired"=20,"sad"=20,"thoughtful"=20,"hungry"=5,"sleepy"=5,"debugging"=5)		//100 total weight
	var/mood = "unset"
	ai_inactive = TRUE		//lizzer don't move
	speak_chance = 5		//we're not going to be very visible.

/mob/living/simple_animal/lizard/spitzer/New()
	var/turf/K = src.loc
	var/obj/structure/bed/chair/C = locate() in K
	if(C)
		C.buckle_mob(src)		//You're gonna be here coding for a while...
	
	//Get his mood.
	mood = pick(possible_moods)
	switch(mood)
		if("happy")
			emote_see = list("types on the console","presses a few keys and chuffs")
			speak_emote = list("chuffs happily","lets off a happy sigh")
			description_fluff = "He seems happy today!"
		if("tired")
			emote_see = list("shakes himself awake","slowly presses a few keys","stares thoughtfully at the console screen")
			speak_emote = list("yawns","sighs")
			description_fluff = "He seems exhausted..."
		if("sad")
			emote_see = list("slowly presses a few keys","glances briefly at the window","lays his head on the console")
			speak_emote = list("sighs")
			description_fluff = "He seems to be having a bad day today..."
		if("thoughtful")
			emote_see = list("stares thoughtfully at the console screen","slowly presses a few keys")
			speak_emote = list("chuffs","hums and haws")
			description_fluff = "He seems lost in thought."
		if("hungry")
			emote_see = list("nibbles on the bacon","glances briefly at the bacon")
			speak_emote = list("chuffs")
			description_fluff = "He seems hungry."
		if("sleepy")
			emote_see = list("twitches in his sleep","suddenly snaps awake, then curls back up in the chair","bats at something in his sleep","kicks at something in his sleep")
			speak_emote = list("yawns","snores softly","chuffs softly")
			description_fluff = "Someone's had a long day."
		if("debugging")		//also annoyed
			emote_see = list("slaps the side of the console","presses a few keys","glares at the console","stares thoughtfully at the console screen","tilts his head at the console screen and hits a couple of keys")
			speak_emote = list("hisses at the console","lets out a low chuff","lets out a confused chuff")
			description_fluff = "He seems to be having a bad day today..."		//same as sad
		else		//something broke.
			emote_see = list("tilts his head at the console screen")
			speak_emote = list("screeches at the console")
			description_fluff = "We have no clue how he's doing today, honestly."
