/obj/item/clothing/mask/gas/owl_griffin //SPECIAL THANKS to Cameron653 for all the help! -lbnesquik
	name = "Griffin mask"
	desc = "Twoooo! This griffon shaped mask is the iconic one from the griffin criminal mastermind! It seems to house some electronics."
	icon_state = "owl1"
//	body_parts_covered = FACE|EYES
//	flags_inv = "HIDEEARS|HIDEEYES|HIDEFACE"
	var/owl_voice_enabled = 0
	var/list/sound_to_plays = list(
		'sound/voice/chatter/griffin_1.ogg',
		'sound/voice/chatter/griffin_2.ogg',
		'sound/voice/chatter/griffin_3.ogg',
		'sound/voice/chatter/griffin_4.ogg',
		'sound/voice/chatter/griffin_5.ogg',
		'sound/voice/chatter/griffin_6.ogg',
		'sound/voice/chatter/griffin_7.ogg',
		'sound/voice/chatter/griffin_8.ogg',
		'sound/voice/chatter/griffin_9.ogg',
		'sound/voice/chatter/griffin_10.ogg'
		)

/obj/item/clothing/mask/gas/owl_griffin/verb/toggle_voices()
	set name = "Voice"
	set category = "Object"
	set desc = "Click to toggle your JUSTICE voice."

	var/mob/living/carbon/human/M = usr
	if(!M.mind)
		return 0

	to_chat(M, "<span class='notice'>You move a switch on \the [src].</span>")
	owl_voice_enabled = !owl_voice_enabled

/obj/item/clothing/mask/gas/owl_griffin/proc/play_owl_sounds()
    var/playing_sound = pick(sound_to_plays)
    if(owl_voice_enabled)
        playsound(src, playing_sound, 25)
