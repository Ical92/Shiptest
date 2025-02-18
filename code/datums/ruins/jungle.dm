// Hey! Listen! Update _maps\map_catalogue.txt with your new ruins!

/datum/map_template/ruin/jungle
	prefix = "_maps/RandomRuins/JungleRuins/"
	ruin_type = RUINTYPE_JUNGLE

/datum/map_template/ruin/jungle/syndicate
	name = "Jungle Syndicate Bunker"
	id = "syndicatebunkerjungle"
	description = "A small bunker owned by the Syndicate."
	suffix = "jungle_syndicate.dmm"
	ruin_tags = list(RUIN_TAG_MEDIUM_COMBAT, RUIN_TAG_MEDIUM_LOOT, RUIN_TAG_LIVEABLE)

/datum/map_template/ruin/jungle/interceptor
	name = "Old Crashed Interceptor"
	id = "crashedcondor"
	description = "An overgrown crashed Condor Class, a forgotten remnant of the Corporate Wars."
	suffix = "jungle_interceptor.dmm"
	ruin_tags = list(RUIN_TAG_NO_COMBAT, RUIN_TAG_MEDIUM_LOOT, RUIN_TAG_LIVEABLE)

/datum/map_template/ruin/jungle/paradise
	name = "Hidden paradise"
	id = "paradise"
	description = "a crashed shuttle, and a hidden beautiful lake."
	suffix = "jungle_paradise.dmm"
	ruin_tags = list(RUIN_TAG_MEDIUM_COMBAT, RUIN_TAG_MEDIUM_LOOT, RUIN_TAG_LIVEABLE, RUIN_TAG_HAZARDOUS)

/datum/map_template/ruin/jungle/airbase
	name = "Abandoned Airbase"
	id = "airbase"
	description = "An abandoned airbase dating back to the ICW, partially scuttled, and moved right back into by the Ramzi Clique."
	suffix = "jungle_bombed_starport.dmm"
	ruin_tags = list(RUIN_TAG_HARD_COMBAT, RUIN_TAG_MAJOR_LOOT, RUIN_TAG_HAZARDOUS, RUIN_TAG_LIVEABLE)

/datum/map_template/ruin/jungle/medtech
	name = "MedTech facility"
	id = "medtech-facility"
	description = "A MedTech pharmaceutical manufacturing plant where something went terribly wrong."
	suffix = "jungle_medtech_outbreak.dmm"
	ruin_tags = list(RUIN_TAG_MEDIUM_COMBAT, RUIN_TAG_MEDIUM_LOOT, RUIN_TAG_LIVEABLE)

/datum/map_template/ruin/jungle/cavecrew
	name = "Frontiersmen Cave"
	id = "cavecrew"
	description = "A frontiersmen base, hidden within a cave. They don't seem friendly"
	suffix = "jungle_cavecrew.dmm"
	ruin_tags = list(RUIN_TAG_MEDIUM_COMBAT, RUIN_TAG_HAZARDOUS, RUIN_TAG_LIVEABLE, RUIN_TAG_MAJOR_LOOT)
