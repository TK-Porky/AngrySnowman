extends Area2D
class_name Spikes

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: CollisionObject2D) -> void:
	if body is Player:
		audio_stream_player.play()
		body.visible = false
		body.set_physics_process(false)
		body.emit_signal("damage")
