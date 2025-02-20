#define DEFAULT_CRATE_VERTICAL_OFFSET 10 // Vertical pixel offset of crates when stacked on the cart.

/obj/structure/crate_cart
	name = "platform cart"
	desc = "A platform cart for easily transporting crates and other large objects."
	icon = 'icons/mob/aibots.dmi'
	icon_state = "mulebot0"
	density = TRUE

	var/list/cart_contents = new()

/obj/structure/crate_cart/Initialize()
	. = ..()

/obj/structure/crate_cart/MouseDrop_T(atom/movable/AM, mob/user)
	var/mob/living/L = user

	if (!istype(L))
		return

	if(user.incapacitated() || (istype(L) && L.body_position == LYING_DOWN))
		return

	if(!istype(AM) || isdead(AM) || iscameramob(AM) || istype(AM, /obj/effect/dummy/phased_mob))
		return

	load(AM)

/obj/structure/crate_cart/proc/load(atom/movable/AM)
	if(AM.anchored)
		return

	if(!isturf(AM.loc)) // To prevent the loading from stuff from someone's inventory or screen icons.
		return

	var/obj/structure/closet/crate/crate = AM
	if(istype(crate))
		if(cart_contents.len >= 2)
			return

	if(crate || isobj(AM))
		var/obj/O = AM
		if(O.has_buckled_mobs() || (locate(/mob) in AM)) // Can't load non crates objects with mobs buckled to it or inside it.
			return

		if(crate)
			crate.close()  // Make sure the crate is closed

		O.forceMove(src)

		cart_contents += AM
		update_appearance()
