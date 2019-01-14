# Radio panic button user manual

## *Quick start guide*
1. Press the UI icon, or right-click the radio you wish to activate the emergency function on and select "Toggle Emergency Function".
2. If the radio has an emergency function available, the radio will change channel to the emergency channel, notify the channel that you have activated your panic alarm, and the microphone will be hot - as you speak or people around you speak, it will relay to the emergency channel.
3. Press the UI icon again, or right-click and select "Toggle Emergency Function" again, to deactivate it.

## *In-depth Explanations - Frontend*

### Panic alarm activation and deactivation
Some radios will now be equipped with a panic alarm. Those that are, will have the headset in question with a UI element at the top left corner of your screen that you can click. Click it once to activate, click it again to deactivate.

If you are handcuffed or otherwise restrained, you can activate the panic alarm by right-clicking the radio and clicking "Toggle Emergency Function". This will take about five seconds and will also send a visible message to nearby people to alert them of your shenanigans.

Activating the alarm will send the emergency channel an alert that your panic function has been activated, plus the name of the area you are in, to assist emergency responders in finding you. It will also lock out the channel controls, so any assailant can't change the channel without deactivating the panic alarm, which will tip security off (see below).

![Example of the activation message.](https://i.imgur.com/CKj41hr.png)

Deactivating the alarm will send the emergency channel an alert that your panic function has been deactivated and who deactivated it, so they know that everything's OK or if your assailant is trying shonky business.

**Administrators can also toggle the panic alarm on any radio (e.g. for events) by calling `force_panic_alarm()` (see below).**

### Which radios?

#### The following get a panic alarm:

* All shortwave radios have a panic alarm.
* All security headsets, plus Colony Director and Head of Personnel headsets, have one as well, due to the fact that they're all high-value targets.
* Centcomm, Nanotrasen Rep, and Admin Omni-channel headsets also have one, as they are all a result of admin intervention (spawning the characters or the headsets). Central and NT are also high-value targets.

---

#### The following do NOT get a panic alarm:

* Intercoms do not have a panic alarm. Intercoms are anchored to the wall; players are not.
* The AI radio does not have a panic alarm. The AI has tons of channels it can scream for help on.
* Borg radios do not have a panic alarm. They can ask for the AI's assistance through a special channel.
* Headsets not listed above do not have a panic alarm.


### Who can hear the channel?

* For shortwave radios: You will need either medical equipment access or security access to hear the channel.
* For headsets: 
  * The AI, Security and Medical (including HoS and CMO) can hear the channel by default. 
  * Medical-Science headsets have access to it since they're medical, but it is deactivated by default since it's technically not part of their job.
  * Heads of Staff have access to the channel, but it is deactivated by default since it's not their department and there's probably someone else there that's more qualified to answer the calls.
  * ERT, NT/Centcomm and Admin Omni-channel headsets can also hear the channel by default.

## *In-depth Explanations - Backend*

### Code Locations

* Channel frequency: [/code/controllers/communications.dm](/code/controllers/communications.dm)
* Shortwave radio channel access: [/code/game/objects/items/devices/radio/radio.dm](/code/game/objects/items/devices/radio/radio.dm)
* Chat CSS: [/code/stylesheet.dm](/code/stylesheet.dm)
* Encryption key-based access: [./encryption_keys.dm](radio_panic_button/encryption_keys.dm)
* Which radios get it, which don't, and the actual code: [./radio.dm](radio_panic_button/radio.dm)


### Variable explanations

#### Function variables (changing will directly affect functionality)

* `action_button_name` - Name of the UI element at the top left corner of the screen.
* `can_toggle_emergency_mode` - Whether or not the radio's emergency function can be toggled.
* `panic_mode_will_turn_off_speaker` - Whether or not the panic function will disable the radio's speaker. 
* `freqlock` - Whether or not the radio's frequency adjustment controls are locked out.

---
	
#### Storage variables (changing will only confuse the proc that calls it)

* `panic_prev_frequency` - The frequency the radio was on prior to the panic function being activated.
* `panic_speaker_state` - Whether or not the radio's speaker was enabled prior to the panic function being activated.
* `panic_mic_state` - Whether or not the radio's microphone was on continuous-transmit prior to the panic function being activated.
* `panic_frequency_lock` - Whether or not the radio's current frequency lock setting is due to the panic alarm being activated. 
  * 0: Not activated by proc, radio frequency will still be locked when we deactivate.
  * 1: Activated by proc, radio frequency will be unlocked when we deactivate.
* `panic_enabled` - Whether or not the emergency function is currently active.

### Proc explanations

#### panic_alarm
```DM
/obj/item/device/radio/proc/begin_panic_alarm_checks(mob/user)
```

Runs the sanity checks, then calls `toggle_panic_alarm`.

Variables:
* `mob/user` - The user.


---

#### toggle_panic_alarm
```DM
/obj/item/device/radio/proc/toggle_panic_alarm(mob/user, sanity_checks_pass = FALSE)
```

Toggles the panic alarm and notifies administrators. This proc exists purely to make it cleaner to call the toggle code from multiple places.

Variables:
* `mob/user` - The user.
* `sanity_checks_pass` - Used in the check for malformed proc calls. If this is false, the proc assumes it didn't go through the sanity checks and calls `CRASH()`, aborting the proc.

#### force_panic_alarm
```DM
/obj/item/device/radio/proc/force_panic_alarm(fake_name = "", fake_area = "")
```

Force-toggles the panic alarm. Intended for event use, not called directly. If the variables are missing or the radio does not have a panic function that can be used, will prompt the person who called it to ask how they wish to proceed.

Variables:
* `fake_name` - The name to display in the radio message.
* `fake_area` - The area name to display in the radio message.

#### panic_enable
```DM
/obj/item/device/radio/proc/panic_enable()
```

Enables the panic alarm. This proc exists to make it cleaner for force_panic_alarm to call pretty much the same code.

No variables.

#### panic_disable
```DM
/obj/item/device/radio/proc/panic_disable()
```

Disables the panic alarm. This proc exists to make it cleaner for force_panic_alarm to call pretty much the same code.

No variables.