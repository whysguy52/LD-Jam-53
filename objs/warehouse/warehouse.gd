extends Node3D

var box_scene = preload("res://objs/box/box.tscn")
var drone_scene = preload("res://objs/drone/drone.tscn")

var MIN_BOX_TIMER = 3
var MAX_BOX_TIMER = 15
var INITIAL_MAX_DRONES = 3
var PRICE_DRONE = 150
var PRICE_DELIVERY = 50
var PRICE_TOWER = 300
var max_drones = INITIAL_MAX_DRONES
var money = 350

@onready var drones_node = get_parent().get_node('drones')
@onready var level_node = get_parent().get_node("level")
@onready var ui = get_node('/root/world/camera_controller/camera/user_interface')
@onready var money_ui = get_node('/root/world/camera_controller/camera/money_ui')
@onready var camera_controller = get_node("/root/world/camera_controller")
@onready var ui_buttons = get_node('/root/world/camera_controller/camera/user_interface/buttons')

func _ready():
  money_ui.update_ui()

func spawn_box():
  if $box_location/spawn.get_child_count() > 0:
    return

  var box = box_scene.instantiate()
  var delivery_areas = level_node.delivery_areas
  var available_fn = func(da): return da.get_node('boxes').get_child_count() == 0
  var available_delivery_areas = delivery_areas.filter(available_fn)

  if available_delivery_areas.is_empty():
    return

  var delivery_area = available_delivery_areas.pick_random()

  var house = delivery_area.get_parent()
  house.get_node('house_arrow').show()
  camera_controller.show_ui_arrow()
  camera_controller.set_direction(house.global_position)

  box.delivery_area = delivery_area

  $box_location/spawn.add_child(box)

func spawn_drone():
  if drones_node.get_child_count() >= max_drones:
    return

  if $box_location/spawn.get_child_count() <= 0:
    return

  var box = $box_location/spawn.get_child(0)

  if !box or drones_node.get_children().any(func(drone): return drone.box_to_pickup == box):
    return

  var drone = drone_scene.instantiate()

  get_parent().get_node('drones').add_child(drone)
  ui.update_ui()

  drone.global_position = $drone_spawn_location.global_position
  drone.pickup_box(box)

  var house = box.delivery_area.get_parent()
  house.get_node('house_arrow').hide()
  camera_controller.hide_ui_arrow()

func _on_box_timer_timeout():
  $box_timer.stop()
  $box_timer.start(randf_range(MIN_BOX_TIMER, MAX_BOX_TIMER))
  spawn_box()

func buy_drone():
  if money < PRICE_DRONE:
    return

  max_drones += 1
  money -= PRICE_DRONE
  ui.update_ui()
  money_ui.update_ui()

func buy_tower(tower):
  if money < PRICE_TOWER:
    return

  tower.isEnabled = true
  money -= PRICE_TOWER
  level_node.init_delivery_areas()
  ui_buttons.get_node('buy_tower_button').hide()

func working_drones_count():
  if !drones_node:
    return 0

  return drones_node.get_children().filter(func(drone): return !drone.will_be_destroyed).size()

func delivered_box():
  money += PRICE_DELIVERY
  money_ui.update_ui()
