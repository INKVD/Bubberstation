/datum/design/crewmonitor
	name = "Handheld crew monitor"
	desc = "A miniature machine that tracks suit sensors across the station."
	id = "crewmonitor"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver = SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/sensor_device
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/clone_disk
	name = "DNA Cloning Scan-disk"
	desc = "A disk with an inbuilt DNA scanner. It can be placed onto an organism to store its genetic sequence, and then used to clone said organism."
	id = "clone_disk"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT * 2, /datum/material/silver = SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/disk/cloning
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
