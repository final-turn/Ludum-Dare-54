extends Node3D

@export var target : Node3D
@export var mouse_sensitivity : float = 0.5

@onready var camera = $"Camera3D"

var zoom_amount = 0
var target_zoom

func _ready():
	zoom_amount = 0
	target_zoom = camera.position.z
	set_as_top_level(true)

func _input(event):	
	if Input.is_action_pressed("ControlCamera"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90, -10)
		
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360)
	
	zoom_amount = clamp(zoom_amount + Input.get_axis("zoom", "zoomout") * 4, -20, 20)
	target_zoom = 5 + (10 * (20 + zoom_amount)/40)

func _physics_process(delta):
	global_position = target.global_position
	camera.position.z = move_toward(camera.position.z, target_zoom, delta * 5)
