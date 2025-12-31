extends Node

const SAVE_PATH := "user://progress.save"

var unlocked_level := 1
var stars_per_level := {}

const TOTAL_LEVELS := 3

func _ready():
	load_progress()

func save_progress():
	var data = {
		"unlocked_level": unlocked_level,
		"stars_per_level": stars_per_level
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(data)

func set_stars(level: int, stars: int):
	stars = clamp(stars, 0, 3)
	stars_per_level[level] = max(stars, stars_per_level.get(level, 0))
	save_progress()

func has_all_stars() -> bool:
	for level in range(1, TOTAL_LEVELS + 1):
		if get_stars(level) < 3:
			return false
	return true

func get_stars(level: int) -> int:
	return stars_per_level.get(level, 0)

func load_progress():
	if not FileAccess.file_exists(SAVE_PATH):
		save_progress()
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = file.get_var()

	unlocked_level = data.get("unlocked_level", 1)
	stars_per_level = data.get("stars_per_level", {})

func unlock_level(level_index: int):
	if level_index > unlocked_level:
		unlocked_level = level_index
		save_progress()

func is_level_unlocked(level_index: int) -> bool:
	return level_index <= unlocked_level
