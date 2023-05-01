extends Node3D

const SPAWN_TIMER_MIN = 20
const SPAWN_TIMER_MAX = 30
const RADIUS_OF_SPAWN = 270

var enemy_scene = preload("res://objs/drone/enemy_combat_drone.tscn")

@onready var world_enemies = get_parent().get_node('enemies')

func _ready():
  $timer.wait_time = randi_range(SPAWN_TIMER_MIN, SPAWN_TIMER_MAX)
  $timer.start()

func _on_timer_timeout():
  if world_enemies.get_child_count() > 0:
    $timer.wait_time = 1
    $timer.start()
    return

  var angle_of_spawn = deg_to_rad(randi_range(1, 360))
  var num_to_spawn = [1, 1, 1, 1, 1, 2, 2].pick_random()

  for i in num_to_spawn:
    var deviation = randi_range(-10, 10)
    var border_location = Vector3()
    border_location.x = RADIUS_OF_SPAWN * cos(angle_of_spawn) + deviation
    border_location.z = RADIUS_OF_SPAWN * sin(angle_of_spawn) + deviation
    var enemy = enemy_scene.instantiate()
    world_enemies.add_child(enemy)

    enemy.global_position.x = border_location.x
    enemy.global_position.z = border_location.z
    #don't do y or else height might get screwed up

  $alarm_sound.play()
  $timer.wait_time = randi_range(SPAWN_TIMER_MIN, SPAWN_TIMER_MAX)
  $timer.start()
