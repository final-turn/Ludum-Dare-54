class_name President extends CharacterBody3D

signal on_health_update(health, damage)

@export var serviceman_array : ServicemanArray
@export var environment : ClickEnvironment

@export var health : int = 100
@export var base_move_speed = 3
@export var base_stand_time = 6
@export var rotation_speed = 0.1
@export var move_length = 3
@export var scaled_remaining : float = 0

@onready var warning = $"Warning Texture"
@onready var anim_tree = $"Visuals/AnimationTree"
@onready var damageable = $"Visuals/Armature/Skeleton3D/lower_poly/Node"

var rng : RandomNumberGenerator
var time_elapsed : float = 0
var target_position : Vector3 = Vector3(0,0,0)
var move_duration : float = 0
var rotation_direction : float = 1
var move_speed = 3
var stand_time = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	environment.mouse_world_position.connect(serviceman_array.on_mouse_world_position)

func _physics_process(delta):
	move_speed = base_move_speed + (2 * scaled_remaining)
	stand_time = base_stand_time - (base_stand_time - 1) * scaled_remaining
	
	if move_duration <= 0:
		velocity.x = move_toward(velocity.x, 0, move_speed * (1.01 - scaled_remaining))
		velocity.z = move_toward(velocity.z, 0, move_speed * (1.01 - scaled_remaining))
		if time_elapsed > stand_time:
			time_elapsed = 0
			move_duration = move_length
		else:
			time_elapsed += delta
			rotate_y(rotation_direction * delta * rotation_speed * (1 + (4 * scaled_remaining)))
	else:
		move_duration -= delta
		var direction = (transform.basis * Vector3.FORWARD).normalized()
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed

	anim_tree.set("parameters/conditions/isIdle", move_duration <= 0)
	anim_tree.set("parameters/conditions/isMoving", move_duration > 0)
	
	move_and_slide()

func set_protected(protected :bool):
	warning.visible = !protected

func _set_health(hp):
	health = hp
	on_health_update.emit(hp, 0)

func _take_damage(damage):
	health -= damage
	on_health_update.emit(health, damage)
	damageable.flash_damage()
	var state_machine = anim_tree["parameters/playback"]
	state_machine.travel("Hit")
