extends CharacterBody2D
class_name PushableBlock

# Properties
@export var FRICTION: float = 5.0

func _physics_process(delta: float) -> void:
	_handle_gravity(delta)
	move_and_slide()
	reset(delta)

# Add the gravity.
func _handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

# Push the block
func push(push_direction: float, push_force: float) -> void:
	if is_on_floor():
		velocity.x = push_direction * push_force

# Reset the velocity
func reset(delta: float) -> void:
	velocity.x = lerp(velocity.x, 0.0, delta * FRICTION)
