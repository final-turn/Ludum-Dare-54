extends Control

@onready var president : President = $"../President"
@onready var health_bar : TextureProgressBar = $"HP/HP Bar"

# Called when the node enters the scene tree for the first time.
func _ready():
	president.on_health_update.connect(on_health_update)
	on_health_update(president.health)

func on_health_update(health):
	health_bar.value = health
