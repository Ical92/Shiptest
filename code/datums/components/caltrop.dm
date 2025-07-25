/datum/component/caltrop
	var/min_damage
	var/max_damage
	var/probability
	var/flags

	var/cooldown = 0

	///given to connect_loc to listen for something moving over target
	var/static/list/crossed_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)

/datum/component/caltrop/Initialize(_min_damage = 0, _max_damage = 0, _probability = 100, _flags = NONE)
	. = ..()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	min_damage = _min_damage
	max_damage = max(_min_damage, _max_damage)
	probability = _probability
	flags = _flags

	if(ismovable(parent))
		AddComponent(/datum/component/connect_loc_behalf, parent, crossed_connections)
	else
		RegisterSignal(get_turf(parent), COMSIG_ATOM_ENTERED, PROC_REF(on_entered))

// Inherit the new values passed to the component
/datum/component/caltrop/InheritComponent(datum/component/caltrop/new_comp, original, min_damage, max_damage, probability, flags, soundfile)
	if(!original)
		return
	if(min_damage)
		src.min_damage = min_damage
	if(max_damage)
		src.max_damage = max_damage
	if(probability)
		src.probability = probability
	if(flags)
		src.flags = flags

/datum/component/caltrop/proc/on_entered(datum/source, atom/movable/AM, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	if(!prob(probability))
		return

	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		var/atom/A = parent		//WS Edit

		if(HAS_TRAIT(H, TRAIT_PIERCEIMMUNE))
			return

		if((flags & CALTROP_IGNORE_WALKERS) && H.m_intent == MOVE_INTENT_WALK)
			return

		//move these next two down a level if you add more mobs to this.
		if(H.is_flying() || H.is_floating()) //check if they are able to pass over us
			return							//gravity checking only our parent would prevent us from triggering they're using magboots / other gravity assisting items that would cause them to still touch us.
		if(H.buckled) //if they're buckled to something, that something should be checked instead.
			return
		if(H.body_position == LYING_DOWN) //if were not standing we cant step on the caltrop
			return

		var/picked_def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
		var/obj/item/bodypart/O = H.get_bodypart(picked_def_zone)
		if(!istype(O))
			return
		if(!IS_ORGANIC_LIMB(O))
			return

		var/feetCover = (H.wear_suit && (H.wear_suit.body_parts_covered & FEET)) || (H.w_uniform && (H.w_uniform.body_parts_covered & FEET))

		if(!(flags & CALTROP_BYPASS_SHOES) && (H.shoes || feetCover))
			return

		var/damage = rand(min_damage, max_damage)
		var/haslightstep = HAS_TRAIT(H, TRAIT_LIGHT_STEP) //BeginWS edit - caltrops don't paralyze people with light step
		if(haslightstep && !H.incapacitated(ignore_restraints = TRUE))
			damage *= 0.75

		if(cooldown < world.time - 10) //cooldown to avoid message spam.
			//var/atom/A = parent		WS edit
			if(!H.incapacitated(ignore_restraints = TRUE))
				if(haslightstep)
					H.visible_message(
						span_danger("[H] carefully steps on [A]."),
						span_danger("You carefully step on [A], but it still hurts!")
					)
				else
					H.visible_message(
						span_danger("[H] steps on [A]."),
						span_userdanger("You step on [A]!")
					)
			else
				H.visible_message(
					span_danger("[H] slides on [A]!"),
					span_userdanger("You slide on [A]!")
				)

			cooldown = world.time
		H.apply_damage(damage, BRUTE, picked_def_zone, wound_bonus = CANT_WOUND)
		if(!haslightstep)
			H.Paralyze(60) //EndWS edit - caltrops don't paralyze people with light step
		if(H.pulledby)								//WS Edit Begin - Being pulled over caltrops is logged
			log_combat(H.pulledby, H, "pulled", A)
		else
			H.log_message("has stepped on [A]", LOG_ATTACK, color="orange")		//WS Edit End

/datum/component/caltrop/UnregisterFromParent()
	if(ismovable(parent))
		qdel(GetComponent(/datum/component/connect_loc_behalf))
	else
		UnregisterSignal(get_turf(parent), list(COMSIG_ATOM_ENTERED))
