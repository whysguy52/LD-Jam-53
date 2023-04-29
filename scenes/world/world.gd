extends Node3D


func _on_warehouse_check_timer_timeout():
  var drone = $drones.get_child(0)

  if !drone:
    return

  var box = $warehouse/box_location/spawn.get_child(0)

  if !box || drone.box_to_pickup == box:
    return

  drone.pickup_box(box)
