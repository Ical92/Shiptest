#define DEFAULT_CRATE_VERTICAL_OFFSET 10 // Vertical pixel offset of crates when stacked on the cart.
#define DEFAULT_LOAD_TIME 1 SECONDS // Default interaction delay of the cart

/obj/structure/platform_cart
	name = "platform cart"
	desc = "A platform cart for easily transporting crates and other large objects."
	icon = 'icons/mob/aibots.dmi'
	icon_state = "mulebot0"
	density = TRUE

	var/datum/component/loading/component
	var/load_time = DEFAULT_LOAD_TIME

/obj/structure/platform_cart/Initialize()
	. = ..()
	component = AddComponent(/datum/component/loading, _offset = 8, _offset_each = 10, _max = 2)
	RegisterSignal(src, COMSIG_MOUSEDROPPED_ONTO, PROC_REF(mousedropped_onto))

/obj/structure/platform_cart/proc/mousedropped_onto(datum/source, atom/movable/AM, mob/user)
	SIGNAL_HANDLER_DOES_SLEEP

	var/mob/living/L = user

	if (!istype(L) || !istype(AM)) // Type checks
		return

	if(user.incapacitated() || L.body_position == LYING_DOWN) // User state checks
		return

	if(!AM.density || !isturf(AM.loc) || AM.anchored || !Adjacent(AM)) // Only able to load dense atoms that aren't anchored and are on the ground next to the cart
		return

	if(user && !do_after(user, load_time, target = AM))
		return FALSE

	var/obj/structure/platform_cart/other_cart = AM
	if (istype(other_cart)) // Attempt to link/unlink two carts
		if(pulling)
			pulling = AM
			AM.set_pulledby(src)
			balloon_alert(user, "carts unlinked")
		else
			AM.set_pulledby(src)
			pulling = (AM)
			balloon_alert(user, "carts linked")
		return TRUE

	var/obj/structure/closet/crate/crate = AM
	if(istype(crate) && crate.opened)
		crate.close() // For convenience, close a crate before trying to load it

	if(component.stack[1]) //Something is in the first slot
		if(!istype(component.stack[1], /obj/structure/closet/crate) || !istype(crate))
			return // Something is on the cart that isn't a crate, so we can't stack a crate on it
	component.insert(AM, null, user) // Nothing is on the cart, or both are crates and we can stack onto it
