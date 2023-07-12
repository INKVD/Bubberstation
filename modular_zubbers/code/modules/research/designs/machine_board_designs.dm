/datum/design/board/plantgenes
	name = "Plant Gene Editor Board"
	desc = "The circuit board for a plant gene editing machine."
	id = "plantgene"
	build_path = /obj/item/circuitboard/machine/plantgenes
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/cloning_pod
	name = "Machine Design (Cloning Pod)"
	desc = "The circuit board for a cloning pod."
	id = "cloning_pod"
	build_path = /obj/item/circuitboard/machine/cloning_pod
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
