extends HBoxContainer

var tower_to_buy = null

@onready var warehouse = get_node('/root/world/warehouse')

func _on_buy_drone_button_pressed():
  warehouse.buy_drone()

func _on_buy_tower_button_pressed():
  warehouse.buy_tower(tower_to_buy)
