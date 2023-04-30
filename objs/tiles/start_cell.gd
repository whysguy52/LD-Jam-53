extends Node3D

@export var isTowerEnabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
  get_node("tower_cell/drone_tower").set_enabled(isTowerEnabled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
