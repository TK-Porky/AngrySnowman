extends Control
class_name HUD

@export var empty_star_texture: Texture2D
@export var full_star_texture: Texture2D

@onready var sugar_counter_label: Label = $CaneContainer/HBoxContainer2/SugarCounterLabel
@onready var lives_counter_label: Label = $HeartContainer/HBoxContainer/LivesCounterLabel
@onready var container: HBoxContainer = $StarsContainer/Container

var max_stars := 3
var current_stars := 0
var sugars_collected := 0
var total_sugars := 0
var lives := 3

func _ready():
	_update_sugars()
	_update_lives()
	_update_stars(0)

# ------------------------------------
# Lives
# ------------------------------------
func set_lives(value: int) -> void:
	lives = max(value, 0)
	_update_lives()

func _update_lives() -> void:
	lives_counter_label.text = str(lives)

# ------------------------------------
# Sugars / Collectibles
# ------------------------------------
func set_total_sugars(value: int) -> void:
	total_sugars = value
	_update_sugars()

func add_sugar(amount: int = 1) -> void:
	sugars_collected += amount
	_update_sugars()

func _update_sugars() -> void:
	if total_sugars > 0:
		sugar_counter_label.text = "%d" % [sugars_collected]
	else:
		sugar_counter_label.text = str(sugars_collected)

# ------------------------------------
# Stars
# ------------------------------------
func set_stars(count: int) -> void:
	current_stars = clamp(count, 0, max_stars)
	_update_stars(current_stars)

func _update_stars(count: int) -> void:
	for i in range(container.get_child_count()):
		var star := container.get_child(i) as TextureRect
		star.texture = full_star_texture if i < count else empty_star_texture
