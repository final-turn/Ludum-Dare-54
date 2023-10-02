class_name Enemy extends Node3D

@export var movespeed : float
@export var damage : float

@onready var damage_label : Label3D = $"Damage Label"
@onready var flair_root : Node3D = $"Missle Flair"
@onready var reduced_label : Label3D = $"Missle Flair/Reduced Damage Label"
@onready var label_animp : AnimationPlayer = $"Missle Flair/Label Animation"
@onready var mesh_animp : AnimationPlayer = $"Missle Flair/Mesh Animation"

var president : President
var is_moving : bool = true

func _ready():
	mesh_animp.play("Spin")
	damage_label.text = str(damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_moving:
		look_at(president.global_position, Vector3.UP)
		global_position = global_position.move_toward(president.global_position, delta * movespeed)

func _on_body_entered(body):
	if body.name == "President" && is_moving:
		president._take_damage(damage)
		le_kill("Explodes")

func decrease_damage(amount : float):
	damage -= amount
	print("Enemy damage reduced to %d" % damage)
	if damage <= 0:
		le_kill("Deflected")
	else:
		reduced_label.text = "-%d" % amount
		label_animp.play("Chip Damage")
		damage_label.text = str(damage)

func le_kill(animation):
	if is_moving:
		var stashed_position = flair_root.global_position
		remove_child(flair_root)
		get_tree().root.add_child(flair_root)
		flair_root.global_position = stashed_position
		mesh_animp.play(animation)
		is_moving = false
		queue_free()
