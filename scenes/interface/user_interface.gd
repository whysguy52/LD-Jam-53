extends Control

@onready var warehouse = get_node('/root/world/warehouse')

func _ready():
  update_ui()

func update_ui():
  $h_info_container/max_value.text = str(warehouse.max_drones)
  $h_info_container/available_value.text = str(warehouse.max_drones - warehouse.working_drones_count())
