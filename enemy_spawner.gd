extends Node3D

var enemy_scene = preload("res://objs/drone/enemy_combat_drone.tscn")
var timer
var enemy_count = 0
var rng
var world_enemies
var num_to_spawn
var max_to_spawn = 1
var angle_of_spawn
var radius_of_spawn = 270

# Called when the node enters the scene tree for the first time.
func _ready():
  timer = $Timer
  rng = RandomNumberGenerator.new()
  world_enemies = get_parent().get_node("enemies")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  if visible == false:
    return
  enemy_count = world_enemies.get_child_count()
  if enemy_count == 0 and timer.is_stopped():
    timer.wait_time = rng.randi_range(20,30)
    num_to_spawn = rng.randi_range(1,max_to_spawn)
    timer.start()

func _on_timer_timeout():
  angle_of_spawn = deg_to_rad(rng.randi_range(1,360))
  $alarm_sound.play()

  for i in num_to_spawn:
    var deviation = rng.randi_range(-10, 10)
    var border_location = Vector3()
    border_location.x = radius_of_spawn * cos(angle_of_spawn) + deviation
    border_location.z = radius_of_spawn * sin(angle_of_spawn) + deviation
    var enemy = enemy_scene.instantiate()
    world_enemies.add_child(enemy)

    enemy.global_position.x = border_location.x
    enemy.global_position.z = border_location.z
    #don't do y or else height might get screwed up

  enemy_count += 1
