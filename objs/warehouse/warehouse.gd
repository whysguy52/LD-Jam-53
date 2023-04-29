extends Node3D

var box_scene = preload("res://objs/box/box.tscn")

func _on_box_timer_timeout():
  var box = box_scene.instantiate()

  $box_location/spawn.add_child(box)
