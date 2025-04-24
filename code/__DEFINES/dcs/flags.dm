//! Flags for [Elements][/datum/element] and [Components][/datum/component]

/// Return this from [/datum/component/proc/Initialize] or [datum/component/proc/TakeComponent] to have the component be deleted if it's applied to an incorrect type.
/// `parent` must not be modified if this is to be returned.
/// This will be noted in the runtime logs
#define COMPONENT_INCOMPATIBLE 1

/// Return this from [/datum/element/proc/Attach] to have the element not attach, and crash.
#define ELEMENT_INCOMPATIBLE 1

/// Causes the detach proc to be called when the host object is being deleted
#define ELEMENT_DETACH (1 << 0)
///Only elements created with the same arguments given after `id_arg_index` share an element instance
///The arguments are the same when the text and number values are the same and all other values have the same ref
#define ELEMENT_BESPOKE (1 << 1)
/// Causes all detach arguments to be passed to detach instead of only being used to identify the element
/// When this is used your Detach proc should have the same signature as your Attach proc
#define ELEMENT_COMPLEX_DETACH (1 << 2)

//! How multiple components of the exact same type are handled in the same datum
/// old component is deleted (default)
#define COMPONENT_DUPE_HIGHLANDER 0
/// duplicates allowed
#define COMPONENT_DUPE_ALLOWED 1
/// new component is deleted
#define COMPONENT_DUPE_UNIQUE 2
/// old component is given the initialization args of the new
#define COMPONENT_DUPE_UNIQUE_PASSARGS 4
/// each component of the same type is consulted as to whether the duplicate should be allowed
#define COMPONENT_DUPE_SELECTIVE 5
