extends Control

signal perk_selected # use this hook to recieve perk data

@export var president : President

@onready var perk_menu = $"PerkMenu"

@onready var health_bar : TextureProgressBar = $"HP Meter/Bar"
@onready var health_label : Label = $"HP Meter/Label"
@onready var exp_bar : TextureProgressBar = $"EXP Meter/Bar"
@onready var timer : Label = $"Timer"

# Called when the node enters the scene tree for the first time.
func _ready():
	perk_menu.perk_selected.connect(on_perk_selected)
	president.on_health_update.connect(on_health_update)
	on_health_update(president.health, 0)

func update_timer(amount : float):
	var minutes = floori(amount /60.0)
	var seconds = "%02d" % floori(amount - (minutes * 60))
	var ms = "%02d" % floori((amount - floorf(amount)) * 100)
	timer.text = ("%02d" % minutes) + ":" + seconds + "." + ms

func on_health_update(health, _damage):
	health_label.text = "%d HP" % health
	health_bar.value = health

func on_exp_update(experience):
	exp_bar.value = floori(experience)

func present_perks(level):
	perk_menu._present_perks(level)

func on_perk_selected(perk):
	emit_signal("perk_selected", perk)
