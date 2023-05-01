extends CharacterBody3D

const SPEED = 999 # 666 for real, 999 for testing
const DISTANCE_THRESHOLD = 3

var destination_position : Vector3 = Vector3.ZERO

var target_acquired

func _ready():
  find_nearest_target()

func _physics_process(delta):
  if visible == false:
    return
  movement(delta)

func movement(delta):
  move_laterally(delta)
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

func find_nearest_target():
  var list_of_del_drones = get_node('/root/world/drones').get_children()
  var min_dist = 0
  var check_dist = 0

  for target in list_of_del_drones:
    check_dist = global_position.distance_to(target.global_position)
    if min_dist == 0 or check_dist < min_dist:
      min_dist = check_dist
      target_acquired = target

  destination_position = get_node('/root/world/warehouse').global_position
    #else (if check_dist is greater than min_dist, do nothing)

