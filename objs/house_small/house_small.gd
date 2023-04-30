extends Node3D

var selection_material_overlay = preload("res://assets/3d/houses/selection_material_overlay_3d.tres")

var is_hovered = false

func _on_selection_area_mouse_entered():
  hover(true)

func _on_selection_area_mouse_exited():
  hover(false)

func hover(hover: bool):
  $mesh/Cube.material_overlay = selection_material_overlay if hover else null
  is_hovered = hover

func _input(event):
  if is_hovered and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
    click()

func click():
  print('>>> clicked house')
