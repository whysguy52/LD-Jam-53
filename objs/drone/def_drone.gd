extends CharacterBody3D

const SPEED = 999 # 666 for real, 999 for testing
const DISTANCE_THRESHOLD = 5

var destination_position : Vector3 = Vector3.ZERO

var target_acquired: Object
var target_to_kill
var will_be_destroyed = false
var go_to_warehouse = false

@onready var warehouse = get_node('/root/world/warehouse')
@onready var drone_spawn_location = get_node('/root/world/warehouse/drone_spawn_location')
@onready var ui = get_node('/root/world/camera_controller/camera/user_interface')

func _ready():
  find_nearest_target()

func _physics_process(delta):
  movement(delta)

func movement(delta):
  if target_acquired == null:
    find_nearest_target()
  else:
    update_target_position()

    if destination_position == Vector3.ZERO:
      if $audio_movement.playing:
        $audio_movement.stop()
      return

    if !$audio_movement.playing:
      $audio_movement.play()

    move_laterally(delta)
    movement_go_to_warehouse(delta)
    move_and_slide()


func move_laterally(delta):
  var horz_position = global_position
  horz_position.y = destination_position.y

  if horz_position.x != destination_position.x && horz_position.z != destination_position.z:
    var look_at_position = destination_position
    look_at_position.y = global_position.y
    look_at(look_at_position, Vector3.UP)

  if horz_position.distance_to(destination_position) < DISTANCE_THRESHOLD:
    # lock into dest x/z since we're close enough
    horz_position.x = destination_position.x
    horz_position.z = destination_position.z

  var direction = (destination_position - horz_position).normalized()

  if direction:
    velocity.x = direction.x * SPEED * delta
    velocity.z = direction.z * SPEED * delta
    return false
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED * delta)
    velocity.z = move_toward(velocity.z, 0, SPEED * delta)
    return true

func movement_go_to_warehouse(delta):
  if !go_to_warehouse: #deleted variable go_to_height
    return

  if !move_laterally(delta):
    return

  # reached warehouse drone spawn location x,z
  if global_position.distance_to(drone_spawn_location.global_position) < DISTANCE_THRESHOLD:
    # mark for destruction
    will_be_destroyed = true
    queue_free()
    ui.update_def_ui()
    return

  move_down_to(drone_spawn_location, delta)

func move_down_to(node, delta):
  var direction = (node.global_position - global_position).normalized()

  if direction:
    velocity.y = direction.y * SPEED * delta
  else:
    velocity.y = move_toward(velocity.y, 0, SPEED * delta)

func find_nearest_target():
  var list_of_enemy_drones = get_node('/root/world/enemies').get_children()
  if list_of_enemy_drones.size() == 0:
    target_acquired = drone_spawn_location
    go_to_warehouse = true
    return

  var min_dist = 0
  var check_dist = 0

  for target in list_of_enemy_drones:
    check_dist = global_position.distance_to(target.global_position)
    if min_dist == 0 or check_dist < min_dist:
      min_dist = check_dist
      target_acquired = target

func update_target_position():
  destination_position = target_acquired.global_position
  #destination_position = get_node('/root/world/warehouse').global_position
    #else (if check_dist is greater than min_dist, do nothing)

func _on_area_3d_body_entered(body):
  var is_enemy_drone
  print(body.name)
  if "enemy_drone" in body.name:
    is_enemy_drone = true
  else:
    return

  target_to_kill = body
  $Timer.start()
  pass # Replace with function body.

func _on_timer_timeout():
  target_to_kill.kill()

func kill():
  will_be_destroyed = true
  warehouse.def_drone_destroyed()
  queue_free()
