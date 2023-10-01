extends Panel
class_name ServicemanStats

@onready var alertness : RichTextLabel = $"VBoxContainer/Alertness"
@onready var speed : RichTextLabel = $"VBoxContainer/Movespeed"
@onready var defense : RichTextLabel = $"VBoxContainer/Defense"

var camera

func _ready():
	camera = get_tree().root.get_camera_3d()

func hide_ui():
	visible = false;

func show_ui(serviceman : Serviceman):
	visible = true
	alertness.text = "REACT: [shake] %.2f" % serviceman.response_time
	speed.text = "SPEED: [wave] %d" % serviceman.speed
	defense.text = "DEFENSE: [b] %d" % serviceman.defense
	
	self.position = camera.unproject_position(serviceman.global_position)
