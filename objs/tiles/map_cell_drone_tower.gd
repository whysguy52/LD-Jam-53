extends Area3D

var houses
var isEnabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
  houses = get_overlapping_areas()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

func set_enabled(enabledSet: bool):
  isEnabled = enabledSet
  get_node("CollisionShape3D").visible = isEnabled
  get_node("drone_radius_view").visible = isEnabled
