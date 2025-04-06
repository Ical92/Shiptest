/obj/effect/turf_decal/road/line/half
	icon_state = "road_line_half"

/obj/structure/fluff/anzu/boiler
	name = "boiler"
	desc = null
	icon = 'icons/obj/atmos.dmi'
	icon_state = "heater:0"

/obj/structure/fluff/anzu/boiler/flipped
	icon = 'icons/anzu_event/fluff.dmi'

/obj/structure/fluff/anzu/exhaust
	name = "exhaust"
	desc = null
	icon = 'icons/obj/atmos.dmi'
	icon_state = "siphon:0"


/// THIS SECTION USES MODIFIED ASSETS FROM CM'S LV759 HYBRISA ///

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

/obj/structure/fluff/anzu/lattice/end
	icon_state = "lattice_end"

/obj/structure/fluff/anzu/lattice/wires
	icon_state = "lattice_wires"

/obj/structure/fluff/anzu/lattice/wires/end
	icon_state = "lattice_wires_end"

/obj/structure/fluff/anzu/lattice/inlay
	icon_state = "lattice_inlay"

/obj/structure/fluff/anzu/lattice/inlay/end
	icon_state = "lattice_inlay_end"

/obj/structure/fluff/anzu/lattice/pipe
	icon_state = "lattice_pipe"

/obj/structure/fluff/anzu/lattice/pipe/end
	icon_state = "lattice_pipe_end"
