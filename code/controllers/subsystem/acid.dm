SUBSYSTEM_DEF(acid)
	name = "Acid"
	priority = FIRE_PRIORITY_ACID
	flags = SS_NO_INIT|SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/list/processing = list()

/datum/controller/subsystem/acid/stat_entry(msg)
	msg = "P:[length(processing)]"
	return ..()

/datum/controller/subsystem/acid/get_metrics()
	. = ..()
	var/list/cust = list()
	cust["processing"] = length(processing)
	.["custom"] = cust

/datum/controller/subsystem/acid/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while (currentrun.len)
		var/obj/O = currentrun[currentrun.len]
		currentrun.len--
		if (!O || QDELETED(O))
			processing -= O
			if (MC_TICK_CHECK)
				return
			continue

		if(!O.acid_level || !O.acid_processing())
			O.update_appearance()
			processing -= O

		if (MC_TICK_CHECK)
			return
