/datum/gm_mode_mode/moveto
	var/list/mob/living/simple_animal/hostile/selection = list()

/datum/gm_mode_mode/moveto/show_help(client/target_client)
	to_chat(target_client, span_purple(boxed_message(
		"[span_bold("Clear selection")] -> Right Mouse Button on buildmode button\n\
		[span_bold("Select Mob")] -> Left Mouse Button on Simple Mob\n\
		[span_bold("Deselect Mob")] -> Alt + Left Mouse Button on Simple Mob\n\
		[span_bold("Path selected mobs")] -> Instruct selected mobs to path to location\n"))
	)

/datum/gm_mode_mode/moveto/change_settings(client/target_client)
	selection = null

/datum/gm_mode_mode/moveto/handle_click(client/target_client, params, atom/object)
	var/list/modifiers = params2list(params)
	var/left_click = LAZYACCESS(modifiers, LEFT_CLICK)
	var/right_click = LAZYACCESS(modifiers, RIGHT_CLICK)
	var/alt_click = LAZYACCESS(modifiers, ALT_CLICK)

	if(left_click)
		var/list/mob/living/simple_animal/hostile/simplemob = selection
		if(istype(simplemob))
			if(alt_click)
				selection -= simplemob
			else
				selection |= simplemob
	else if(right_click)
		var/turf/destination = get_turf(object)
		if(istype(destination))
			for(var/mob/living/simple_animal/hostile/M in selection)
				if(M.AIStatus == AI_OFF)
					return
				else
					M.Goto(destination, M.move_to_delay, 0)
