extends CanvasLayer
class_name LevelSelect

@export var level_scenes := [
	"res://levels/level_1.tscn",
	"res://levels/level_2.tscn",
	"res://levels/level_3.tscn",
]

@onready var LevelsContainer: VBoxContainer = $HBoxContainer
@onready var level_1_button: Button = $HBoxContainer/Level1Button
@onready var level_2_button: Button = $HBoxContainer/Level2Button
@onready var level_3_button: Button = $HBoxContainer/Level3Button
@onready var level_4_button: Button = $HBoxContainer/Level4Button
@onready var level_5_button: Button = $HBoxContainer/Level5Button
@onready var back_button: Button = $BackButton

func _ready():
	SoundManager.play_track("Main")
	
	for i in range(level_scenes.size()):
		var button := LevelsContainer.get_child(i) as Button
		var level_number := i + 1
		button.text = "level " + str(level_number)
		if GameProgress.is_level_unlocked(level_number):
			button.disabled = false
			button.pressed.connect(func():
				get_tree().change_scene_to_file(level_scenes[i])
			)
		else:
			button.disabled = true
	back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
