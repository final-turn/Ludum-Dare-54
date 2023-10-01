class_name President extends RigidBody3D

signal on_health_update(health)

@export var health : int = 100
@export var move_speed = 5
@export var distance = 10
@export var stand_time = 6

@onready var warning = $"Warning Texture"
@onready var anim_tree = $"Visuals/AnimationTree"
@onready var visuals : Node3D = $"Visuals"
@onready var environment : ClickEnvironment = $"../Environment"
@onready var serviceman_array : ServicemanArray = $"Serviceman Array"

var rng : RandomNumberGenerator
var time_elapsed : float = 0
var target_position : Vector3 = Vector3(0,0,0)
var is_moving : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	environment.mouse_world_position.connect(serviceman_array.on_mouse_world_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	
	if is_moving:
		time_elapsed = 0
		if(position == target_position):
			is_moving = false
			anim_tree.set("parameters/conditions/isIdle", true)
			anim_tree.set("parameters/conditions/isMoving", false)
		else:
			position = position.move_toward(target_position, delta * move_speed)
	elif time_elapsed > stand_time:
		time_elapsed = 0
		is_moving = true
		anim_tree.set("parameters/conditions/isIdle", false)
		anim_tree.set("parameters/conditions/isMoving", true)
		var randX = rng.randf_range(-1.0, 1.0)
		var randZ = rng.randf_range(-1.0, 1.0)
		var randLen = rng.randf_range(3, distance)
		target_position = position + (Vector3(randX,0,randZ).normalized() * randLen)
		
		visuals.look_at(-1 * target_position)

func set_protected(protected :bool):
	warning.visible = !protected

func _take_damage(damage):
	health -= damage
	on_health_update.emit(health)
