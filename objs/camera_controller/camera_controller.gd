extends Node3D

const MAX_SPEED = 25
const SPEED = 1.25

var input_movement_vector = Vector2()
var is_disabled = false

func _physics_process(delta):
  if is_disabled:
    return

  process_input()
  process_movement(delta)

func process_input():
  input_movement_vector = Vector2()

  if Input.is_action_pressed("cam_forward"):
    input_movement_vector.y -= 1
    input_movement_vector.x -= 1
  if Input.is_action_pressed("cam_backward"):
      input_movement_vector.y += 1
      input_movement_vector.x += 1
  if Input.is_action_pressed("cam_strafe_left"):
    input_movement_vector.x -= 1
    input_movement_vector.y += 1
  if Input.is_action_pressed("cam_strafe_right"):
    input_movement_vector.x += 1
    input_movement_vector.y -= 1

  input_movement_vector = input_movement_vector.normalized()

func process_movement(delta):
  var dir = Vector3(input_movement_vector.x, 0, input_movement_vector.y)
  var origin = Vector3(transform.origin)
  var target = origin + dir * MAX_SPEED

  origin = origin.lerp(target, SPEED * delta)

  print(">>> process_movement", " orgin: ", origin, " dir: ", dir, " t: ", target)

  transform.origin.x = origin.x
  transform.origin.z = origin.z


# TODO: for camera zoom in/out
#func _input(_event):
#  if is_disabled:
#    return
#
#  if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#    # do zoom stuff here
