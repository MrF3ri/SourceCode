extends CharacterBody2D

signal enemy_killed(score)

@export var speed = 150.0
@export var health = 30
@export var damage = 10
@export var score = 10
@export var enemy_color = Color(0.95, 0.2, 0.2, 1)

var player

func _ready():
	$Body.color = enemy_color
	player = get_tree().get_first_node_in_group("ArenaPlayer")

func _physics_process(_delta):
	if not player:
		return
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()

func take_damage(amount):
	health -= amount
	$Body.scale = Vector2(1.2, 1.2)
	var tween = create_tween()
	tween.tween_property($Body, "scale", Vector2.ONE, 0.12)
	if health <= 0:
		enemy_killed.emit(score)
		queue_free()

func _on_hit_box_body_entered(body):
	if body.is_in_group("ArenaPlayer"):
		body.take_damage(damage)
