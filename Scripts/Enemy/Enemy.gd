class_name Enemy extends Node3D

@export var movespeed : float
@export var damage : float

@onready var damage_label : Label3D = $"Label3D"

var president : President

func _ready():
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
	print(damage)
	if damage <= 0:
		queue_free()
	else:
		damage_label.text = str(damage)
