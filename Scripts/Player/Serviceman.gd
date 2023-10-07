class_name Serviceman extends Node3D

@export var target_position : Node3D

@export var dive : float = 0
@export var speed : float = 4
@export var defense : int = 2
@export var response_time : float = 2

@onready var anim_tree = $"agent/AnimationTree"
@onready var anim_player = $"agent/AnimationPlayer"

var rng : RandomNumberGenerator
var is_standing : bool = false
var idle_countdown : float = 0
var president : President
var dive_duration : float = 0
var dive_position : Vector3

func _ready():
	rng = RandomNumberGenerator.new()
	president = get_parent().get_parent().target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if dive_duration > 0:
		global_position = global_position.move_toward(dive_position, delta * speed * 3 * dive)
		self.look_at(-1 * dive_position)
		dive_duration -= delta
	elif idle_countdown == 0:
		is_standing = false
		anim_tree.set("parameters/conditions/isIdle", false)
		anim_tree.set("parameters/conditions/isMoving", true)
		global_position = global_position.move_toward(target_position.global_position, delta * speed)
		self.look_at(-1 * target_position.global_position)
	
	if global_position == target_position.global_position:
		if not is_standing:
			anim_tree.set("parameters/conditions/isIdle", true)
			anim_tree.set("parameters/conditions/isMoving", false)
			idle_countdown = response_time + rng.randf_range(0, 0.5)
			is_standing = true
	else:
		idle_countdown = max(0, idle_countdown - delta)
	
	var blend = clamp((speed - 4)/4, 0, 1)
	anim_player.speed_scale = 1 + blend
	#print(blend)
	anim_tree.set("parameters/Moving/blend_amount", blend)

func start_dive(area):
	dive_duration = 1.6
	dive_position = area.global_position
	var state_machine = anim_tree["parameters/playback"]
	state_machine.travel("Dive")
	#print("Serviceman Radius: " + area.name)

func _on_area_3d_area_entered(area):
	if dive > 0 && area.name.contains("Enemy") && not president.is_protected:
		var space_state = get_world_3d().direct_space_state
		var origin = global_position + Vector3(0,0.5,0)
		var dest = area.global_position + Vector3(0,0.5,0)
		var ray = dest - origin  + Vector3(0,0.5,0)
		#print("raycasting" + str(ray))
		var query = PhysicsRayQueryParameters3D.create(origin, ray * 3)
		query.collide_with_areas = false
		query.collide_with_bodies = true
		var result = space_state.intersect_ray(query)
		if result && result.collider.name == "President":
			start_dive(area)
