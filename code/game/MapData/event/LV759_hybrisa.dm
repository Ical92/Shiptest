/// USES MODIFIED ASSETS FROM CM'S LV759 HYBRISA ///

/obj/structure/fluff/anzu/small_truck
	name = "\improper CLIP truck"
	desc = null
	icon = 'icons/anzu_event/box_truck.dmi'
	icon_state = "clip_base"
	bound_width = 64
	layer = MOB_LAYER
	density = TRUE

/obj/structure/fluff/anzu/small_truck/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/largetransparency, _x_size = 2)

/obj/structure/fluff/anzu/small_truck/alt
	icon_state = "clip_base_alt"

/obj/effect/turf_decal/tiremarks
	icon = 'icons/anzu_event/decals.dmi'
	icon_state = "tiremarks"

/obj/structure/fluff/anzu/ambulance
	name = "\improper ambulance"
	desc = null
	icon = 'icons/anzu_event/large_vehicles.dmi'
	icon_state = "ambulance"
	bound_width = 64
	layer = MOB_LAYER
	density = TRUE

/obj/structure/fluff/anzu/ambulance/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/largetransparency, _x_size = 2)

/obj/structure/fluff/anzu/lattice
	name = "overhead lattice"
	desc = null
	icon = 'icons/anzu_event/lattice.dmi'
	icon_state = "lattice"
	layer = FLY_LAYER

/obj/structure/fluff/anzu/lattice/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/largetransparency, _y_offset = 0)

// bweh !! sillycode warning
#define OVERHEAD_LATTICE_HELPER(path, state, offset) ##path/north {\
	icon_state = state; \
	dir = NORTH; \
	pixel_y = offset; \
} \
##path/south {\
	icon_state = state; \
	dir = SOUTH; \
	pixel_y = -offset; \
} \
##path/east {\
	icon_state = state; \
	dir = EAST; \
	pixel_x = offset; \
} \
##path/west {\
	icon_state = state; \
	dir = WEST; \
	pixel_x = -offset; \
}


OVERHEAD_LATTICE_HELPER(/obj/structure/fluff/anzu/lattice, "lattice_end", 32)

/obj/structure/fluff/anzu/lattice/wires
	icon_state = "lattice_wires"

OVERHEAD_LATTICE_HELPER(/obj/structure/fluff/anzu/lattice/wires, "lattice_wires_end", 32)

/obj/structure/fluff/anzu/lattice/inlay
	icon_state = "lattice_inlay"

OVERHEAD_LATTICE_HELPER(/obj/structure/fluff/anzu/lattice/inlay, "lattice_inlay_end", 32)

/obj/structure/fluff/anzu/lattice/pipe
	icon_state = "lattice_pipe"

OVERHEAD_LATTICE_HELPER(/obj/structure/fluff/anzu/lattice/pipe, "lattice_pipe_end", 32)
