#define DEFAULT_CRATE_VERTICAL_OFFSET 10 // Vertical pixel offset of crates when stacked on the cart.

/obj/structure/crate_cart
	name = "platform cart"
	desc = "A platform cart for easily transporting crates and other large objects."
	icon = 'icons/mob/aibots.dmi'
	icon_state = "mulebot0"
	density = TRUE
	var/datum/component/loading/component

/obj/structure/crate_cart/Initialize()
	. = ..()
	component = AddComponent(/datum/component/loading, _offset = 8, _offset_each = 10, _max = 2)
	RegisterSignal(src, COMSIG_MOUSEDROPPED_ONTO, PROC_REF(mousedropped_onto))

/obj/structure/crate_cart/proc/mousedropped_onto(datum/source, atom/movable/AM, mob/user)
	SIGNAL_HANDLER

	var/mob/living/L = user

	if (!istype(L))
		return

	if(user.incapacitated() || (istype(L) && L.body_position == LYING_DOWN))
		return

	if(!istype(AM) || isdead(AM) || iscameramob(AM) || istype(AM, /obj/effect/dummy/phased_mob))
		return

	if(AM.anchored || !isturf(AM.loc))
		return

	if(component.stack[1]) //Something is in the first slot
		if(!istype(component.stack[1], /obj/structure/closet/crate) || !istype(AM, /obj/structure/closet/crate))
			return // Something is on the cart that isn't a crate, so we can't stack it
	component.insert(AM, null, L) // Nothing is on the cart, or it's a crate and we can stack it
