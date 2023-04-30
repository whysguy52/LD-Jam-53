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

  for tower in towers:
    if tower.isEnabled == true:
      #print("count: ", tower.get_delivery_areas().size())
      #delivery_areas.append_array(tower.get_delivery_areas())
      pass

  for target in delivery_areas:
    target.scale.x = 10
    target.scale.y = 10
    target.scale.z = 10
  #print("delivery_areas: ", delivery_areas.size())



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if Input.is_action_just_pressed("space_tester"):
    delivery_areas.clear()
    for tower in towers:
      if tower.isEnabled == true:
        print("count: ", tower.get_delivery_areas().size())
        delivery_areas.append_array(tower.get_delivery_areas())

    for target in delivery_areas:
      target.scale.x += 5
      target.scale.y += 5
      target.scale.z += 5

