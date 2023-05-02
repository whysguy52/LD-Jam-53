extends Node3D

const MAX_SPEED = 25
const SPEED = 1.25
const ZOOM_DEFAULT = 50
const ZOOM_AMOUNT = 25
const ZOOM_MIN = 25
const ZOOM_MAX = 150

var input_movement_vector = Vector2()
var is_disabled = false
var next_house = null

func _ready():
  $camera.size = ZOOM_DEFAULT

func _physics_process(delta):
  if is_disabled:
    return

  process_input()
  process_movement(delta)

  if next_house != null:
    $camera/ui_arrow.look_at(next_house)

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

  origin = origin.lerp(target, SPEED * zoom_factor() * delta)

  transform.origin.x = origin.x
  transform.origin.z = origin.z

func _input(event):
  if is_disabled:
    return

  if event is InputEventMouseButton:
    if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
        zoom(-ZOOM_AMOUNT)
    if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
        zoom(ZOOM_AMOUNT)

func zoom(amount):
  var new_size = clamp($camera.size + amount, ZOOM_MIN, ZOOM_MAX)

  $camera.size = new_size

func zoom_factor():
  return $camera.size / ZOOM_DEFAULT

func show_ui_arrow():
  $camera/ui_arrow.show()

func hide_ui_arrow():
  $camera/ui_arrow.hide()

func set_direction(pointTo: Vector3):
  next_house = pointTo

func show_game_over_ui():
  $camera/game_over_ui.show()

func _on_restart_button_pressed():
  get_tree().reload_current_scene()

func _on_exit_button_pressed():
  get_tree().quit()
