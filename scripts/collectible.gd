extends Area2D
class_name Collectible

signal collected

@export var float_offset := Vector2(0, -16)
@export var float_duration := 1.2

@export var collect_rise_distance := 24.0
@export var collect_duration := 0.6

var start_position: Vector2
var is_collected := false

@onready var sprite: Sprite2D = $Sprite2D
@onready var collect_sound: AudioStreamPlayer2D = $CollectSound

func _ready():
	start_position = global_position
	body_entered.connect(_on_body_entered)
	_start_idle_float()

# -----------------------------
# Idle floating animation
# -----------------------------
func _start_idle_float():
	var tween := create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "global_position", start_position + float_offset, float_duration / 2)

	tween.tween_property(self, "global_position", start_position, float_duration / 2)

# -----------------------------
# Collect behavior
# -----------------------------
func _on_body_entered(body):
	if is_collected:
		return

	if body is Player:
		collect_sound.play()
		is_collected = true
		monitoring = false
		_collect()

func _collect():
	emit_signal("collected")
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)

	# Move up
	tween.tween_property(
		self,
		"global_position:y",
		global_position.y - collect_rise_distance,
		collect_duration
	)

	# Fade out
	tween.parallel().tween_property(
		sprite,
		"modulate:a",
		0.0,
		collect_duration
	)

	await tween.finished
	queue_free()
