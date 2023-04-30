extends HBoxContainer

@onready var warehouse = get_node('/root/world/warehouse')

func _on_buy_button_pressed():
  warehouse.buy_drone()
