extends CharacterBody3D

const FLY_HEIGHT = 10
const SPEED = 500
const DISTANCE_THRESHOLD = 0.3

var destination_position : Vector3 = Vector3.ZERO
var box_to_pickup : Node3D = null
var box_to_deliver : Node3D = null
var deliver_box_location : Node3D = null
var go_to_height = false

func _ready():
  transform.origin.y = FLY_HEIGHT

func _physics_process(delta):
  movement(delta)

func movement(delta):
  if destination_position == Vector3.ZERO:
    return

  movement_pickup(delta)
  movement_deliver(delta)
  movement_go_to_height(delta)
  move_and_slide()

func movement_pickup(delta):
  if !box_to_pickup:
    return

  var horz_position = global_position
  horz_position.y = destination_position.y

  if horz_position.x != destination_position.x && horz_position.z != destination_position.z:
    look_at(destination_position, Vector3.UP)

  if horz_position.distance_to(destination_position) < DISTANCE_THRESHOLD:
    # lock into dest x/z since we're close enough
    horz_position.x = destination_position.x
    horz_position.z = destination_position.z
    global_position.x = destination_position.x
    global_position.z = destination_position.z

  var direction = (destination_position - horz_position).normalized()

  if direction:
    velocity.x = direction.x * SPEED * delta
    velocity.z = direction.z * SPEED * delta
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED * delta)
    velocity.z = move_toward(velocity.z, 0, SPEED * delta)

    # reached box x,z
    if $box_location.global_position.distance_to(box_to_pickup.global_position) < DISTANCE_THRESHOLD:
      # pickup box and prep to go to height
      box_to_deliver = box_to_pickup
      box_to_deliver.reparent($box_location)
      box_to_pickup = null
      go_to_height = true
      destination_position = global_position
      destination_position.y = global_position.y + FLY_HEIGHT
      return
    else:
      # go down to box
      direction = (box_to_pickup.global_position - global_position).normalized()

    if direction:
      velocity.y = direction.y * SPEED * delta
    else:
      velocity.y = move_toward(velocity.y, 0, SPEED * delta)

func movement_go_to_height(delta):
  if !go_to_height:
    return

  if global_position.distance_to(destination_position) < DISTANCE_THRESHOLD:
    global_position = destination_position

  var direction = (destination_position - global_position).normalized()

  if direction:
    velocity.y = direction.y * SPEED * delta
  else:
    velocity.y = move_toward(velocity.y, 0, SPEED * delta)
    go_to_height = false

    if deliver_box_location:
      # finished delivering a box, and reached fly height, reset so we can go back to warehouse
      deliver_box_location = null
      destination_position = Vector3()

func movement_deliver(delta):
  if go_to_height or !box_to_deliver:
    return

  if !deliver_box_location:
    # TODO: get a random house, in the radius of drone tower
    var world = get_parent().get_parent()
    var houses = world.get_node("level/Node3D2/map2/houses")
    var house = houses.get_children().pick_random()
    var box_location = house.get_node("delivery_area")

    deliver_box_location = box_location
    destination_position = box_location.global_position
  else:
    # found a deliver_box_location, move x,z there
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
      global_position.x = destination_position.x
      global_position.z = destination_position.z

    var direction = (destination_position - horz_position).normalized()

    if direction:
      velocity.x = direction.x * SPEED * delta
      velocity.z = direction.z * SPEED * delta
    else:
      velocity.x = move_toward(velocity.x, 0, SPEED * delta)
      velocity.z = move_toward(velocity.z, 0, SPEED * delta)

      # reached box x,z
      if $box_location.global_position.distance_to(deliver_box_location.global_position) < DISTANCE_THRESHOLD:
        # deliver box and prep to go to height
        box_to_deliver.reparent(deliver_box_location)
        box_to_deliver = null
        go_to_height = true
        destination_position = global_position
        destination_position.y = global_position.y + FLY_HEIGHT
        return
      else:
        # go down to box
        direction = (deliver_box_location.global_position - global_position).normalized()

      if direction:
        velocity.y = direction.y * SPEED * delta
      else:
        velocity.y = move_toward(velocity.y, 0, SPEED * delta)

func pickup_box(box):
  if destination_position != Vector3.ZERO or box_to_pickup or box_to_deliver or deliver_box_location or go_to_height:
    return false

  box_to_pickup = box
  destination_position = box_to_pickup.global_position
  destination_position.y = global_position.y
