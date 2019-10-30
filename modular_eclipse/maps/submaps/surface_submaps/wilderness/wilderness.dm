// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST

#include "Hunted.dmm"

#endif

/datum/map_template/surface/wilderness/normal/Hunted
	name = "Hunted"
	desc = "Some vacation hunters from Sol bit off more than they could chew."
	mappath = 'modular_eclipse/maps/submaps/surface_submaps/wilderness/Hunted.dmm'
	allow_duplicates = FALSE
	annihilate = TRUE
	cost = 20

//Rebalancing, done by Spitzer
//Clearing-area submaps
/datum/map_template/surface/wilderness/normal/spider1
	allow_duplicates = TRUE
	cost = 5		//Increase cost +4; spiders are fun and all, but this is light woods and we're going to get spammed with spiders otherwise

//deep woods
/datum/map_template/surface/wilderness/deep/Boombase
	cost = 8		//Increase cost +6
	allow_duplicates = TRUE		//Explosive craters on the surface hardly seem ill-fitting given Nanotrasen's reason for being here.

/datum/map_template/surface/wilderness/deep/BSD
	cost = 10		//No change. Might go back and do more later, so leaving it in.

/datum/map_template/surface/wilderness/deep/Rockybase
	cost = 15		//Increase cost +3
	
/datum/map_template/surface/wilderness/deep/MHR
	cost = 8		//Increase cost +6
	allow_duplicates = TRUE		//THEY'RE FILLING THE TUNNELS WITH MANHACKS

/datum/map_template/surface/wilderness/deep/DoomP
	cost = 20	//Increase cost +10

/datum/map_template/surface/wilderness/deep/Cave
	cost = 10		//Increase cost +4
	allow_duplicates = TRUE		//More spiders? Sure why the hell not

