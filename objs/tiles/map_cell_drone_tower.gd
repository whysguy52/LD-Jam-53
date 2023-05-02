extends Area3D

var selection_material_overlay = preload("res://assets/3d/houses/selection_material_overlay_3d.tres")

var delivery_areas = Array()
var isEnabled = false
var is_hovered = false

@onready var ui_buttons = get_node('/root/world/camera_controller/camera/user_interface/outer_margin/inner_margin/buttons')

func set_enabled(enabledSet: bool):
  isEnabled = enabledSet
  $collision.visible = isEnabled

func toggle_view_radius():
  $drone_radius_view.visible = !$drone_radius_view.visible

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

func set_hover(hover: bool):
  for child in $drone_tower.get_children(true):
    if child is MeshInstance3D:
      child.material_overlay = selection_material_overlay if hover else null

  is_hovered = hover

func _input(event):
  if is_hovered and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
    click()

func _on_selection_area_mouse_entered():
  set_hover(true)

func _on_selection_area_mouse_exited():
  set_hover(false)

func click():
  if isEnabled:
    if is_hovered:
      toggle_view_radius()
  else:
    ui_buttons.get_node('buy_tower_button').visible = !ui_buttons.get_node('buy_tower_button').visible
    ui_buttons.tower_to_buy = self
