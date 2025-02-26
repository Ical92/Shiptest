/datum/component/loading
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/list/stack
	var/list/allowed_types
	var/offset = 0
	var/offset_each = 0
	var/max = 0

/datum/component/loading/Initialize(list/_allowed_types, _offset = 0, _offset_each = 0, _max = 2)
	stack = new/list(_max)
	allowed_types = _allowed_types
	offset = _offset
	offset_each = _offset_each
	max = _max

/datum/component/loading/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOUSEDROPPED_ONTO, PROC_REF(mousedropped_onto))

/datum/component/loading/proc/mousedropped_onto(datum/source, atom/movable/O, mob/M)
	insert(O, null, M)

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
		var/obj_offset = offset
		for(var/i = 1, i < slot, i++)
			var/obj/below = stack[i]
			if(!below.stack_offset)
				obj_offset += offset_each
				continue
			obj_offset += below.stack_offset
		O.pixel_y = obj_offset
		stack[slot] = O
		var/atom/movable/container = parent
		O.forceMove(container)
		container.vis_contents = container.contents
		break
