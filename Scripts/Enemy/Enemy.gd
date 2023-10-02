class_name Enemy extends Node3D

@export var movespeed : float
@export var damage : float

@onready var damage_label : Label3D = $"Damage Label"
@onready var label_animp : AnimationPlayer = $"Missle Flair/Label Animation"
@onready var reduced_label : Label3D = $"Missle Flair/Reduced Damage Label"
@onready var mesh_animp : AnimationPlayer = $"Missle Flair/Mesh Animation"

var president : President

func _ready():
	mesh_animp.play("Spin")
	damage_label.text = str(damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(president.global_position, Vector3.UP)
	global_position = global_position.move_toward(president.global_position, delta * movespeed)

func _on_body_entered(body):
	if body.name == "President":
		president._take_damage(damage)
		queue_free()

func decrease_damage(amount : float):
	damage -= amount
	print("Enemy damage reduced to %d" % damage)
	if damage <= 0:
		queue_free()
	else:
		reduced_label.text = "-%d" % amount
		label_animp.play("Chip Damage")
		damage_label.text = str(damage)
