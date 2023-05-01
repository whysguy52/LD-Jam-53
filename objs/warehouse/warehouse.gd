extends Node3D

var box_scene = preload("res://objs/box/box.tscn")
var drone_scene = preload("res://objs/drone/drone.tscn")

var MIN_BOX_TIMER = 1.0
var MAX_BOX_TIMER = 5.0
var INITIAL_MAX_DRONES = 3
var INITIAL_DEF_DRONES = 3
var PRICE_DRONE = 150
var PRICE_DEF_DRONE = 150
var PRICE_DELIVERY = 50
var PRICE_TOWER = 300
var max_drones = INITIAL_MAX_DRONES
var max_def_drones = INITIAL_DEF_DRONES
var money = 0

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
    $audio_error.play()
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
  spawn_box()

  var total_towers = level_node.towers.size()
  var towers_enabled = level_node.towers.filter(func(t): return t.isEnabled).size()
  var timer_multiplier = total_towers - towers_enabled + 1

  $box_timer.wait_time = timer_multiplier * randf_range(MIN_BOX_TIMER, MAX_BOX_TIMER) / total_towers

func buy_drone():
  if money < PRICE_DRONE:
    $audio_error.play()
    return

  max_drones += 1
  money -= PRICE_DRONE
  ui.update_ui()
  money_ui.update_ui()

func buy_tower(tower):
  if money < PRICE_TOWER:
    $audio_error.play()
    return

  if !tower:
    ui_buttons.get_node('buy_tower_button').hide()
    $audio_error.play()
    return

  tower.isEnabled = true
  money -= PRICE_TOWER
  money_ui.update_ui()
  ui_buttons.get_node('buy_tower_button').hide()
  level_node.init_delivery_areas()

func buy_def_drone():
  if money < PRICE_DEF_DRONE:
    $audio_error.play()
    return

  max_def_drones += 1
  money -= PRICE_DEF_DRONE
  ui.update_def_ui()
  money_ui.update_ui()

func working_drones_count():
  if !drones_node:
    return 0

  return drones_node.get_children().filter(func(drone): return !drone.will_be_destroyed).size()

func drone_destroyed():
  max_drones -= 1
  ui.update_ui()

func delivered_box():
  money += PRICE_DELIVERY
  money_ui.update_ui()
