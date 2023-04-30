extends Area3D

var delivery_areas = Array()
var isEnabled = false


# Called when the node enters the scene tree for the first time.
func _ready():
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  pass

func set_enabled(enabledSet: bool):
  isEnabled = enabledSet
  get_node("CollisionShape3D").visible = isEnabled
  get_node("drone_radius_view").visible = isEnabled

func get_delivery_areas():
  var instance_ids = Array()
  var overlapped_delivery_areas = get_overlapping_areas()
  delivery_areas.clear()

  for target in overlapped_delivery_areas:
    var target_id = target.get_instance_id()
    if !instance_ids.has(target_id):
      instance_ids.append(target_id)
      delivery_areas.append(target)
  return delivery_areas
