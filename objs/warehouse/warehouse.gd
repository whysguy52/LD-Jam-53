extends Node3D

var box_scene = preload("res://objs/box/box.tscn")

func spawn_box():
  var box = box_scene.instantiate()

  $box_location/spawn.add_child(box)

func _on_initial_box_timer_timeout():
  spawn_box()

func _on_box_timer_timeout():
  spawn_box()
