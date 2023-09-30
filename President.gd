extends RigidBody3D

@export var move_speed = 5
@export var distance = 10
@export var stand_time = 6

@onready var anim_tree = $"AnimationTree"

var rng : RandomNumberGenerator

var time_elapsed : float = 0
var target_position : Vector3 = Vector3(0,0,0)
var is_moving : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()

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
		target_position = position + (Vector3(rng.randf_range(-1.0, 1.0),0,rng.randf_range(-1.0, 1.0)).normalized() * distance)
