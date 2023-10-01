extends MeshInstance3D

@export var servicemanFrom : Serviceman
@export var servicemanTo : Serviceman

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = (servicemanFrom.position + servicemanTo.position)/2
	pass
