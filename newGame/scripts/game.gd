extends Node2D

var score = 0
var kills = 0
var game_finished = false
var power_timer = 5.0
var victory_kills = 30

func _ready():
	get_tree().paused = false
	$Player.health_changed.connect($CanvasLayer/UI._on_health_changed)
	$Player.shield_changed.connect($CanvasLayer/UI._on_shield_changed)
	$Player.player_died.connect(_on_player_died)
	$CanvasLayer/UI.update_score(score, kills, victory_kills)
	$CanvasLayer/UI.show_message("۳۰ دشمن را نابود کن")

func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE) and not game_finished:
		$CanvasLayer/UI.show_pause()
	power_timer -= delta
	if power_timer <= 0 and not game_finished:
		spawn_power_up()
		power_timer = randf_range(8.0, 12.0)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and not game_finished:
		attack()
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE and not game_finished:
		attack()

func attack():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		if $Player.global_position.distance_to(enemy.global_position) < 115:
			enemy.take_damage(20)

func _on_enemy_killed(enemy_score):
	kills += 1
	score += enemy_score
	$CanvasLayer/UI.update_score(score, kills, victory_kills)
	if kills >= victory_kills:
		show_victory()

func spawn_power_up():
	var power = preload("res://newGame/scenes/power_up.tscn").instantiate()
	power.power_type = ["heal", "speed", "shield"].pick_random()
	power.position = Vector2(randf_range(120, 1160), randf_range(120, 630))
	$PowerUps.add_child(power)

func _on_player_died():
	game_finished = true
	$CanvasLayer/UI.show_game_over(score, kills)

func show_victory():
	game_finished = true
	$CanvasLayer/UI.show_victory(score, kills)
