#define GM_SWITCHSTATE_NONE 0
#define GM_SWITCHSTATE_MODE 1
#define GM_SWITCHSTATE_DIR 2

/datum/gm_mode
	var/build_dir = SOUTH
	var/datum/gm_mode_mode/mode
	var/client/holder

	// login callback
	var/li_cb

	// SECTION UI
	var/list/buttons

	// Switching management
	var/switch_state = GM_SWITCHSTATE_NONE
	var/switch_width = 4
	// modeswitch UI
	var/atom/movable/screen/buildmode/mode/modebutton
	var/list/modeswitch_buttons = list()
	// dirswitch UI
	var/atom/movable/screen/buildmode/bdir/dirbutton
	var/list/dirswitch_buttons = list()
	/// item preview for selected item
	var/atom/movable/screen/buildmode/preview_item/preview

/datum/gm_mode/New(client/c)
	mode = new /datum/gm_mode_mode/moveto(src)
	holder = c
	buttons = list()
	li_cb = CALLBACK(src, PROC_REF(post_login))
	holder.player_details.post_login_callbacks += li_cb
	holder.show_popup_menus = FALSE
	create_buttons()
	holder.screen += buttons
	holder.click_intercept = src
	mode.enter_mode(src)
	modebutton.update_appearance()

/datum/gm_mode/proc/quit()
	mode.exit_mode(src)
	holder.screen -= buttons
	holder.click_intercept = null
	holder.show_popup_menus = TRUE
	qdel(src)

/datum/gm_mode/Destroy()
	close_switchstates()
	close_preview()
	holder.player_details.post_login_callbacks -= li_cb
	QDEL_NULL(li_cb)
	holder = null
	buttons.Cut()
	QDEL_NULL(mode)
	QDEL_NULL(modebutton)
	QDEL_LIST(modeswitch_buttons)
	QDEL_NULL(dirbutton)
	QDEL_LIST(dirswitch_buttons)
	return ..()

/datum/gm_mode/proc/post_login()
	// since these will get wiped upon login
	holder.screen += buttons
	// re-open the according switch mode
	switch(switch_state)
		if(GM_SWITCHSTATE_MODE)
			open_modeswitch()
		if(GM_SWITCHSTATE_DIR)
			open_dirswitch()

/datum/gm_mode/proc/create_buttons()
	// keep a reference so we can update it upon mode switch
	modebutton = new /atom/movable/screen/buildmode/mode(src)
	buttons += modebutton
	buttons += new /atom/movable/screen/buildmode/help(src)
	// keep a reference so we can update it upon dir switch
	dirbutton = new /atom/movable/screen/buildmode/bdir(src)
	buttons += dirbutton
	buttons += new /atom/movable/screen/buildmode/quit(src)
	// build the lists of switching buttons
	build_options_grid(subtypesof(/datum/gm_mode_mode), modeswitch_buttons, /atom/movable/screen/buildmode/modeswitch)
	build_options_grid(GLOB.alldirs, dirswitch_buttons, /atom/movable/screen/buildmode/dirswitch)

// this creates a nice offset grid for choosing between buildmode options,
// because going "click click click ah hell" sucks.
/datum/gm_mode/proc/build_options_grid(list/elements, list/buttonslist, buttontype)
	var/pos_idx = 0
	for(var/thing in elements)
		var/x = pos_idx % switch_width
		var/y = FLOOR(pos_idx / switch_width, 1)
		var/atom/movable/screen/buildmode/B = new buttontype(src, thing)
		// extra .5 for a nice offset look
		B.screen_loc = "NORTH-[(1 + 0.5 + y*1.5)],WEST+[0.5 + x*1.5]"
		buttonslist += B
		pos_idx++

/datum/gm_mode/proc/close_switchstates()
	switch(switch_state)
		if(GM_SWITCHSTATE_MODE)
			close_modeswitch()
		if(GM_SWITCHSTATE_DIR)
			close_dirswitch()

/datum/gm_mode/proc/toggle_modeswitch()
	if(switch_state == GM_SWITCHSTATE_MODE)
		close_modeswitch()
	else
		close_switchstates()
		open_modeswitch()

/datum/gm_mode/proc/open_modeswitch()
	switch_state = GM_SWITCHSTATE_MODE
	holder.screen += modeswitch_buttons

/datum/gm_mode/proc/close_modeswitch()
	switch_state = GM_SWITCHSTATE_NONE
	holder.screen -= modeswitch_buttons

/datum/gm_mode/proc/toggle_dirswitch()
	if(switch_state == GM_SWITCHSTATE_DIR)
		close_dirswitch()
	else
		close_switchstates()
		open_dirswitch()

/datum/gm_mode/proc/open_dirswitch()
	switch_state = GM_SWITCHSTATE_DIR
	holder.screen += dirswitch_buttons

/datum/gm_mode/proc/close_dirswitch()
	switch_state = GM_SWITCHSTATE_NONE
	holder.screen -= dirswitch_buttons

/datum/gm_mode/proc/preview_selected_item(atom/typepath)
	close_preview()
	preview = new /atom/movable/screen/buildmode/preview_item(src)
	preview.name = initial(typepath.name)

	// Scale the preview if it's bigger than one tile
	var/mutable_appearance/preview_overlay = new(typepath)
	var/icon/size_check = icon(initial(typepath.icon), icon_state = initial(typepath.icon_state))
	var/scale = 1
	var/width = size_check.Width()
	var/height = size_check.Height()
	if(width > world.icon_size || height > world.icon_size)
		if(width >= height)
			scale = world.icon_size / width
		else
			scale = world.icon_size / height
	preview_overlay.transform = preview_overlay.transform.Scale(scale)
	preview_overlay.appearance_flags |= TILE_BOUND
	preview_overlay.layer = FLOAT_LAYER
	preview_overlay.plane = FLOAT_PLANE
	preview.add_overlay(preview_overlay)

	holder.screen += preview

/datum/gm_mode/proc/close_preview()
	if(isnull(preview))
		return
	holder.screen -= preview
	QDEL_NULL(preview)

/datum/gm_mode/proc/change_mode(newmode)
	mode.exit_mode(src)
	QDEL_NULL(mode)
	close_switchstates()
	close_preview()
	mode = new newmode(src)
	mode.enter_mode(src)
	modebutton.update_appearance()

/datum/gm_mode/proc/change_dir(newdir)
	build_dir = newdir
	close_dirswitch()
	dirbutton.update_appearance()
	return 1

/datum/gm_mode/proc/InterceptClickOn(mob/user, params, atom/object)
	mode.handle_click(user.client, params, object)
	return TRUE // no doing underlying actions

/proc/togglegm_mode(mob/M as mob in GLOB.player_list)
	if(M.client)
		if(istype(M.client.click_intercept,/datum/gm_mode))
			var/datum/gm_mode/B = M.client.click_intercept
			B.quit()
			log_admin("[key_name(usr)] has left GM mode.")
		else
			new /datum/gm_mode(M.client)
			log_admin("[key_name(usr)] has entered GM mode.")

#undef GM_SWITCHSTATE_NONE
#undef GM_SWITCHSTATE_MODE
#undef GM_SWITCHSTATE_DIR
