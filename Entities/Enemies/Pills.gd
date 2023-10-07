class_name PillsEnemy extends Node3D

@export var damage : float = 20

@onready var damage_label : Label3D = $"Damage Label"
@onready var flair_root : Node3D = $"Missle Flair"
@onready var reduced_label : Label3D = $"Missle Flair/Reduced Damage Label"
@onready var label_animp : AnimationPlayer = $"Missle Flair/Label Animation"
@onready var mesh_animp : AnimationPlayer = $"Missle Flair/Mesh Animation"
@onready var dmg : damagable = $"Missle Flair/missle/Pills/damagable"

var damage_cooldown = 0

func _ready():
	mesh_animp.play("Spin")
	damage_label.text = str(damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	damage_cooldown = max(0, damage_cooldown - delta)

func _on_body_entered(body):
	if body.name == "President":
		body._take_damage(damage)
		le_kill("Explodes")

func decrease_damage(amount : float):
	if damage_cooldown == 0:
		damage -= amount
		#print("Enemy damage reduced to %d" % damage)
		if damage <= 0:
			le_kill("Deflected")
		else:
			reduced_label.text = "-%d" % amount
			label_animp.play("Chip Damage")
			damage_label.text = str(damage)
			damage_cooldown = 1
			dmg.flash_damage(damage_cooldown)
		

func le_kill(animation):
	var stashed_position = flair_root.global_position
	remove_child(flair_root)
	get_tree().root.add_child(flair_root)
	flair_root.global_position = stashed_position
	mesh_animp.play(animation)
	queue_free()
