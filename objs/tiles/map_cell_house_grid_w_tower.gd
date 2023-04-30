extends Node3D

@export var isTowerEnabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
  get_node("map/drone_tower").set_enabled(isTowerEnabled)
