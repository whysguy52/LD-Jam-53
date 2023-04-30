extends Control

@onready var warehouse = get_node('/root/world/warehouse')

func update_ui():
  $h_box/money_value.text = str(warehouse.money)
