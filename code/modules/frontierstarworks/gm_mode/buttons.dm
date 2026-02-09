/atom/movable/screen/gm_mode
	icon = 'icons/misc/buildmode.dmi'
	var/datum/gm_mode/bd
	// If we don't do this, we get occluded by item action buttons
	layer = ABOVE_HUD_LAYER

/atom/movable/screen/gm_mode/New(bld)
	bd = bld
	return ..()

/atom/movable/screen/gm_mode/Destroy()
	bd = null
	return ..()

/atom/movable/screen/gm_mode/mode
	name = "Toggle Mode"
	icon_state = "buildmode_basic"
	screen_loc = "NORTH,WEST"

/atom/movable/screen/gm_mode/mode/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, LEFT_CLICK))
		bd.toggle_modeswitch()
	else if(LAZYACCESS(modifiers, RIGHT_CLICK))
		bd.mode.change_settings(usr.client)

	update_appearance()
	return 1

/atom/movable/screen/gm_mode/mode/update_icon_state()
	icon_state = bd.mode.get_button_iconstate()
	return ..()

/atom/movable/screen/gm_mode/help
	icon_state = "buildhelp"
	screen_loc = "NORTH,WEST+1"
	name = "Buildmode Help"

/atom/movable/screen/gm_mode/help/Click(location, control, params)
	bd.mode.show_help(usr.client)
	return 1

/atom/movable/screen/gm_mode/bdir
	icon_state = "build"
	screen_loc = "NORTH,WEST+2"
	name = "Change Dir"

/atom/movable/screen/gm_mode/bdir/update_icon_state()
	dir = bd.build_dir
	return ..()

/atom/movable/screen/gm_mode/bdir/Click()
	bd.toggle_dirswitch()
	update_appearance()
	return 1

// used to switch between modes
/atom/movable/screen/gm_mode/modeswitch
	var/datum/buildmode_mode/modetype

/atom/movable/screen/gm_mode/modeswitch/New(bld, mt)
	modetype = mt
	icon_state = "buildmode_[initial(modetype.key)]"
	name = initial(modetype.key)
	return ..(bld)

/atom/movable/screen/gm_mode/modeswitch/Click()
	bd.change_mode(modetype)
	return 1

// used to switch between dirs
/atom/movable/screen/gm_mode/dirswitch
	icon_state = "build"

/atom/movable/screen/gm_mode/dirswitch/New(bld, dir)
	src.dir = dir
	name = dir2text(dir)
	return ..(bld)

/atom/movable/screen/gm_mode/dirswitch/Click()
	bd.change_dir(dir)
	return 1

/atom/movable/screen/gm_mode/quit
	icon_state = "buildquit"
	screen_loc = "NORTH,WEST+3"
	name = "Quit Buildmode"

/atom/movable/screen/gm_mode/quit/Click()
	bd.quit()
	return 1

/atom/movable/screen/gm_mode/preview_item
	name = "Selected Item"
	icon_state = "template"
	screen_loc = "NORTH,WEST+4"
