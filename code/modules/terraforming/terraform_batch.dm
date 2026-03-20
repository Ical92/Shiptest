/datum/terraform_batch
	var/list/machine_terraforms

/datum/terraform_batch/New(obj/machinery/machine, radius)
	var/turf/source_turf = get_turf(machine)
	if(!istype(machine) || !istype(source_turf))
		return FALSE

	var/datum/overmap/dynamic/planet = source_turf.get_overmap_location()
	if(!istype(planet) || !(planet.planet)) // This planet isn't a planet!
		return FALSE

	machine_terraforms = planet.planet.terraforming_table[machine.type]

	if(!machine_terraforms)
		return FALSE

	for(var/turf/target in circleview(machine, 5))
		if(istype(target.loc, /area/overmap_encounter/planetoid))
			terraform(target)

/datum/terraform_batch/proc/terraform(turf/original)
	var/turf/new_turf = machine_terraforms[original.type]
	if(!new_turf)
		return

	original.TerraformTurf(new_turf, new_turf.baseturfs, CHANGETURF_INHERIT_AIR)
