/datum/technomancer/spell/shared_burden
	name = "Shared Burden"
	desc = "One of the few functions able to adjust instability, this allows you to take someone else's instability."
	spell_power_desc = "Draws bonus instability from the target, with the bonus dissipating harmlessly, for 'free'."
	cost = 50
	obj_path = /obj/item/weapon/spell/shared_burden
	category = SUPPORT_SPELLS

/obj/item/weapon/spell/shared_burden
	name = "shared burden"
	icon_state = "shared_burden"
	desc = "Send instability from the target to you, for whatever reason you'd want to."
	cast_methods = CAST_MELEE
	aspect = ASPECT_UNSTABLE

/obj/item/weapon/spell/shared_burden/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(ishuman(hit_atom) && within_range(hit_atom))
		var/mob/living/carbon/human/H = hit_atom
		if(H == user)
			user << "<span class='warning'>Draining instability out of you to put it back seems a bit pointless.</span>"
			return 0
		if(H.instability <= 0)
			user << "<span class='warning'>\The [H] has no instability to drain.</span>"
			return 0
		if(pay_energy(500))
			var/instability_to_drain = min(H.instability, 25)
			user << "<span class='notice'>You draw instability away from \the [H] and towards you.</span>"
			adjust_instability(instability_to_drain)
			H.adjust_instability(-calculate_spell_power(instability_to_drain))