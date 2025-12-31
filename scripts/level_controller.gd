extends Node
class_name LevelController

@export var level_index := 1
@export var required_collectibles := -1
@export var finish_flag: LevelFlag

@onready var victory_screen: Control = $"../UI/LevelFinished"
@onready var failed_screen: Control = $"../UI/GameOver"
@onready var hud: HUD = $"../UI/HUD"

var player: Player
var player_lives := 3
var player_start_position: Vector2
var level_failed := false

var total_collectibles := 0
var collected_collectibles := 0
var level_completed := false

func _ready():
	_register_flag()
	_register_collectibles()
	_register_player()
	hud.set_lives(player_lives)
	hud.set_total_sugars(total_collectibles)
	SoundManager.play_track("World1")

func _process(_delta: float) -> void:
	hud.set_stars(calculate_stars())

func calculate_stars() -> int:
	if collected_collectibles == total_collectibles:
		return 3
	elif collected_collectibles >= total_collectibles * 0.7:
		return 2
	elif collected_collectibles >= total_collectibles * 0.4:
		return 1
	return 0

func _register_collectibles():
	var collectibles := get_tree().get_nodes_in_group("Collectibles")
	total_collectibles = collectibles.size()
	if required_collectibles < 0:
		required_collectibles = total_collectibles
	for collectible in collectibles:
		collectible.collected.connect(_on_collectible_collected)
	print("Collectibles: ", total_collectibles)

func _register_player() -> void:
	player = get_tree().current_scene.get_node("Player")
	if player:
		player_start_position = player.global_position
		player.damage.connect(_on_player_damage)
		print("Player Connected!")
	else:
		push_error("Player is missing!")

func _register_flag() -> void:
	if not finish_flag:
		finish_flag = get_tree().current_scene.get_node("FinishFlag")
	
	if not finish_flag == null:
		finish_flag.level_complete.connect(_complete_level)
	else:
		return

func _on_collectible_collected():
	if level_completed:
		return
	collected_collectibles += 1
	hud.add_sugar()
	_check_level_completion()

func calculate_score() -> int:
	return collected_collectibles * 100

func _on_player_damage() -> void:
	if player_lives < 1 or level_failed:
		_failed_level()
		return
	player_lives -= 1
	hud.set_lives(player_lives)
	player.global_position = player_start_position
	player.set_physics_process(true)
	player.visible = true

func _failed_level() -> void:
	level_failed = true
	failed_screen.visible = true
	hud.visible = false

func _check_level_completion():
	if finish_flag:
		return
	
	if collected_collectibles >= required_collectibles:
		_complete_level()

func _complete_level() -> void:
	var stars := calculate_stars()
	var score := calculate_score()
	GameProgress.unlock_level(level_index + 1)
	hud.visible = false
	victory_screen.show_screen(level_index, score, stars)
