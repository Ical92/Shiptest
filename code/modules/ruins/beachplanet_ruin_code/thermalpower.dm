/obj/structure/hazard/spray/steam/freezing
	smoke_type = /obj/effect/particle_effect/smoke/freezing

/obj/structure/hazard/atmospheric/hot_gas
	name = "hot steam emitter"
	invisibility = INVISIBILITY_ABSTRACT
	density = FALSE
	random_gas = TRUE
	created_gas = GAS_H2O
	mols_created_gas = 50
	max_pressure = 202
	temperature = T0C+500
	requires_client_nearby = TRUE

/obj/structure/hazard/atmospheric/hot_gas/once
	random_gas = FALSE
	requires_client_nearby = FALSE

/obj/structure/hazard/atmospheric/hot_gas/once/toggle()
	. = ..()
	if(on)
		emit_gas()

/obj/structure/hazard/slowdown/abstract_slow
	name = "slowdown zone"
	icon_state = "slowdown"
	invisibility = INVISIBILITY_ABSTRACT
	density = FALSE
	slowdown = 1

/obj/structure/hazard/atmospheric/abstract_slow/toggle()
	. = ..()
	update_turf_slowdown(!on)

/obj/structure/salvageable/thermalpower/gen
	name = "\improper broken thermoelectric generator"
	desc = "An older model of a thermoelectric generator. It's broken beyond repair, but you may be able to salvage something from this."
	icon = 'icons/obj/machines/thermoelectric.dmi'
	icon_state = "teg-broken"
	salvageable_parts = list( //placeholder
		/obj/item/stack/cable_coil/cut = 80,
		/obj/item/stack/ore/salvage/scraptitanium/five = 60,
		/obj/item/stack/ore/salvage/scrapmetal/five = 60,
		/obj/effect/spawner/random/salvage_manipulator = 30,
		/obj/item/stack/sheet/metal/five = 10,
		/obj/item/stack/sheet/plasteel/five = 30
	)

/obj/structure/salvageable/thermalpower/circulator
	name = "\improper broken circulator"
	desc = "A gas circulating turbine and heat exchanger. It's broken beyond repair, but you may be able to salvage something from this."
	icon = 'icons/obj/machines/thermoelectric.dmi'
	icon_state = "circ-broken"
	salvageable_parts = list( //placeholder
		/obj/item/stack/cable_coil/cut = 80,
		/obj/item/stack/ore/salvage/scraptitanium/five = 60,
		/obj/item/stack/ore/salvage/scrapmetal/five = 60,
		/obj/effect/spawner/random/salvage_manipulator = 30,
		/obj/item/stack/sheet/metal/five = 10,
		/obj/item/stack/sheet/plasteel/five = 30
	)

/obj/structure/hazard_shutoff/turn_on_others // Open a door, or other things, at the cost of turning on hazards
	name = "door switch"
	desc = "An emergency shutoff switch for industrial doors."
	icon_state = "electric_toggle"
	var/door_id
	var/wall_gen_id
	var/used = FALSE
	var/areapower = FALSE
	shutoff_message = "You turn on the power leading to the door."

/obj/structure/hazard_shutoff/turn_on_others/examine(mob/user)
	. = ..()
	. += "<span class='notice'>It's [used ? "been turned back on" : "currently off"].</span>"

/obj/structure/hazard_shutoff/turn_on_others/interact(mob/user)
	if(used)
		return FALSE
	used = TRUE
	if(door_id)
		for(var/obj/machinery/door/poddoor/M in GLOB.machines)
			if(M.id == door_id)
				INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/machinery/door/poddoor, open))
	if(wall_gen_id)
		for(var/obj/machinery/power/shieldwallgen/machine in GLOB.machines)
			if(machine.id == wall_gen_id)
				INVOKE_ASYNC(machine, TYPE_PROC_REF(/obj/machinery/power/shieldwallgen, toggle))
	if(areapower)
		var/area/our_area = get_area(src)
		our_area.requires_power = FALSE
	return ..()

/area/ruin/jungle/thermalpower
	name = "abandoned thermal power plant"

/area/ruin/jungle/thermalpower/open_roof
	allow_weather = TRUE

/obj/structure/fluff/boiler
	name = "\improper broken boiler"
	desc = "Part of an obsolete water boiler, used to turn water into steam. The parts have decayed and are unable to be salvaged."
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	density = TRUE

/obj/structure/salvageable/thermalpower/boiler
	name = "\improper broken boiler heater"
	desc = "A heating element of an obsolete water boiler. It's broken beyond repair, but you may be able to salvage something from this."
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	icon_state = "power_boxp"
	salvageable_parts = list( //placeholder
		/obj/item/stack/cable_coil/cut = 80,
		/obj/item/stack/ore/salvage/scraptitanium/five = 60,
		/obj/item/stack/ore/salvage/scrapmetal/five = 60,
		/obj/effect/spawner/random/salvage_manipulator = 30,
		/obj/item/stack/sheet/metal/five = 10,
		/obj/item/stack/sheet/plasteel/five = 30
	)

/obj/structure/fluff/camera
	name = "\improper broken camera"
	desc = "A dusty, unmoving camera, previously used to monitor rooms. The parts have decayed and are unable to be salvaged."
	icon = 'icons/obj/machines/camera.dmi'
	icon_state = "camera_off"

/obj/effect/mob_spawn/human/corpse/thermalpower
	brute_damage = 300
	husk = TRUE
	outfit = /datum/outfit/job/independent/engineer //placeholder

/obj/structure/salvageable/thermalpower/borg
	name = "\improper dusty Cyborg"
	desc = "A Cyborg that's mysteriously stopped operations. There is a thick layer of dust on it, but the parts seem to be salvagable."
	icon = 'icons/mob/robots.dmi'
	icon_state = "landmate"
	anchored = FALSE
	salvageable_parts = list( //placeholder
		/obj/item/stack/cable_coil/cut = 80,
		/obj/item/stack/ore/salvage/scraptitanium/five = 60,
		/obj/item/stack/ore/salvage/scrapmetal/five = 60,
		/obj/effect/spawner/random/salvage_manipulator = 30,
		/obj/item/stack/sheet/metal/five = 10,
		/obj/item/stack/sheet/plasteel/five = 30
	)
