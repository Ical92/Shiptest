/// A component for ai-controlled atoms which paths them between other atoms
/datum/component/patrol
	/// Hostile NPC we're controlling
	var/mob/living/simple_animal/hostile/npc
	/// List of atoms to path between
	var/list/atom/waypoints
	/// Index of which waypoint we're moving towards now
	var/waypoint_index = 1
	/// Time to idle at each waypoint
	var/idle_time
	/// Time we've waited at the current waypoint
	var/idled_timer

/datum/component/patrol/Initialize(waypoints, idle_time = 5 SECONDS)
	. = ..()

	npc = parent
	if (!istype(npc))
		return COMPONENT_INCOMPATIBLE
	src.waypoints = waypoints
	src.idle_time = idle_time

/datum/component/patrol/process(seconds_per_tick)
	idled_timer += seconds_per_tick
	if(idled_timer > idle_time)
		idled_timer = 0
		waypoint_index = (waypoint_index + 1) % waypoints.len
		npc.Goto(waypoints[waypoint_index], npc.move_to_delay, 0)
