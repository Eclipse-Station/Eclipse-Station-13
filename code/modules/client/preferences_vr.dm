//File isn't currently being used.
//It is now.
/datum/preferences/update_preview_icon() // Lines up and un-overlaps character edit previews. Also un-splits taurs.
	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(client_ckey)
	mannequin.delete_inventory(TRUE)
	dress_preview_mob(mannequin)
	var/icon/bgstate = pick("000", "FFF", "steel", "white", "plating", "reinforced")

	preview_icon = icon('icons/effects/128x72_vr.dmi', bgstate)
	preview_icon.Scale(128, 72)

	mannequin.dir = NORTH
	var/icon/stamp = getFlatIcon(mannequin)
	stamp.Scale(stamp.Width()*size_multiplier,stamp.Height()*size_multiplier)
	preview_icon.Blend(stamp, ICON_OVERLAY, 67-stamp.Width()/2, 4)

	mannequin.dir = WEST
	stamp = getFlatIcon(mannequin)
	stamp.Scale(stamp.Width()*size_multiplier,stamp.Height()*size_multiplier)
	preview_icon.Blend(stamp, ICON_OVERLAY, 17-stamp.Width()/2, 4)

	mannequin.dir = SOUTH
	stamp = getFlatIcon(mannequin)
	stamp.Scale(stamp.Width()*size_multiplier,stamp.Height()*size_multiplier)
	preview_icon.Blend(stamp, ICON_OVERLAY, 99-stamp.Width()/2, 4)

	preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.