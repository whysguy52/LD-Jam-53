extends Control

@onready var warehouse = get_node('/root/world/warehouse')

func _ready():
  update_ui()

func update_ui():
  $h_info_container/max_value.text = str(warehouse.max_drones)
  $h_info_container/available_value.text = str(warehouse.max_drones - warehouse.working_drones_count())

func update_def_ui():
  $h_info_container/max_def_drone_value.text = str(warehouse.max_def_drones)
  print("deployed drone count: ",warehouse.deployed_def_drones_count())
  $h_info_container/available_def_drone_value.text = str(warehouse.max_def_drones - warehouse.deployed_def_drones_count())
