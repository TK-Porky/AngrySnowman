extends CanvasLayer
class_name MainMenu

@onready var start_button: Button = $HBoxContainer/StartButton
@onready var music_button: Button = $HBoxContainer/MusicButton
@onready var quit_button: Button = $HBoxContainer/QuitButton

func _ready() -> void:
	SoundManager.play_track("Main")
	music_button.text =  "music: OFF" if SoundManager.stream_paused else "music: ON"
	
	start_button.pressed.connect(_on_start_pressed)
	music_button.pressed.connect(_on_music_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_music_pressed() -> void:
	toggle_music()

func _on_quit_pressed() -> void:
	get_tree().quit()

func toggle_music() -> void:
	SoundManager.stream_paused = !SoundManager.stream_paused
	music_button.text =  "music: OFF" if SoundManager.stream_paused else "music: ON"
