/obj/item/clothing/mask/gas/owl_aeiou //SPECIAL THANKS to Cameron653 for all the help! -lbnesquik
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. It seems to house some odd electronics."
	icon_state = "owl"
	var/owl_voice_enabled = 0
	var/list/sound_to_play = list(
		'sound/voice/chatter/owl_1.ogg',
		'sound/voice/chatter/owl_2.ogg',
		'sound/voice/chatter/owl_3.ogg',
		'sound/voice/chatter/owl_4.ogg',
		'sound/voice/chatter/owl_5.ogg',
		'sound/voice/chatter/owl_6.ogg',
		'sound/voice/chatter/owl_7.ogg',
		'sound/voice/chatter/owl_8.ogg',
		'sound/voice/chatter/owl_9.ogg',
		'sound/voice/chatter/owl_10.ogg'
		)

/obj/item/clothing/mask/gas/owl_aeiou/verb/toggle_voice()
	set name = "Voice"
	set category = "Object"
	set desc = "Click to toggle your JUSTICE voice."

	var/mob/living/carbon/human/M = usr
	if(!M.mind)
		return 0

	to_chat(M, "<span class='notice'>You move a switch on \the [src].</span>")
	owl_voice_enabled = !owl_voice_enabled

/obj/item/clothing/mask/gas/owl_aeiou/proc/play_owl_sound()
    var/playing_sound = pick(sound_to_play)
    if(owl_voice_enabled)
        playsound(src, playing_sound, 25)
