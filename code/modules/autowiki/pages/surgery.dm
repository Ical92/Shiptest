/datum/autowiki/surgery
	page = "Template:Autowiki/Content/Surgeries"

/datum/autowiki/surgery/generate()
	var/list/output = list()

	for(var/datum/surgery/surgery_type as anything in subtypesof(/datum/surgery))
		var/datum/surgery/surgery = new surgery_type
		var/list/targets = list()
		for(var/low_target in surgery.possible_locs)
			targets += capitalize(low_target)

		var/target = jointext(targets, ", ")
		var/need_exposed
		if(!surgery.ignore_clothes)
			need_exposed = "1"

		output[surgery.name] = include_template("Autowiki/Surgery", list(
			"name" = escape_value(surgery.name),
			"desc" = escape_value(surgery.desc),
			"target" = escape_value(target),
			"needexposed" = need_exposed,
			"steps" = generate_steps(surgery.steps)
		))

	return output

/datum/autowiki/surgery/proc/generate_steps(var/list/steps)
	var/all_steps = ""
	for(var/i=1, i<steps.len, i++)

		var/datum/surgery_step/step = steps[i]

		var/step_name = capitalize(step.name)
		var/tool = step.implements[1]

		var/alternatives = ""
		for(var/key in step.implements)
			var/filename
			if(key == tool) // Skip default tool
				continue

			var/obj/item/check
			if(ispath(check, key)) // Alternate uses some other qualifier applying to many items
				var/icon/icon = new('icons/effects/mapping/random_spawners.dmi', "scalpel")
				upload_icon(icon, "wildcard")
			else
				var/obj/O = new(key)
				filename = SANITIZE_FILENAME(escape_value(O.name))
				upload_icon(getFlatIcon(key, no_anim = TRUE), filename)
			var/chance = step.implements[key]

			alternatives += "\[\[File:Autowiki-[filename].png]][chance]%"

		all_steps += include_template("Autowiki/SurgeryStep", list(
			"name" = escape_value(step_name),
			"number" = i,
			"tool" = escape_value(tool),
			"alternate" = alternatives
		))

	return all_steps

