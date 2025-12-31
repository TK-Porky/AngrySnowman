extends Control
class_name LevelFinished

@export var empty_star_texture: Texture2D
@export var full_star_texture: Texture2D

@onready var score_label: Label = $Control/ScoreContainer/ScoreLabel
@onready var stars_container: HBoxContainer = $Control/StarsContainer
@onready var restart_button: Button = $ButtonsContainer/RestartButton
@onready var continue_button: Button = $ButtonsContainer/ContinueButton
@onready var quit_button: Button = $ButtonsContainer/QuitButton

var max_stars := 3
var current_stars := 0
var score := 0

var next_path := "res://scenes/level_select.tscn"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	visible = false
	_update_stars(0)
	_update_score()

	restart_button.pressed.connect(_on_restart_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

# ------------------------------------
# Public API (appelée par LevelController)
# ------------------------------------
func show_screen(level_index: int, final_score: int, stars: int) -> void:
	score = final_score
	current_stars = clamp(stars, 0, max_stars)
	
	GameProgress.set_stars(level_index, current_stars)
	if level_index == GameProgress.TOTAL_LEVELS:
		next_path = "res://scenes/ending_screen.tscn"

	_update_score()
	_update_stars(current_stars)

	visible = true
	get_tree().paused = true

# ------------------------------------
# Score
# ------------------------------------
func _update_score() -> void:
	score_label.text = str(score)

# ------------------------------------
# Stars
# ------------------------------------
func _update_stars(count: int) -> void:
	for i in range(stars_container.get_child_count()):
		var star := stars_container.get_child(i) as TextureRect
		star.texture = full_star_texture if i < count else empty_star_texture

# ------------------------------------
# Buttons
# ------------------------------------
func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_continue_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(next_path)

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
