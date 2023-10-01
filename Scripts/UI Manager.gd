extends Control

@onready var president : President = $"../President"
@onready var health_bar : TextureProgressBar = $"HP Meter/Bar"
@onready var shield_bar : TextureProgressBar = $"Shield Meter/Bar"
@onready var exp_bar : TextureProgressBar = $"EXP Meter/Bar"
@onready var timer : Label = $"Timer"

# Called when the node enters the scene tree for the first time.
func _ready():
	president.on_health_update.connect(on_health_update)
	on_health_update(president.health)

func update_timer(amount : float):
	var minutes = floori(amount /60.0)
	var seconds = "%02d" % floori(amount - (minutes * 60))
	var ms = "%02d" % floori((amount - floorf(amount)) * 100)
	timer.text = ("%02d" % minutes) + ":" + seconds + "." + ms

func on_health_update(health):
	health_bar.value = health
