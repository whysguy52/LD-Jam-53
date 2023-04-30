extends CharacterBody3D

const FLY_HEIGHT = 10
const SPEED = 500
const DISTANCE_THRESHOLD = 0.3

var destination_position : Vector3 = Vector3.ZERO
var box_to_pickup : Node3D = null
var box_to_deliver : Node3D = null
var deliver_box_location : Node3D = null

func _ready():
  transform.origin.y = FLY_HEIGHT

func _physics_process(delta):
  if destination_position == Vector3.ZERO:
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

    # reached destination x,z now do y
    if box_to_pickup:
      if $box_location.global_position.distance_to(box_to_pickup.global_position) < DISTANCE_THRESHOLD:
        box_to_deliver = box_to_pickup
        box_to_deliver.reparent($box_location)
        box_to_pickup = null
        destination_position = global_position
        destination_position.y = global_position.y + FLY_HEIGHT
        return
      else:
        direction = (box_to_pickup.global_position - global_position).normalized()
    elif box_to_deliver:
      if global_position.distance_to(destination_position) < DISTANCE_THRESHOLD:
        global_position = destination_position

      direction = (destination_position - global_position).normalized()

    if box_to_pickup or box_to_deliver:
      if direction:
        velocity.y = direction.y * SPEED * delta
      else:
        velocity.y = move_toward(velocity.y, 0, SPEED * delta)

        if box_to_deliver && !deliver_box_location:
          # TODO: remove this, find a house instead, and set that houses box to deliver_box_location
          deliver_box_location = box_to_deliver
          print('>>> picked up box, find a house to deliver to')

  move_and_slide()

func pickup_box(box):
  if box_to_pickup:
    return false

  box_to_pickup = box
  destination_position = box_to_pickup.global_position
  destination_position.y = global_position.y
