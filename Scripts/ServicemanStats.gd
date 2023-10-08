extends Panel
class_name ServicemanStats

@onready var alertness : RichTextLabel = $"VBoxContainer/Alertness"
@onready var speed : RichTextLabel = $"VBoxContainer/Movespeed"
@onready var defense : RichTextLabel = $"VBoxContainer/Defense"
@onready var dive : RichTextLabel = $"VBoxContainer/Dive"

var camera

func _ready():
	camera = get_tree().root.get_camera_3d()

func show_ui(serviceman : Serviceman):
	visible = true
	alertness.text = "REACT: [shake] %.2f" % serviceman.response_time
	speed.text = "SPEED: [wave] %d" % serviceman.speed
	defense.text = "DEFENSE: [b] %d" % serviceman.defense
	dive.text = "DIVE: [rainbow] %d" % serviceman.dive
	self.position = camera.unproject_position(serviceman.global_position)
