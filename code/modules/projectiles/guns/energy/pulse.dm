/obj/item/weapon/gun/energy/pulse_rifle
	name = "pulse rifle"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Because of its complexity and cost, it is rarely seen in use except by specialists."
	icon_state = "pulse"
	item_state = null	//so the human update icon uses the icon_state instead.
	slot_flags = SLOT_BELT|SLOT_BACK
	force = 10
	projectile_type = /obj/item/projectile/beam
	charge_cost = 120
	sel_mode = 2

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_delay=null, charge_cost = 120),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_delay=null, charge_cost = 120),
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_delay=null, charge_cost = 240),
		)

/obj/item/weapon/gun/energy/pulse_rifle/mounted
	self_recharge = 1
	use_external_power = 1

/obj/item/weapon/gun/energy/pulse_rifle/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon. Because of its complexity and cost, it is rarely seen in use except by specialists."
	fire_sound='sound/weapons/gauss_shoot.ogg'
	projectile_type=/obj/item/projectile/beam/pulse
	charge_cost = 120

/obj/item/weapon/gun/energy/pulse_rifle/destroyer/attack_self(mob/living/user as mob)
	user << "<span class='warning'>[src.name] has three settings, and they are all DESTROY.</span>"

//WHY?
/obj/item/weapon/gun/energy/pulse_rifle/M1911
	name = "\improper M1911-P"
	desc = "It's not the size of the gun, it's the size of the hole it puts through people."
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	icon_state = "m1911-p"
	charge_cost = 240

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_delay=null, charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, fire_delay=null, charge_cost = 240),
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_delay=null, charge_cost = 480),
		)


/*
//VG GUN
/obj/item/gun/energy/laser/LaserAK
	name = "Laser AK470"
	desc = "A laser AK. Death solves all problems -- No man, no problem."
	icon_state = "LaserAK"
	item_state = null
	slot_flags = SLOT_BELT|SLOT_BACK
	force = 10
	recoil_m = 1
	icon = 'icons/obj/gun.dmi'
	firemodes = list(
		list(mode_name="single shot", burst = 1, burst_accuracy = list(5), dispersion = list(0), charge_cost = 24),
		list(mode_name="five shot burst", burst = 5, burst_accuracy = list(5,5,5,5,5), dispersion = list(1,1,1,1,1)),
		list(mode_name="ten shot burst", burst = 10, burst_accuracy = list(5,5,5,5,5,5,5,5,5,5), dispersion = list(2,2,2,2,2,2,2,2,2,2)),
		)

//	firemodes = list(
//		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
//		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0))
//		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1,-2,-2), dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2)),
//		)

*/
