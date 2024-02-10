class_name Penguin
extends CharacterBody3D

@export_subgroup("Components")
@export var view: Node3D

@export_subgroup("Properties")
@export var movement_speed: int = 250
@export var jump_strength: int = 7

var current: bool = false : set=set_current
var movement_velocity: Vector3
var rotation_direction: float
var gravity: float = 0.0

var previously_floored: bool = false

var jump_single: bool = true
var jump_double: bool = true

@onready var model = $CharacterModel
@onready var animation = $CharacterModel/AnimationPlayer


func _physics_process(delta: float) -> void:
	handle_controls(delta)
	handle_gravity(delta)
	handle_effects()
	
	var applied_velocity: Vector3
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	velocity = applied_velocity
	move_and_slide()
	
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()
	
	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)
	
	# Falling/respawning
	if position.y < -10:
		get_tree().reload_current_scene()
	
	# Animation for scale (jumping and landing)
	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)
	
	# Animation when landing
	if is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)
	
	previously_floored = is_on_floor()


func set_current(value: bool) -> void:
	current = value
	%Arrow.visible = current
	
	if current:
		%ArrowAnim.play("animate")
	else:
		%ArrowAnim.stop()


func handle_effects() -> void:
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			animation.play("walk", 0.5)
		else:
			animation.play("idle", 0.5)
	else:
		animation.play("jump", 0.5)


func handle_controls(delta : float) -> void:
	var input := Vector3.ZERO
	
	if current:
		input.x = Input.get_axis("move_left", "move_right")
		input.z = Input.get_axis("move_forward", "move_backward")
	
	input = input.rotated(Vector3.UP, view.rotation.y).normalized()
	movement_velocity = input * movement_speed * delta
	
	if current and Input.is_action_just_pressed("jump"):
		if jump_double:
			gravity = -jump_strength
			
			jump_double = false
			model.scale = Vector3(0.5, 1.5, 0.5)

		if(jump_single):
			jump()


func handle_gravity(delta: float) -> void:
	gravity += 25 * delta
	
	if gravity > 0 and is_on_floor():
		jump_single = true
		gravity = 0


func jump() -> void:
	gravity = -jump_strength
	
	model.scale = Vector3(0.5, 1.5, 0.5)
	
	jump_single = false
	jump_double = true
