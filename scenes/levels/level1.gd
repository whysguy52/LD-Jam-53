extends Node3D

var towers = Array()
var delivery_areas = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
  towers.append(get_node("Node3D/tower_cell/drone_tower"))
  towers.append(get_node("Node3D10/map/drone_tower"))
  towers.append(get_node("Node3D11/map/drone_tower"))
  towers.append(get_node("Node3D12/map/drone_tower"))
  towers.append(get_node("Node3D13/map/drone_tower"))
  towers.append(get_node("Node3D14/map/drone_tower"))
  towers.append(get_node("Node3D15/map/drone_tower"))
  towers.append(get_node("Node3D16/map/drone_tower"))
  towers.append(get_node("Node3D17/map/drone_tower"))

  # TODO: figure out how to correctly init, without 0.5 init timer

func init_delivery_areas():
  for tower in towers:
      if tower.isEnabled == true:
        delivery_areas.append_array(tower.get_delivery_areas())

func _on_init_delivery_areas_timer_timeout():
  init_delivery_areas()
