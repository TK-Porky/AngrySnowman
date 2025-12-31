extends AnimatableBody2D
class_name MovingPlatform

# Properties
@export var offset := Vector2(0, -320)
@export var duration := 5.0

# Initial Position
var start_position: Vector2

func _ready():
	start_position = global_position
	start_tween()

func start_tween():
	var tween := create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops()
	tween.tween_property(self, "global_position", start_position + offset, duration / 2)
	tween.tween_property(self, "global_position", start_position, duration / 2)
