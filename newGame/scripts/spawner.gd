extends Node2D

@export var enemy_scene: PackedScene

var game
var timer = 0.0
var spawn_delay = 1.35
var spawn_points = []

func _ready():
	game = get_parent()
	spawn_points = [Vector2(60, 90), Vector2(1220, 100), Vector2(80, 650), Vector2(1210, 650), Vector2(640, 60), Vector2(640, 690)]

func _process(delta):
	if game.game_finished:
		return
	timer -= delta
	if timer <= 0:
		spawn_enemy()
		spawn_delay = max(0.45, spawn_delay - 0.015)
		timer = spawn_delay

func spawn_enemy():
	# spawn enemy
	var enemy = enemy_scene.instantiate()
	var enemy_type = randi_range(0, 2)
	if enemy_type == 0:
		enemy.speed = 145
		enemy.health = 30
		enemy.damage = 9
		enemy.score = 10
		enemy.enemy_color = Color(0.95, 0.18, 0.18, 1)
	elif enemy_type == 1:
		enemy.speed = 230
		enemy.health = 18
		enemy.damage = 7
		enemy.score = 15
		enemy.enemy_color = Color(1, 0.72, 0.18, 1)
	else:
		enemy.speed = 95
		enemy.health = 65
		enemy.damage = 16
		enemy.score = 25
		enemy.enemy_color = Color(0.55, 0.22, 1, 1)
	enemy.position = spawn_points.pick_random()
	enemy.enemy_killed.connect(game._on_enemy_killed)
	game.get_node("Enemies").add_child(enemy)
