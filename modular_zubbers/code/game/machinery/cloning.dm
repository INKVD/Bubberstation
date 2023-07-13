#define CLONE_BIOMASS 150
#define BIOMASS_CHUNK 50

/obj/machinery/cloning_pod
	name = "cloning pod"
	desc = "A pod made for cloning humanoid bodies."
	density = TRUE
	icon = 'modular_zubbers/icons/obj/machines/cloning.dmi'
	icon_state = "pod_idle"
	circuit = /obj/item/circuitboard/machine/cloning_pod

	var/obj/machinery/computer/cloning/linked_consoles = list() ///Consoles using this cloning pod. Pods can be linked to more than one console.
	var/cloning = FALSE ///Tracks if the machine is currently cloning
	var/datum/dna/growing_dna = null ///DNA of the currently growing clone
	var/growth_progress = 0 ///Current clone growth progress
	var/growth_required = 120 ///Amount of progress needed for completion - 2 MINUTES

	var/growth_speed = 1 ///Clone growth speed multiplier

	var/biomass = 0 ///Biomass required for clone growth.
	var/resource_efficiency = 1 ///Improve parts to use less biomass.

/obj/machinery/cloning_pod/Destroy()
	if(cloning)
		fail_clone()
	for(var/LC in linked_consoles)
		var/obj/machinery/computer/cloning/console = LC
		console.unlink_pod(src)
		linked_consoles -= LC
	return ..()

/obj/machinery/cloning_pod/RefreshParts()
	. = ..()
	growth_speed = 0
	var/T = 0
	for(var/obj/item/stock_parts/servo/M in component_parts)
		growth_speed += M.rating * 0.5
		T += M.rating
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		growth_speed += M.rating * 0.5
	resource_efficiency = T/2
	T = 0

/obj/machinery/cloning_pod/update_icon_state()
	. = ..()
	if(cloning)
		icon_state = "pod_cloning"
	else
		icon_state = "pod_idle"

///Initializes the clone growth process
/obj/machinery/cloning_pod/proc/grow_clone(datum/dna/dna)
	if(!is_operational || panel_open)
		return FALSE
	growing_dna = new
	dna.copy_dna(growing_dna)
	cloning = TRUE
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/machinery/cloning_pod/process()
	if(!cloning)
		return FALSE
	if(!is_operational)
		fail_clone()
	growth_progress += growth_speed
	if(growth_progress >= growth_required)
		complete_clone()

///Resets cloner to default, ready to clone again
/obj/machinery/cloning_pod/proc/reset()
	cloning = FALSE
	growth_progress = 0
	growing_dna = null
	STOP_PROCESSING(SSobj, src)
	update_icon()

///Successfully completes cloning, creating a new human and applying the stored dna to it
/obj/machinery/cloning_pod/proc/complete_clone()
	playsound(src, 'sound/machines/twobeep.ogg', 50, FALSE)
	var/mob/living/carbon/human/clone = new(drop_location())
	clone.real_name = growing_dna.real_name
	growing_dna.transfer_identity(clone, TRUE)
	clone.set_cloned_appearance()
	clone.updateappearance(mutcolor_update=TRUE)
	clone.domutcheck()
	visible_message(span_notice("[clone.real_name] steps out of \the [src]!"))
	if(biomass > 0)
		biomass -= CLONE_BIOMASS/resource_efficiency //Improve parts to use less biomass
	else
		biomass = 0
	reset()

///Messily dumps the uncompleted clone, spawning gibs
/obj/machinery/cloning_pod/proc/fail_clone()
	new /obj/effect/gibspawner/generic(get_turf(src), null)
	reset()

/obj/machinery/cloning_pod/attackby(obj/item/W, mob/user, params)
	if(!(cloning))
		if(default_deconstruction_screwdriver(user, "[icon_state]_maintenance", "[initial(icon_state)]",W))
			return

	var/turf/drop_location = drop_location()
	if(default_deconstruction_crowbar(W))
		if(biomass > 0)
			drop_location.visible_message(span_warning("Biomass spills from \the [src]'s biomass tank!"))
			playsound(drop_location, 'sound/effects/slosh.ogg', 25, vary = TRUE)
			new /obj/effect/decal/cleanable/greenglow(drop_location)
		return

	if(istype(W, /obj/item/food/meat/slab/synthmeat))
		playsound(src, 'sound/machines/juicer.ogg', 30, 1)
		to_chat(user, span_notice("\The [src] processes \the [W]."))
		biomass += BIOMASS_CHUNK
		qdel(W)
		return

	if(W.tool_behaviour == TOOL_MULTITOOL)
		if(!multitool_check_buffer(user, W))
			return
		var/obj/item/multitool/P = W

		if(istype(P.buffer, /obj/machinery/computer/cloning))
			if(get_area(P.buffer) != get_area(src))
				to_chat(user, "<font color = #666633>Cannot link machines across power zones. Buffer cleared.</font color>")
				P.buffer = null
				return
			to_chat(user, "<font color = #666633>Successfully linked [P.buffer] with [src]./font color>")
			var/obj/machinery/computer/cloning/console = P.buffer
			console.link_pod(src)
		else
			P.buffer = src
			to_chat(user, "<font color = #666633>Successfully stored [REF(P.buffer)] [P.buffer.name] in buffer.</font color>")
		return

	return ..()

///Dump the unfinished clone if EMPd
/obj/machinery/cloning_pod/emp_act(severity)
	. = ..()
	if (!(. & EMP_PROTECT_SELF) && cloning)
		if(prob(50))
			playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
			fail_clone()
