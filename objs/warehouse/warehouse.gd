extends Node3D


var box_scene = preload("res://objs/box/box.tscn")
var drone_scene = preload("res://objs/drone/drone.tscn")

var MIN_BOX_TIMER = 3
var MAX_BOX_TIMER = 15
var INITIAL_MAX_DRONES = 3
var max_drones = INITIAL_MAX_DRONES
@onready var drones_node = get_parent().get_node('drones')

func spawn_box():
  if $box_location/spawn.get_child_count() > 0:
    return

  var box = box_scene.instantiate()

  $box_location/spawn.add_child(box)

func spawn_drone():
  if drones_node.get_child_count() >= max_drones:
    return

  if $box_location/spawn.get_child_count() <= 0:
    return

  var box = $box_location/spawn.get_child(0)

  if !box or drones_node.get_children().any(func(drone): return drone.box_to_pickup == box):
    return

  var drone = drone_scene.instantiate()

  get_parent().get_node('drones').add_child(drone)

  drone.global_position = $drone_spawn_location.global_position
  drone.pickup_box(box)

func _on_box_timer_timeout():
  $box_timer.stop()
  $box_timer.start(randf_range(MIN_BOX_TIMER, MAX_BOX_TIMER))
  spawn_box()


func _on_drone_timer_timeout():
  spawn_drone()
