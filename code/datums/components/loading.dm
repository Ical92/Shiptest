/*
   Contains component/loading and component/unloading
   component/loading allows objects to be loaded onto the parent
   component/unloading is applied to loaded objects and allows them to be unloaded
*/

/datum/component/loading
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/list/stack
	var/list/allowed_types
	var/offset = 0
	var/offset_each = 0
	var/max = 0
	var/unload_time = 1 SECONDS
	var/suspend = FALSE

/datum/component/loading/Initialize(list/_allowed_types, _offset = 0, _offset_each = 0, _max = 2, _unload_time = 1 SECONDS, _suspend = FALSE)
	if(!istype(parent, /atom/movable))
		return COMPONENT_INCOMPATIBLE
	stack = new/list(_max)
	if(!_allowed_types || !_allowed_types.len)
		allowed_types = list(/obj)
	else
		allowed_types = _allowed_types
	offset = _offset
	offset_each = _offset_each
	max = _max
	unload_time = _unload_time
	suspend = _suspend

/datum/component/loading/proc/insert(obj/O, _slot, mob/user)
	var/slot = _slot
	if(slot && stack[slot])
		return FALSE // Wanted slot full
	if(!slot)
		slot = stack.Find(null) // Find first empty slot
		if(!slot)
			return FALSE // No empty slots
	for(var/type in allowed_types)
		if(!istype(O, type))
			continue
		if(!O.AddComponent(/datum/component/unloading, _loaded_to = src))
			continue
		stack[slot] = O
		var/atom/movable/container = parent
		O.forceMove(container)
		update_visuals()
		return TRUE
	return FALSE

/datum/component/loading/proc/update_visuals()
	for(var/slot = 1, slot <= stack.len, slot++)
		var/obj/O = stack[slot]
		if(!istype(O))
			continue
		var/obj_offset = offset
		if(offset_each)
			obj_offset += offset_each * (slot-1)
		else
			for(var/i = 1, i < slot, i++)
				var/obj/below = stack[i]
				if(!offset_each)
					obj_offset += below.stack_offset
					continue
				obj_offset += offset_each
		O.pixel_y = obj_offset
		O.layer = ABOVE_MOB_LAYER + 0.02 * (slot-1)
	var/atom/movable/container = parent
	container.vis_contents = container.contents

/datum/component/unloading
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/datum/component/loading/loaded_to

/datum/component/unloading/Initialize(datum/component/loading/_loaded_to)
	if(!isobj(parent) || !istype(_loaded_to))
		return COMPONENT_INCOMPATIBLE
	loaded_to = _loaded_to

/datum/component/unloading/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_PRE_ATTACK, PROC_REF(pre_attack))
	RegisterSignal(parent, COMSIG_MOUSEDROP_ONTO, PROC_REF(mousedrop_onto))

/datum/component/unloading/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_PRE_ATTACK, COMSIG_MOUSEDROP_ONTO))

/datum/component/unloading/proc/pre_attack(datum/source, atom/A, mob/living/user, params)
	SIGNAL_HANDLER
	return TRUE // Stops basic interaction (such as opening a crate) with an object if it's loaded onto something

/datum/component/unloading/proc/mousedrop_onto(datum/source, atom/over, mob/user)
	if(user && !do_after(user, loaded_to.unload_time, parent)) // This should be an async invoke
		return FALSE

	if(get_dist(over, parent) != 1 || get_dist(over, user) != 1)
		return
	unload(over, user)

/datum/component/unloading/proc/unload(atom/target, mob/user)
	SIGNAL_HANDLER

	var/datum/component/loading/load_comp = target.GetComponent(/datum/component/loading)
	var/obj/O = parent
	if(load_comp && load_comp.insert(parent, null, user))
		remove(O)
		return TRUE // Transfer to other loadable object

	var/turf/drop_location
	if(target && isturf(target)) // Dragged onto a turf, try to unload there
		drop_location = target
	else if(target && isturf(target.loc)) // Dragged onto something on a turf, unload to it's location
		drop_location = target.loc
	else if(!drop_location && user) // If no target turf, unload at user's location
		drop_location = get_turf(user)
	else drop_location = get_turf(parent) // If nothing else, default to wherever the obj is / where it's loaded
	if(drop_location && !drop_location.Enter(parent, no_side_effects = TRUE)) // If unloading to the desired turf would bump, don't do it! - From previous crate shelf code
		drop_location.balloon_alert(user, "no room!")
		return FALSE
	O.layer = initial(O.layer)
	O.pixel_y = initial(O.pixel_y) // Reset the changes made by loading
	O.forceMove(drop_location)
	remove(O)
	return TRUE

/datum/component/unloading/proc/remove(obj/O)
	if(loaded_to.suspend)
		loaded_to.stack[loaded_to.stack.Find(O)] = null // Remove ourselves from the stack
	else
		loaded_to.stack -= O // Remove ourselves from the stack, and shift everything else down
		loaded_to.stack.len++
	loaded_to.update_visuals()
	qdel(src)
