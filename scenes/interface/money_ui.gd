extends Control

@onready var warehouse = get_node('/root/world/warehouse')

func update_ui():
  $money/inner/hbox/money_value.text = str(warehouse.money)
  $delivered/inner/hbox/delivered_value.text = str(warehouse.delivered_boxes)
