extends Node3D

var enemy_scene = preload("res://objs/drone/enemy_combat_drone.tscn")
var timer
var enemy_count = 0
var rng
var world_enemies

# Called when the node enters the scene tree for the first time.
func _ready():
  timer = $Timer
  rng = RandomNumberGenerator.new()
  world_enemies = get_parent().get_node("enemies")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if visible == false:
    return
  if enemy_count == 0 and timer.is_stopped():
    timer.wait_time = rng.randi_range(10,15)
    timer.start()
    print("timer ping: ",timer.wait_time)

func _on_timer_timeout():
  var enemy = enemy_scene.instantiate()
  world_enemies.add_child(enemy)
  enemy_count += 1
  print("enemy instantiated")
