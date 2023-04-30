extends Area3D

var selection_material_overlay = preload("res://assets/3d/houses/selection_material_overlay_3d.tres")

var delivery_areas = Array()
var isEnabled = false

func set_enabled(enabledSet: bool):
  isEnabled = enabledSet
  get_node("collision").visible = isEnabled

func set_view_radius_enabled(enabled: bool):
  get_node("drone_radius_view").visible = enabled

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

func _on_selection_area_mouse_entered():
  for child in $drone_tower.get_children(true):
    if child is MeshInstance3D:
      child.material_overlay = selection_material_overlay

func _on_selection_area_mouse_exited():
  for child in $drone_tower.get_children(true):
    if child is MeshInstance3D:
      child.material_overlay = null
