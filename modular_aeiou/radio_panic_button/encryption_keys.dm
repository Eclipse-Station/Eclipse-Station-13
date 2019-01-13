// code/game/objects/items/devices/radio/encryptionkey.dm
// code/game/objects/items/devices/radio/encryptionkey_vr.dm


//Medical
/obj/item/device/encryptionkey/headset_med
	channels = list("Medical" = 1, "Emergency" = 1)

//Medical research
//Has access since it's medical, but since they're also the research side of medical, it's disabled by default.
/obj/item/device/encryptionkey/headset_medsci
	channels = list("Medical" = 1, "Science" = 1, "Emergency" = 0)

//Security
/obj/item/device/encryptionkey/headset_sec
	channels = list("Security" = 1, "Emergency" = 1)

//Head of Security
/obj/item/device/encryptionkey/heads/hos
	channels = list("Security" = 1, "Command" = 1, "Emergency" = 1)

//Chief Medical Officer
/obj/item/device/encryptionkey/heads/cmo
	channels = list("Medical" = 1, "Command" = 1, "Emergency" = 1)

//Colony director
//Has access since they're the Head Honcho, but disabled by default.
/obj/item/device/encryptionkey/heads/captain
	channels = list("Command" = 1, "Security" = 1, "Engineering" = 0, "Science" = 0, "Medical" = 0, "Supply" = 0, "Service" = 0, "Explorer" = 0, "Emergency" = 0)

//AIs
/obj/item/device/encryptionkey/heads/ai_integrated
	channels = list("Command" = 1, "Security" = 1, "Engineering" = 1, "Science" = 1, "Medical" = 1, "Supply" = 1, "Service" = 1, "AI Private" = 1, "Explorer" = 1, "Emergency" = 1)

//Other heads of staff. Since it's not their department, they're disabled by default, but they can turn 'em back on if they care enough to

//Research Director
/obj/item/device/encryptionkey/heads/rd
	channels = list("Command" = 1, "Science" = 1, "Explorer" = 1, "Emergency" = 0)

//Chief Engineer
/obj/item/device/encryptionkey/heads/ce
	channels = list("Engineering" = 1, "Command" = 1, "Emergency" = 0)

//Head of Personnel
/obj/item/device/encryptionkey/heads/hop
	channels = list("Supply" = 1, "Service" = 1, "Command" = 1, "Security" = 0, "Explorer" = 0, "Emergency" = 0)


//These won't show up outside of admin intervention of some sort.

//ERT/CentComm
//They're saving your lives, so probably a good idea to have it enabled.
/obj/item/device/encryptionkey/ert
	channels = list("Response Team" = 1, "Science" = 1, "Command" = 1, "Medical" = 1, "Engineering" = 1, "Security" = 1, "Supply" = 1, "Service" = 1, "Emergency" = 1)

//Admin intercoms
/obj/item/device/encryptionkey/omni
	channels = list("Mercenary" = 1, "Raider" = 1, "Response Team" = 1, "Science" = 1, "Command" = 1, "Medical" = 1, "Engineering" = 1, "Security" = 1, "Supply" = 1, "Service" = 1, "Emergency" = 1)