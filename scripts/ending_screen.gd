extends CanvasLayer
@onready var back_button: Button = $BackButton

@onready var secret_text: Label = $SecretText

func _ready():
	SoundManager.play_track("Main")
	if GameProgress.has_all_stars():
		secret_text.visible = true

	back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
