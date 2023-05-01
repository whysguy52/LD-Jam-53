extends Node3D

var selection_material_overlay = preload("res://assets/3d/houses/selection_material_overlay_3d.tres")

var is_hovered = false

func deliver_box(box):
  box.reparent($delivery_area/boxes)
  $remove_delivery_timer.start()

func _on_selection_area_mouse_entered():
  set_hover(true)

func _on_selection_area_mouse_exited():
  set_hover(false)

func set_hover(hover: bool):
  $mesh/Cube.material_overlay = selection_material_overlay if hover else null
  is_hovered = hover

func _input(event):
  if is_hovered and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
    click()

func click():
  if $house_arrow.visible:
    get_node('/root/world/warehouse').spawn_drone()

func _on_remove_delivery_timer_timeout():
  for box in $delivery_area/boxes.get_children():
    box.queue_free()
