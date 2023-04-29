extends Camera3D

const MAX_SPEED = 5
const ACCEL = 4.5
const DEACCEL = 16

var dir = Vector3()
var is_disabled = false
var velocity = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
  if is_disabled:
    return

  process_input()
  process_movement(delta)

func process_input():
  dir = Vector3()
  var cam_xform = get_global_transform()
  var input_movement_vector = Vector2()

  if Input.is_action_pressed("cam_forward"):
    input_movement_vector.y += 1
  if Input.is_action_pressed("cam_backward"):
      input_movement_vector.y -= 1
  if Input.is_action_pressed("cam_strafe_left"):
    input_movement_vector.x -= 1
  if Input.is_action_pressed("cam_strafe_right"):
    input_movement_vector.x += 1

  input_movement_vector = input_movement_vector.normalized()
  dir += -cam_xform.basis.z.normalized() * input_movement_vector.y
  dir += cam_xform.basis.x.normalized() * input_movement_vector.x

func process_movement(delta):
  dir.y = 0
  dir = dir.normalized()

  var hvel = velocity
  hvel.y = 0

  var target = dir * MAX_SPEED

  var accel
  if dir.dot(hvel) > 0:
    accel = ACCEL
  else:
    accel = DEACCEL

  hvel = hvel.lerp(target, accel * delta)
  velocity.x = hvel.x
  velocity.z = hvel.z

  # move_and_slide()

func _input(event):
  if is_disabled:
    return

  # if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
    # do zoom stuff here
