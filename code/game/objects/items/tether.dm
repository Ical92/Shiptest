/obj/item/tether
	name = "tether kit"
	desc = "A small casing for holding a spool of tether rope. The end has a mag-clamp for attaching to hulls, and a clip for attaching to lattices and railings."
	icon = 'icons/obj/device.dmi'
	icon_state = "signmaker_engi"
	item_state = "electronic"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 30)
	w_class = WEIGHT_CLASS_SMALL

	var/check_delay = 5

	var/tether_name = "tether rope"
	var/can_fire = FALSE
	var/can_retract = FALSE
	var/max_range = 8

	var/last_check = 0
	var/atom/current_target
	var/datum/beam/current_tether = null
	var/active = FALSE
	var/broken = FALSE
	var/current_range = 8

/obj/item/tether/Initialize()
	. = ..()

/obj/item/tether/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/tether/examine(mob/user)
	. = ..()
	if(can_fire)
		. += "<span class='notice'>The [tether_name] is attached to a spring-loaded launcher, allowing it to be fired at flat surfaces.</span>"
	if(can_retract)
		. += "<span class='notice'>The [tether_name] is fed into an attached pulley, allowing it to be retracted quickly.</span>"
	if(broken)
		. += "<span class'warning'>The [tether_name] is unspooled and needs fixed with a screwdriver!</span>"

/obj/item/tether/dropped(mob/user)
	..()
	if(loc != user && active)
		src.visible_message("<span class='warning'>The [tether_name] suddenly retracts!</span>")
		LoseTarget(user)

/obj/item/tether/proc/LoseTarget(mob/user)
	if(active)
		playsound(src, 'sound/items/zip.ogg', 30, TRUE)
		active = FALSE
		qdel(current_tether)
		current_tether = null
	for (var/datum/component/tether/component in user.GetComponents(/datum/component/tether))
		if(component.holder == src)
			qdel(component)
			break
	if(!length(user.GetComponents(/datum/component/tether)))
		user.RemoveElement(/datum/element/forced_gravity, TRUE, TRUE)
		user.update_gravity(user.has_gravity())
	current_target = null
	STOP_PROCESSING(SSobj, src)

/obj/item/tether/proc/tether_broke()
	if(isliving(loc) && active)
		loc.visible_message("<span class='danger'>The [tether_name] snaps!</span>")
		broken = TRUE
	active = FALSE
	LoseTarget(loc)

/obj/item/tether/attack_self(mob/user)
	if(can_retract && active)
		user.visible_message("<span class='notice'>[user] retracts the [tether_name].</span>",\
			"<span class='notice'>You retract the [tether_name].</span>")
		LoseTarget(user)
	else if(active && user.CanReach(current_target, src, TRUE))
		user.visible_message("<span class='notice'>[user] [isclosedturf(current_target) ? "detaches" : "unclips"] the [tether_name] from \the [current_target].</span>",\
			"<span class='notice'>You [isclosedturf(current_target) ? "detach" : "unclip"] the [tether_name] from \the [current_target].</span>")
		playsound(src, 'sound/misc/box_deploy.ogg', 30, TRUE)
		user.changeNext_move(CLICK_CD_RANGE)
		LoseTarget(user)


