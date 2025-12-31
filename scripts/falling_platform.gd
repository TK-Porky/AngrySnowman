extends AnimatableBody2D
class_name FallingPlatform

@export var fall_speed := 900.0
@export var fall_accel := 2000.0
@export var fall_delay := 0.3
@export var respawn_delay := 2.0

var start_position: Vector2
var velocity := 0.0
var is_falling := false
var is_respawning := false

func _ready() -> void:
	start_position = global_position

func _physics_process(delta: float) -> void:
	if is_falling:
		velocity += fall_accel * delta
		global_position.y += velocity * delta

func fall() -> void:
	if is_falling or is_respawning:
		return

	await get_tree().create_timer(fall_delay).timeout
	is_falling = true

	# Lance le respawn
	_start_respawn()

func _start_respawn() -> void:
	is_respawning = true
	await get_tree().create_timer(respawn_delay).timeout

	# Reset plateforme
	global_position = start_position
	velocity = 0.0
	is_falling = false
	is_respawning = false
