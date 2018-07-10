# AEIOU's Modular Folder

## Why do we use it?
Trying to keep up to date with Virgo as an upstream while also creating unique modifications to the code results in a mess of merge conflicts that can be impossible to keep up with. By keeping our unique code in this folder, conflicts can be avoided as nothing will overwrite the files that the upstream may modify.

## Please mark your changes!
All modifications to non-AEIOU files should be marked. A simple `//AEIOU change - reason` will suffice.

## Icons, code, and sounds
Icons are notorious for conflicts. Because of this, ALL NEW ICONS must go in the "modular_aeiou/icons" folder. There are to be no exceptions to this rule. Sounds rarely cause conflicts, but for the sake of organization they are to go in the "modular_aeiou/sounds" folder. No exceptions, either. Unless absolutely necessary, code should go in the "modular_aeiou/code" folder. Small changes outside of the folder should be done with hook-procs. Larger changes should simply mirror the file in the "modular_aeiou/code" folder.

ur gay lol