/obj/item/tether/pre_attack(atom/target, mob/living/user)
	. = ..()

	if(broken)
		playsound(src, 'sound/weapons/gun/pistol/dry_fire.ogg', 30, TRUE)
		to_chat(user, "<span class='warning'>The [tether_name] is unspooled!</span>")
		return TRUE
	if(active)
		if(target == current_target && user.CanReach(target, src, TRUE))
			user.visible_message("<span class='notice'>[user] [isclosedturf(target) ? "detaches" : "unclips"] the [tether_name] from \the [target].</span>",\
				"<span class='notice'>You [isclosedturf(target) ? "detach" : "unclip"] the [tether_name] from \the [target].</span>")
			playsound(src, 'sound/misc/box_deploy.ogg', 30, TRUE)
			user.changeNext_move(CLICK_CD_RANGE)
			LoseTarget(user)
			return TRUE
		if(can_retract && (isclosedturf(target) || istype(target, /obj/structure/railing) || istype(target, /obj/structure/lattice)) && user.CanReach(target, src, TRUE))
			user.visible_message("<span class='notice'>[user] quickly retracts the [tether_name] and [isclosedturf(target) ? "reattaches" : "clips"] it to \the [target].</span>",\
				"<span class='notice'>You quickly retract the [tether_name] and [isclosedturf(target) ? "reattach" : "clip"] it to \the [target].</span>")
			LoseTarget(user)
			playsound(src, 'sound/misc/box_deploy.ogg', 30, TRUE)
			fire_tether(target, user)
			return TRUE
	else
		if(!los_check(user, target))
			return FALSE
		if(user.CanReach(target, src, TRUE))
			if(isclosedturf(target))
				user.visible_message("<span class='notice'>[user] attaches the [tether_name] to \the [target].</span>",\
					"<span class='notice'>You attach the [tether_name] to \the [target].</span>")
				playsound(src, 'sound/misc/box_deploy.ogg', 30, TRUE)
				fire_tether(target, user)
				return TRUE
			if(istype(target, /obj/structure/railing) || istype(target, /obj/structure/lattice))
				user.visible_message("<span class='notice'>[user] clips the [tether_name] to \the [target].</span>",\
					"<span class='notice'>You clip the [tether_name] to \the [target].</span>")
				playsound(src, 'sound/misc/box_deploy.ogg', 30, TRUE)
				fire_tether(target, user)
				return TRUE
		else if(can_fire)
			if(isclosedturf(target))
				user.visible_message("<span class='notice'>[user] fires the [tether_name] at \the [target], and it attaches!</span>",\
					"<span class='notice'>You fire the [tether_name] at \the [target], and it attaches!</span>")
				playsound(src, 'sound/weapons/gun/pistol/shot_suppressed.ogg', 30, TRUE)
				fire_tether(target, user)
				return TRUE
			if(!isgroundlessturf(target))
				user.visible_message("<span class='warning'>[user] fires the [tether_name] at \the [target], but it ricochets off!</span>",\
					"<span class='warning'>You fire the [tether_name] at \the [target], but it ricochets off!</span>")
				playsound(src, 'sound/weapons/gun/pistol/shot_suppressed.ogg', 30, TRUE)
				user.changeNext_move(CLICK_CD_RANGE)
				return TRUE
	return ..()

/obj/item/tether/proc/fire_tether(atom/target, mob/living/user)
	current_target = target
	active = TRUE
	current_tether = user.Beam(current_target, icon_state="tether", maxdistance = max_range, beam_type = /obj/effect/ebeam/tether)
	user.AddElement(/datum/element/forced_gravity, TRUE, TRUE)
	user.AddComponent(/datum/component/tether, target, max_range, tether_name, src)
	user.update_gravity(user.has_gravity())
	user.changeNext_move(CLICK_CD_RANGE)
	START_PROCESSING(SSobj, src)
	RegisterSignal(current_tether, COMSIG_PARENT_QDELETING, PROC_REF(tether_broke))

/obj/item/tether/process()

	if(!current_target)
		LoseTarget(loc)
		return

	if(world.time <= last_check+check_delay)
		return

	last_check = world.time

	if(!los_check(loc, current_target))
		qdel(current_tether)
		return

/obj/item/tether/proc/los_check(atom/movable/user, turf/target_turf)
	var/turf/user_turf = user.loc
	if(!istype(user_turf))
		return 0
	for(var/turf/T in getline(user_turf, target_turf))
		if (T.density && T != target_turf)
			return FALSE
		for(var/a in T)
			var/atom/A = a
			if(A.density && A != user && A != target_turf)
				return FALSE
	return 1

/obj/item/tether/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(broken)
		to_chat(user, "<span class='notice'>You start rewinding the spool of [tether_name].</span>")
		if(!do_after(user, 4 SECONDS))
			return
		to_chat(user, "<span class='notice'>You rewind the spool of [tether_name].</span>")
		I.play_tool_sound(src)
		return TRUE
	if(active)
		to_chat(user, "<span class='warning'>You can't reach the clamp to adjust it while the [src] is active!</span>")
		return
	current_range = ((current_range) % (max_range - 1) + 2)
	to_chat(user, "<span class='notice'>You adjust the [tether_name] length to [current_range] tiles.</span>")
	return TRUE

/obj/effect/ebeam/tether
	name = "thin rope"
	desc = "A thin, tethering rope."

/obj/item/tether/advanced
	name = "advanced tether kit"
	can_fire = TRUE
	can_retract = TRUE
	tether_name = "chained tether rope"
