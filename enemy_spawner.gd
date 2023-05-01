extends Node3D

var enemy_scene = preload("res://objs/drone/enemy_combat_drone.tscn")
var timer
var enemy_count = 0
var rng
var world_enemies
var num_to_spawn
var max_to_spawn = 3

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
    timer.wait_time = rng.randi_range(10,15)
    num_to_spawn = rng.randi_range(1,max_to_spawn)
    timer.start()

func _on_timer_timeout():
  var enemy = enemy_scene.instantiate()
  world_enemies.add_child(enemy)
  enemy_count += 1
