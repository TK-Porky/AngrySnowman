extends Node

var total_levels := 5
var levels_unlocked := 1

func unlocked_next_level() -> void:
	if levels_unlocked < total_levels:
		levels_unlocked += 1
