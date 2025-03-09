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
	temperature = T0C+300
	requires_client_nearby = TRUE

/obj/structure/hazard/slowdown/abstract_slow
	name = "slowdown zone"
	icon_state = "slowdown"
	invisibility = INVISIBILITY_ABSTRACT
	density = FALSE
	slowdown = TRUE

/obj/structure/salvageable/thermalpower/gen
	name = "\improper broken thermoelectric generator"
	desc = "It's broken beyond repair. You may be able to salvage something from this."
	icon = 'icons/obj/machines/thermoelectric.dmi'
	icon_state = "teg-broken"
	salvageable_parts = list(
		/obj/item/stack/cable_coil/cut = 80,
		/obj/item/stack/ore/salvage/scraptitanium/five = 60,
		/obj/item/stack/ore/salvage/scrapmetal/five = 60,
		/obj/effect/spawner/random/salvage_manipulator = 30,
		/obj/item/stack/sheet/metal/five = 10,
		/obj/item/stack/sheet/plasteel/five = 30
	)

/obj/structure/salvageable/thermalpower/circulator
	name = "\improper broken circulator"
	desc = "It's broken beyond repair. You may be able to salvage something from this."
	icon = 'icons/obj/machines/thermoelectric.dmi'
	icon_state = "circ-broken"
	salvageable_parts = list(
		/obj/item/stack/cable_coil/cut = 80,
		/obj/item/stack/ore/salvage/scraptitanium/five = 60,
		/obj/item/stack/ore/salvage/scrapmetal/five = 60,
		/obj/effect/spawner/random/salvage_manipulator = 30,
		/obj/item/stack/sheet/metal/five = 10,
		/obj/item/stack/sheet/plasteel/five = 30
	)
