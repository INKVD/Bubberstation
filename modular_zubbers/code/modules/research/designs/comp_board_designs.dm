/datum/design/board/minesweeper
	name = "Minesweeper Arcade Machine Board"
	desc = "Allows for the construction of circuit boards used to build a new arcade machine."
	id = "minesweeper"
	build_path = /obj/item/circuitboard/computer/arcade/minesweeper
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/cloning
	name = "Machine Design (Cloning Console)"
	desc = "The circuit board for a cloning console."
	id = "cloning_console"
	build_path = /obj/item/circuitboard/computer/cloning
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
