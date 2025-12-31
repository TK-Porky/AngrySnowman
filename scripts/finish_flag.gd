extends Area2D
class_name LevelFlag

signal level_complete

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: CollisionObject2D) -> void:
	if body is Player:
		emit_signal("level_complete")
