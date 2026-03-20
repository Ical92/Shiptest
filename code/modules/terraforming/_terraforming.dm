/obj/machinery/terraforming
	name = "terraforming machine"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "scrubber:0"

/obj/machinery/terraforming/proc/activate()
	new /datum/terraform_batch(src, 5)

