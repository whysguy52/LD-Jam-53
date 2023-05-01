extends HBoxContainer

var tower_to_buy = null

@onready var warehouse = get_node('/root/world/warehouse')

func _input(event):
    if event.is_action_pressed("deploy_button"):
      _on_deploy_button_pressed()

func _on_buy_drone_button_pressed():
  warehouse.buy_drone()

func _on_buy_tower_button_pressed():
  warehouse.buy_tower(tower_to_buy)

func _on_buy_def_drone_button_pressed():
  warehouse.buy_def_drone()

func _on_deploy_button_pressed():
  warehouse.deploy_def_drone()
