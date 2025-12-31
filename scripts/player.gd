extends CharacterBody2D
class_name Player

signal damage

# Proprieties
@export var SPEED: float = 300.0
@export var ACCEL: float = 10.0
@export var FRICTION: float = 5.0
@export var PUSH_FORCE: float = 25.0
@export var JUMP_VELOCITY: float = -400.0
@export var CLIMB_SPEED: float = 100.0

# Nodes
@onready var right_collider: RayCast2D = $RightCollider
@onready var left_collider: RayCast2D = $LeftCollider
@onready var down_collider: RayCast2D = $DownCollider
@onready var ladder_detection_area: Area2D = $LadderDetectionArea
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

# Refs
var on_ladder: bool = false
var current_ladder: Ladder = null
var push_block: Node2D = null

func _ready() -> void:
	ladder_detection_area.area_entered.connect(_on_area_entered)
	ladder_detection_area.area_exited.connect(_on_area_exited)

func _physics_process(delta: float) -> void:
	if on_ladder:
		handle_ladder()
		global_position.x = lerp(global_position.x, current_ladder.global_position.x,0.2)
	else:
		handle_animation()
		apply_gravity(delta)
		handle_movement(delta)
	_is_outside_room()
	move_and_slide()

# Add the gravity.
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

# Handle movement platformer logic
func handle_movement(delta: float) -> void:
	# Handle Simple Jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		jump_sound.play()
		velocity.y = JUMP_VELOCITY

	# Handle Movement
	var direction := Input.get_axis("Left", "Right")
	if direction:
		animated_sprite_2d.flip_h = true if direction == -1 else false
		velocity.x = lerp(velocity.x, SPEED * direction, delta * ACCEL)
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * FRICTION)

	# Handle Push block logic
	var block = _is_pushing_block()
	if block and is_on_floor():
		block.push(velocity.x, PUSH_FORCE)

	# Handle falling platform activation
	var platform = _is_falling_platform()
	if platform and is_on_floor():
		platform.fall()

# Detect Pushable block aside
func _is_pushing_block() -> PushableBlock:
	if left_collider.is_colliding() and left_collider.get_collider() is PushableBlock:
		return left_collider.get_collider()
	elif right_collider.is_colliding() and right_collider.get_collider() is PushableBlock:
		return right_collider.get_collider()
	return null

# Detect falling platform beneath
func _is_falling_platform() -> FallingPlatform:
	if down_collider.is_colliding() and down_collider.get_collider() is FallingPlatform:
		return down_collider.get_collider()
	return null

# Detect ladder
func _on_area_entered(area):
	if area is Ladder:
		current_ladder = area
		on_ladder = true

func _on_area_exited(area):
	if area == current_ladder:
		current_ladder = null
		on_ladder = false

func handle_ladder() -> void:
	var vertical := Input.get_axis("Up", "Down")

	if vertical:
		velocity.y = vertical * CLIMB_SPEED
		velocity.x = 0

	if not Input.is_action_pressed("Up") and not Input.is_action_pressed("Down"):
		velocity.y = 0

	if Input.is_action_just_pressed("Jump"):
		on_ladder = false

# Detect falling outside room
func _is_outside_room() -> void:
	var screen_size: Rect2 = get_viewport_rect()
	if global_position.y > screen_size.size.y + 250:
		emit_signal("damage")

func handle_animation() -> void:
	if not abs(velocity.x) < 5:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("default")
