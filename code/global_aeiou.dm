var/cans_opened = 0 // TEST
var/lights_switched_on = 0
var/trash_piles_searched = 0
var/rare_trash_found = 0
var/turbo_lift_floors_moved = 0
var/lost_limbs_shift = 0
var/mouse_spawned_shift = 0
var/seed_planted_shift = 0
var/step_taken_shift = 0
var/number_people_walked_over = 0
var/destroyed_research_items = 0
var/items_sold_shift = 0
var/disposals_flush_shift = 0

var/global/list/fluff_info = list(
	"[cans_opened] cans were drank today!",
//    world << "[cans_opened] cans were drank today!",
    "[lights_switched_on] light switches were flipped today!",
    "People rummaged through [trash_piles_searched] trash piles today. Ech.",
    "[rare_trash_found] rare objects were found in the bowels of the station today.",
    "The elevator moved up [turbo_lift_floors_moved] floors today!",
    "[lost_limbs_shift] limbs left their owners bodies this shift, oh no!",
    "The mice population grew by [mouse_spawned_shift] according to our sensors. How unhygienic!",
    "[seed_planted_shift] were planted according to our sensors this shift.",
    "The employees walked a total of [step_taken_shift] for this shift! It should put them on the road to fitness!",
    "About [number_people_walked_over] of people were trodden upon, look both ways!",
    "[destroyed_research_items] were destroyed in the name of Science! Keep it up!",
    "The vending machines sold [items_sold_shift] today.",
    "The disposal system flushed a whole [disposals_flush_shift] for this shift. We should really invest in waste treatement.",
)