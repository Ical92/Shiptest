/datum/disease/gastrolosis
	name = "Invasive Gastrolosis"
	max_stages = 4
	spread_text = "Unknown"
	spread_flags = DISEASE_SPREAD_SPECIAL
	cure_text = "Salt and mutadone"
	agent = "Agent S and DNA restructuring"
	viable_mobtypes = list(/mob/living/carbon/human)
	stage_prob = 1
	disease_flags = CURABLE
	cures = list(/datum/reagent/consumable/sodiumchloride,  /datum/reagent/medicine/mutadone)

/datum/disease/gastrolosis/stage_act()
	..()
	if(is_species(affected_mob, /datum/species/snail))
		cure()
	switch(stage)
		if(2)
			if(prob(2))
				affected_mob.emote("gag")
			if(prob(1))
				var/turf/open/OT = get_turf(affected_mob)
				if(isopenturf(OT))
					OT.MakeSlippery(TURF_WET_LUBE, 40)
		if(3)
			if(prob(5))
				affected_mob.emote("gag")
			if(prob(5))
				var/turf/open/OT = get_turf(affected_mob)
				if(isopenturf(OT))
					OT.MakeSlippery(TURF_WET_LUBE, 100)
		if(4)
			var/obj/item/organ/eyes/eyes = locate(/obj/item/organ/eyes/snail) in affected_mob.internal_organs
			if(!eyes && prob(5))
				var/obj/item/organ/eyes/snail/new_eyes = new()
				new_eyes.Insert(affected_mob, drop_if_replaced = TRUE)
				affected_mob.visible_message(span_warning("[affected_mob]'s eyes fall out, with snail eyes taking its place!"), \
				span_userdanger("You scream in pain as your eyes are pushed out by your new snail eyes!"))
				affected_mob.force_scream()
				return
			var/obj/item/organ/tongue/tongue = locate(/obj/item/organ/tongue/snail) in affected_mob.internal_organs
			if(!tongue && prob(5))
				var/obj/item/organ/tongue/snail/new_tongue = new()
				new_tongue.Insert(affected_mob)
				to_chat(affected_mob, span_userdanger("You feel your speech slow down..."))
				return
			if(eyes && tongue && prob(5))
				affected_mob.set_species(/datum/species/snail)
				affected_mob.client?.give_award(/datum/award/achievement/misc/snail, affected_mob)
				affected_mob.visible_message(span_warning("[affected_mob] turns into a snail!"), \
				span_boldnotice("You turned into a snail person! You feel an urge to cccrrraaawwwlll..."))
				cure()
			if(prob(10))
				affected_mob.emote("gag")
			if(prob(10))
				var/turf/open/OT = get_turf(affected_mob)
				if(isopenturf(OT))
					OT.MakeSlippery(TURF_WET_LUBE, 100)

/datum/disease/gastrolosis/cure()
	. = ..()
	if(affected_mob && !is_species(affected_mob, /datum/species/snail)) //undo all the snail fuckening
		var/mob/living/carbon/human/H = affected_mob
		var/obj/item/organ/tongue/tongue = locate(/obj/item/organ/tongue/snail) in H.internal_organs
		if(tongue)
			var/obj/item/organ/tongue/new_tongue = new H.dna.species.mutanttongue ()
			new_tongue.Insert(H)
		var/obj/item/organ/eyes/eyes = locate(/obj/item/organ/eyes/snail) in H.internal_organs
		if(eyes)
			var/obj/item/organ/eyes/new_eyes = new H.dna.species.mutanteyes ()
			new_eyes.Insert(H)
