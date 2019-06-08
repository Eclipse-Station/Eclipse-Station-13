# Modular Handgun Spriting System

## Overview

The Modular Handgun Spriting System (MHSS) is an overlay-based method of spriting handguns. Its goal is to reduce the amount of spriting necessary for new or improved handgun sprites to be created, by layering each major component of the handgun itself over each other piece.

## How It Works

There are five major layers in the spriting system:

* The base layer makes up all the parts common to each sprite, such as the barrel assembly, recoil spring, hammer, etc.
* The slide layer is pixel-shifted when the weapon is emptied. How far it is pixel-shifted is determined by the `mod_slide_offset` var.
* The grips are static, and do not change based on the weapon's state (loaded versus unloaded, firing, etc).
* The magazine is added when the weapon has one inserted. The magazine sprite is calculated automatically if set to do so; if the maximum capacity is greater than the standard magazine capacity (`mod_mag_standard_cap`), the magazine uses `[mod_identifier]-mag-ext` as the sprite state, otherwise it uses `[mod_identifier]-mag-st`.
* The gun supports accessory slots, such as flashlights, frame-mounted sights, etc. These are static by default.

Each layer's calculations can be adjusted on the fly, by overwriting the relevant build procs.

## Reskinning

The system supports reskinning, by default. Skins are not automatically calculated (not all guns will have all slide finishes available for all grips). If the weapon author indicates the weapon cannot be reskinned, or if alternate skins have not been set up, the user will not be able to change the skin.

Attempting to change the skin when that is not the case will bring up a small menu, with all the available dev-set skin combinations.

Alternatively, specific finishes can be set up by varediting `mod_slide_style`, `mod_grip_style`, `mod_mag_style_override`, and `mod_accessory_style`, then calling `update_icons()` or `rebuild_gun()`.

## Creating skins for use by players via reskin verb

To create a skin set, first think of a name and set it in the `reset_skin_combos()` proc, like so:

```C
mod_reskin_options["black grips, blued slide"] = 1
mod_reskin_options["black grips, steel slide"] = 2
```

The number at the end is the specific skin number, and the string in brackets is the short description.

Next, add the skin numbers in a `switch()` statement in `reset_skin()`, like so:

```C
switch(skin_number)
	if(1)		//blued steel slide, synthetic grips
		mod_slide_style = "blued"
		mod_grip_style = "synth"
	if(2)		//brushed steel slide, synthetic grips
		mod_slide_style = "steel"
		mod_grip_style = "synth"
update_icon()
```

The skin number (defined above) is parsed by the switch statement, which sets the grip and slide variables and then updates the icons.

**Please note: Your final skin in the switch statement should be preceded by an `else` clause.** This allows a form of inherent error handling, where if you do not set it up right and have too many combinations in `reset_skin_combos()` and not enough entries in `reset_skin()`, it'll fall back to a usable sprite.

## Conventions and Default Behaviours

The weapon sprite calculations are done as follows:

* Base icons are taken as `[identifier]-base`.
* Slide and grip styles are `[identifier]-[component]-[style]`.
* Magazines are `[mod_identifier]-mag-ext` for extended magazines, `[mod_identifier]-mag-st` for standard magazines. 
* ***`mod_mag_style_override` does not auto-parse. If used, icon states should be entered VERBATIM.***
* Accessories are parsed as `[identifier]-acc-[style]`. Multiple accessories are currently not supported.

All variables used by this system start with `mod_`.

Calling `update_icon()` will rebuild the gun sprite.

## Notable Variables

* `mod_identifier`: String. Specific weapon identifier. This is used in the event you add more than one gun to a file, to distinguish between them.
* `mod_slide_style`: String. Style or finish of the slide. See above for auto-parsing information.
* `mod_grip_style`: String. Style or finish of the grips. See above for auto-parsing information.
* `mod_mag_style_override`: String. Magazine style override. Does not automatically parse.
* `mod_accessory_style`: String. Style of accessory on the gun. See above for auto-parsing information.
* `mod_mag_has_multiple_styles`: Boolean. Does the magainz support an extended magazine? If FALSE, will use standard magazine sprite no matter the capacity.
* `mod_mag_standard_cap`: Number. If the magazine capacity is over this amount, use extended magazines.
* `mod_slide_offset`: Number. How far the slide moves when the gun is emptied. Positive numbers will shift it right, negative numbers will shift it left.
* `mod_all_slide_styles`: List. Clerical only.
* `mod_all_grip_styles`: List. Clerical only.
* `mod_all_accessory_styles`: List. Clerical only.
* `mod_reskin_permitted`: Boolean. Allow players to reskin this weapon?

## Notable procs

* `reset_skin(skin_number)`: Sets the skin to the skin number specified.
* `reset_skin_combos()`: Clears and resets the list of available skin combinations.

### Construction
* `build_slide()`: Builds the slide sprite and adds it to the gun.
* `build_grips()`: Builds the grip sprite and adds it to the gun.
* `build_magazine()`: Builds the magazine sprite and adds it to the gun.
* `build_accessory()`: Adds the accessory sprite to the gun.
* `rebuild_gun()`: Cuts all overlays, and then calls the four above procs.

### Verbs
* `reskin_gun()`: Allows players to choose a gun skin specified by the developers. Clicking this will open a menu if the gun can be reskinned and an alternate skin is set in `reset_skin_combos()`.