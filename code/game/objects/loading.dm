/atom/movable
	/// movable atom we are loaded on
	var/atom/movable/loaded = null
	/// movable atoms buckled to this
	var/atom/movable/loading

/atom/movable/MouseDrop_T(atom/movable/AM, mob/user)
	. = ..()
	var/mob/living/L = user

	if (!istype(L))
		return

	if(!istype(AM) || isdead(AM) || iscameramob(AM) || istype(AM, /obj/effect/dummy/phased_mob))
		return

	if(!is_load_possible(AM))
		return

	//load(AM)

/atom/movable/proc/load(atom/movable/target)

/atom/movable/proc/is_load_possible(atom/movable/target, force = FALSE, check_adj = TRUE)
	// Make sure target is mob/living
	if(!istype(target))
		return FALSE

	// No bucking you to yourself.
	if(target == src)
		return FALSE

	// Check if this atom can have things buckled to it.
	if(!can_buckle && !force)
		return FALSE

	// Make sure the target isn't already buckled to something.
	if(target.loaded)
		return FALSE

	// Make sure this atom can still have more things buckled to it.
	if(LAZYLEN(loading) >= max_buckled_mobs)
		return FALSE

	return TRUE
