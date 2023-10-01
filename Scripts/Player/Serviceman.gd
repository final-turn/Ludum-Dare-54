class_name Serviceman extends Node3D

@export var response_time : float = 2
@export var speed : float = 5
@export var defense : float = 2

@onready var model = $"Model"
@onready var anim_tree = $"AnimationTree"
@onready var anim_player = $"AnimationPlayer"

var rng : RandomNumberGenerator
var target : Node3D
var is_standing : bool = false
var idle_countdown : float = 0

func _ready():
	rng = RandomNumberGenerator.new()
	target = get_node("/root/Game Scene/President/Serviceman Array/" + name + " Position")

func _get_target_position():
	return target.global_position - Vector3(0, 0.7, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	anim_player.speed_scale = speed / 5
	if idle_countdown == 0:
		is_standing = false
		anim_tree.set("parameters/conditions/isIdle", false)
		anim_tree.set("parameters/conditions/isMoving", true)
		global_position = global_position.move_toward(_get_target_position(), delta * speed)		
		model.look_at(-1 * _get_target_position())
	
	if global_position == _get_target_position():
		if not is_standing:
			anim_tree.set("parameters/conditions/isIdle", true)
			anim_tree.set("parameters/conditions/isMoving", false)
			idle_countdown = response_time + rng.randf_range(0, 0.5)
			is_standing = true
	else:
		idle_countdown = max(0, idle_countdown - delta)
