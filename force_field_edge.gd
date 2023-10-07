extends Node3D
class_name ForceFieldEdge

@onready var area : Area3D = $"Area3D"
@onready var label : Label3D = $"Label3D"
@onready var damage : damagable = $"Area3D/MeshInstance3D/damagable"

var agent_defense : int
var override_scale : float
var show_defense_override : bool

var effective_defense = 0

func _physics_process(_delta):
	if show_defense_override:
		effective_defense = floori(agent_defense/(max(2, area.scale.x) * 0.5))
		var override = floori(agent_defense/(max(2, override_scale) * 0.5))
		label.text = "%d -> %d" % [effective_defense, override]
	else:
		effective_defense = floori(agent_defense/(max(2, area.scale.x) * 0.5))
		label.text = "%d" % effective_defense

func _on_area_3d_area_entered(collision):
	if collision.name != "Area3D":
		collision.decrease_damage(effective_defense)
		damage.flash_damage(.2)
