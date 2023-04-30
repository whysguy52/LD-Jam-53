extends Node3D

var selection_material_overlay = preload("res://assets/3d/houses/selection_material_overlay_3d.tres")

func _on_selection_area_mouse_entered():
  $mesh/Cube.material_overlay = selection_material_overlay

func _on_selection_area_mouse_exited():
  $mesh/Cube.material_overlay = null
