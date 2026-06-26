extends CharacterBody2D

signal health_changed(value, max_value)
signal player_died
signal shield_changed(active)

const SPEED = 310.0
const DASH_SPEED = 880.0
const DASH_TIME = 0.16
const DASH_COOLDOWN = 0.75

var health = 100
var max_health = 100
var shield_active = false
var speed_bonus_time = 0.0
var dash_time = 0.0
var dash_cooldown = 0.0
var damage_cooldown = 0.0
var last_direction = Vector2.RIGHT

func _ready():
	health_changed.emit(health, max_health)
	shield_changed.emit(shield_active)

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1
	if Input.is_key_pressed(KEY_D):
		direction.x += 1
	if Input.is_key_pressed(KEY_W):
		direction.y -= 1
	if Input.is_key_pressed(KEY_S):
		direction.y += 1
	direction = direction.normalized()
	if direction:
		last_direction = direction
		$AnimatedSprite2D.play("Walk")
	else:
		$AnimatedSprite2D.play("Idle")
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	if direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	if dash_cooldown > 0:
		dash_cooldown -= delta
	if dash_time > 0:
		dash_time -= delta
		velocity = last_direction * DASH_SPEED
	elif Input.is_key_pressed(KEY_SHIFT) and dash_cooldown <= 0:
		# dash player
		dash_time = DASH_TIME
		dash_cooldown = DASH_COOLDOWN
		velocity = last_direction * DASH_SPEED
	else:
		var speed = SPEED
		if speed_bonus_time > 0:
			speed_bonus_time -= delta
			speed += 140
		velocity = direction * speed
	if damage_cooldown > 0:
		damage_cooldown -= delta
	move_and_slide()
	position.x = clamp(position.x, 40, 1240)
	position.y = clamp(position.y, 70, 680)

func take_damage(amount):
	if damage_cooldown > 0:
		return
	if shield_active:
		shield_active = false
		shield_changed.emit(shield_active)
		damage_cooldown = 0.5
		blink_player()
		return
	health -= amount
	damage_cooldown = 0.7
	health_changed.emit(health, max_health)
	blink_player()
	if health <= 0:
		player_died.emit()

func heal_player(amount):
	health = min(max_health, health + amount)
	health_changed.emit(health, max_health)

func add_speed_time(time):
	speed_bonus_time = time

func add_shield():
	shield_active = true
	shield_changed.emit(shield_active)

func blink_player():
	# damage blink
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 0.25, 0.25, 1), 0.08)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1, 1), 0.12)
