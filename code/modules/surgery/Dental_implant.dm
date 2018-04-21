//Procedures in this file: Dental Implant surgery
//////////////////////////////////////////////////////////////////
//						DENTAL IMPLANT SURGERY					//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/mouth
	priority = 2
	req_open = 0
	can_infect = 0

/datum/surgery_step/face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected || (affected.robotic >= ORGAN_ROBOT))
		return 0
	return target_zone == O_MOUTH


////////////////////////////////////////////////////////////////
// Teeth opening Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/drill_teeth
	allowed_tools = list(
	/obj/item/weapon/surgical/surgicaldrill = 100,		\
	/obj/item/weapon/pickaxe/excavationdrill = 75,	\
	/obj/item/mecha_parts/mecha_equipment/tool/drill = 50, 		\
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/drill_teeth/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == O_MOUTH && target.op_stage.face == 0

/datum/surgery_step/drill_teeth/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to drill into [target]'s teeths with \the [tool].", \
	"You start to drill into [target]'s teeth with \the [tool].")
	..()

/datum/surgery_step/drill_teeth/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<font color='blue'>[user] has drilled a hole in [target]'s teeths with \the [tool].</font>" , \
	"<font color='blue'> You have drilled a hole in [target]'s teeths with \the [tool].</font>",)
	target.op_stage.face = 1

/datum/surgery_step/drill_teeth/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, slicing [target]'s gums with \the [tool]!</font>" , \
	"<font color='red'>Your hand slips, slicing [target]'s gums with \the [tool]!</font>" )
	affected.createwound(CUT, 40)
	target.apply_damage(10, BRUTE, affected, sharp=1, sharp=1)

////////////////////

/datum/surgery_step/insert_pill/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == O_MOUTH && target.op_stage.face == 0

/datum/surgery_step/insert_pill/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to wedge the [tool] into [target]'s teeths.", \
	"You start to wedge the [tool] into [target]'s teeths.")
	..()

/datum/surgery_step/insert_pill/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<font color='blue'>[user] has wedged the [tool] into [target]'s mouth .</font>" , \
	"<font color='blue'> You have wedged the [tool] into [target]'s teeths. </font>",)
	target.op_stage.face = 1


/datum/surgery_step/insert_pill/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!</span>")
	affected.createwound(BRUISE, 5)

///////////////


/datum/surgery_step/insert_pill/success(mob/user, mob/living/carbon/target, target_zone, var/obj/item/reagent_containers/pill/tool, datum/surgery/surgery)
	if(!istype(tool))
		return 0

	user.transferItemToLoc(tool, target, TRUE)

	var/datum/action/item_action/hands_free/activate_pill/P = new(tool)
	P.button.name = "Activate [tool.name]"
	P.target = tool
	P.Grant(target)	//The pill never actually goes in an inventory slot, so the owner doesn't inherit actions from it

	user.visible_message("[user] wedges \the [tool] into [target]'s [parse_zone(target_zone)]!", "<span class='notice'>You wedge [tool] into [target]'s [parse_zone(target_zone)].</span>")
	return 1


